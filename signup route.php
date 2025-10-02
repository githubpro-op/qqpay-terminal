cat <<'EOF' | sudo tee /var/www/qqpay/routes/signup.php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SignupController;
use App\Http\Controllers\OTPController;

Route::get('/signup', [SignupController::class, 'showForm'])->name('signup.form');
Route::post('/signup', [SignupController::class, 'register'])->name('signup.register');
Route::post('/signup/otp', [OTPController::class, 'send'])->name('signup.otp');
EOF
