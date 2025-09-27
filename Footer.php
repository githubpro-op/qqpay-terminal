cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/footer.blade.php
<!-- FOOTER -->
<div class="footer">
  <!-- Links -->
  <div class="footer-links">
    <a href="https://qqpays.online/about" target="_blank">About Us</a> •
    <a href="https://qqpays.online/contact" target="_blank">Contact Us</a> •
    <a href="https://qqpays.online/faqs" target="_blank">FAQs</a> •
    <a href="https://qqpays.online/locate" target="_blank">Locate Us</a> •
    <a href="https://qqpays.online/privacy" target="_blank">Privacy Policy</a>
  </div>

  <!-- Shield Icon -->
  <div class="footer-shield">
    <div class="shield">
      <span class="shield-text">QQPAY™</span>
    </div>
  </div>

  <!-- Text -->
  <div class="footer-text">
    <p><b>QQPAY™ HOLDINGS PVT LTD</b></p>
    <p>Licensed and regulated by Malta Gaming Authority</p>
    <p>ISO | PCI | DCI Compliant</p>
    <p>© 2021-2027 All rights reserved</p>
  </div>

  <!-- Button -->
  <div class="footer-btn">
    <a href="https://drive.google.com/file/d/1-S1B3QBnpD2lDndo28_PJ4WGLBgg9dF2/view" target="_blank" class="license-btn">View License</a>
  </div>
</div>

<style>
.footer{margin-top:30px;text-align:center;color:#fff;padding:15px;}
.footer-links a{color:#0ff;text-decoration:none;margin:0 5px;font-size:13px;}
.footer-links a:hover{color:#0f0;text-shadow:0 0 6px #0f0;}
.footer-shield{margin:15px 0;}

/* Shield */
.shield{
  width:80px;height:90px;margin:0 auto;
  clip-path:polygon(50% 0%, 95% 22%, 82% 100%, 18% 100%, 5% 22%);
  background:linear-gradient(135deg,#0f0,#ffd700,#0ff,#f0f);
  background-size:400% 400%;
  animation:neonFlow 5s infinite linear, glowShield 2s infinite alternate;
  display:flex;align-items:center;justify-content:center;
  border:2px solid rgba(255,255,255,0.3);
  border-radius:6px;
}
.shield-text{
  font-size:12px;
  font-weight:bold;
  color:#000; /* BLACK TEXT */
  text-shadow:0 0 6px rgba(255,255,255,0.6);
}
@keyframes neonFlow {
  0% {background-position:0% 50%;}
  50%{background-position:100% 50%;}
  100%{background-position:0% 50%;}
}
@keyframes glowShield {
  0% {box-shadow:0 0 15px #0f0,0 0 30px #ffd700,0 0 45px #0ff;}
  100%{box-shadow:0 0 20px #ffd700,0 0 35px #0f0,0 0 50px #f0f;}
}

/* Footer Text */
.footer-text p{margin:3px 0;color:#ccc;font-size:12px;}

/* License Button */
.footer-btn{margin-top:22px;}
.license-btn{
  background:#0f0;color:#000;padding:8px 16px;
  border-radius:6px;text-decoration:none;font-size:13px;
  font-weight:bold;box-shadow:0 0 15px #0f0,0 0 25px #ffd700;transition:0.3s;
}
.license-btn:hover{background:#ffd700;color:#000;box-shadow:0 0 20px #0ff;}
</style>
EOF
