cat <<'EOF' | sudo tee /var/www/qqpay/resources/views/signup.blade.php
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign Up - QQPAY™</title>
  <style>
    body{background:#000;color:#fff;font-family:Arial;margin:0}
    header{display:flex;align-items:center;padding:15px 25px;background:#080808;border-bottom:1px solid #111;}
    header img{height:40px;margin-right:12px}
    .brand{font-size:22px;font-weight:bold;color:#00e6ff}
    .tag{font-size:12px;color:#bbb}

    .container{max-width:500px;margin:40px auto;background:rgba(255,255,255,0.02);padding:30px;border-radius:12px;box-shadow:0 0 25px rgba(0,230,255,0.2);}
    h2{color:#00e6ff;margin-bottom:10px;text-align:center}
    label{display:block;margin-top:10px;color:#aaa}
    .field{position:relative}
    input[type=text],input[type=email],input[type=password]{width:100%;padding:12px;margin-top:5px;border:none;border-radius:8px;background:#111;color:#fff}
    .eye{position:absolute;right:12px;top:50%;transform:translateY(-50%);cursor:pointer;color:#aaa}

    .otpBtn{margin-top:10px;padding:10px 12px;border:none;border-radius:8px;background:#ff2d55;color:#fff;font-weight:bold;cursor:pointer}
    .msg{font-size:13px;margin-top:6px;display:none}

    .terms{margin-top:12px;font-size:12px;color:#bbb}
    .terms input{margin-right:6px}
    .btn-create{width:100%;padding:12px;margin-top:15px;border:none;border-radius:8px;font-weight:bold;font-size:16px;cursor:pointer;background:linear-gradient(90deg,#00e676,#00b0ff);color:#000;box-shadow:0 4px 15px rgba(0,230,255,0.4);transition:.2s;}
    .btn-create:hover{transform:scale(1.05)}

    #successBox{margin-top:15px;padding:14px;background:rgba(0,255,0,0.1);border:1px solid #0f0;border-radius:8px;color:#0f0;font-weight:bold;display:none;text-align:center}

    footer{margin-top:40px;padding:20px;text-align:center;background:#080808;color:#999;font-size:13px;border-top:1px solid #111;}
    footer .shield{font-size:22px;color:#0f0;margin-bottom:6px;}
  </style>
</head>
<body>
<header>
  <img src="https://i.postimg.cc/Kvk4Vhr9/file-000000008b3061f580b32ed1e16e49cb.png">
  <div>
    <div class="brand">QQPAY™</div>
    <div class="tag">SINCE 2021</div>
  </div>
</header>

<div class="container">
  <h2>Welcome to QQPAY™ — Get ₹5000 Sign-up Bonus</h2>

  <!-- Laravel Signup Form -->
  <form id="signupForm" method="POST">
    @csrf

    <label>Full Name</label>
    <input type="text" id="name" name="name" required>

    <label>Email</label>
    <input type="email" id="email" name="email" required>

    <label>Password</label>
    <div class="field">
      <input type="password" id="pass" name="password" required>
      <span class="eye" onclick="togglePass('pass')">👁️</span>
    </div>

    <label>Confirm Password</label>
    <div class="field">
      <input type="password" id="cpass" name="password_confirmation" required>
      <span class="eye" onclick="togglePass('cpass')">👁️</span>
    </div>

    <label>OTP</label>
    <input type="text" id="otp" name="otp">
    <button type="button" id="otpBtn" class="otpBtn">Send OTP</button>
    <p id="otpMsg" class="msg"></p>

    <div class="terms">
      <input type="checkbox" id="terms" required> 
      I agree to the <a href="/privacy" style="color:#00e6ff;">Terms & Conditions</a>
    </div>

    <button type="submit" id="createBtn" class="btn-create">Create Account</button>

    <div id="successBox"></div>
  </form>
</div>

<footer>
  <div class="shield">🛡️</div>
  QQPAY™ HOLDINGS PVT LTD<br>
  Licensed by Malta Gaming Authority • ISO • PCI • DCI<br>
  © 2021-2027 All Rights Reserved
</footer>

<script>
function togglePass(id){
  const f=document.getElementById(id);
  f.type=(f.type==="password")?"text":"password";
}

const otpBtn=document.getElementById("otpBtn");
const otpMsg=document.getElementById("otpMsg");

otpBtn.addEventListener("click",()=>{
  fetch("/signup", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": document.querySelector('input[name="_token"]').value
    },
    body: JSON.stringify({
      email: document.getElementById("email").value
    })
  })
  .then(res=>res.json())
  .then(data=>{
    otpMsg.style.display="block";
    otpMsg.style.color="#0f0";
    otpMsg.textContent="✅ " + data.message;
  })
  .catch(()=>{
    otpMsg.style.display="block";
    otpMsg.style.color="red";
    otpMsg.textContent="❌ Failed to send OTP";
  });
});

document.getElementById("signupForm").addEventListener("submit",(e)=>{
  e.preventDefault();
  fetch("/register-otp", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": document.querySelector('input[name="_token"]').value
    },
    body: JSON.stringify({
      name: document.getElementById("name").value,
      email: document.getElementById("email").value,
      password: document.getElementById("pass").value,
      otp: document.getElementById("otp").value
    })
  })
  .then(res=>res.json())
  .then(data=>{
    document.getElementById("successBox").style.display="block";
    document.getElementById("successBox").innerText="🎉 "+data.message;
  })
  .catch(()=>{
    alert("❌ Registration failed");
  });
});
</script>
</body>
</html>
EOF
