<?php

// use Illuminate\Support\Facades\Route;
// use App\Http\Controllers\AuthController;
// use App\Http\Controllers\AuthPenjualController;
// use App\Http\Controllers\TokoController;
// use App\Http\Controllers\ProductController;
// use App\Http\Controllers\KeranjangController;
// use App\Http\Controllers\PesananController;
// use App\Http\Controllers\BalanceController;
// // USER AUTH
// Route::prefix('auth/user')->group(function () {
//     Route::post('register', [AuthController::class, 'register']);
//     Route::post('login', [AuthController::class, 'login']);

//     Route::middleware('auth:sanctum')->group(function () {
//         Route::post('logout', [AuthController::class, 'logout']);
//         Route::post('refresh', [AuthController::class, 'refresh']);
//         Route::post('me', [AuthController::class, 'me']);
//     });
// });

// // PENJUAL AUTH
// Route::prefix('auth/penjual')->group(function () {
//     Route::post('register', [AuthPenjualController::class, 'register']);
//     Route::post('login', [AuthPenjualController::class, 'login']);

//     Route::middleware('auth:sanctum')->group(function () {
//         Route::post('logout', [AuthPenjualController::class, 'logout']);
//         Route::post('/toko', [TokoController::class, 'store']);
//         Route::post('/produk', [ProductController::class, 'store']); // contoh
//     });
// });

// // USER KERANJANG
// Route::middleware('auth:api')->group(function () {
//     Route::prefix('keranjang')->group(function () {
//         Route::post('/', [KeranjangController::class, 'store']);
//         Route::get('/', [KeranjangController::class, 'index']);
//         Route::delete('/{id}', [KeranjangController::class, 'destroy']);
//     });
// });
// // User routes (JWT)
// Route::middleware('auth:api')->group(function() {
//     Route::get('/pesanan', [PesananController::class, 'index']);
//     Route::get('/pesanan/{id}', [PesananController::class, 'show']);
//     Route::post('/pesanan', [PesananController::class, 'store']);
//     Route::patch('/pesanan/{id}/batal', [PesananController::class, 'batal']);
//     Route::patch('/pesanan/{id}/selesai', [PesananController::class, 'selesai']);
// });

// // Penjual routes (Sanctum)
// Route::middleware('auth:sanctum')->group(function() {
//     Route::get('/penjual/pesanan', [PesananController::class, 'pesananPenjual']);
//     Route::patch('/pesanan/{id}/kirim', [PesananController::class, 'kirim']);
// });
// Route::middleware('auth:api')->group(function() {
//     Route::get('/user/balance', [BalanceController::class, 'getUserBalance']);
//     Route::get('/user/transactions', [BalanceController::class, 'getUserTransactions']);
//     Route::post('/user/topup', [BalanceController::class, 'topUp']);
// });

// // Balance routes for penjual
// Route::middleware('auth:sanctum')->group(function() {
//     Route::get('/penjual/balance', [BalanceController::class, 'getTokoBalance']);
//     Route::get('/penjual/transactions', [BalanceController::class, 'getTokoTransactions']);
// });

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AuthPenjualController;
use App\Http\Controllers\TokoController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\KeranjangController;
use App\Http\Controllers\PesananController;
use App\Http\Controllers\BalanceController;

/*
|--------------------------------------------------------------------------
| AUTH ROUTES
|--------------------------------------------------------------------------
*/

// USER AUTH (menggunakan JWT / auth:api)
Route::prefix('auth/user')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);

    Route::middleware('auth:api')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::post('refresh', [AuthController::class, 'refresh']);
        Route::post('me', [AuthController::class, 'me']);
    });
});

// PENJUAL AUTH (menggunakan Sanctum / auth:sanctum)
Route::prefix('auth/penjual')->group(function () {
    Route::post('register', [AuthPenjualController::class, 'register']);
    Route::post('login', [AuthPenjualController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('logout', [AuthPenjualController::class, 'logout']);
    });
});


/*
|--------------------------------------------------------------------------
| USER ROUTES (auth:api)
|--------------------------------------------------------------------------
*/

Route::middleware('auth:api')->group(function () {
    // Keranjang
    Route::prefix('keranjang')->group(function () {
        Route::post('/', [KeranjangController::class, 'store']);
        Route::get('/', [KeranjangController::class, 'index']);
        Route::delete('/{id}', [KeranjangController::class, 'destroy']);
    });

    // Pesanan
    Route::prefix('pesanan')->group(function () {
        Route::get('/', [PesananController::class, 'index']);
        Route::get('/{id}', [PesananController::class, 'show']);
        Route::post('/', [PesananController::class, 'store']);
        Route::patch('/{id}/batal', [PesananController::class, 'batal']);
        Route::patch('/{id}/selesai', [PesananController::class, 'selesai']);
        Route::patch('/{id}/bayar', [PesananController::class, 'bayar']); // kamu bisa tambahkan ini untuk proses bayar
    });

    // Balance
    Route::prefix('user')->group(function () {
        Route::get('/balance', [BalanceController::class, 'getUserBalance']);
        Route::get('/transactions', [BalanceController::class, 'getUserTransactions']);
        Route::post('/topup', [BalanceController::class, 'topUp']);
    });
});


/*
|--------------------------------------------------------------------------
| PENJUAL ROUTES (auth:sanctum)
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')->prefix('penjual')->group(function () {
    // Toko dan Produk
    Route::post('/toko', [TokoController::class, 'store']);
    Route::post('/produk', [ProductController::class, 'store']);

    // Pesanan dari pelanggan
    Route::get('/pesanan', [PesananController::class, 'pesananPenjual']);
    Route::patch('/pesanan/{id}/kirim', [PesananController::class, 'kirim']);

    // Balance penjual
    Route::get('/balance', [BalanceController::class, 'getTokoBalance']);
    Route::get('/transactions', [BalanceController::class, 'getTokoTransactions']);
});

