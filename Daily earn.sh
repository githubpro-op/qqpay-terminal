cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/dailyearn-modal.blade.php
<div id="dailyearn-modal" class="modal">
  <div class="modal-content">

    <!-- ❌ Close Button (top right, outside ticker) -->
    <button onclick="closeModal('dailyearn-modal')" class="btn-x">✖</button>

    <!-- 🚂 AI Train Ticker -->
    <div class="ticker-wrapper">
      <div id="tickerTrack"></div>
    </div>

    <!-- 💰 Wallet balances -->
    <div class="balances">
      <span>₹: <span id="balRS">20000</span></span>
      <span>$: <span id="balUSDT">500</span> USDT</span>
      <span>QQCoins: <span id="balQQ">1000</span></span>
      <button onclick="openFaqs()" class="btn-faq">📜 FAQs</button>
    </div>

    <!-- 🟢 Daily Earn Schemes Table -->
    <table class="scheme-table">
      <thead>
        <tr>
          <th>S.No</th><th>Scheme</th><th>Seats</th><th>Interest</th><th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>1</td><td>Altcoins</td><td>30/50</td><td>30%</td>
          <td><button onclick="openDeposit(this,'RS')" class="btn-invest">Invest</button></td>
        </tr>
        <tr>
          <td>2</td><td>Forex</td><td>24/40</td><td>32%</td>
          <td><button onclick="openDeposit(this,'USDT')" class="btn-invest">Invest</button></td>
        </tr>
        <tr>
          <td>3</td><td>Bonds</td><td>18/30</td><td>28%</td>
          <td><button onclick="openDeposit(this,'QQ')" class="btn-invest">Invest</button></td>
        </tr>
        <tr>
          <td>4</td><td>ETF Plan</td><td>15/25</td><td>35%</td>
          <td><button onclick="openDeposit(this,'USDT')" class="btn-invest">Invest</button></td>
        </tr>
        <tr>
          <td>5</td><td>VIP Fund</td><td>9/15</td><td>50%</td>
          <td><button onclick="openDeposit(this,'RS')" class="btn-invest">Invest</button></td>
        </tr>
      </tbody>
    </table>

  </div>
</div>

<!-- 📜 FAQs Modal -->
<div id="faqsModal" class="modal small">
  <div class="modal-content">
    <h3>FAQs & Rules</h3>
    <ul>
      <li>⚠️ Bonus 5000 or 100 QQCoins cannot be invested.</li>
      <li>✅ Only real deposit via Rs / USDT / QQCoins is eligible.</li>
      <li>⏳ Schemes auto reset daily at 12 AM IST.</li>
      <li>💰 Profits auto credited to QQWallet after 24 hours.</li>
      <li>❌ If insufficient balance → popup will show.</li>
      <li>👤 1 User = 1 Account (security check active).</li>
    </ul>
    <button onclick="closeFaqs()" class="btn-close">Close</button>
  </div>
</div>

<!-- 💳 Deposit Modal -->
<div id="depositModal" class="modal small">
  <div class="modal-content">
    <h3>Deposit</h3>
    <div class="balances small">
      <span>₹ <span id="depRS">20000</span></span>
      <span>$ <span id="depUSDT">500</span></span>
      <span>QQ <span id="depQQ">1000</span></span>
    </div>
    <label>Mode:</label>
    <select id="depMode" style="color:#fff;background:#222;">
      <option value="RS">₹ Rupees</option>
      <option value="USDT">USDT</option>
      <option value="QQ">QQCoins</option>
    </select>
    <label>Amount:</label>
    <input type="number" id="depAmount" placeholder="Enter amount" style="color:#fff;background:#222;">
    <button onclick="submitDeposit()" class="btn-invest">Submit</button>
    <button onclick="closeDeposit()" class="btn-close">Cancel</button>
  </div>
</div>

<style>
/* Modal base */
.modal {display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:#000a;z-index:999;}
.modal-content {background:#111;color:#fff;margin:6% auto;padding:20px;border-radius:10px;max-width:600px;position:relative;}
.modal.small .modal-content{max-width:400px;}
.btn-x{position:absolute;top:8px;right:8px;background:#c00;color:#fff;border:none;padding:4px 10px;border-radius:50%;cursor:pointer;z-index:1000;}
.btn-close{background:#c00;padding:5px 12px;border:none;border-radius:6px;color:#fff;cursor:pointer;}
.btn-faq{background:maroon;color:#fff;padding:5px 12px;border:none;border-radius:6px;cursor:pointer;}
.scheme-table{width:100%;border-collapse:collapse;margin-top:10px;}
.scheme-table th,.scheme-table td{border:1px solid #0f0;padding:6px;text-align:center;}
.btn-invest{background:#0f0;color:#000;font-weight:bold;padding:4px 10px;border:none;border-radius:5px;cursor:pointer;}
.invested-amt{display:inline-block;background:#0f0;color:#000;font-weight:bold;padding:4px 10px;border-radius:5px;animation:blink 1s infinite;}
@keyframes blink{50%{opacity:0.5;}}

/* 🚂 ticker */
.ticker-wrapper{overflow:hidden;white-space:nowrap;background:transparent;color:#fff;font-weight:bold;margin-bottom:6px;font-size:13px;}
#tickerTrack{display:inline-block;animation:scroll-left 35s linear infinite;}
@keyframes scroll-left{0%{transform:translateX(100%);}100%{transform:translateX(-100%);}}
#tickerTrack span{margin-right:80px;font-weight:bold;}
</style>

<script>
let tickerMsgs=[
 "🚀 Agent-1122QQ deposited ₹35000 in Altcoins",
 "💹 Agent-4433QQ invested 500 USDT in Forex",
 "🏦 Agent-7788QQ joined Bonds scheme",
 "📊 Agent-9911QQ selected ETF Plan",
 "🔥 Agent-5566QQ took VIP Fund at 50%"
];
function renderTicker(){
 let el=document.getElementById("tickerTrack");
 el.innerHTML=tickerMsgs.map((m,i)=>`<span style="color:hsl(${(i*72)%360},100%,65%)">${m}</span>`).join("");
}
renderTicker();
setInterval(()=>{
 let agents=["1122","4433","5566","7788","9911","2244","8899"];
 let schemes=["Altcoins","Forex","Bonds","ETF Plan","VIP Fund"];
 let icons=["🚀","💹","🏦","📊","🔥"];
 let a=agents[Math.floor(Math.random()*agents.length)];
 let s=schemes[Math.floor(Math.random()*schemes.length)];
 let i=icons[Math.floor(Math.random()*icons.length)];
 let amt=Math.floor(Math.random()*5000+500);
 tickerMsgs.push(`${i} Agent-${a}QQ invested ${amt} in ${s}`);
 if(tickerMsgs.length>20) tickerMsgs.shift();
 renderTicker();
},10000);

// Deposit Logic
let currentBtn=null;
function openDeposit(btn,scheme){
 currentBtn=btn;
 document.getElementById("depositModal").style.display="block";
}
function closeDeposit(){document.getElementById("depositModal").style.display="none";}
function submitDeposit(){
 let amt=parseFloat(document.getElementById("depAmount").value)||0;
 let mode=document.getElementById("depMode").value;
 if(amt<=0){alert("Enter valid amount");return;}

 // 🔹 Fetch balances
 let rs=parseFloat(document.getElementById("balRS").innerText);
 let usdt=parseFloat(document.getElementById("balUSDT").innerText);
 let qq=parseFloat(document.getElementById("balQQ").innerText);

 if(mode==="RS" && amt>rs){alert("Insufficient ₹ balance!");return;}
 if(mode==="USDT" && amt>usdt){alert("Insufficient USDT balance!");return;}
 if(mode==="QQ" && amt>qq){alert("Insufficient QQCoins!");return;}

 // 🔹 Deduct from wallet
 if(mode==="RS"){rs-=amt;document.getElementById("balRS").innerText=rs;document.getElementById("depRS").innerText=rs;}
 if(mode==="USDT"){usdt-=amt;document.getElementById("balUSDT").innerText=usdt;document.getElementById("depUSDT").innerText=usdt;}
 if(mode==="QQ"){qq-=amt;document.getElementById("balQQ").innerText=qq;document.getElementById("depQQ").innerText=qq;}

 // 🔹 Replace Invest button
 if(currentBtn){
   currentBtn.outerHTML=`<span class="invested-amt">Invested: ${amt} ${mode}</span>`;
 }
 closeDeposit();
}

// FAQs Logic
function openFaqs(){document.getElementById("faqsModal").style.display="block";}
function closeFaqs(){document.getElementById("faqsModal").style.display="none";}
function closeModal(id){document.getElementById(id).style.display="none";}
</script>
EOF
