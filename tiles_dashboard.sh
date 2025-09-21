cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/tiles.blade.php
<div class="tiles-grid">    
  <div class="tile qqpanel"><i>📊</i><span>QQPANEL</span>    
    <div id="qqpanelMsg" class="fade">Loading...</div>    
  </div>    
  <div class="tile wallet"><i>👛</i><span>QQWALLET</span>    
    <div id="walletBal" class="fade">0.00 USDT<br>₹0.00</div>    
  </div>    
  <div class="tile daily"><i>💹</i><span>Daily Earn</span>    
    <div id="dailyMsg" class="fade">Loading...</div>    
  </div>    
  <div class="tile p2p"><i>🤝</i><span>P2P</span>    
    <div id="p2pMsg" class="fade">Loading...</div>    
  </div>    
  <div class="tile coming"><i>🎰</i><span>Casino<br><small>Coming Soon</small></span></div>    
  <div class="tile refer"><i>👥</i><span>Refer & Earn</span>    
    <div id="referMsg" class="fade">Invite friends & earn rewards!</div>    
  </div>    
  <div class="tile leaderboard"><i>🏆</i><span>Leaderboard</span>    
    <div id="leaderMsg" class="fade">Rank #1 – Agent-4521</div>    
  </div>    
  <div class="tile rewards"><i>🎁</i><span>Rewards</span>    
    <div id="rewardMsg" class="fade">Bonus ₹500 credited</div>    
  </div>    
</div>  

<style>    
  .tiles-grid {    
    display:grid;    
    grid-template-columns:repeat(3,1fr);    
    gap:12px;    
    padding:15px;    
  }    
  .tile {    
    height:110px;    
    background:linear-gradient(145deg,#220000,#440000);    
    border:1px solid #ff2d55;    
    border-radius:10px;    
    display:flex;    
    flex-direction:column;    
    align-items:center;    
    justify-content:center;    
    color:#fff;    
    font-weight:bold;    
    font-size:12px;    
    text-shadow:0 0 6px #ff2d55;    
    box-shadow:0 0 12px #ff2d55aa,inset 0 0 6px #ff2d5577;    
    cursor:pointer;    
    transition:.3s;    
  }    
  .tile:hover {    
    background:linear-gradient(145deg,#330000,#550000);    
    transform:translateY(-4px) scale(1.05);    
    box-shadow:0 0 18px #ff2d55,inset 0 0 10px #ff2d5588;    
  }    
  .tile i { font-size:20px; margin-bottom:5px; display:block; }    
  .tile small { font-size:10px; color:#ff2d55; }    
  .fade { opacity:0; transition:opacity 1s ease-in-out; }  
  .fade.show { opacity:1; }  
</style>  

<script>
// QQPanel auto messages
const panelMsgs=["💰 Savings → 3%","🏦 Current → 3.2%","🏢 Corporate → 3.5%"];
let pIndex=0;
function rotatePanel(){
  let el=document.getElementById("qqpanelMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    el.textContent=panelMsgs[pIndex];
    el.classList.add("show");
    pIndex=(pIndex+1)%panelMsgs.length;
  },500);
}
setInterval(rotatePanel,3000); rotatePanel();

// Daily Earn auto schemes
const dailyMsgs=[
  "🚀 Altcoins → 20% (Seats 20)",
  "💱 Forex → 25% (Seats 15)",
  "🏦 Bonds → 30% (Seats 25)",
  "📊 ETF Plan → 35% (Seats 10)",
  "🔥 VIP Fund → 50% (Seats 5)"
];
let dIndex=0;
function rotateDaily(){
  let el=document.getElementById("dailyMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    el.textContent=dailyMsgs[dIndex];
    el.classList.add("show");
    dIndex=(dIndex+1)%dailyMsgs.length;
  },500);
}
setInterval(rotateDaily,4000); rotateDaily();

// Wallet balance live update
function updateWallet(){
  let el=document.getElementById("walletBal");
  el.classList.remove("show");
  setTimeout(()=>{
    let usdt=(Math.random()*1000).toFixed(2);
    let rs=(usdt*96+Math.random()*5).toFixed(2);
    el.innerHTML=`${usdt} USDT<br>₹${rs}`;
    el.classList.add("show");
  },500);
}
setInterval(updateWallet,5000); updateWallet();

// Leaderboard random agent
function updateLeader(){
  let el=document.getElementById("leaderMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    let agent="Agent-"+Math.floor(1000+Math.random()*9000)+"QQ";
    let rank="#"+Math.floor(1+Math.random()*10);
    el.textContent=`Rank ${rank} – ${agent}`;
    el.classList.add("show");
  },500);
}
setInterval(updateLeader,6000); updateLeader();

// P2P random swaps
const p2pMsgs=[
  "🤝 Agent-2456QQ sold 500 USDT @ ₹97",
  "🤝 Agent-5821QQ bought 1200 USDT @ ₹96.8",
  "🤝 Agent-7753QQ swapped 300 USDT @ ₹97.2",
  "🤝 Agent-9922QQ sold 750 USDT @ ₹96.9",
  "🤝 Agent-6641QQ bought 50 USDT @ ₹97.1"
];
let pIndex2=0;
function rotateP2P(){
  let el=document.getElementById("p2pMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    el.textContent=p2pMsgs[pIndex2];
    el.classList.add("show");
    pIndex2=(pIndex2+1)%p2pMsgs.length;
  },500);
}
setInterval(rotateP2P,4500); rotateP2P();

// Rewards random bonuses
const rewardMsgs=[
  ()=>`🎁 Agent-${Math.floor(1000+Math.random()*9000)}QQ got ₹500 bonus`,
  ()=>`🪙 Agent-${Math.floor(1000+Math.random()*9000)}QQ rewarded 120 QQCOINS`,
  ()=>`🎉 Agent-${Math.floor(1000+Math.random()*9000)}QQ cashback ₹1500`,
  ()=>`🔥 Agent-${Math.floor(1000+Math.random()*9000)}QQ got 50 QQCOINS login`,
  ()=>`💎 Agent-${Math.floor(1000+Math.random()*9000)}QQ earned ₹2000 reward`
];
function rotateReward(){
  let el=document.getElementById("rewardMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    el.textContent=rewardMsgs[Math.floor(Math.random()*rewardMsgs.length)]();
    el.classList.add("show");
  },500);
}
setInterval(rotateReward,5000); rotateReward();

// Refer & Earn auto feed
const referMsgs=[
  ()=>`👥 Agent-${Math.floor(1000+Math.random()*9000)}QQ invited 2 friends → ₹1000 bonus`,
  ()=>`👥 Agent-${Math.floor(1000+Math.random()*9000)}QQ earned 5% from referral deposit`,
  ()=>`👥 Agent-${Math.floor(1000+Math.random()*9000)}QQ invited 10 users → got ₹5000`,
];
function rotateRefer(){
  let el=document.getElementById("referMsg");
  el.classList.remove("show");
  setTimeout(()=>{
    el.textContent=referMsgs[Math.floor(Math.random()*referMsgs.length)]();
    el.classList.add("show");
  },500);
}
setInterval(rotateRefer,5500); rotateRefer();
</script>
EOF
