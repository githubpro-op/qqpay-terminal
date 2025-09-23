cd /var/www/qqpay

cat <<'EOF' | sudo tee resources/views/dashboard.blade.php
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>QQPAY™ Dashboard</title>
  <style>
    body {
      margin:0;
      font-family:Arial, sans-serif;
      background:#000;
      color:#fff;
      text-align:center;
    }
    header {
      display:flex;
      justify-content:space-between;
      align-items:center;
      background:#000;
      padding:10px 20px;
      border-bottom:1px solid #222;
    }
    .logo-area { display:flex; align-items:center; gap:10px; }
    .logo-area img { height:40px; }
    .brand { font-size:16px; font-weight:bold; }
    .tag { font-size:11px; color:#aaa; }
    .agent-info { text-align:right; font-size:13px; }
    .shield-red { color:#ff1744; text-shadow:0 0 8px #ff1744; }
    .shield-green { color:#00ff99; text-shadow:0 0 8px #00ff99; }

    .dashboard-title {
      margin-top:5px;
      font-size:22px;
      font-weight:bold;
      color:#ff1744;
      text-shadow:0 0 15px #ff1744, 0 0 30px #ff1744;
      animation:glow 1.5s infinite alternate;
    }
    @keyframes glow {
      from { text-shadow:0 0 8px #ff1744,0 0 15px #ff1744; }
      to   { text-shadow:0 0 20px #ff1744,0 0 40px #ff1744; }
    }

    /* Navbar */
    .navbar {
      display:flex;
      justify-content:space-around;
      align-items:center;
      background:#000;
      padding:6px 5px;
      margin-top:6px;
      gap:6px;
    }
    .nav-btn {
      flex:1;
      padding:7px;
      background:#111;
      border:1px solid #00e6ff;
      border-radius:6px;
      color:#fff;
      font-size:13px;
      font-weight:bold;
      cursor:pointer;
      text-shadow:0 0 6px #00e6ff;
      box-shadow:0 0 8px #00e6ff88;
      transition:0.2s;
    }
    .nav-btn:hover { background:#00e6ff33; }
    .nav-btn.active { border:1px solid #00e6ff; }
    .logout { color:#ff2d55; text-shadow:0 0 6px #ff2d55; }

    .section {
      display:none;
      padding:15px;
      color:#00e6ff;
      font-weight:bold;
      text-shadow:0 0 8px #00e6ff;
    }
    .section.active { display:block; }
  </style>
</head>
<body>
  <header>
    <div class="logo-area">
      <img src="https://i.postimg.cc/Kvk4Vhr9/file-000000008b3061f580b32ed1e16e49cb.png" alt="logo">
      <div>
        <div class="brand">QQPAY™</div>
        <div class="tag">SINCE 2021</div>
      </div>
    </div>
    <div class="agent-info">
      AGENT: <b>1234QQ</b> <span class="shield-red">🛡️</span><br>
      <span id="dateTime">--:--</span>
    </div>
  </header>

  <div class="dashboard-title">QQPAY™ DASHBOARD</div>

  <!-- Navbar -->
  <nav class="navbar">
    <button onclick="toggleSection('home')" class="nav-btn active">Home</button>
  <button onclick="toggleModal('profileModal')" class="nav-btn">Profile</button>
<button onclick="toggleModal('kycModal')" class="nav-btn">KYC</button>
<button onclick="toggleModal('notifyModal')" class="nav-btn">🔔 Notifications</button>
    <button onclick="logoutConfirm()" class="nav-btn logout">Logout</button>
  </nav>
  @include('sections.ticker')
  @include('sections.stats')
  @include('sections.tiles')
  @include('sections.modals')
@include('sections.leaderboard-modal')
@include('sections.qqpanel-modal')
@include('sections.wallet-modal')
@include('sections.dailyearn-modal')
@include('sections.refer-modal')
@include('sections.rewards-modal')
@include('sections.p2p-modal')
  <!-- Sections -->
  <div id="home" class="section active">
    <h2> </h2>
  </div>

  <div id="profile" class="section">
    @include('sections.profile')
  </div>

  <div id="kyc" class="section">
    @include('sections.kyc')
  </div>

  <div id="notifications" class="section">
  @include('sections.notifications')
</div>

<div id="logout" class="section">
  @include('sections.logout')
</div>

  <script>
    function updateTime(){
      const opts={hour:'2-digit',minute:'2-digit',second:'2-digit',day:'2-digit',month:'short',year:'numeric'};
      document.getElementById("dateTime").textContent=new Intl.DateTimeFormat('en-GB',opts).format(new Date());
    }
    setInterval(updateTime,1000); updateTime();

    function toggleSection(id){
      document.querySelectorAll(".section").forEach(s=>s.classList.remove("active"));
      document.querySelectorAll(".nav-btn").forEach(b=>b.classList.remove("active"));
      document.getElementById(id).classList.add("active");
      event.target.classList.add("active");
    }

    function logoutConfirm(){
      if(confirm("Are you sure you want to logout?")){
        window.location.href="/login";
      }
    }
  </script>
</body>
</html>
EOF
