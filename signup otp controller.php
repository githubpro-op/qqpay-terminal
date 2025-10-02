cat <<'EOF' | sudo tee /var/www/qqpay/app/Http/Controllers/OTPController.php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Otp;
use Illuminate\Support\Facades\Mail;

class OTPController extends Controller
{
    public function send(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $otp = rand(100000, 999999);

        Otp::create([
            'email' => $request->email,
            'otp_code' => $otp,
            'is_verified' => 0,
        ]);

        Mail::raw("Your OTP is: $otp", function ($msg) use ($request) {
            $msg->to($request->email)->subject("QQPAY™ Signup OTP");
        });

        return response()->json(['message' => 'OTP sent successfully']);
    }
}
EOF
