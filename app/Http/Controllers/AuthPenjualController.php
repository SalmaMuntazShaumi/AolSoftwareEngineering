<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\Penjual;

class AuthPenjualController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'namalengkap' => 'required|string',
            'email' => 'required|string|email|unique:penjuals',
            'notelp' => 'required|string',
            'katasandi' => 'required|string|min:6',
        ]);

        $penjual = Penjual::create([
            'namalengkap' => $request->namalengkap,
            'email' => $request->email,
            'notelp' => $request->notelp,
            'katasandi' => Hash::make($request->katasandi),
        ]);

        $token = $penjual->createToken('auth_token')->plainTextToken;

        return response()->json([
            'penjual' => $penjual,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'katasandi' => 'required',
        ]);

        $penjual = Penjual::where('email', $request->email)->first();

        if (! $penjual || ! Hash::check($request->katasandi, $penjual->katasandi)) {
            throw ValidationException::withMessages([
                'email' => ['Email or password is incorrect'],
            ]);
        }

        $token = $penjual->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'penjual' => $penjual,
            'token' => $token,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logout successful',
        ]);
    }
}
