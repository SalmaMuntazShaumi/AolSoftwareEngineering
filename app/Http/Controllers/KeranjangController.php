<?php

namespace App\Http\Controllers;

use App\Models\Keranjang;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class KeranjangController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'banyak' => 'required|integer|min:1',
        ]);

        $user = Auth::user();
        $product = Product::findOrFail($request->product_id);

        $total_harga = $product->harga_berat * $request->banyak;
        $total_berat = $product->berat * $request->banyak;

        $keranjang = Keranjang::create([
            'user_id' => $user->id,
            'product_id' => $product->id,
            'banyak' => $request->banyak,
            'total_harga' => $total_harga,
            'total_berat' => $total_berat,
        ]);

        return response()->json([
            'message' => 'Produk ditambahkan ke keranjang',
            'keranjang' => $keranjang->load('product'),
        ], 201);
    }
    public function index(Request $request)
    {
    $user = $request->user();

    if (!$user) {
        return response()->json(['message' => 'Unauthorized - user tidak ditemukan'], 401);
    }

    $keranjangs = Keranjang::with('product')
        ->where('user_id', $user->id)
        ->get();

    return response()->json([
        'message' => 'Daftar keranjang pengguna',
        'keranjangs' => $keranjangs
    ]);
    }


}
