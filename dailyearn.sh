cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/dailyearn-modal.blade.php
<div id="dailyearn-modal" class="modal">
  <div class="modal-content">

    <!-- ❌ Close -->
    <button onclick="closeModal('dailyearn-modal')" class="btn-x">✖</button>

    <!-- 📜 FAQs -->
    <button onclick="openFaqs()" class="btn-faq">❓ FAQs</button>

    <!-- 🚂 Ticker -->
    <div class="ticker-wrapper">
      <div id="tickerTrack"></div>
    </div>

    <!-- 💰 Wallet -->
    <div class="wallet-box">
      <div class="wallet-item">💵 USDT <span id="balUSDT">1200.00</span></div>
      <div class="wallet-item">₹ INR <span id="balRS">50000.00</span></div>
      <div class="wallet-item">🪙 QQCOINS <span id="balQQ">250</span></div>
    </div>

    <!-- 🟢 Schemes -->
    <table class="scheme-table">
      <thead>
        <tr><th>S.No</th><th>Scheme</th><th>Seats</th><th>Interest</th><th>Invest</th></tr>
      </thead>
      <tbody>
        <tr><td>1</td><td>Altcoins</td><td>32/50</td><td data-int="30">30%</td><td><button onclick="openDeposit(this,'Altcoins',30)" class="btn-invest">Invest</button></td></tr>
        <tr><td>2</td><td>Forex</td><td>28/50</td><td data-int="35">35%</td><td><button onclick="openDeposit(this,'Forex',35)" class="btn-invest">Invest</button></td></tr>
        <tr><td>3</td><td>Bonds</td><td>21/50</td><td data-int="25">25%</td><td><button onclick="openDeposit(this,'Bonds',25)" class="btn-invest">Invest</button></td></tr>
        <tr><td>4</td><td>ETF Plan</td><td>38/50</td><td data-int="40">40%</td><td><button onclick="openDeposit(this,'ETF Plan',40)" class="btn-invest">Invest</button></td></tr>
        <tr><td>5</td><td>VIP Fund</td><td>35/50</td><td data-int="50">50%</td><td><button onclick="openDeposit(this,'VIP Fund',50)" class="btn-invest">Invest</button></td></tr>
      </tbody>
    </table>

  </div>
</div>

<!-- 📜 FAQs Modal -->
<div id="faqsModal" class="modal small">
  <div class="modal-content">
    <h3>FAQs & Rules</h3>
    <ul>
      <li>⚠️ Bonus 5000 or 100 QQCOINS cannot be invested.</li>
      <li>✅ Only real deposit via Rs / USDT / QQCoins is eligible.</li>
      <li>⏳ Schemes auto reset daily at 12 AM IST.</li>
      <li>💰 Profits auto credited to QQWallet after 24 hours.</li>
      <li>❌ If insufficient balance → popup will show.</li>
    </ul>
    <button onclick="closeFaqs()" class="btn-close">Close</button>
  </div>
</div>

<!-- 💳 Deposit Modal -->
<div id="depositModal" class="modal small">
  <div class="modal-content">
    <h3 id="depScheme">Deposit</h3>
    <div class="wallet-mini">
      <span>💵 USDT: <span id="depUSDT">1200.00</span></span>
      <span>₹ INR: <span id="depRS">50000.00</span></span>
      <span>🪙 QQCOINS: <span id="depQQ">250</span></span>
    </div>
    <label>Mode:</label>
    <select id="depMode">
      <option value="RS">₹ Rupees</option>
      <option value="USDT">USDT</option>
      <option value="QQ">QQCoins</option>
    </select>
    <label>Amount:</label>
    <div class="input-wrap">
      <span id="amtIcon">💰</span>
      <input type="number" id="depAmount" placeholder="Enter amount">
    </div>
    <button onclick="submitDeposit()" class="btn-invest">Submit</button>
    <button onclick="closeDeposit()" class="btn-close">Cancel</button>
  </div>
</div>

<!-- 🌌 Popup -->
<div id="popupMsg" class="popup"></div>

<style>
.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:#000a;z-index:999;}
.modal-content{background:#111;color:#fff;margin:5% auto;padding:20px;border-radius:12px;max-width:650px;font-family:'Segoe UI',sans-serif;font-weight:300;position:relative;}
.modal.small .modal-content{max-width:400px;}
.btn-x{position:absolute;top:10px;right:10px;background:#c00;color:#fff;border:none;padding:6px 10px;border-radius:50%;cursor:pointer;}
.btn-faq{position:absolute;top:10px;left:10px;background:#0f0;color:#000;padding:6px 12px;border:none;border-radius:6px;font-weight:bold;cursor:pointer;}
.btn-close{background:#c00;padding:6px 14px;border:none;border-radius:6px;color:#fff;cursor:pointer;}
.wallet-box{display:flex;justify-content:space-around;background:#1a1a1a;border:1px solid #0ff;border-radius:12px;padding:12px;margin:15px 0;box-shadow:0 0 12px #0ff3;}
.wallet-item{font-size:14px;font-weight:400;color:#0ff;}
.wallet-item span{color:#fff;font-weight:600;}
.wallet-mini span{display:block;margin:5px 0;color:#0ff;}
.scheme-table{width:100%;border-collapse:collapse;font-size:13px;font-weight:300;}
.scheme-table th,.scheme-table td{border:1px solid #0ff;padding:8px;text-align:center;}
.btn-invest{background:#0f0;color:#000;font-weight:600;padding:4px 12px;border:none;border-radius:6px;cursor:pointer;}
.btn-invest:hover{background:#5f5;}
.countdown{color:#ff0;font-weight:bold;animation:glow 1s infinite alternate;}
@keyframes glow{from{text-shadow:0 0 5px #ff0;}to{text-shadow:0 0 15px #ff0;}}
.ticker-wrapper{overflow:hidden;white-space:nowrap;background:#000;padding:5px 0;margin:40px 0 10px;}
#tickerTrack{display:inline-block;animation:scroll-left 30s linear infinite;font-size:13px;}
#tickerTrack span{margin-right:60px;}
@keyframes scroll-left{0%{transform:translateX(100%);}100%{transform:translateX(-100%);}}

/* Input with icon */
.input-wrap{position:relative;display:flex;align-items:center;}
.input-wrap span{position:absolute;left:10px;color:#0f0;font-size:16px;}
.input-wrap input{width:100%;padding:8px 8px 8px 30px;background:#111;border:1px solid #0f0;border-radius:6px;font-weight:600;font-size:15px;color:#0f0;}
.input-wrap input::placeholder{color:#666;}

/* Deposit select */
#depositModal select{width:100%;margin:8px 0;padding:8px;background:#111;color:#0f0;border:1px solid #0f0;border-radius:6px;font-weight:600;}
#depositModal select option{background:#111;color:#0f0;}

/* Popup */
.popup{display:none;position:fixed;top:20%;left:50%;transform:translateX(-50%);background:#111;padding:20px 30px;border-radius:12px;text-align:center;font-size:16px;font-weight:bold;z-index:2000;color:#fff;box-shadow:0 0 20px #0ff;}
</style>

<script>
let tickerMsgs=["🚀 Agent-1122QQ deposited ₹35000 in Altcoins","💹 Agent-4433QQ invested 500 USDT in Forex"];
function renderTicker(){document.getElementById("tickerTrack").innerHTML=tickerMsgs.map((m,i)=>`<span style="color:hsl(${(i*60)%360},100%,65%)">${m}</span>`).join("");}
renderTicker();

// Deposit Vars
let currentBtn=null,currentScheme="",currentInterest=0,currentAmt=0,currentMode="";
document.getElementById("depMode").addEventListener("change",function(){
  let mode=this.value;
  let iconEl=document.getElementById("amtIcon");
  if(mode==="RS"){iconEl.innerText="₹";}
  else if(mode==="USDT"){iconEl.innerText="$";}
  else if(mode==="QQ"){iconEl.innerText="🪙";}
});
function openDeposit(btn,scheme,intRate){
 currentBtn=btn;currentScheme=scheme;currentInterest=intRate;
 document.getElementById("depScheme").innerText="Deposit in "+scheme;
 syncBalances();
 document.getElementById("depositModal").style.display="block";
}
function closeDeposit(){document.getElementById("depositModal").style.display="none";}
function syncBalances(){
 document.getElementById("depRS").innerText=document.getElementById("balRS").innerText;
 document.getElementById("depUSDT").innerText=document.getElementById("balUSDT").innerText;
 document.getElementById("depQQ").innerText=document.getElementById("balQQ").innerText;
}
function submitDeposit(){
 let amt=parseFloat(document.getElementById("depAmount").value)||0;
 let mode=document.getElementById("depMode").value;
 if(amt<=0){showPopup("Enter valid amount","error");return;}
 let rs=parseFloat(document.getElementById("balRS").innerText);
 let usdt=parseFloat(document.getElementById("balUSDT").innerText);
 let qq=parseFloat(document.getElementById("balQQ").innerText);
 if(mode==="RS"&&amt>rs){showPopup("Insufficient ₹ balance!","error");return;}
 if(mode==="USDT"&&amt>usdt){showPopup("Insufficient USDT!","error");return;}
 if(mode==="QQ"&&amt>qq){showPopup("Insufficient QQCoins!","error");return;}
 if(mode==="RS"){document.getElementById("balRS").innerText=(rs-amt).toFixed(2);}
 if(mode==="USDT"){document.getElementById("balUSDT").innerText=(usdt-amt).toFixed(2);}
 if(mode==="QQ"){document.getElementById("balQQ").innerText=(qq-amt).toFixed(0);}
 syncBalances();
 currentAmt=amt;currentMode=mode;
 if(currentBtn){
   let endTime=Date.now()+24*60*60*1000;
   let span=document.createElement("span");
   span.className="countdown";
   currentBtn.replaceWith(span);
   updateCountdown(span,endTime,amt,mode,currentScheme,currentInterest);
 }
 showPopup("Deposit Successful in "+currentScheme+": "+amt+" "+mode,"success");
 closeDeposit();
}
function updateCountdown(el,end,amt,mode,scheme,intRate){
 function tick(){
   let diff=end-Date.now();
   if(diff<=0){
     let profit=amt*(intRate/100);
     if(mode==="RS"){document.getElementById("balRS").innerText=(parseFloat(document.getElementById("balRS").innerText)+amt+profit).toFixed(2);}
     if(mode==="USDT"){document.getElementById("balUSDT").innerText=(parseFloat(document.getElementById("balUSDT").innerText)+amt+profit).toFixed(2);}
     if(mode==="QQ"){document.getElementById("balQQ").innerText=(parseFloat(document.getElementById("balQQ").innerText)+amt+profit).toFixed(0);}
     syncBalances();
     showPopup("Withdraw Successful – "+(amt+profit).toFixed(2)+" "+mode+" credited!","success");
     let btn=document.createElement("button");
     btn.className="btn-invest";
     btn.innerText="Invest";
     btn.setAttribute("onclick","openDeposit(this,'"+scheme+"',"+intRate+")");
     el.replaceWith(btn);
     return;
   }
   let h=Math.floor(diff/3600000),m=Math.floor((diff%3600000)/60000),s=Math.floor((diff%60000)/1000);
   el.innerText="Withdraw in "+h.toString().padStart(2,"0")+":"+m.toString().padStart(2,"0")+":"+s.toString().padStart(2,"0");
   setTimeout(tick,1000);
 }
 tick();
}
function showPopup(msg,type="info"){
 let el=document.getElementById("popupMsg");
 if(type==="success"){msg="✅ "+msg;el.style.color="#0f0";el.style.border="1px solid #0f0";el.style.boxShadow="0 0 20px #0f0, 0 0 40px #0f08";}
 else if(type==="error"){msg="❌ "+msg;el.style.color="#f00";el.style.border="1px solid #f00";el.style.boxShadow="0 0 20px #f00, 0 0 40px #f008";}
 else {msg="ℹ️ "+msg;el.style.color="#0ff";el.style.border="1px solid #0ff";el.style.boxShadow="0 0 20px #0ff, 0 0 40px #0ff8";}
 el.innerText=msg;el.style.display="block";
 setTimeout(()=>{el.style.display="none";},3000);
}
function closeModal(id){document.getElementById(id).style.display="none";}
function openFaqs(){document.getElementById("faqsModal").style.display="block";}
function closeFaqs(){document.getElementById("faqsModal").style.display="none";}
</script>
EOF
