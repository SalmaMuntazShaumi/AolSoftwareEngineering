<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function store(Request $request)
    {
        $penjual = $request->user(); // Authenticated penjual
        $toko = $penjual->toko;

        if (!$toko) {
            return response()->json(['error' => 'Penjual does not have a Toko'], 404);
        }

        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'kategori' => 'required|in:roti,lemak,nasi,daging,buah dan sayur,tulang',
            'deskripsi' => 'nullable|string',
            'foto' => 'nullable|image|max:2048',
            'harga_berat' => 'required|numeric',
            'diskon' => 'nullable|numeric',
            'berat' => 'required|numeric',
            'total_barang' => 'required|integer',
            'total_berat' => 'required|numeric',
            'tanggal_produksi' => 'required|date',
            'tanggal_kadaluarsa' => 'required|date|after_or_equal:tanggal_produksi',
            'kondisi' => 'required|string',
            'syarat_ketentuan' => 'nullable|string',
            'catatan_tambahan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $data['toko_id'] = $toko->id;

        if ($request->hasFile('foto')) {
            $image = $request->file('foto');
            $filename = time() . '_' . uniqid() . '.' . $image->getClientOriginalExtension();
            $path = $image->storeAs('produk', $filename, 'public');
            $data['foto'] = $path;
        }


        $product = Product::create($data);

        return response()->json(['message' => 'Product created', 'product' => $product], 201);
    }
}