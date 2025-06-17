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
     public function getByCategory($kategori)
    {
    // Validasi kategori
    $validCategories = ['roti', 'lemak', 'nasi', 'daging', 'buah dan sayur', 'tulang'];
    
    if (!in_array(strtolower($kategori), $validCategories)) {
        return response()->json([
            'success' => false,
            'message' => 'Kategori tidak valid',
            'valid_categories' => $validCategories
        ], 400);
    }

    // Query produk dengan pagination
    $products = Product::where('kategori', $kategori)
                      ->where('total_barang', '>', 0) // Hanya produk yang tersedia
                      ->orderBy('created_at', 'desc')
                      ->paginate(10);

    return response()->json([
        'success' => true,
        'category' => $kategori,
        'data' => $products
    ]);
    }

    /**
     * Menampilkan semua kategori yang tersedia
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function getCategories()
    {
        $categories = Product::select('kategori')
                            ->distinct()
                            ->pluck('kategori');

        return response()->json([
            'message' => 'Daftar kategori produk',
            'data' => $categories
        ]);
    }
}