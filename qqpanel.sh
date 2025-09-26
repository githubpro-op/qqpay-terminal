cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/qqpanel-modal.blade.php
<!-- QQPANEL Modal -->
<div id="qqpanel-modal" class="modal">
  <div class="modal-content qqpanel-box">
    <button onclick="closeModal('qqpanel-modal')" class="btn-x">✖</button>

    <!-- HEADER -->
    <h2 class="qqpanel-heading">QQPANEL</h2>
    <p class="qqpanel-sub">High Volume • Commission</p>

    <!-- TICKER -->
    <div class="ticker-box">
      <div class="ticker">
        <span>💰 Savings account commission 3%</span>
        <span>🏦 Current account commission 3.2%</span>
        <span>👔 Corporate account commission 3.5%</span>
        <span>🎮 Pure gaming funds</span>
        <span>✅ No complaints no cyber</span>
        <span>💳 Savings need 100 USDT or 10000₹ refundable</span>
        <span>💳 Current need 200 USDT or 20000₹ refundable</span>
        <span>💳 Corporate need 500 USDT or 50000₹ refundable</span>
        <span>📆 Savings life 20-25 days</span>
        <span>📆 Current life 5-8 days</span>
        <span>📆 Corporate life 5-7 days</span>
        <span>🏦 All banks accepted with/without merchant QR</span>
        <span>💸 Commission withdrawable 24x7 via QQWallet</span>
        <span>📱 Sim card needed only for first registration</span>
        <span>🔟 After deposit, agent can run 10 accounts</span>
      </div>
    </div>

    <!-- TILES -->
    <div class="tiles-row">
      <div class="tile-btn" onclick="toggleTile('addBankForm')">➕ Add Bank</div>
      <div class="tile-btn" onclick="toggleTile('rulesBox')">📜 Rules</div>
      <div class="tile-btn" onclick="toggleTile('activeAccountsBox')">📂 Active Accounts</div>
    </div>

    <!-- ADD BANK FORM MULTI STEP -->
    <div id="addBankForm" class="hidden form-box">
      <h3>Add Bank - Multi Step</h3>
      <form id="bankForm">

        <!-- Step 1 -->
        <div class="step" id="step1">
          <label>Select Bank</label>
          <select id="bankName">
            <option>State Bank of India</option>
            <option>HDFC Bank</option>
            <option>ICICI Bank</option>
            <option>Axis Bank</option>
            <option>Punjab National Bank</option>
            <option>Bank of Baroda</option>
            <option>Canara Bank</option>
            <option>Kotak Mahindra Bank</option>
            <option>Union Bank of India</option>
            <option>Yes Bank</option>
            <option>IDFC First Bank</option>
            <option>IndusInd Bank</option>
            <option>Central Bank of India</option>
            <option>Indian Bank</option>
            <option>Bank of India</option>
            <option>UCO Bank</option>
            <option>South Indian Bank</option>
            <option>Karur Vysya Bank</option>
            <option>DCB Bank</option>
            <option>J&K Bank</option>
            <option>Federal Bank</option>
            <option>RBL Bank</option>
            <option>Saraswat Bank</option>
            <option>Bandhan Bank</option>
            <option>Punjab & Sind Bank</option>
            <option>Karnataka Bank</option>
            <option>Tamilnad Mercantile Bank</option>
            <option>Bank of Maharashtra</option>
            <option>City Union Bank</option>
            <option>Andhra Bank</option>
          </select>
          <label>Type</label>
          <select id="bankType">
            <option>Savings</option>
            <option>Current</option>
            <option>Corporate</option>
          </select>
          <label>Mode</label>
          <select id="bankMode">
            <option>1ID</option>
            <option>2ID</option>
            <option>3ID</option>
          </select>
          <label>Bank Mobile Number</label>
          <input type="text" id="bankMobile">
        </div>

        <!-- Step 2 -->
        <div class="step hidden" id="step2">
          <label>User ID</label><input type="text">
          <label>Password</label><input type="password">
          <label>Profile Password (if any)</label><input type="password">
          <label>Transaction Password (if any)</label><input type="password">
        </div>

        <!-- Step 3 -->
        <div class="step hidden" id="step3">
          <label>User ID</label><input type="text">
          <label>Password</label><input type="password">
          <label>Transaction Password (if any)</label><input type="password">
          <label>Profile Password (if any)</label><input type="password">
        </div>

        <!-- Step 4 -->
        <div class="step hidden" id="step4">
          <label>User ID</label><input type="text">
          <label>Password</label><input type="password">
          <label>Transaction Password (if any)</label><input type="password">
          <label>Profile Password (if any)</label><input type="password">
        </div>

        <!-- Step 5 -->
        <div class="step hidden" id="step5">
          <label>Debit Card Number (Optional)</label><input type="text">
          <label>Expiry</label><input type="text">
          <label>CVV</label><input type="password">
          <label>PIN</label><input type="password">
          <label>Upload Merchant QR (Optional)</label>
          <input type="file">
        </div>

        <!-- Buttons -->
        <div class="form-buttons">
          <button type="button" onclick="prevStep()" id="backBtn" class="hidden">⬅ Back</button>
          <button type="button" onclick="nextStep()" id="nextBtn">Next ➡</button>
          <button type="button" onclick="skipStep()" id="skipBtn">Skip ⏭</button>
          <button type="button" onclick="submitBank()" id="submitBtn" class="hidden">✅ Submit</button>
        </div>
      </form>
    </div>

    <!-- RULES -->
    <div id="rulesBox" class="hidden rules-box">
      <h3>Rules</h3>
      <ul>
        <li>Savings account commission 3%</li>
        <li>Current account commission 3.2%</li>
        <li>Corporate account commission 3.5%</li>
        <li>Pure gaming funds allowed</li>
        <li>No complaints / No cyber issues</li>
        <li>Savings → 100 USDT / 10000₹ refundable deposit</li>
        <li>Current → 200 USDT / 20000₹ refundable deposit</li>
        <li>Corporate → 500 USDT / 50000₹ refundable deposit</li>
        <li>Account life: Savings 20-25d, Current 5-8d, Corporate 5-7d</li>
        <li>All banks accepted</li>
        <li>Commission withdraw 24x7 via QQWallet</li>
      </ul>
    </div>

    <!-- ACTIVE ACCOUNTS -->
    <div id="activeAccountsBox" class="hidden accounts-box">
      <h3>Active Accounts</h3>
      <table class="acc-table">
        <thead>
          <tr><th>Bank ID</th><th>Status</th><th>Remarks</th></tr>
        </thead>
        <tbody id="accTableBody"></tbody>
      </table>
    </div>

    <!-- COMMISSION GRAPH -->
    <div class="commission-graph">
      <canvas id="commissionChart"></canvas>
    </div>

    <!-- COMMISSION TABLE -->
    <div class="commission-table">
      <h3>Commission Overview</h3>
      <table>
        <thead>
          <tr><th>Bank ID</th><th>Today Commission</th><th>Total Commission</th><th>Status</th></tr>
        </thead>
        <tbody id="commTableBody"></tbody>
      </table>
    </div>
  </div>
</div>

<!-- FUTURISTIC POPUP -->
<div id="popupBox" class="popup hidden">
  <div class="popup-content">
    <p id="popupMsg"></p>
    <button onclick="closePopup()">OK</button>
  </div>
</div>

<style>
.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.92);overflow:auto;z-index:9999;}
.qqpanel-box{max-width:900px;margin:2% auto;padding:20px;background:#0a0a0a;border-radius:12px;box-shadow:0 0 25px #ff00ff66;}
.btn-x{position:absolute;top:15px;right:15px;background:#ff1744;color:#fff;border:none;padding:6px 10px;border-radius:50%;cursor:pointer;}
.qqpanel-heading{text-align:center;color:#0f0;font-size:24px;text-shadow:0 0 15px #0f0,0 0 25px #f0f;}
.qqpanel-sub{text-align:center;color:#aaa;margin-bottom:15px;}
/* Ticker */
.ticker-box{overflow:hidden;white-space:nowrap;border:1px solid #333;margin:10px 0;padding:6px;background:#111;}
.ticker{display:inline-block;padding-left:100%;animation:ticker 40s linear infinite;}
.ticker span{margin:0 30px;color:#0ff;font-weight:bold;animation:colorShift 5s infinite;}
@keyframes ticker{0%{transform:translateX(0);}100%{transform:translateX(-100%);}}
@keyframes colorShift{0%{color:#0f0;}50%{color:#f0f;}100%{color:#0ff;}}
/* Tiles */
.tiles-row{display:flex;gap:10px;margin:15px 0;justify-content:center;}
.tile-btn{flex:1;background:#111;border:1px solid #f0f;color:#fff;padding:12px;text-align:center;border-radius:10px;cursor:pointer;box-shadow:0 0 12px #f0f;}
.tile-btn:hover{background:#0f0;color:#000;}
/* Forms */
.form-box{margin-top:15px;padding:12px;background:#111;border-radius:10px;color:#fff;max-height:400px;overflow-y:auto;}
.form-box input,.form-box select{width:100%;padding:8px;margin:5px 0;border-radius:6px;border:1px solid #444;background:#fafafa;color:#000;}
.form-buttons{display:flex;justify-content:space-between;margin-top:10px;}
.form-buttons button{flex:1;margin:0 5px;padding:8px;border:none;border-radius:6px;background:#ff00ff99;color:#fff;cursor:pointer;box-shadow:0 0 10px #ff00ff;}
.form-buttons button:hover{background:#0f0;color:#000;}
/* Tables */
.acc-table,.commission-table table{width:100%;border-collapse:collapse;margin-top:10px;}
.acc-table th,.commission-table th{background:#111;color:#0f0;padding:8px;}
.acc-table td,.commission-table td{padding:8px;border-bottom:1px solid #333;color:#fff;}
.inactive{color:#f00;animation:blink 1.5s infinite;}
@keyframes blink{50%{opacity:0.3;}}
/* Graph */
.commission-graph{margin:20px 0;}
/* Popup */
.popup{position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.85);display:flex;align-items:center;justify-content:center;z-index:10000;}
.popup-content{background:#111;padding:20px;border-radius:10px;text-align:center;box-shadow:0 0 20px #0f0,0 0 25px #f0f;}
.popup-content p{color:#fff;font-size:16px;margin-bottom:10px;}
.popup-content button{padding:8px 15px;border:none;background:#0f0;color:#000;border-radius:6px;cursor:pointer;}
.hidden{display:none;}
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
let currentStep=1;
function showStep(step){
  document.querySelectorAll(".step").forEach(s=>s.classList.add("hidden"));
  document.getElementById("step"+step).classList.remove("hidden");
  document.getElementById("backBtn").classList.toggle("hidden",step===1);
  document.getElementById("nextBtn").classList.toggle("hidden",step===5);
  document.getElementById("skipBtn").classList.toggle("hidden",step===5);
  document.getElementById("submitBtn").classList.toggle("hidden",step!==5);
}
function nextStep(){if(currentStep<5){currentStep++;showStep(currentStep);}}
function prevStep(){if(currentStep>1){currentStep--;showStep(currentStep);}}
function skipStep(){nextStep();}

function submitBank(){
  const bank=document.getElementById("bankName").value;
  const type=document.getElementById("bankType").value;
  if(!bank || !type){openPopup("❌ Please fill all details first");return;}
  const rand=Math.floor(Math.random()*9000)+1000;
  const bankID=bank.split(" ")[0].toUpperCase()+"-"+rand;
  let remark=""; if(type==="Savings"){remark="Deposit 100 USDT / 10000₹";} 
  if(type==="Current"){remark="Deposit 200 USDT / 20000₹";} 
  if(type==="Corporate"){remark="Deposit 500 USDT / 50000₹";}
  document.getElementById("accTableBody").innerHTML+=`<tr><td>${bankID}</td><td class="inactive">Inactive</td><td>${remark}</td></tr>`;
  document.getElementById("commTableBody").innerHTML+=`<tr><td>${bankID}</td><td>₹0</td><td>₹0</td><td class="inactive">Inactive</td></tr>`;
  openPopup("✅ Account added successfully!");
  currentStep=1;showStep(1);
}

function toggleTile(id){
  const el=document.getElementById(id);
  if(el.style.display==="block"){el.style.display="none";}
  else{document.querySelectorAll('.form-box,.rules-box,.accounts-box').forEach(x=>x.style.display="none");el.style.display="block";}
}

function openPopup(msg){document.getElementById("popupMsg").innerText=msg;document.getElementById("popupBox").classList.remove("hidden");}
function closePopup(){document.getElementById("popupBox").classList.add("hidden");}

/* Commission Graph */
const ctx=document.getElementById('commissionChart');
new Chart(ctx,{type:'line',data:{labels:['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],datasets:[{label:'Commission ₹',data:[5000,8000,12000,7000,15000,9000,20000],borderColor:'#0f0',backgroundColor:'#0f04',fill:true}]},options:{plugins:{legend:{labels:{color:'#fff'}}},scales:{x:{ticks:{color:'#fff'}},y:{ticks:{color:'#fff'}}}}});

showStep(1);
</script>
EOF
