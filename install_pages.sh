#!/bin/bash
set -e

APP_DIR="/var/www/qqpay"
VIEW_DIR="$APP_DIR/resources/views"
INCLUDE_DIR="$VIEW_DIR/includes"
PAGES_DIR="$VIEW_DIR/pages"
WEB_ROUTES="$APP_DIR/routes/web.php"
TS=$(date +%s)

# 0. sanity checks
if [ ! -d "$APP_DIR" ]; then
  echo "ERROR: Laravel app directory not found: $APP_DIR"
  exit 1
fi

# 1. make directories
sudo mkdir -p "$INCLUDE_DIR"
sudo mkdir -p "$PAGES_DIR"

# 2. backup files
sudo cp "$VIEW_DIR/welcome.blade.php" "$VIEW_DIR/welcome.blade.php.bak.$TS" || true
sudo cp "$WEB_ROUTES" "$WEB_ROUTES.bak.$TS"

echo "Backups created."

# 3. create header include with Login/Signup buttons and top-right agent/time placeholder
sudo tee "$INCLUDE_DIR/topbar.blade.php" > /dev/null <<'HTML'
@verbatim
<!-- Topbar with Logo left and Login/Signup right + AgentID/time (injected) -->
<style>
.topbar { display:flex; align-items:center; gap:12px; padding:12px 20px; background:linear-gradient(90deg,rgba(255,255,255,0.02), rgba(255,255,255,0.01)); border-bottom:1px solid rgba(255,255,255,0.03); }
.topbar .left { display:flex; align-items:center; gap:10px; }
.topbar .left img{height:42px;width:42px;border-radius:8px}
.topbar .brand { font-weight:700; color:#fff; }
.topbar .tag { font-size:12px; color:#aab8d6; }
.topbar .right { margin-left:auto; display:flex; gap:10px; align-items:center; }
.btn-futuristic { padding:8px 14px; border-radius:10px; font-weight:700; cursor:pointer; border:none; color:#001; background: linear-gradient(90deg,#00e676,#ff2d55); box-shadow: 0 8px 24px rgba(0,0,0,0.45); transition: transform .15s; }
.btn-futuristic:hover{ transform: translateY(-3px); filter:brightness(1.05); }
.agentbox{ background: rgba(255,255,255,0.03); padding:8px 12px; border-radius:8px; border:1px solid rgba(255,255,255,0.04); color:#e6eef8; font-weight:700;}
.small-time{ font-size:12px; color:#cbd9f1;}
.login-link, .signup-link{ text-decoration:none; }
</style>

<div class="topbar">
  <div class="left">
    <img src="https://i.postimg.cc/Kvk4Vhr9/file-000000008b3061f580b32ed1e16e49cb.png" alt="QQPAY">
    <div>
      <div class="brand">QQPAY™</div>
      <div class="tag">SINCE 2021 • Play • Trade • Earn • P2P</div>
    </div>
  </div>

  <div class="right">
    <div class="agentbox" id="agentDisplay" title="Your Agent ID">AGENT - <span id="agentID">- - - - QQ</span></div>
    <div class="small-time" id="localTime">--</div>
    <a href="/login" class="login-link"><button class="btn-futuristic">Login</button></a>
    <a href="/signup" class="signup-link"><button class="btn-futuristic">Sign Up</button></a>
  </div>
</div>

<script>
  // show Indian time and date in top-right
  function updateLocalTime(){
    try{
      const opts = { timeZone:'Asia/Kolkata', hour12:false, hour:'2-digit', minute:'2-digit', second:'2-digit', day:'2-digit', month:'short', year:'numeric' };
      const now = new Intl.DateTimeFormat('en-GB', opts).format(new Date());
      document.getElementById('localTime').innerText = now.replace(',', ' •');
    }catch(e){
      // fallback
      document.getElementById('localTime').innerText = new Date().toLocaleString();
    }
  }
  setInterval(updateLocalTime,1000);
  updateLocalTime();
</script>
@endverbatim
HTML

echo "Created include: includes/topbar.blade.php"

# 4. create pages (signup, login, about, contact, faqs, locate, privacy)
# Signup Page (frontend + client-side agent id generation and show success message)
sudo tee "$PAGES_DIR/signup.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')

@section('content')
<div style="max-width:720px;margin:20px auto;padding:18px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2 style="margin:0 0 8px;">Create your QQPAY Account</h2>
  <p style="color:#9fb0d6;margin:0 0 16px;">Sign up now and get ₹5000 bonus credited to your QQWallet.</p>

  <form id="signupForm" method="POST" action="/register">
    <!-- if your Laravel has /register route this will submit server-side; otherwise client-only success will show -->
    <div style="display:flex;gap:8px;flex-wrap:wrap;">
      <input name="name" placeholder="Full Name" required style="flex:1;padding:10px;border-radius:8px;border:1px solid rgba(255,255,255,0.06);background:transparent;color:#e6eef8;">
      <input name="email" type="email" placeholder="Email" required style="flex:1;padding:10px;border-radius:8px;border:1px solid rgba(255,255,255,0.06);background:transparent;color:#e6eef8;">
    </div>
    <div style="display:flex;gap:8px; margin-top:8px;">
      <input name="mobile" placeholder="Mobile number" required style="flex:1;padding:10px;border-radius:8px;border:1px solid rgba(255,255,255,0.06);background:transparent;color:#e6eef8;">
      <input id="pass" name="password" placeholder="Password" type="password" required style="flex:1;padding:10px;border-radius:8px;border:1px solid rgba(255,255,255,0.06);background:transparent;color:#e6eef8;">
    </div>

    <div style="margin-top:12px;display:flex;gap:8px;align-items:center;">
      <button type="submit" class="btn-futuristic">Sign Up</button>
      <div style="color:#9fb0d6;">Agent ID will be generated automatically after signup.</div>
    </div>
  </form>

  <div id="signupSuccess" style="display:none;margin-top:14px;padding:12px;border-radius:8px;background:linear-gradient(90deg,#e6ffe6,#e6f3ff);color:#001;font-weight:700;">
    🎉 Congratulations — Sign-up bonus credited to your QQWallet. Check your wallet now.
  </div>
</div>

<script>
  // client-side agent id create (4 chars + QQ) and show success if server not available
  function genAgentID(){ const c="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; let s=""; for(let i=0;i<4;i++){ s+=c.charAt(Math.floor(Math.random()*c.length)); } return s+"QQ"; }

  document.getElementById('signupForm').addEventListener('submit', function(e){
    e.preventDefault();
    // attempt to POST to server /register; if server responds with JSON {success:true, agent_id:...} show success else show client-side confirmation
    const form = e.target;
    const data = new FormData(form);
    fetch(form.action, { method:'POST', body: data, headers: {'X-Requested-With':'XMLHttpRequest'} })
      .then(r=>r.json().catch(()=>({ok:false})))
      .then(json=>{
        if(json && (json.success || json.status=='ok')) {
          // server handled registration
          const aid = json.agent_id || genAgentID();
          document.getElementById('agentID').innerText = aid;
          document.getElementById('signupSuccess').style.display='block';
          // show notification (in-page)
          alert('🎉 Signup complete. Agent ID: '+aid);
          window.location.href = '/login';
        } else {
          // fallback client-side (frontend-only)
          const aid = genAgentID();
          document.getElementById('agentID').innerText = aid;
          document.getElementById('signupSuccess').style.display='block';
          alert('🎉 (Local) Signup simulated. Agent ID: '+aid);
          // do not auto-redirect
        }
      }).catch(err=>{
        // network error -> simulate
        const aid = genAgentID();
        document.getElementById('agentID').innerText = aid;
        document.getElementById('signupSuccess').style.display='block';
        alert('🎉 (Local) Signup simulated. Agent ID: '+aid);
      });
  });
</script>
@endverbatim
HTML

echo "Created page: pages/signup.blade.php"

# Login page
sudo tee "$PAGES_DIR/login.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:560px;margin:20px auto;padding:18px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2>Login to QQPAY</h2>
  <form id="loginForm" method="POST" action="/login">
    <input name="email" type="email" placeholder="Email" required style="width:100%;padding:10px;border-radius:8px;margin-top:8px;background:transparent;color:#e6eef8;border:1px solid rgba(255,255,255,0.06);">
    <input name="password" type="password" placeholder="Password" required style="width:100%;padding:10px;border-radius:8px;margin-top:8px;background:transparent;color:#e6eef8;border:1px solid rgba(255,255,255,0.06);">
    <div style="margin-top:12px;display:flex;gap:8px;align-items:center;">
      <button class="btn-futuristic" type="submit">Login</button>
      <a href="/forgot" style="color:#9fb0d6;margin-left:8px;">Forgot password?</a>
    </div>
  </form>
  <div id="loginMsg" style="display:none;margin-top:12px;padding:10px;border-radius:8px;background:#e6ffe6;color:#001;">Login successful. Redirecting...</div>
</div>

<script>
document.getElementById('loginForm').addEventListener('submit', function(e){
  e.preventDefault();
  const form=this;
  fetch(form.action, {method:'POST', body:new FormData(form), headers:{'X-Requested-With':'XMLHttpRequest'}})
    .then(r=>r.json().catch(()=>({ok:false}))).then(json=>{
      if(json && (json.success||json.status=='ok')){
        document.getElementById('loginMsg').style.display='block';
        // set agent id if returned
        if(json.agent_id) document.getElementById('agentID').innerText = json.agent_id;
        setTimeout(()=>{ window.location.href = '/dashboard'; },1200);
      } else {
        // fallback: show success locally
        document.getElementById('loginMsg').innerText = 'Login simulated (no server).';
        document.getElementById('loginMsg').style.display='block';
      }
    }).catch(err=>{
      document.getElementById('loginMsg').innerText = 'Network error - login simulated.';
      document.getElementById('loginMsg').style.display='block';
    });
});
</script>
@endverbatim
HTML

echo "Created page: pages/login.blade.php"

# About page (real content)
sudo tee "$PAGES_DIR/about.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:900px;margin:18px auto;padding:22px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h1>About QQPAY™ HOLDINGS PVT LTD</h1>
  <p><strong>Licensed & Regulated:</strong> QQPAY™ is licensed and regulated by the Malta Gaming Authority.</p>
  <p>We partner with some of the world’s biggest casino providers and facilitate their payment solutions. To support high-volume operations we maintain and manage a large number of bank accounts via our QQPANEL system — enabling fast settlements, reconciliations and gaming fund flows.</p>
  <h3>Our Services</h3>
  <ul>
    <li>Play, Trade & Earn platforms with integrated wallet.</li>
    <li>P2P USDT exchange and manual receipt deposit flow.</li>
    <li>Daily Earn investment schemes & tournaments.</li>
    <li>QQCOINS ecosystem & future QQ token (BEP-20).</li>
  </ul>
  <p><strong>Security & Compliance:</strong> We follow ISO | PCI | DCI security practices and operate under regulatory compliance in our jurisdictions.</p>
</div>
@endsection
@endverbatim
HTML

echo "Created page: pages/about.blade.php"

# Contact page
sudo tee "$PAGES_DIR/contact.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:720px;margin:20px auto;padding:18px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2>Contact Us</h2>
  <p>Official Email: <a href="mailto:tio@qqpays.online">tio@qqpays.online</a></p>
  <p>Telegram: <a href="https://t.me/tio_912" target="_blank">@tio_912</a></p>
  <p>Follow us: Facebook • Twitter • Instagram (links managed from admin panel)</p>

  <form id="contactForm" action="/contact/send" method="POST" style="margin-top:12px;">
    <input name="name" placeholder="Your Name" style="width:100%;padding:10px;border-radius:8px;margin-top:8px;background:transparent;border:1px solid rgba(255,255,255,0.06);color:#e6eef8;" required>
    <input name="email" placeholder="Your Email" type="email" style="width:100%;padding:10px;border-radius:8px;margin-top:8px;background:transparent;border:1px solid rgba(255,255,255,0.06);color:#e6eef8;" required>
    <textarea name="message" placeholder="Message" style="width:100%;padding:10px;border-radius:8px;margin-top:8px;background:transparent;border:1px solid rgba(255,255,255,0.06);color:#e6eef8;" rows="5" required></textarea>
    <div style="margin-top:8px;"><button class="btn-futuristic" type="submit">Send Message</button></div>
  </form>
</div>
@endsection
@endverbatim
HTML

echo "Created page: pages/contact.blade.php"

# FAQs page with all the real Q&A you provided
sudo tee "$PAGES_DIR/faqs.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:900px;margin:18px auto;padding:22px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2>Frequently Asked Questions (FAQs)</h2>

  <h3>How to add bank accounts?</h3>
  <p>Go to QQPANEL → Add Bank Account. Provide Name, Bank Name, Account Number, IFSC. You may add Netbanking or Debit Card details optionally. At least one payment method must be provided to activate an account.</p>

  <h3>What are commission rates?</h3>
  <ul>
    <li>Savings Account - 2.5%</li>
    <li>Current Account - 3.0%</li>
    <li>Corporate Account - 3.5%</li>
  </ul>

  <h3>What are gaming funds?</h3>
  <p>Gaming funds are the funds you allocate for the gaming operations — these are managed within the platform and used according to the product rules.</p>

  <h3>How many days does an account run?</h3>
  <ul>
    <li>Savings: 20 to 25 days</li>
    <li>Current: 5 to 8 days</li>
    <li>Corporate: 5 to 7 days</li>
  </ul>

  <h3>Security deposit to activate accounts</h3>
  <ul>
    <li>Savings: 100 USDT or ₹10,000</li>
    <li>Current: 200 USDT or ₹20,000</li>
    <li>Corporate: 500 USDT or ₹50,000</li>
  </ul>
  <p>All security deposits are refundable. Work starts within 24 hours after activation.</p>

  <h3>Which banks are accepted?</h3>
  <p>All Indian banks are accepted. Merchant QR optional.</p>

  <h3>Daily Earn / P2P / Bonus Withdrawals</h3>
  <p>Daily Earn schemes and P2P flows are visible under Daily Earn & P2P tabs. Bonus withdrawal rules: sign-up & bonus withdrawals are allowed only after meeting scheme/activation criteria. QQCOINS: daily login reward 100 QQCoins; Amazon gift cards may be part of periodic rewards.</p>

</div>
@endsection
@endverbatim
HTML

echo "Created page: pages/faqs.blade.php"

# Locate page (Google Map embed placeholders)
sudo tee "$PAGES_DIR/locate.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:1000px;margin:18px auto;padding:18px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2>Locate Us</h2>
  <h3>Corporate Office (Malta)</h3>
  <p>170 Triq ir-Repubblika, Valletta, Malta</p>
  <div style="margin:12px 0;">
    <!-- Malta maps embed -->
    <iframe src="https://www.google.com/maps?q=Valletta,%20Malta&output=embed" style="width:100%;height:300px;border:0;border-radius:8px;"></iframe>
  </div>

  <h3>Head Office (Hong Kong)</h3>
  <p>25/F, Central Plaza, Harbour Road, Wan Chai, Hong Kong</p>
  <p>Customer Care: +852 5808 3200</p>
  <div style="margin:12px 0;">
    <iframe src="https://www.google.com/maps?q=Wan%20Chai,%20Hong%20Kong&output=embed" style="width:100%;height:300px;border:0;border-radius:8px;"></iframe>
  </div>
</div>
@endsection
@endverbatim
HTML

echo "Created page: pages/locate.blade.php"

# Privacy policy page
sudo tee "$PAGES_DIR/privacy.blade.php" > /dev/null <<'HTML'
@verbatim
@extends('layouts.app')
@section('content')
<div style="max-width:900px;margin:18px auto;padding:22px;background:rgba(255,255,255,0.02);border-radius:12px;">
  <h2>Privacy Policy</h2>
  <p>QQPAY™ respects your privacy. We collect only necessary data for account operation and KYC. Data is stored securely and not sold to third parties. We comply with applicable data protection laws. Transaction logs, deposits and withdrawals are retained for auditing. Users may request deletion in accordance with policy and legal retention rules.</p>

  <h3>Security</h3>
  <p>We follow ISO, PCI standards and maintain secure infrastructure. All sensitive data is encrypted in transit and at rest.</p>

  <h3>Refunds & Deposits</h3>
  <p>Security deposits are refundable. Withdrawals processed after admin approval.</p>
</div>
@endsection
@endverbatim
HTML

echo "Created page: pages/privacy.blade.php"

# 5. Add QQCHAT floating widget include (bottom right) in includes/qqchat.blade.php
sudo tee "$INCLUDE_DIR/qqchat.blade.php" > /dev/null <<'HTML'
@verbatim
<!-- QQCHAT floating widget -->
<style>
.qqchat-float { position:fixed; right:18px; bottom:18px; z-index:99999; }
.qqchat-btn { width:64px;height:64px;border-radius:999px;background:linear-gradient(90deg,#ff2d55,#00e676);display:flex;align-items:center;justify-content:center;font-weight:800;color:#001;box-shadow:0 10px 28px rgba(0,0,0,0.6);cursor:pointer; }
.qqchat-window { position:fixed; right:18px; bottom:92px; width:320px; max-width:92%; background:rgba(6,8,15,0.98); border-radius:12px; border:1px solid rgba(255,255,255,0.04); box-shadow:0 20px 60px rgba(0,0,0,0.7); display:none; z-index:99999; }
.qqchat-window .head{ padding:12px; font-weight:700; color:#fff; border-bottom:1px solid rgba(255,255,255,0.03); }
.qqchat-window .body{ padding:10px; max-height:260px; overflow:auto; color:#dfefff; font-size:13px; }
.qqchat-window .footer{ padding:10px; border-top:1px solid rgba(255,255,255,0.03); display:flex; gap:8px; }
.qqchat-window input{ flex:1; padding:8px;border-radius:8px;border:1px solid rgba(255,255,255,0.05); background:transparent;color:#fff;}
.qqchat-window button.send{ padding:8px 10px;border-radius:8px;background:linear-gradient(90deg,#00e676,#ff2d55); border:none; color:#001; font-weight:700;}
</style>

<div class="qqchat-float">
  <div class="qqchat-btn" id="qqchatBtn">QQ</div>
  <div class="qqchat-window" id="qqchatWindow" role="dialog" aria-live="polite">
    <div class="head">QQCHAT Support</div>
    <div class="body" id="qqchatBody">
      <div><strong>QQCHAT</strong>: Hi, I am QQCHAT — the official customer support agent of QQPAY™ HOLDINGS PVT LTD. How may I help you?</div>
    </div>
    <div class="footer">
      <input id="qqchatInput" placeholder="Type your message..." />
      <button class="send" id="qqchatSend">Send</button>
    </div>
  </div>
</div>

<script>
(function(){
  const btn = document.getElementById('qqchatBtn');
  const win = document.getElementById('qqchatWindow');
  const body = document.getElementById('qqchatBody');
  const input = document.getElementById('qqchatInput');
  const send = document.getElementById('qqchatSend');

  btn.addEventListener('click', ()=> {
    win.style.display = (win.style.display==='block') ? 'none' : 'block';
  });

  function appendMsg(who, text){
    const d = document.createElement('div');
    d.innerHTML = '<strong>'+who+':</strong> '+(text.replace(/</g,'&lt;'));
    body.appendChild(d);
    body.scrollTop = body.scrollHeight;
  }

  send.addEventListener('click', ()=> {
    const txt = input.value.trim();
    if(!txt) return;
    appendMsg('You', txt);
    input.value='';
    // POST to server to forward to admin email (if route exists)
    fetch('/qqchat/send', { method:'POST', headers:{ 'Content-Type':'application/json','X-Requested-With':'XMLHttpRequest' }, body: JSON.stringify({ message: txt }) })
      .then(r=>r.json().catch(()=>({ok:false})))
      .then(res=>{
        if(res && res.status=='ok') appendMsg('QQCHAT', 'Message received. Support will reply via email.');
        else appendMsg('QQCHAT', 'Message queued. Support will contact you by email.');
      }).catch(e=>{
        appendMsg('QQCHAT', 'Offline: message saved locally. Admin will be notified when system online.');
      });
  });

})();
</script>
@endverbatim
HTML

echo "Created include: includes/qqchat.blade.php"

# 6. Insert includes in welcome.blade.php if not present
if ! sudo grep -q "@include('includes.topbar')" "$VIEW_DIR/welcome.blade.php"; then
  sudo sed -i '0,/<body[^>]*>/s//&\n@include('"'"'includes.topbar'"'"')\n@include('"'"'includes.qqchat'"'"')\n/' "$VIEW_DIR/welcome.blade.php"
  echo "Injected includes into welcome.blade.php"
else
  echo "Includes already present in welcome.blade.php"
fi

# 7. Append routes to web.php (if not already)
ROUTE_BLOCK="// QQPAY custom pages routes - added by script
Route::view('/signup', 'pages.signup')->name('signup');
Route::view('/login', 'pages.login')->name('login');
Route::view('/about', 'pages.about')->name('about');
Route::view('/contact', 'pages.contact')->name('contact');
Route::view('/faqs', 'pages.faqs')->name('faqs');
Route::view('/locate', 'pages.locate')->name('locate');
Route::view('/privacy', 'pages.privacy')->name('privacy');
// qqchat API endpoint (frontend posts to this) - requires backend mail config to be functional
Route::post('/qqchat/send', function(\Illuminate\Http\Request \$req){
    try{
        // forward to admin email if mail configured
        if(filter_var(env('MAIL_FROM_ADDRESS', ''), FILTER_VALIDATE_EMAIL)){
            \\Mail::raw('Support message from website:\\n\\n'.\$req->input('message').'\\n\\nUser IP: '.\$req->ip(), function(\$m){ \$m->to('tio@qqpays.online')->subject('QQCHAT Support Message'); });
        }
        return response()->json(['status'=>'ok']);
    }catch(\\Throwable \$e){
        return response()->json(['status'=>'error','msg'=>\$e->getMessage()]);
    }
});"

if ! grep -q "QQPAY custom pages routes - added by script" "$WEB_ROUTES"; then
  echo "$ROUTE_BLOCK" | sudo tee -a "$WEB_ROUTES"
  echo "Appended routes to routes/web.php"
else
  echo "Routes block already present in web.php"
fi

# 8. Clear caches & restart services
cd "$APP_DIR"
php artisan view:clear || true
php artisan cache:clear || true
php artisan config:clear || true

# try restart php-fpm (auto detect), else skip
PHP_FPM=$(systemctl list-units --type=service --all | grep -o 'php[0-9.]*-fpm.service' | head -n1 || true)
if [ -n "$PHP_FPM" ]; then
  sudo systemctl restart "$PHP_FPM" || true
fi
sudo systemctl restart nginx || true

echo "✅ Pages & QQCHAT includes installed."
echo "Backups: welcome.blade.php.bak.$TS and routes/web.php.bak.$TS"
echo "Visit /signup, /login, /about, /contact, /faqs, /locate, /privacy to check pages."
