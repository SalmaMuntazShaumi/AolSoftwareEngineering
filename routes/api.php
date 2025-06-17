<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AuthPenjualController;
use App\Http\Controllers\TokoController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\KeranjangController;
use App\Http\Controllers\PesananController;

// USER AUTH
Route::prefix('auth/user')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::post('refresh', [AuthController::class, 'refresh']);
        Route::post('me', [AuthController::class, 'me']);
    });
});

// PENJUAL AUTH
Route::prefix('auth/penjual')->group(function () {
    Route::post('register', [AuthPenjualController::class, 'register']);
    Route::post('login', [AuthPenjualController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('logout', [AuthPenjualController::class, 'logout']);
        Route::post('/toko', [TokoController::class, 'store']);
        Route::post('/produk', [ProductController::class, 'store']); // contoh
    });
});

// USER KERANJANG
Route::middleware('auth:api')->group(function () {
    Route::prefix('keranjang')->group(function () {
        Route::post('/', [KeranjangController::class, 'store']);
        Route::get('/', [KeranjangController::class, 'index']);
        Route::delete('/{id}', [KeranjangController::class, 'destroy']);
    });
});
Route::middleware('auth:api')->group(function () {
    Route::prefix('pesanan')->group(function () {
        Route::post('/', [PesananController::class, 'store']); // Buat pesanan
        Route::get('/', [PesananController::class, 'index']); // Lihat semua pesanan user/penjual
        Route::get('/{id}', [PesananController::class, 'show']); // Detail pesanan

        Route::patch('/{id}/status', [PesananController::class, 'updateStatus']); // Ubah status
    });
});

