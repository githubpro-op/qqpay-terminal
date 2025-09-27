cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/sections/partners.blade.php
<!-- OFFICIAL PARTNERS -->
<div class="partners-section">
  <div class="partners-logos">
    <div class="shield">
      <img src="https://i.postimg.cc/Y4T533F9/vavada.png" alt="Vavada">
    </div>
    <div class="shield">
      <img src="https://i.postimg.cc/WqmctktX/1xbet.png" alt="1XBET">
    </div>
    <div class="shield">
      <img src="https://i.postimg.cc/qhPpNrwR/alibaba.png" alt="Alibaba">
    </div>
  </div>
  <p class="partners-text">OFFICIAL PARTNER</p>
</div>

<style>
.partners-section {
  text-align: center;
  margin: 20px 0;
}
.partners-logos {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 10px;
}

/* Futuristic Shield */
.shield {
  width: 80px;
  height: 90px;
  background: linear-gradient(135deg, #ff00ff, #00ffff);
  background-size: 300% 300%;
  clip-path: polygon(50% 0%, 95% 25%, 80% 100%, 20% 100%, 5% 25%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8px;
  animation: shieldGlow 6s infinite alternate ease-in-out;
  transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
  box-shadow: 
    0 0 10px rgba(255, 0, 255, 0.7),
    0 0 20px rgba(0, 255, 255, 0.6),
    inset 0 0 12px rgba(255, 255, 255, 0.15);
}
.shield:hover {
  transform: scale(1.2) rotate(2deg);
  box-shadow: 
    0 0 15px rgba(255, 0, 255, 0.9),
    0 0 30px rgba(0, 255, 255, 0.8),
    inset 0 0 18px rgba(255, 255, 255, 0.25);
}

.shield img {
  max-width: 45px;
  max-height: 45px;
  object-fit: contain;
  filter: drop-shadow(0 0 6px #000);
}

/* Gradient Animation */
@keyframes shieldGlow {
  0%   { background: linear-gradient(135deg, #ff00ff, #ff9900); }
  25%  { background: linear-gradient(135deg, #ff0099, #00ffff); }
  50%  { background: linear-gradient(135deg, #00ffcc, #0099ff); }
  75%  { background: linear-gradient(135deg, #ff00ff, #00ffcc); }
  100% { background: linear-gradient(135deg, #00ffff, #ff00ff); }
}

.partners-text {
  font-size: 16px;
  font-weight: bold;
  color: #fff;
  text-shadow: 
    0 0 8px #ff00ff, 
    0 0 15px #00ffff,
    0 0 25px #ff00ff;
  letter-spacing: 2px;
  margin-top: 5px;
}
</style>
EOF
