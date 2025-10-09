cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/wallet-modal.blade.php
<!-- ⚡ QQWALLET MODAL — FINAL PRODUCTION VERSION -->
<div id="wallet-modal" class="modal">
  <div class="modal-content wallet-neon">
    <button onclick="closeModal('wallet-modal')" class="btn-x">✖</button>

    <div class="wm-header">
      <div class="wm-title">QQWALLET</div>
      <div class="wm-sub">INSTANT • SECURE • SMART FINANCE</div>
    </div>

    <!-- BALANCES -->
    <div class="wallet-balance-box">
      <table class="wallet-bal-table">
        <tr>
          <th>USDT (₮)</th>
          <th>₹ INR</th>
          <th>QQCOINS</th>
        </tr>
        <tr>
          <td id="wBalUSDT">0.0000 ₮</td>
          <td id="wBalRS">₹0.00</td>
          <td id="wBalQQ">0.0000 QQ</td>
        </tr>
      </table>
    </div>

    <!-- ACTION BUTTONS -->
    <div class="wallet-actions">
      <div class="wallet-act-card" onclick="qqOpenForm('depositForm')">💰 Deposit</div>
      <div class="wallet-act-card" onclick="qqOpenForm('withdrawForm')">🏧 Withdraw</div>
      <div class="wallet-act-card" onclick="qqOpenForm('exchangeForm')">♻️ Exchange</div>
      <div class="wallet-act-card" onclick="qqOpenForm('transferForm')">🔁 Transfer</div>
    </div>

    <!-- FORMS -->
    <div id="walletForms">

      <!-- DEPOSIT -->
      <div id="depositForm" class="form-box hidden">
        <h3>Deposit Funds</h3>
        <label>Enter Amount (₹)</label>
        <input type="number" id="depositAmt" placeholder="Enter deposit amount" min="1">
        <div class="method-tiles">
          <button onclick="qqDepositMethod('upi')">UPI</button>
          <button onclick="qqDepositMethod('bank')">Bank</button>
          <button onclick="qqDepositMethod('usdt')">USDT (₮)</button>
        </div>
        <div id="depositDetails" class="deposit-details"></div>
        <label>Upload Payment Receipt</label>
        <input type="file" id="depositReceipt" accept="image/*">
        <div style="margin-top:10px;">
          <button id="btnDeposit" onclick="submitWalletDeposit()" class="primary">Submit Deposit</button>
        </div>
      </div>

      <!-- WITHDRAW -->
      <div id="withdrawForm" class="form-box hidden">
        <h3>Withdraw Funds</h3>
        <label>Enter Amount (₹)</label>
        <input type="number" id="withdrawAmt" placeholder="Enter withdraw amount" min="1">
        <div class="method-tiles">
          <button onclick="qqWithdrawMethod('upi')">UPI</button>
          <button onclick="qqWithdrawMethod('bank')">Bank</button>
          <button onclick="qqWithdrawMethod('usdt')">USDT</button>
        </div>
        <div id="withdrawDetails" class="withdraw-details"></div>
        <div style="margin-top:10px;">
          <button id="btnWithdraw" onclick="submitWalletWithdraw()" class="primary warn">Submit Withdraw</button>
        </div>
      </div>

      <!-- EXCHANGE -->
      <div id="exchangeForm" class="form-box hidden">
        <h3>Exchange Currency</h3>
        <div class="exchange-rates">
          <div>1 USDT = 97 ₹</div>
          <div>1 QQCoin = 0.96 ₹ (0.096 ₮)</div>
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
        <input type="number" id="exchangeAmt" placeholder="Enter amount" min="1">
        <div style="margin-top:10px;"><button onclick="submitWalletExchange()" class="primary">Swap</button></div>
      </div>

      <!-- TRANSFER -->
      <div id="transferForm" class="form-box hidden">
        <h3>Transfer Assets</h3>
        <label>Recipient QQ ID</label>
        <input type="text" id="transferID" placeholder="e.g., Agent-1122QQ">
        <label>Mode</label>
        <select id="transferMode">
          <option value="RS">₹ INR</option>
          <option value="USDT">USDT</option>
          <option value="QQ">QQCoins</option>
        </select>
        <label>Amount</label>
        <input type="number" id="transferAmt" placeholder="Enter amount" min="1">
        <div style="margin-top:10px;"><button onclick="submitWalletTransfer()" class="primary">Submit Transfer</button></div>
      </div>
    </div>

    <!-- HISTORY -->
    <div class="wallet-history">
      <div class="history-head">Transaction History</div>
      <div class="history-table-wrapper">
        <table class="wallet-bal-table">
          <thead>
            <tr>
              <th>Type</th>
              <th>Amount</th>
              <th>Method</th>
              <th>Status</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody id="transaction-history">
            <tr><td colspan="5">Loading...</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<style>
.modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.88);z-index:9999;overflow:auto;}
.wallet-neon{max-width:880px;margin:3% auto;padding:25px;border-radius:20px;background:radial-gradient(circle at top,#0c0c0c,#000);border:1px solid rgba(255,0,255,0.08);box-shadow:0 0 50px rgba(0,255,128,0.05);}
.wm-title{text-align:center;font-size:26px;color:#90ffb7;font-weight:900;letter-spacing:1px;text-shadow:0 0 15px #00ff99;}
.wm-sub{text-align:center;color:#bbb;margin-top:4px;font-size:13px;}
.wallet-bal-table{width:100%;margin-top:10px;text-align:center;border-collapse:collapse;}
.wallet-bal-table th{color:#8effa3;padding:10px;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.05);}
.wallet-bal-table td{color:#fff;padding:10px;font-weight:600;border-bottom:1px solid rgba(255,255,255,0.03);}
.wallet-actions{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin:20px 0;}
.wallet-act-card{padding:18px;text-align:center;background:linear-gradient(135deg,#111,#0b0b0b);border-radius:14px;border:1px solid rgba(0,255,128,0.1);box-shadow:0 0 20px rgba(0,255,128,0.05);cursor:pointer;color:#fff;font-weight:700;}
.wallet-act-card:hover{transform:scale(1.04);transition:0.2s;background:linear-gradient(135deg,#00ff88,#0099ff);}
.form-box{padding:16px;margin-top:10px;border-radius:14px;background:linear-gradient(180deg,#111,#080808);border:1px solid rgba(255,255,255,0.05);}
.form-box h3{color:#90ffb7;text-shadow:0 0 10px rgba(0,255,128,0.2);}
.form-box input,.form-box select{width:100%;padding:12px;margin:6px 0;border-radius:10px;border:none;background:#161616;color:#fff;font-size:14px;outline:none;}
.method-tiles{display:flex;gap:8px;margin:10px 0;}
.method-tiles button{flex:1;border:none;padding:12px;border-radius:10px;background:linear-gradient(90deg,#ff00ff88,#00ff99aa);color:#000;font-weight:800;cursor:pointer;}
.primary{background:linear-gradient(90deg,#00ffa1,#00d1ff);border:none;border-radius:10px;padding:10px 16px;font-weight:800;color:#000;cursor:pointer;}
.warn{background:linear-gradient(90deg,#ff9a7a,#ff3b7a);color:#000;}
.wallet-history{margin-top:18px;background:linear-gradient(180deg,#0a0a0a,#050505);padding:14px;border-radius:12px;}
.history-head{color:#90ffb7;font-weight:700;margin-bottom:8px;}
.hidden{display:none;}
.popup{position:fixed;top:40%;left:50%;transform:translate(-50%,-50%);background:#0f0;padding:20px 30px;border-radius:15px;box-shadow:0 0 20px #0f08;z-index:99999;font-weight:800;}
</style>

<script>
function qqOpenForm(id){
  document.querySelectorAll('#walletForms .form-box').forEach(f=>f.classList.add('hidden'));
  const el=document.getElementById(id); if(el)el.classList.remove('hidden');
}
function showPopup(msg){const p=document.createElement('div');p.className='popup';p.innerText=msg;document.body.appendChild(p);setTimeout(()=>p.remove(),1500);}

// ✅ Deposit / Withdraw Buttons Active
function qqDepositMethod(method){
  let html='';
  if(method==='upi'){
    html=`
      <div>
        <b>UPI ID:</b> <span id="upiId">admin@upi</span>
        <button onclick="copyText('upiId')">Copy</button>
        <button onclick="saveQR('/images/sample_upi_qr.png')">Save QR</button><br>
        <img src="/images/sample_upi_qr.png" width="130" style="margin-top:8px;border-radius:8px;">
      </div>`;
  }else if(method==='bank'){
    html=`
      <div>
        <b>Bank Details:</b><br>
        Name: QQPAY ADMIN<br>
        Account No: 1234567890<br>
        Bank Name: State Bank of India<br>
        IFSC: SBIN0000111<br>
      </div>`;
  }else if(method==='usdt'){
    html=`
      <div>
        <b>USDT Address (TRC20):</b> <span id="usdtAddr">TXs2Adf11xPQz99kZ</span>
        <button onclick="copyText('usdtAddr')">Copy</button>
        <button onclick="saveQR('/images/sample_usdt_qr.png')">Save QR</button><br>
        <img src="/images/sample_usdt_qr.png" width="130" style="margin-top:8px;border-radius:8px;">
      </div>`;
  }
  document.getElementById('depositDetails').innerHTML=html;
}

function qqWithdrawMethod(method){
  let html='';
  if(method==='upi'){
    html='<label>Your UPI ID</label><input type="text" placeholder="Enter your upi@bank">';
  }else if(method==='bank'){
    html='<label>Account Holder Name</label><input type="text" placeholder="Enter your name"><label>Bank Name</label><input type="text" placeholder="Enter bank name"><label>Account Number</label><input type="text" placeholder="Enter account number"><label>IFSC Code</label><input type="text" placeholder="Enter IFSC code">';
  }else if(method==='usdt'){
    html='<label>Your USDT Address (TRC20)</label><input type="text" placeholder="Enter your TRC20 address">';
  }
  document.getElementById('withdrawDetails').innerHTML=html;
}

function copyText(id){
  const txt=document.getElementById(id)?.innerText;
  if(!txt)return;
  navigator.clipboard.writeText(txt);
  showPopup('Copied: '+txt);
}

function saveQR(url){
  const a=document.createElement('a');
  a.href=url;
  a.download='qqwallet_qr.png';
  a.click();
  showPopup('QR Saved');
}

// ✅ Load Wallet Data + History
async function loadWalletData(){
  try{
    const res=await fetch('/wallet/{{ Auth::id() }}');
    const data=await res.json();

    document.getElementById('wBalRS').innerText='₹'+parseFloat(data.wallet.balance_rs).toFixed(2);
    document.getElementById('wBalUSDT').innerText=parseFloat(data.wallet.balance_usdt).toFixed(4)+' ₮';
    document.getElementById('wBalQQ').innerText=parseFloat(data.wallet.balance_qq).toFixed(4)+' QQ';

    const tbody=document.getElementById('transaction-history');
    tbody.innerHTML='';
    const txns=data.transactions.slice(0,10);
    if(txns.length===0){
      tbody.innerHTML='<tr><td colspan="5">No transactions yet</td></tr>';
    }else{
      txns.forEach(tx=>{
        tbody.innerHTML+=`
          <tr>
            <td>${tx.type.toUpperCase()}</td>
            <td>₹${tx.amount}</td>
            <td>${tx.method?tx.method.toUpperCase():'-'}</td>
            <td>${tx.status.toUpperCase()}</td>
            <td>${new Date(tx.created_at).toLocaleString()}</td>
          </tr>`;
      });
    }
  }catch(e){console.error('Wallet load failed',e);}
}
document.addEventListener('DOMContentLoaded',loadWalletData);
</script>
EOF
