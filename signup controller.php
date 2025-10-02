cat <<'EOF' | sudo tee /var/www/qqpay/app/Http/Controllers/SignupController.php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Wallet;
use App\Models\Otp;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class SignupController extends Controller
{
    public function showForm()
    {
        return view('signup');
    }

    public function register(Request $request)
    {
        // Validate form
        $request->validate([
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users',
            'password' => 'required|min:6|confirmed',
            'otp'      => 'required|numeric'
        ]);

        // OTP check
        $otp = Otp::where('email', $request->email)
                  ->where('otp_code', $request->otp)
                  ->where('is_verified', 0)
                  ->latest()->first();

        if (!$otp) {
            return back()->withErrors(['otp' => 'Invalid or expired OTP'])->withInput();
        }

        // User create
        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        // Agent ID
        $agentId = 'QQ' . str_pad($user->id, 4, '0', STR_PAD_LEFT);
        $user->agent_id = $agentId;
        $user->save();

        // Wallet with ₹5000
        Wallet::create([
            'user_id'    => $user->id,
            'balance'    => 5000,
            'rs_balance' => 5000,
        ]);

        // Mark OTP verified
        $otp->is_verified = 1;
        $otp->save();

        // Welcome email
        Mail::raw("Welcome {$user->name}, your account has been created! Agent ID: {$user->agent_id}. ₹5000 bonus credited.", function ($msg) use ($user) {
            $msg->to($user->email)->subject("Welcome to QQPAY™");
        });

        return redirect()->route('login.form')->with('success', 'Account created successfully! Please login.');
    }
}
EOF
