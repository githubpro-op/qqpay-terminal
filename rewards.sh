cat <<'EOF' | sudo tee /var/www/qqpay/resources/views/sections/rewards-modal.blade.php
<div id="rewards-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.9); z-index:9999; font-family:Arial, sans-serif; color:#fff;">

  <div style="background:#111; border:1px solid #ff33cc; border-radius:12px; width:95%; max-width:600px;
              max-height:90%; padding:20px; position:absolute; top:50%; left:50%;
              transform:translate(-50%,-50%); box-shadow:0 0 25px #ff33cc; overflow-y:auto;">
    
    <!-- Cross button -->
    <button onclick="toggleModal('rewards-modal')" 
            style="position:absolute; top:10px; right:10px; background:#ff1744; border:none; color:#fff;
                   font-size:18px; border-radius:50%; width:32px; height:32px; cursor:pointer; z-index:100;">
      ×
    </button>

    <h2 style="color:#ff33cc; text-shadow:0 0 10px #ff33cc; margin-bottom:15px;">🎁 Rewards</h2>

    <!-- Rewards Table -->
    <table style="width:100%; border-collapse:collapse; text-align:center; font-size:14px; margin-bottom:20px;">
      <thead>
        <tr style="background:#222;">
          <th style="padding:10px; border:1px solid #ff33cc;">S. No</th>
          <th style="padding:10px; border:1px solid #ff33cc;">Reward Name</th>
          <th style="padding:10px; border:1px solid #ff33cc;">Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td style="padding:10px; border:1px solid #ff33cc;">1</td>
          <td style="padding:10px; border:1px solid #ff33cc;">Sign Up Bonus ₹5000</td>
          <td style="padding:10px; border:1px solid #ff33cc; color:#00ff66; animation:blink 1s infinite;">Credited</td>
        </tr>
        <tr>
          <td style="padding:10px; border:1px solid #ff33cc;">2</td>
          <td style="padding:10px; border:1px solid #ff33cc;">100 QQCOINS every 24 hours</td>
          <td style="padding:10px; border:1px solid #ff33cc;">
            <span id="reward-timer" style="color:#ffcc00;">24:00:00</span><br>
            <button onclick="claimQQCoins()" style="margin-top:5px; padding:6px 12px; border:none; border-radius:6px;
                    background:#ff33cc; color:#fff; font-weight:bold; cursor:pointer; box-shadow:0 0 12px #ff33cc;">
              Claim 100 QQCOINS
            </button>
          </td>
        </tr>
        <tr>
          <td style="padding:10px; border:1px solid #ff33cc;">3</td>
          <td style="padding:10px; border:1px solid #ff33cc;">1 Year Netflix Subscription</td>
          <td style="padding:10px; border:1px solid #ff33cc; color:#aaa;">Not Eligible</td>
        </tr>
        <tr>
          <td style="padding:10px; border:1px solid #ff33cc;">4</td>
          <td style="padding:10px; border:1px solid #ff33cc;">500 USDT Reward</td>
          <td style="padding:10px; border:1px solid #ff33cc; color:#aaa;">Not Eligible</td>
        </tr>
        <tr>
          <td style="padding:10px; border:1px solid #ff33cc;">5</td>
          <td style="padding:10px; border:1px solid #ff33cc;">₹1000 via Google Pay / Paytm</td>
          <td style="padding:10px; border:1px solid #ff33cc; color:#aaa;">Not Eligible</td>
        </tr>
      </tbody>
    </table>

    <!-- FAQs Button -->
    <button onclick="document.getElementById('rewards-faq').style.display =
                     document.getElementById('rewards-faq').style.display === 'block' ? 'none' : 'block';" 
            style="display:block; margin:0 auto; padding:10px 18px; border:none; border-radius:20px;
                   background:#ff33cc; color:#fff; font-weight:bold; cursor:pointer;
                   text-shadow:0 0 10px #ff33cc; box-shadow:0 0 20px #ff33cc;">
      ❓ FAQs
    </button>

    <!-- FAQs Section -->
    <div id="rewards-faq" style="display:none; margin-top:20px; padding:15px; background:#1a1a1a;
         border-radius:10px; border:1px solid #ff33cc;">
      <h3 style="color:#ff33cc; text-shadow:0 0 6px #ff33cc;">Rewards FAQs</h3>
      <ul style="text-align:left; font-size:13px; line-height:1.6;">
        <li>💡 <b>Netflix / USDT / ₹1000 Rewards:</b> Not eligible by default. To unlock, users must achieve premium milestones (future update).</li>
        <li>💡 <b>Daily 100 QQCOINS:</b> Claim every 24 hours. Timer runs continuously (not reset on logout).</li>
        <li>💡 <b>Conversion:</b> QQCOINS can be converted into USDT or INR inside Wallet section.</li>
      </ul>
    </div>
  </div>
</div>

<style>
@keyframes blink { 50% { opacity:0; } }
</style>

<script>
let rewardSeconds = 24*60*60; // 24 hours
function startRewardTimer(){
  setInterval(()=>{
    if(rewardSeconds > 0){
      rewardSeconds--;
      const h = String(Math.floor(rewardSeconds/3600)).padStart(2,'0');
      const m = String(Math.floor((rewardSeconds%3600)/60)).padStart(2,'0');
      const s = String(rewardSeconds%60).padStart(2,'0');
      document.getElementById('reward-timer').textContent = h+":"+m+":"+s;
    }
  },1000);
}
function claimQQCoins(){
  if(rewardSeconds <= 0){
    alert("✅ 100 QQCOINS added to your wallet!");
    rewardSeconds = 24*60*60; // reset timer
  } else {
    alert("⏳ You can only claim after timer ends!");
  }
}
startRewardTimer();
</script>
EOF
