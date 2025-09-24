cat <<'EOF' | sudo tee /var/www/qqpay/resources/views/sections/refer-modal.blade.php
<div id="refer-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.92); z-index:9999; font-family:Arial, sans-serif; color:#fff;">

  <div style="background:#111; border:1px solid #00ffff; border-radius:12px; width:95%; max-width:700px;
              max-height:90%; padding:20px; position:absolute; top:50%; left:50%;
              transform:translate(-50%,-50%); box-shadow:0 0 25px #00ffff; overflow-y:auto;">

    <!-- Cross button -->
    <button onclick="toggleModal('refer-modal')" 
            style="position:absolute; top:10px; right:10px; background:#ff1744; border:none; color:#fff;
                   font-size:18px; border-radius:50%; width:32px; height:32px; cursor:pointer;">
      ×
    </button>

    <!-- FAQs button (top right corner inside header) -->
    <button onclick="document.getElementById('refer-faq').style.display =
                     document.getElementById('refer-faq').style.display === 'block' ? 'none' : 'block';"
            style="position:absolute; top:10px; left:10px; padding:6px 14px; border:none; border-radius:20px;
                   background:#00ff99; color:#000; font-weight:bold; cursor:pointer; text-shadow:0 0 8px #00ff99;
                   box-shadow:0 0 15px #00ff99;">
      ❓ FAQs
    </button>

    <h2 style="color:#00ffff; text-shadow:0 0 12px #00ffff; text-align:center; margin-bottom:20px;">👥 Refer & Earn</h2>

    <!-- Futuristic Glowing Table -->
    <table style="width:100%; border-collapse:collapse; text-align:center; font-size:14px; margin-bottom:20px;">
      <thead>
        <tr style="background:#222;">
          <th style="padding:10px; border:1px solid #00ffff;">S. No</th>
          <th style="padding:10px; border:1px solid #00ffff;">Team Member</th>
          <th style="padding:10px; border:1px solid #00ffff;">Joined On</th>
          <th style="padding:10px; border:1px solid #00ffff;">Salary %</th>
        </tr>
      </thead>
      <tbody id="refer-team">
        <tr>
          <td style="padding:10px; border:1px solid #00ffff;">1</td>
          <td style="padding:10px; border:1px solid #00ffff;">Agent-1234QQ</td>
          <td style="padding:10px; border:1px solid #00ffff;">2025-09-24</td>
          <td style="padding:10px; border:1px solid #00ffff; color:#00ff99;">0.5%</td>
        </tr>
      </tbody>
    </table>

    <!-- Referral Link Generator -->
    <div style="text-align:center; margin-top:20px;">
      <input type="text" id="referral-link" readonly 
             style="width:80%; padding:8px; border-radius:6px; border:1px solid #00ffff;
                    background:#000; color:#fff; margin-bottom:10px; text-align:center;" 
             placeholder="Your referral link will appear here">
      <br>
      <button onclick="generateReferralLink()" 
              style="padding:10px 20px; border:none; border-radius:20px; background:#ff33cc; color:#fff;
                     font-weight:bold; cursor:pointer; text-shadow:0 0 10px #ff33cc; box-shadow:0 0 20px #ff33cc;">
        🔗 Generate Referral Link
      </button>
      <button onclick="copyReferralLink()" 
              style="margin-left:10px; padding:10px 20px; border:none; border-radius:20px; background:#00ccff; color:#fff;
                     font-weight:bold; cursor:pointer; text-shadow:0 0 10px #00ccff; box-shadow:0 0 20px #00ccff;">
        📋 Copy
      </button>
    </div>

    <!-- FAQs Section -->
    <div id="refer-faq" style="display:none; margin-top:20px; padding:15px; background:#1a1a1a; border-radius:10px; border:1px solid #00ffff;">
      <h3 style="color:#00ffff; text-shadow:0 0 6px #00ffff;">Refer & Earn FAQs</h3>
      <ul style="text-align:left; font-size:13px; line-height:1.6;">
        <li>💡 <b>How referral works?</b> Share your referral link. When someone joins, they become your team member.</li>
        <li>💡 <b>What is the salary percentage?</b> You earn a fixed 0.5% from your team’s deposits.</li>
        <li>💡 <b>How to withdraw earnings?</b> All commissions are credited into your wallet, from where you can convert into INR/USDT.</li>
      </ul>
    </div>
  </div>
</div>

<script>
function generateReferralLink(){
  const rand = Math.floor(1000+Math.random()*9000);
  const link = "https://qqpays.online/register?ref=Agent-"+rand+"QQ";
  document.getElementById("referral-link").value = link;
}
function copyReferralLink(){
  const copyText = document.getElementById("referral-link");
  if(copyText.value){
    copyText.select();
    document.execCommand("copy");
    alert("✅ Referral link copied!");
  } else {
    alert("⚠️ Please generate a referral link first!");
  }
}
</script>
EOF
