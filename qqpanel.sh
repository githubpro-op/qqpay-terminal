cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/qqpanel-modal.blade.php
<!-- QQPANEL Modal + Add Bank / Rules / Active Accounts -->
<!-- FRONTEND DEMO: commission generator intervals are shortened for demo (15s). Change qqp.COMMISSION_INTERVAL to 15*60*1000 for production (15 minutes). -->
<div id="qqpanelModal" class="modal">
  <div class="modal-content qqp-panel">
    <button class="btn-x" onclick="closeModal('qqpanel-Modal')">✖</button>
    <h2 class="qqp-title">QQPANEL™</h2>
    <div class="qqp-slogan">High Volume Commission</div>

    <!-- Ticker -->
    <div class="qqp-ticker-wrap">
      <div id="qqpTicker" class="qqp-ticker"></div>
    </div>

    <!-- Tiles -->
    <div class="qqp-tiles">
      <div class="qqp-tile" onclick="qqp_openModal('qqpAddBankModal')">
        <div class="ico">🏦</div>
        <div class="label">Add Bank</div>
      </div>
      <div class="qqp-tile" onclick="qqp_openModal('qqpRulesModal')">
        <div class="ico">📜</div>
        <div class="label">Rules</div>
      </div>
      <div class="qqp-tile" onclick="qqp_openModal('qqpActiveModal')">
        <div class="ico">📊</div>
        <div class="label">Active Accounts</div>
      </div>
    </div>

    <!-- Graph -->
    <div class="qqp-graph-wrap">
      <canvas id="qqpChart" width="800" height="180"></canvas>
    </div>

    <!-- Reminder (appears after adding account) -->
    <div id="qqpReminder" class="qqp-reminder hidden"></div>

    <!-- Commission Table (no remarks) -->
    <div class="qqp-table-wrap">
      <div class="table-head">
        <div>Total Accounts: <span id="qqpTotalCount">0</span></div>
        <div>Active: <span id="qqpActiveCount">0</span> / Inactive: <span id="qqpInactiveCount">0</span></div>
        <div>QQWallet Balance: <span id="qqpWalletBal">₹0.00</span></div>
      </div>
      <table id="qqpTable" class="qqp-table">
        <thead>
          <tr><th>Bank ID</th><th>Today Commission (₹)</th><th>Total Commission (₹)</th><th>Status</th></tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>

  </div>
</div>

<!-- Add Bank Modal (multi-step) -->
<div id="qqpAddBankModal" class="modal small">
  <div class="modal-content">
    <button class="btn-x" onclick="qqp_closeModal('qqpAddBankModal')">✖</button>
    <h3>Add Bank - Step <span id="qqpStepLabel">1</span>/5</h3>
    <div id="qqpSteps">
      <!-- Step 1 -->
      <div class="qqp-step" data-step="1">
        <label>Bank</label>
        <select id="qqpBankSelect">
          <!-- value contains initials for ID generation -->
          <option value="SBI">State Bank of India (SBI)</option>
          <option value="HDFC">HDFC Bank (HDFC)</option>
          <option value="ICICI">ICICI Bank (ICICI)</option>
          <option value="AXIS">Axis Bank (AXIS)</option>
          <option value="PNB">Punjab National Bank (PNB)</option>
          <option value="IDBI">IDBI Bank (IDBI)</option>
          <option value="KOTAK">Kotak Mahindra Bank (KOTAK)</option>
          <option value="YES">Yes Bank (YES)</option>
          <option value="BOB">Bank of Baroda (BOB)</option>
          <!-- add more as needed -->
        </select>

        <label>Account Type</label>
        <select id="qqpAccType">
          <option value="savings">Savings</option>
          <option value="current">Current</option>
          <option value="corporate">Corporate</option>
        </select>

        <label>Mode</label>
        <select id="qqpMode">
          <option>1ID</option>
          <option>2ID</option>
          <option>3ID</option>
        </select>

        <label>Bank Mobile Number</label>
        <input id="qqpBankMobile" type="text" placeholder="Enter bank mobile number">
      </div>

      <!-- Step 2 (login details - mandatory) -->
      <div class="qqp-step hidden" data-step="2">
        <label>User ID</label>
        <input id="qqpLoginUser" type="text" placeholder="Bank login user id">
        <label>Password</label>
        <div class="qqp-passwrap">
          <input id="qqpLoginPass" type="password"><button type="button" onclick="qqp_togglePass('qqpLoginPass')">👁️</button>
        </div>
        <label>Profile Password (if any)</label>
        <input id="qqpProfilePass" type="password">
        <label>Transaction Password (if any)</label>
        <input id="qqpTxnPass" type="password">
      </div>

      <!-- Step 3 -->
      <div class="qqp-step hidden" data-step="3">
        <label>Extra Login ID</label>
        <input id="qqpExtraUser" type="text">
        <label>Extra Password</label>
        <input id="qqpExtraPass" type="password">
      </div>

      <!-- Step 4 -->
      <div class="qqp-step hidden" data-step="4">
        <label>Alternate Login ID</label>
        <input id="qqpAltUser" type="text">
        <label>Alternate Password</label>
        <input id="qqpAltPass" type="password">
      </div>

      <!-- Step 5 -->
      <div class="qqp-step hidden" data-step="5">
        <label>Debit Card (optional)</label>
        <input id="qqpCardNum" type="text" placeholder="Card number">
        <label>Expiry (MM/YY)</label>
        <input id="qqpCardExp" type="text" placeholder="MM/YY">
        <label>CVV</label>
        <input id="qqpCardCVV" type="text" placeholder="CVV">
        <label>PIN</label>
        <input id="qqpCardPIN" type="password">
        <label>Upload Merchant QR (optional)</label>
        <input id="qqpMerchantQR" type="file" accept="image/*">
      </div>
    </div>

    <div class="qqp-step-nav">
      <button id="qqpPrevBtn" onclick="qqp_step(-1)">⬅ Back</button>
      <button id="qqpSkipBtn" onclick="qqp_skip()" class="hidden">Skip</button>
      <button id="qqpNextBtn" onclick="qqp_step(1)">Next ➡</button>
    </div>
  </div>
</div>

<!-- Rules Modal -->
<div id="qqpRulesModal" class="modal small">
  <div class="modal-content">
    <button class="btn-x" onclick="qqp_closeModal('qqpRulesModal')">✖</button>
    <h3>Rules & Commission</h3>
    <div class="qqp-rules">
      <ul>
        <li>💠 Savings → 3% commission. Refundable security: 100 USDT or ₹10,000. Life: 20–25 days.</li>
        <li>💠 Current → 3.2% commission. Refundable security: 200 USDT or ₹20,000. Life: 5–8 days.</li>
        <li>💠 Corporate → 3.5% commission. Refundable security: 500 USDT or ₹50,000. Life: 5–7 days.</li>
        <li>🔐 All banks accepted with or without merchant QR. Commission withdrawable 24×7 via QQWallet.</li>
        <li>📱 SIM required only at first registration. After deposit, agent can run up to 10 accounts one-by-one.</li>
      </ul>
    </div>
    <div style="text-align:center;margin-top:10px;"><button onclick="qqp_closeModal('qqpRulesModal')">Close</button></div>
  </div>
</div>

<!-- Active Accounts Modal (with remarks) -->
<div id="qqpActiveModal" class="modal">
  <div class="modal-content">
    <button class="btn-x" onclick="qqp_closeModal('qqpActiveModal')">✖</button>
    <h3>Active Accounts (with remarks)</h3>
    <div id="qqpActiveStats" class="qqp-active-stats"></div>
    <div id="qqpActiveList" class="qqp-active-list"></div>
    <div style="margin-top:12px;text-align:center;">
      <small>Admin actions (demo): select a Bank ID below and click Activate to simulate admin approval</small><br>
      <select id="qqpAdminSelect"></select>
      <button onclick="qqp_adminActivate()">Activate</button>
    </div>
  </div>
</div>

<style>
/* Basic modal base (kept consistent) */
.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.85);z-index:9999;overflow:auto;}
.modal.small .modal-content{max-width:680px;margin:40px auto;padding:18px;border-radius:10px;background:#111;color:#fff;}
.modal .modal-content{max-width:1000px;margin:20px auto;padding:18px;border-radius:10px;background:linear-gradient(180deg,#070707,#0f0f10);color:#fff;position:relative;}
.btn-x{position:absolute;top:12px;right:12px;background:#ff3b3b;border:none;color:#fff;padding:6px 10px;border-radius:50%;cursor:pointer;}

/* Panel styling */
.qqp-panel{padding:18px;border-radius:12px;}
.qqp-title{font-size:22px;color:#0f0;text-shadow:0 0 16px #0f0;}
.qqp-slogan{color:#cfc;text-shadow:0 0 8px #f0f;padding-bottom:8px;}

/* ticker */
.qqp-ticker-wrap{overflow:hidden;background:transparent;padding:6px 0;margin-bottom:10px;}
.qqp-ticker{display:inline-block;white-space:nowrap;animation:qqp-scroll 30s linear infinite;font-weight:700;}
@keyframes qqp-scroll{0%{transform:translateX(100%);}100%{transform:translateX(-100%);}}

/* tiles */
.qqp-tiles{display:flex;gap:12px;justify-content:center;margin-bottom:12px;}
.qqp-tile{width:150px;height:90px;background:linear-gradient(135deg,#070707,#121212);border:1px solid rgba(255,0,255,0.06);border-radius:8px;display:flex;flex-direction:column;align-items:center;justify-content:center;cursor:pointer;box-shadow:0 6px 18px rgba(255,0,255,0.04);}
.qqp-tile .ico{font-size:26px;margin-bottom:6px;}
.qqp-tile .label{font-weight:700;color:#fff;}

/* graph */
.qqp-graph-wrap{margin:8px auto;max-width:900px;background:linear-gradient(90deg,#060606,#0b0b0b);padding:10px;border-radius:8px;border:1px solid rgba(0,255,136,0.03);}

/* reminder */
.qqp-reminder{margin:10px auto;padding:10px;border-radius:8px;background:linear-gradient(90deg,#ff00ff22,#00ff9922);color:#fff;font-weight:700;overflow:hidden;white-space:nowrap;}
.hidden{display:none;}

/* table */
.qqp-table-wrap{max-width:1000px;margin:12px auto;background:#070707;padding:8px;border-radius:8px;border:1px solid #222;}
.table-head{display:flex;justify-content:space-between;color:#9aa;padding:6px 10px;font-weight:700;}
.qqp-table{width:100%;border-collapse:collapse;margin-top:8px;}
.qqp-table th, .qqp-table td{padding:8px;border-bottom:1px solid #171717;text-align:center;color:#ddd;}
.qqp-table th{color:#8fffb8;background:#081208;}

/* add bank form */
.qqp-step{margin-top:8px;}
.qqp-step input, .qqp-step select{width:100%;padding:8px;margin-top:6px;border-radius:6px;border:1px solid #333;background:#111;color:#fff;}
.qqp-step-nav{margin-top:12px;text-align:center;}
.qqp-step-nav button{padding:8px 12px;border-radius:6px;border:none;cursor:pointer;margin:0 6px;font-weight:700;}
#qqpPrevBtn{background:#444;color:#fff;}
#qqpSkipBtn{background:#ff00ff;color:#fff;}
#qqpNextBtn{background:#0f0;color:#000;}

/* active accounts modal */
.qqp-active-list{max-height:300px;overflow:auto;margin-top:10px;border-top:1px solid #222;padding-top:8px;}
.qqp-active-item{padding:8px;border-bottom:1px dashed #222;display:flex;justify-content:space-between;align-items:center;color:#ddd;}
.qqp-active-stats{font-weight:700;color:#9aa;}
</style>

<script>
/* Namespace object to avoid global collisions */
window.qqp = (function(){
  const qqp = {};

  // Demo settings (change intervals for production)
  qqp.COMMISSION_INTERVAL = 15 * 1000; // demo 15s ; set to 15*60*1000 for 15 minutes in prod
  qqp.COMMISSION_MIN = 500.25;
  qqp.COMMISSION_MAX = 2000.75;

  // Data stores
  qqp.accounts = []; // {bankId, bankInitials, bankLabel, type, mode, mobile, status, remark, today, total}
  qqp.walletBal = 0; // in INR for demo (commission credited here)

  // Chart data
  qqp.chartPoints = []; // recent aggregated commission per tick
  qqp.maxChartPoints = 30;

  // Utilities
  function randFloat(min,max){
    return Math.round((Math.random() * (max - min) + min) * 100) / 100;
  }
  function pad(n){ return (n<10? '0'+n : n); }

  // generate bank id (initials + random 5 digits)
  qqp.generateBankId = function(initials){
    const rnd = Math.floor(10000 + Math.random()*89999);
    return initials + '-' + rnd;
  };

  // UI helpers
  qqp.updateCounts = function(){
    const total = qqp.accounts.length;
    const active = qqp.accounts.filter(a=>a.status==='Active').length;
    const inactive = total - active;
    document.getElementById('qqpTotalCount').innerText = total;
    document.getElementById('qqpActiveCount').innerText = active;
    document.getElementById('qqpInactiveCount').innerText = inactive;
    document.getElementById('qqpWalletBal').innerText = '₹' + qqp.walletBal.toFixed(2);
  };

  qqp.renderTable = function(){
    const tbody = document.querySelector('#qqpTable tbody');
    tbody.innerHTML = '';
    qqp.accounts.forEach(acc=>{
      const tr = document.createElement('tr');
      const statusLabel = acc.status==='Active' ? '🟢 Active' : (acc.status==='Pending' ? '🟡 Pending' : '🔴 Inactive');
      tr.innerHTML = `<td>${acc.bankId}</td>
                      <td>${acc.today.toFixed(2)}</td>
                      <td>${acc.total.toFixed(2)}</td>
                      <td>${statusLabel}</td>`;
      tbody.appendChild(tr);
    });
  };

  qqp.renderActiveList = function(){
    const container = document.getElementById('qqpActiveList');
    container.innerHTML = '';
    qqp.accounts.forEach(acc=>{
      const div = document.createElement('div');
      div.className = 'qqp-active-item';
      div.innerHTML = `<div><strong>${acc.bankId}</strong> — ${acc.type.toUpperCase()} — ${acc.bankLabel}</div>
                       <div><span style="color:${acc.status==='Active'?'#0f0':'#ff8080'}">${acc.status}</span><br><small style="color:#aaa">${acc.remark||'—'}</small></div>`;
      container.appendChild(div);
    });

    // populate admin select
    const sel = document.getElementById('qqpAdminSelect');
    sel.innerHTML = '';
    qqp.accounts.forEach(acc=>{
      const opt = document.createElement('option');
      opt.value = acc.bankId;
      opt.text = acc.bankId + ' ('+acc.type+')';
      sel.appendChild(opt);
    });
    document.getElementById('qqpActiveStats').innerText = `Total: ${qqp.accounts.length} • Active: ${qqp.accounts.filter(a=>a.status==='Active').length}`;
  };

  // reminder handling
  qqp.showReminder = function(type){
    const el = document.getElementById('qqpReminder');
    let txt = '';
    if(type==='savings') txt = '⚠️ Deposit 100 USDT or ₹10,000 as refundable security in QQWallet to activate your account.';
    if(type==='current') txt = '⚠️ Deposit 200 USDT or ₹20,000 as refundable security in QQWallet to activate your account.';
    if(type==='corporate') txt = '⚠️ Deposit 500 USDT or ₹50,000 as refundable security in QQWallet to activate your account.';
    el.innerText = txt;
    el.classList.remove('hidden');
    // make it scroll by CSS animation; keep visible for 20s then hide (demo)
    clearTimeout(el._h); el._h = setTimeout(()=>{ el.classList.add('hidden'); }, 20000);
  };

  // add account (called on form submit)
  qqp.addAccount = function(data){
    const bankId = qqp.generateBankId(data.initials);
    const acc = {
      bankId,
      bankInitials: data.initials,
      bankLabel: data.bankLabel,
      type: data.type,
      mode: data.mode,
      mobile: data.mobile,
      status: 'Inactive', // must be activated by admin
      remark: 'Deposit security required',
      today: 0,
      total: 0
    };
    qqp.accounts.unshift(acc);
    qqp.updateCounts();
    qqp.renderTable();
    qqp.renderActiveList();
    // show reminder depending on type
    qqp.showReminder(data.type);
    qqp_showPopup('✅ Account added successfully: ' + bankId, 'success');
  };

  // admin activate (demo)
  qqp.activateAccount = function(bankId){
    const acc = qqp.accounts.find(a=>a.bankId===bankId);
    if(!acc) { qqp_showPopup('Account not found', 'error'); return; }
    // For demo: require that wallet has at least required deposit (simulate)
    // In real, check wallet balance + deposit transaction before activation
    const required = acc.type==='savings' ? 10000 : (acc.type==='current' ? 20000 : 50000);
    // For demo we allow activation even without deposit but mark remark
    acc.status = 'Active';
    acc.remark = 'Active (admin approved)';
    qqp.updateCounts();
    qqp.renderTable();
    qqp.renderActiveList();
    qqp_showPopup('✅ '+bankId+' activated (demo)', 'success');
  };

  // commission tick: generates commission for each active account
  qqp.commissionTick = function(){
    let aggregate = 0;
    qqp.accounts.forEach(acc=>{
      if(acc.status === 'Active'){
        const c = randFloat(qqp.COMMISSION_MIN, qqp.COMMISSION_MAX);
        // make non-round by adding random cents
        acc.today = Math.round((acc.today + c) * 100) / 100;
        aggregate += c;
        // auto-credit to wallet for demo - in real, credit at daily reset
        qqp.walletBal += c;
        // animate quick (blink) by temporarily highlighting the row later (not implemented to keep simple)
      }
    });
    // push to chart
    qqp.chartPoints.push(aggregate);
    if(qqp.chartPoints.length > qqp.maxChartPoints) qqp.chartPoints.shift();
    qqp.updateCounts();
    qqp.renderTable();
    qqp.updateChart();
  };

  // reset at midnight (for demo, provide function)
  qqp.midnightReset = function(){
    qqp.accounts.forEach(acc=>{
      acc.total = Math.round((acc.total + acc.today) * 100) / 100;
      acc.today = 0;
    });
    qqp.updateCounts();
    qqp.renderTable();
    qqp_showPopup('🔁 Midnight reset simulated: today → total', 'info');
  };

  /* ---------- Chart ---------- */
  qqp.chartCanvas = null;
  qqp.chartCtx = null;
  qqp.initChart = function(){
    qqp.chartCanvas = document.getElementById('qqpChart');
    if(!qqp.chartCanvas) return;
    qqp.chartCtx = qqp.chartCanvas.getContext('2d');
    qqp.updateChart();
  };
  qqp.updateChart = function(){
    const ctx = qqp.chartCtx;
    if(!ctx) return;
    const w = qqp.chartCanvas.width;
    const h = qqp.chartCanvas.height;
    ctx.clearRect(0,0,w,h);
    // background grid
    ctx.fillStyle = '#050505'; ctx.fillRect(0,0,w,h);
    ctx.strokeStyle = 'rgba(255,255,255,0.04)';
    for(let i=0;i<5;i++){
      ctx.beginPath(); ctx.moveTo(0, i*(h/5)); ctx.lineTo(w, i*(h/5)); ctx.stroke();
    }
    // draw line
    const pts = qqp.chartPoints;
    if(pts.length===0) return;
    const max = Math.max(...pts) || 1;
    ctx.beginPath();
    ctx.strokeStyle = '#7CFC00';
    ctx.lineWidth = 2;
    pts.forEach((v,i)=>{
      const x = (i/(Math.max(pts.length-1,1))) * (w-40) + 20;
      const y = h - (v/max)*(h-30) - 10;
      if(i===0) ctx.moveTo(x,y); else ctx.lineTo(x,y);
    });
    ctx.stroke();
    // fill gradient
    ctx.lineTo(w-20,h-10); ctx.lineTo(20,h-10); ctx.closePath();
    const grad = ctx.createLinearGradient(0,0,0,h);
    grad.addColorStop(0,'rgba(127,255,0,0.12)'); grad.addColorStop(1,'rgba(0,0,0,0)');
    ctx.fillStyle = grad; ctx.fill();
  };

  /* ---------- Initialization and intervals ---------- */
  qqp.init = function(){
    qqp.initChart();
    // initial ticker content
    qqp.renderTicker();
    // demo commission interval
    qqp._commissionIntervalId = setInterval(qqp.commissionTick, qqp.COMMISSION_INTERVAL);
    // single tick now for initial data
    //qqp.commissionTick();
    qqp.updateCounts();
    qqp.renderTable();
    qqp.renderActiveList();
  };

  /* Ticker rendering */
  qqp.renderTicker = function(){
    const el = document.getElementById('qqpTicker');
    const msgs = [
      '🚀 Savings commission 3% • Security 100 USDT / ₹10,000',
      '💹 Current commission 3.2% • Security 200 USDT / ₹20,000',
      '🏢 Corporate commission 3.5% • Security 500 USDT / ₹50,000',
      '🔒 Commission withdrawable 24×7 via QQWallet',
      '📱 SIM required for first-time registration only',
      '⏳ Savings life 20–25 days • Current 5–8 days • Corporate 5–7 days'
    ];
    el.innerHTML = msgs.map((m,i)=>`<span style="color:hsl(${(i*55)%360},100%,70%)">${m}</span>`).join(' • ');
  };

  return qqp;
})();

/* ------ small UI helpers outside namespace ------- */
function qqp_openModal(id){ document.getElementById(id).style.display = 'block'; }
function qqp_closeModal(id){ document.getElementById(id).style.display = 'none'; }
function qqp_togglePass(id){ const el=document.getElementById(id); if(!el) return; el.type = el.type==='password' ? 'text' : 'password'; }

/* Stepper logic for add-bank form */
(function(){
  let current = 1;
  const max = 5;
  function show(n){
    document.querySelectorAll('#qqpSteps .qqp-step').forEach(s=>s.classList.add('hidden'));
    const sel = document.querySelector('#qqpSteps .qqp-step[data-step="'+n+'"]');
    if(sel) sel.classList.remove('hidden');
    document.getElementById('qqpStepLabel').innerText = n;
    document.getElementById('qqpPrevBtn').style.display = n===1 ? 'none' : 'inline-block';
    document.getElementById('qqpSkipBtn').style.display = (n>2 && n<5) ? 'inline-block' : 'none';
    document.getElementById('qqpNextBtn').innerText = n===max ? 'Submit ➡' : 'Next ➡';
  }
  window.qqp_step = function(dir){
    if(dir===1 && current===5){
      // submit
      const data = {
        initials: document.getElementById('qqpBankSelect').value,
        bankLabel: document.getElementById('qqpBankSelect').selectedOptions[0].text,
        type: document.getElementById('qqpAccType').value,
        mode: document.getElementById('qqpMode').value,
        mobile: document.getElementById('qqpBankMobile').value
      };
      // minimal validation for mandatory fields
      if(!data.initials || !data.type || !data.mobile){
        qqp_showPopup('Fill Bank, Type and Mobile in Step 1 (mandatory)', 'error'); return;
      }
      // add account
      window.qqp.addAccount(data);
      // update admin select and active list
      window.qqp.renderActiveList();
      // close add bank modal after short delay
      setTimeout(()=>{ qqp_closeModal('qqpAddBankModal'); }, 800);
      return;
    }
    current += dir;
    if(current<1) current=1;
    if(current>max) current=max;
    show(current);
  };
  window.qqp_skip = function(){
    current++;
    if(current>5) current=5;
    show(current);
  };
  // initialize
  show(1);
})();

/* Admin activate demo function */
function qqp_adminActivate(){
  const sel = document.getElementById('qqpAdminSelect');
  if(!sel || !sel.value) { qqp_showPopup('Select account to activate', 'error'); return; }
  window.qqp.activateAccount(sel.value);
}

/* Simple cross-modal popup */
function qqp_showPopup(msg,type='info'){
  const id='__qqp_popup__';
  let el=document.getElementById(id);
  if(!el){ el=document.createElement('div'); el.id=id; document.body.appendChild(el); }
  el.style.position='fixed'; el.style.left='50%'; el.style.top='12%'; el.style.transform='translateX(-50%)';
  el.style.padding='12px 18px'; el.style.borderRadius='8px'; el.style.zIndex=99999; el.style.color='#fff';
  if(type==='success'){ el.style.background='linear-gradient(90deg,#004d00,#0f0)'; }
  else if(type==='error'){ el.style.background='linear-gradient(90deg,#4d0000,#f00)'; }
  else { el.style.background='linear-gradient(90deg,#003344,#00f)'; }
  el.innerText = msg;
  el.style.display='block';
  clearTimeout(el._hide);
  el._hide = setTimeout(()=>{ el.style.display='none'; }, 2500);
}

/* boot */
document.addEventListener('DOMContentLoaded', function(){
  window.qqp.init();
});
</script>
EOF
