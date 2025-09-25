cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/wallet-modal.blade.php
<!-- Wallet Modal - Futuristic Pink-Green (UPI/USDT clickable QR + copy/save) -->
<div id="wallet-modal" class="modal">
  <div class="modal-content wallet-neon">
    <button onclick="closeModal('wallet-modal')" class="btn-x">✖</button>

    <!-- Header -->
    <div class="wm-header">
      <div class="wm-title">QQWALLET</div>
      <div class="wm-sub">SAFE • RELIABLE • FAST</div>
    </div>

    <!-- Balance Table -->
    <div class="wallet-balance-box">
      <table class="wallet-bal-table">
        <tr>
          <th>USDT</th>
          <th>₹ INR</th>
          <th>QQCOINS</th>
          <th>Total</th>
        </tr>
        <tr>
          <td id="wBalUSDT">1200</td>
          <td id="wBalRS">50,000</td>
          <td id="wBalQQ">250</td>
          <td id="wBalTotal">65,000</td>
        </tr>
      </table>
    </div>

    <!-- Action Tiles -->
    <div class="wallet-actions">
      <div class="wallet-act-card" onclick="openForm('depositForm')">💰 Deposit</div>
      <div class="wallet-act-card" onclick="openForm('withdrawForm')">🏧 Withdraw</div>
      <div class="wallet-act-card" onclick="openForm('exchangeForm')">♻️ Exchange</div>
      <div class="wallet-act-card" onclick="openForm('transferForm')">🔁 Transfer</div>
    </div>

    <!-- Forms Section -->
    <div id="walletForms">

      <!-- Deposit Form -->
      <div id="depositForm" class="form-box hidden">
        <h3>Deposit Funds</h3>
        <label>Enter Amount</label>
        <input type="number" id="depositAmt" placeholder="Enter amount">
        <div class="method-tiles">
          <button onclick="depositMethod('upi')">UPI</button>
          <button onclick="depositMethod('bank')">Bank</button>
          <button onclick="depositMethod('usdt')">USDT (TRC20)</button>
        </div>
        <div id="depositDetails"></div>
        <label>Upload Payment Receipt</label>
        <input type="file" id="depositReceipt" accept="image/*">
        <button onclick="submitDeposit()">Submit</button>
      </div>

      <!-- Withdraw Form -->
      <div id="withdrawForm" class="form-box hidden">
        <h3>Withdraw Funds</h3>
        <label>Enter Amount</label>
        <input type="number" id="withdrawAmt" placeholder="Enter amount">
        <div class="method-tiles">
          <button onclick="withdrawMethod('upi')">UPI</button>
          <button onclick="withdrawMethod('bank')">Bank</button>
          <button onclick="withdrawMethod('usdt')">USDT (TRC20)</button>
        </div>
        <div id="withdrawDetails"></div>
        <label>Upload Payment Receipt (if required)</label>
        <input type="file" id="withdrawReceipt" accept="image/*">
        <button onclick="submitWithdraw()">Submit</button>
      </div>

      <!-- Transfer Form -->
      <div id="transferForm" class="form-box hidden">
        <h3>Transfer Funds</h3>
        <label>Recipient QQ ID</label>
        <input type="text" id="transferID" placeholder="e.g., Agent-1122QQ">
        <label>Mode</label>
        <select id="transferMode">
          <option value="USDT">USDT</option>
          <option value="RS">₹ INR</option>
          <option value="QQ">QQCoins</option>
        </select>
        <label>Amount</label>
        <input type="number" id="transferAmt" placeholder="Enter amount">
        <button onclick="submitTransfer()">Submit</button>
      </div>

      <!-- Exchange Form -->
      <div id="exchangeForm" class="form-box hidden">
        <h3>Exchange</h3>
        <div class="exchange-rates">
          <div>1 USDT ≈ <span id="rateUsdt">96</span> ₹ <span class="arrow" id="usdtArrow">🔺</span></div>
          <div>1 QQCoin ≈ <span id="rateQq">0.85</span> ₹ <span class="arrow" id="qqArrow">🔻</span></div>
        </div>
        <label>From</label>
        <select id="exchangeFrom">
          <option value="USDT">USDT</option>
          <option value="RS">₹ INR</option>
          <option value="QQ">QQCoins</option>
        </select>
        <label>To</label>
        <select id="exchangeTo">
          <option value="RS">₹ INR</option>
          <option value="USDT">USDT</option>
          <option value="QQ">QQCoins</option>
        </select>
        <label>Amount</label>
        <input type="number" id="exchangeAmt" placeholder="Enter amount">
        <button onclick="submitExchange()">Swap</button>
      </div>
    </div>

    <!-- History -->
    <div class="wallet-history">
      <div class="history-head">Transaction History</div>
      <div id="walletActivityList" class="history-list"></div>
    </div>
  </div>
</div>

<style>
.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.9);z-index:9999;overflow:auto;}
.wallet-neon{max-width:850px;margin:2% auto;padding:20px;border-radius:16px;background:#0a0a0a;box-shadow:0 0 25px #ff00ff77;}
.wm-header{text-align:center;margin-bottom:12px;}
.wm-title{font-size:22px;color:#0f0;font-weight:700;text-shadow:0 0 20px #0f0,0 0 25px #f0f;}
.wm-sub{font-size:12px;color:#aaa;}
.wallet-bal-table{width:100%;border-collapse:collapse;margin:10px 0;text-align:center;}
.wallet-bal-table th{background:#111;color:#0f0;padding:6px;}
.wallet-bal-table td{padding:10px;color:#fff;border-top:1px solid #333;}
.wallet-actions{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin:15px 0;}
.wallet-act-card{background:#111;padding:18px;text-align:center;border-radius:12px;cursor:pointer;color:#fff;text-shadow:0 0 10px #f0f;border:1px solid #ff00ff44;box-shadow:0 0 12px #ff00ff66;}
.wallet-act-card:hover{background:#0f0;color:#000;transition:.2s;}
.form-box{margin-top:12px;padding:12px;background:#111;border-radius:10px;}
.form-box input,.form-box select{width:100%;padding:8px;margin:6px 0;border-radius:6px;border:1px solid #444;background:#fafafa;color:#000;}
.method-tiles{display:flex;gap:8px;margin:8px 0;}
.method-tiles button{flex:1;padding:8px;border:none;border-radius:6px;background:#ff00ff99;color:#fff;cursor:pointer;}
.wallet-history{margin-top:20px;background:#0f0f0f;padding:10px;border-radius:10px;border:1px solid #333;}
.history-item{padding:6px;border-bottom:1px solid #222;font-size:13px;color:#ccc;}
.exchange-rates{display:flex;justify-content:space-around;margin-bottom:10px;}
.arrow.green{color:#0f0;}
.arrow.red{color:#f00;}
.hidden{display:none;}
.copy-btn{margin-left:8px;padding:6px 8px;border-radius:6px;background:#222;color:#fff;border:1px solid #555;cursor:pointer;}
.save-btn{margin-left:8px;padding:6px 8px;border-radius:6px;background:#0f0;color:#000;border:none;cursor:pointer;}
</style>

<script>
/* ----- Helpers & demo history ----- */
const historyEl = document.getElementById("walletActivityList");
function addHistory(msg){ const d = document.createElement("div"); d.className="history-item"; d.textContent = msg; if(historyEl) historyEl.prepend(d); }

/* Init demo entries */
addHistory("✅ Wallet opened");

/* Open form area */
function openForm(id){
  document.querySelectorAll("#walletForms > div").forEach(el => el.classList.add('hidden'));
  const f = document.getElementById(id);
  if(f) f.classList.remove('hidden');
}

/* ----- Deposit (UPI/Bank/USDT) ----- */

/*
  Replace these dummy values with real merchant IDs / addresses from backend.
  UPI deep link format:
    upi://pay?pa=PAYID&pn=NAME&am=AMOUNT&tn=NOTE
  Clicking the <a href="upi://pay?..."> on mobile will open the UPI app (if present).
*/

const UPI_ID = "qqpay@upi";                 // merchant UPI id (example)
const UPI_DISPLAY = "qqpay@upi";            // text shown
const USDT_ADDR = "TXYZ-123-ABC";           // example TRC20 address
const BANK_ACC = "123456789";
const BANK_IFSC = "HDFC0001234";
const MERCHANT_NAME = "QQPAY";

function depositMethod(type){
  const el = document.getElementById("depositDetails");
  const amt = (document.getElementById("depositAmt")||{}).value || "";
  const amountParam = amt ? `&am=${encodeURIComponent(amt)}` : "";
  if(type === "upi"){
    // build UPI deep link
    const upiLink = `upi://pay?pa=${encodeURIComponent(UPI_ID)}&pn=${encodeURIComponent(MERCHANT_NAME)}${amountParam}&tn=${encodeURIComponent("QQPAY Deposit")}`;
    el.innerHTML = `
      <p>Pay via UPI:</p>
      <div><b id="upiID">${UPI_DISPLAY}</b>
        <button class="copy-btn" onclick="copyById('upiID')">Copy</button>
        <button class="copy-btn" onclick="openUpiIntent('${UPI_ID}','${MERCHANT_NAME}','${amt}')">Open UPI App</button>
      </div>
      <div style="margin-top:8px">
        <a href="${upiLink}" id="upiDeepLink" onclick="/* link used for mobile */" style="display:inline-block;">
          <img id="upiQR" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(upiLink)}" width="150" alt="UPI QR">
        </a>
        <button class="save-btn" onclick="downloadImage(document.getElementById('upiQR').src, 'qqpay-upi-qr.png')">Save QR</button>
        <button class="copy-btn" onclick="shareText('UPI','${UPI_DISPLAY}','${upiLink}')">Share</button>
      </div>
    `;
  }
  if(type === "bank"){
    el.innerHTML = `
      <p>Bank Transfer Details:</p>
      <div><b>Bank:</b> HDFC<br><b>Name:</b> ${MERCHANT_NAME}<br><b>Acc:</b> <span id="bankAcc">${BANK_ACC}</span>
      <button class="copy-btn" onclick="copyById('bankAcc')">Copy</button><br><b>IFSC:</b> ${BANK_IFSC}</div>
      <div style="margin-top:8px"><label>Upload screenshot/receipt</label></div>
    `;
  }
  if(type === "usdt"){
    // For USDT, generate QR for the address & allow copy
    el.innerHTML = `
      <p>Send via USDT TRC20:</p>
      <div><b id="usdtAddr">${USDT_ADDR}</b>
      <button class="copy-btn" onclick="copyById('usdtAddr')">Copy</button>
      <button class="copy-btn" onclick="shareText('USDT','${USDT_ADDR}','')">Share</button></div>
      <div style="margin-top:8px">
        <img id="usdtQR" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(USDT_ADDR)}" width="150" alt="USDT QR">
        <button class="save-btn" onclick="downloadImage(document.getElementById('usdtQR').src, 'qqpay-usdt-qr.png')">Save QR</button>
      </div>
    `;
  }
}

/* ----- Withdraw methods (simple placeholders) ----- */
function withdrawMethod(type){
  const el = document.getElementById("withdrawDetails");
  if(type==="upi"){
    el.innerHTML = `<label>Enter your UPI ID</label><input id="wUpi" placeholder="eg user@upi">`;
  } else if(type==="bank"){
    el.innerHTML = `<label>Name</label><input><label>Bank</label><input><label>Acc No</label><input><label>IFSC</label><input>`;
  } else if(type==="usdt"){
    el.innerHTML = `<label>TRC20 Address</label><input id="wUsdt" placeholder="TRC20 address">`;
  }
}

/* ----- Submit handlers (basic demo) ----- */
function submitDeposit(){
  const amt = document.getElementById("depositAmt")?.value || "";
  if(!amt || Number(amt) <= 0){ showPopup("Enter a valid amount","error"); return; }
  addHistory(`✅ Deposit requested ₹${amt}`);
  showPopup("Deposit request submitted — wait for verification","success");
  // clear form
  document.getElementById("depositAmt").value = "";
  document.getElementById("depositReceipt").value = "";
  document.getElementById("depositDetails").innerHTML = "";
}
function submitWithdraw(){
  const amt = document.getElementById("withdrawAmt")?.value || "";
  if(!amt || Number(amt) <= 0){ showPopup("Enter a valid amount","error"); return; }
  addHistory(`✅ Withdraw requested ₹${amt}`);
  showPopup("Withdraw request submitted — processing","success");
  document.getElementById("withdrawAmt").value = "";
  document.getElementById("withdrawReceipt").value = "";
  document.getElementById("withdrawDetails").innerHTML = "";
}
function submitTransfer(){
  const id = document.getElementById("transferID")?.value || "";
  const amt = document.getElementById("transferAmt")?.value || "";
  if(!id){ showPopup("Enter recipient ID","error"); return; }
  if(!amt || Number(amt) <= 0){ showPopup("Enter valid amount","error"); return; }
  addHistory(`✅ Transferred ${amt} to ${id}`);
  showPopup("Transfer successful (demo)","success");
  document.getElementById("transferID").value = "";
  document.getElementById("transferAmt").value = "";
}
function submitExchange(){
  const amt = document.getElementById("exchangeAmt")?.value || "";
  if(!amt || Number(amt) <= 0){ showPopup("Enter valid amount","error"); return; }
  addHistory(`✅ Exchanged ${amt}`);
  showPopup("Exchange completed (demo)","success");
  document.getElementById("exchangeAmt").value = "";
}

/* ----- Utility: copy / download / share / open UPI intent ----- */
function copyById(id){
  const el = document.getElementById(id);
  if(!el) return;
  const txt = el.innerText || el.value || el.textContent;
  navigator.clipboard.writeText(txt).then(()=> showPopup("Copied: "+txt,"success"), ()=> showPopup("Copy failed","error"));
}
function downloadImage(url, filename){
  // create an <a download> to trigger
  const a = document.createElement('a');
  a.href = url;
  a.download = filename || 'qr.png';
  document.body.appendChild(a);
  a.click();
  a.remove();
  showPopup("QR image download started","success");
}
function shareText(kind, text, link){
  // Try native share first
  const payload = {title: "QQPAY "+kind, text: text + (link?("\n"+link):"")};
  if(navigator.share){
    navigator.share(payload).then(()=> showPopup("Share sheet opened","success")).catch(()=> showPopup("Share canceled","info"));
  } else {
    // fallback: copy to clipboard
    navigator.clipboard.writeText(text + (link?("\n"+link):"")).then(()=> showPopup("Copied share text","success"));
  }
}
/* Open UPI intent with parameters (prefers opening app if on mobile) */
function openUpiIntent(pa, pn, am){
  // build upi link
  const amountPart = am ? `&am=${encodeURIComponent(am)}` : '';
  const upiLink = `upi://pay?pa=${encodeURIComponent(pa)}&pn=${encodeURIComponent(pn)}${amountPart}&tn=${encodeURIComponent('QQPAY Deposit')}`;
  // Try to open via location; on mobile it will prompt apps that handle upi
  window.location.href = upiLink;
  // fallback message
  setTimeout(()=> showPopup("If UPI app didn't open, copy the UPI ID and pay manually.","info"), 800);
}

/* ----- Live exchange rates (demo) ----- */
let usdtRate = 96.00, qqRate = 0.85;
function updateRates(){
  const uChange = (Math.random()*0.6 - 0.3);
  const qChange = (Math.random()*0.03 - 0.015);
  usdtRate = Math.max(96, Math.min(98, +(usdtRate + uChange).toFixed(2)));
  qqRate = Math.max(0.80, Math.min(0.95, +(qqRate + qChange).toFixed(3)));
  const usdtEl = document.getElementById("rateUsdt");
  const qqEl = document.getElementById("rateQq");
  const usdtArrow = document.getElementById("usdtArrow");
  const qqArrow = document.getElementById("qqArrow");
  if(usdtEl){ usdtEl.innerText = usdtRate.toFixed(2); usdtArrow.innerText = uChange >= 0 ? "🔺" : "🔻"; usdtArrow.style.color = uChange >= 0 ? "#0f0" : "#f00";}
  if(qqEl){ qqEl.innerText = qqRate.toFixed(3); qqArrow.innerText = qChange >= 0 ? "🔺" : "🔻"; qqArrow.style.color = qChange >= 0 ? "#0f0" : "#f00";}
}
setInterval(updateRates, 800);
updateRates();

/* ----- Popup (simple) ----- */
function showPopup(msg, type='info'){
  // prefer existing showPopup if present elsewhere
  if(typeof window.showPopup === 'function' && window.showPopup !== showPopup){
    window.showPopup(msg, type); return;
  }
  // simple toast
  alert((type==='success'?'✅ ':'') + msg);
}

/* ----- open default form (keep deposit hidden till user clicks) ----- */
openForm(''); // hide all forms initially
</script>
EOF
