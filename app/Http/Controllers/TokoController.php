<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Toko;
use Illuminate\Support\Facades\Auth;


class TokoController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'nama_resto' => 'required|string',
            'alamat' => 'required|string',
            'no_telp' => 'required|string',
            'jenis_resto' => 'required|in:individu,perusahaan',
            'tipe_resto' => 'nullable|string',
            'produk_layak' => 'boolean',
            'produk_tidak_layak' => 'boolean',
            'deskripsi' => 'nullable|string|max:2000',
        ]);

        $toko = Toko::create([
            'penjual_id' => Auth::id(), // Automatically get the logged-in user ID
            'nama_resto' => $request->nama_resto,
            'alamat' => $request->alamat,
            'no_telp' => $request->no_telp,
            'jenis_resto' => $request->jenis_resto,
            'tipe_resto' => $request->tipe_resto,
            'produk_layak' => $request->produk_layak ?? false,
            'produk_tidak_layak' => $request->produk_tidak_layak ?? false,
            'deskripsi' => $request->deskripsi,
        ]);

        return response()->json([
            'message' => 'Toko berhasil dibuat.',
            'data' => $toko,
        ], 201);
    }

    // You can also add index, show, update, destroy methods here
}
