cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/p2p-modal.blade.php
<div id="p2p-modal" class="modal">
  <div class="modal-content futuristic-modal">
    <span class="close-btn" onclick="toggleModal('p2p-modal')">&times;</span>
    <h2>🤝 P2P Trading</h2>

    <!-- Only visible after sign in -->
    <div id="p2p-guest" style="text-align:center; padding:20px;">
      <p>Please <b>Sign Up / Login</b> to access P2P Trading.</p>
    </div>

    <div id="p2p-auth" style="display:none;">
      <!-- AI Live Ticker -->
      <div id="p2p-ticker" class="ticker"></div>

      <!-- Ads Table -->
      <table class="futuristic-table" id="p2p-table">
        <thead>
          <tr>
            <th>Type</th>
            <th>Agent</th>
            <th>Price</th>
            <th>Limits</th>
            <th>Method</th>
            <th>Rating</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
</div>

<!-- Buy/Sell Popup -->
<div id="trade-popup" class="modal">
  <div class="modal-content futuristic-modal">
    <span class="close-btn" onclick="toggleModal('trade-popup')">&times;</span>
    <h3 id="trade-type">Trade</h3>
    <p>Agent: <span id="trade-agent"></span></p>
    <p>Price: <span id="trade-price"></span></p>
    <label>Payment Method:</label>
    <select id="trade-method">
      <option value="upi">UPI</option>
      <option value="bank">Bank Transfer</option>
      <option value="qqwallet">QQWallet</option>
    </select>
    <br><br>
    <label>Amount:</label>
    <input type="number" id="trade-amount" placeholder="Enter amount" />
    <br><br>
    <button class="btn-glow" onclick="confirmTrade()">Submit</button>
  </div>
</div>

<style>
#p2p-modal, #trade-popup { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:#000a; z-index:9999; }
.futuristic-modal { background:#0d0d0d; border:2px solid #00ff99; border-radius:12px; color:#fff; width:90%; max-width:900px; margin:5% auto; padding:20px; box-shadow:0 0 20px #00ff99; }
.close-btn { float:right; font-size:22px; cursor:pointer; color:#ff0066; }
h2,h3 { text-align:center; margin-bottom:15px; text-shadow:0 0 10px #00ff99; }
.ticker { background:#001a00; color:#0f0; font-weight:bold; padding:5px; margin-bottom:15px; white-space:nowrap; overflow:hidden; border-radius:6px; }
.futuristic-table { width:100%; border-collapse:collapse; font-size:13px; margin-top:10px; }
.futuristic-table th, .futuristic-table td { border:1px solid #00ff99; padding:6px; text-align:center; }
.futuristic-table th { background:#003300; color:#00ffcc; }
.futuristic-table tr:nth-child(even){ background:#001a00; }
.futuristic-table tr:hover{ background:#004400; }
.rating { color:#ffcc00; }
.btn-glow { background:#003300; border:1px solid #00ff99; color:#fff; padding:6px 12px; border-radius:6px; cursor:pointer; font-size:12px; }
.btn-glow:hover { background:#004d00; }
input, select { padding:6px; width:80%; border:1px solid #00ff99; border-radius:6px; background:#000; color:#fff; }
</style>

<script>
// Simulate logged-in user (set true/false)
let isLoggedIn = true;

window.onload = () => {
  if(isLoggedIn){
    document.getElementById("p2p-guest").style.display="none";
    document.getElementById("p2p-auth").style.display="block";
    fillP2PAds();
  }
};

// AI Ads
const aiAds = [
  {type:"Buy", agent:"Agent-2456QQ", price:"₹97.2", limits:"500 - 50,000", method:"UPI", rating:"⭐⭐⭐⭐", action:"Buy"},
  {type:"Sell", agent:"Agent-5821QQ", price:"₹96.8", limits:"1000 - 20,000", method:"Bank", rating:"⭐⭐⭐⭐⭐", action:"Sell"},
  {type:"Buy", agent:"Agent-7753QQ", price:"₹97.1", limits:"200 - 10,000", method:"UPI/Bank", rating:"⭐⭐⭐", action:"Buy"},
  {type:"Sell", agent:"Agent-9922QQ", price:"₹96.9", limits:"3000 - 30,000", method:"UPI", rating:"⭐⭐⭐⭐", action:"Sell"},
  {type:"Buy", agent:"Agent-6641QQ", price:"₹97.3", limits:"100 - 5,000", method:"Bank", rating:"⭐⭐⭐⭐⭐", action:"Buy"},
];

function fillP2PAds(){
  let tbody=document.querySelector("#p2p-table tbody");
  tbody.innerHTML="";
  aiAds.forEach(ad=>{
    let tr=document.createElement("tr");
    tr.innerHTML=`<td>${ad.type}</td>
                  <td>${ad.agent}</td>
                  <td>${ad.price}</td>
                  <td>${ad.limits}</td>
                  <td>${ad.method}</td>
                  <td class="rating">${ad.rating}</td>
                  <td><button class="btn-glow" onclick="openTrade('${ad.type}','${ad.agent}','${ad.price}')">${ad.action}</button></td>`;
    tbody.appendChild(tr);
  });
}

// Live ticker
const tickerMsgs = [
  "🤝 Agent-2456QQ posted BUY 1000 USDT",
  "💸 Agent-9922QQ SOLD 5000 USDT",
  "🔥 Agent-6641QQ new ad at ₹97.3",
  "⚡ Agent-5821QQ completed trade",
];
function startTicker(){
  let ticker=document.getElementById("p2p-ticker");
  let i=0;
  setInterval(()=>{
    ticker.innerHTML=`<span style="color:hsl(${Math.random()*360},100%,50%)">${tickerMsgs[i]}</span>`;
    i=(i+1)%tickerMsgs.length;
  },2500);
}
startTicker();

// Open trade popup
function openTrade(type, agent, price){
  document.getElementById("trade-type").innerText = type+" Order";
  document.getElementById("trade-agent").innerText = agent;
  document.getElementById("trade-price").innerText = price;
  toggleModal('trade-popup');
}

// Confirm trade
function confirmTrade(){
  let amt = document.getElementById("trade-amount").value;
  if(amt<500){
    alert("❌ Insufficient balance or below minimum limit!");
  } else {
    alert("✅ Order placed successfully for "+amt);
    toggleModal('trade-popup');
  }
}
</script>
EOF
