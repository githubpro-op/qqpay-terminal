cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/tiles.blade.php

<div class="tiles-grid">        <div class="tile qqpanel" onclick="toggleModal('qqpanel-modal')">  
    <i>📊</i><span class="tile-title qqpanel-title">QQPANEL</span>      
    <div id="qqpanelMsg" class="fade qqpanel-feed">Loading...</div>      
  </div>        <div class="tile wallet" onclick="toggleModal('qqwallet-modal')">  
    <i>👛</i><span class="tile-title wallet-title">QQWALLET</span>      
    <div id="walletBal" class="fade wallet-feed">0.00 USDT<br>₹0.00</div>      
  </div>        <div class="tile daily" onclick="toggleModal('dailyearn-modal')">  
    <i>💹</i><span class="tile-title daily-title">Daily Earn</span>  
    <div id="dailyMsg" class="fade daily-feed">Loading...</div>      
  </div>        <div class="tile p2p" onclick="toggleModal('p2p-modal')">  
    <i>🤝</i><span class="tile-title p2p-title">P2P</span>      
    <div id="p2pMsg" class="fade p2p-feed">Loading...</div>      
  </div>        <div class="tile leaderboard" onclick="toggleModal('leaderboardModal')">  
    <i>🏆</i><span class="tile-title leaderboard-title">Leaderboard</span>  
    <div id="leaderMsg" class="fade leaderboard-feed">Loading...</div>  
  </div>    <div class="tile refer" onclick="toggleModal('refer-Modal')">  
    <i>👥</i><span class="tile-title refer-title">Refer & Earn</span>  
    <div id="referMsg" class="fade refer-feed">Invite friends & earn rewards!</div>  
  </div>        <div class="tile rewards" onclick="toggleModal('rewards-Modal')">  
    <i>🎁</i><span class="tile-title rewards-title">Rewards</span>  
    <div id="rewardMsg" class="fade rewards-feed">Bonus ₹500 credited</div>  
  </div>        <div class="tile coming">  
    <i>🎰</i><span class="tile-title casino-title">Casino<br><small>Coming Soon</small></span>  
  </div>        <div class="tile coming">  
    <i>🤖</i><span class="tile-title app-title">Android App<br><small>Coming Soon</small></span>  
  </div>      </div>    <style>      
  .tiles-grid {      
    display:grid;      
    grid-template-columns:repeat(3,1fr);      
    gap:12px;      
    padding:15px;      
  }      
  
  .tile {      
    height:110px;      
    border-radius:10px;      
    display:flex;      
    flex-direction:column;      
    align-items:center;      
    justify-content:center;      
    font-weight:bold;      
    font-size:12px;      
    cursor:pointer;      
    transition:.3s;      
    text-align:center;  
  }      
  .tile i { font-size:20px; margin-bottom:5px; display:block; }      
  .tile small { font-size:10px; }      
  .fade { opacity:0; transition:opacity 1s ease-in-out; }    
  .fade.show { opacity:1; }    
  
  /* Title colors */  
  .qqpanel-title { color:#00e6ff; }  
  .wallet-title { color:#ffcc00; }  
  .daily-title { color:#00ff66; }  
  .p2p-title { color:#cc66ff; }  
  .leaderboard-title { color:#ff3333; }  
  .refer-title { color:#00ffff; }  
  .rewards-title { color:#ff33cc; }  
  .casino-title { color:#ff6600; }  
  .app-title { color:#00ffaa; }  
  
  /* Feed colors */  
  .qqpanel-feed { color:#00e6ff; text-shadow:0 0 6px #00e6ff; }  
  .wallet-feed { color:#ffcc00; text-shadow:0 0 6px #ffcc00; }  
  .daily-feed { color:#00ff66; text-shadow:0 0 6px #00ff66; }  
  .p2p-feed { color:#cc66ff; text-shadow:0 0 6px #cc66ff; }  
  .leaderboard-feed { color:#ff3333; text-shadow:0 0 6px #ff3333; }  
  .refer-feed { color:#00ffff; text-shadow:0 0 6px #00ffff; }  
  .rewards-feed { color:#ff33cc; text-shadow:0 0 6px #ff33cc; }  
  
  /* Backgrounds */  
  .tile.qqpanel { background:linear-gradient(145deg,#001133,#002266); border:1px solid #00e6ff; box-shadow:0 0 12px #00e6ffaa; }  
  .tile.wallet { background:linear-gradient(145deg,#332200,#664400); border:1px solid #ffcc00; box-shadow:0 0 12px #ffcc00aa; }  
  .tile.daily { background:linear-gradient(145deg,#001a00,#003300); border:1px solid #00ff66; box-shadow:0 0 12px #00ff66aa; }  
  .tile.p2p { background:linear-gradient(145deg,#220033,#440066); border:1px solid #cc66ff; box-shadow:0 0 12px #cc66ffaa; }  
  .tile.leaderboard { background:linear-gradient(145deg,#330000,#660000); border:1px solid #ff3333; box-shadow:0 0 12px #ff3333aa; }  
  .tile.refer { background:linear-gradient(145deg,#003333,#006666); border:1px solid #00ffff; box-shadow:0 0 12px #00ffffaa; }  
  .tile.rewards { background:linear-gradient(145deg,#330033,#660066); border:1px solid #ff33cc; box-shadow:0 0 12px #ff33ccaa; }  
  .tile.coming { background:linear-gradient(145deg,#332200,#552200); border:1px solid #ff6600; box-shadow:0 0 12px #ff6600aa; }  
</style>    <script>  
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
  
// Daily Earn random feed  
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
  
// Wallet balance live update (AI simulation)  
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
  
// Leaderboard random feed  
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
  
// P2P random ads  
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

