<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pesanan;
use App\Models\PesananDetail;
use App\Models\Keranjang;
use App\Models\Product;
use Illuminate\Support\Facades\DB;

class PesananController extends Controller
{
    public function store(Request $request)
    {
        $user = $request->user();

        // Ambil semua keranjang user
        $keranjangs = Keranjang::where('user_id', $user->id)->get();

        if ($keranjangs->isEmpty()) {
            return response()->json(['message' => 'Keranjang kosong'], 400);
        }

        // Hitung total
        $total_harga = 0;
        $total_berat = 0;

        // Transaksi untuk mencegah inkonsistensi data
        DB::beginTransaction();

        try {
            $penjual_id = null;

            // ambil penjual dari produk pertama di keranjang
            if ($keranjangs->first()) {
                $penjual_id = $keranjangs->first()->product->toko->penjual_id;
            }

            // Buat pesanan
            $pesanan = Pesanan::create([
                'user_id' => $user->id,
                'penjual_id' => $penjual_id,
                'total_harga' => 0, // akan di-update
                'total_berat' => 0, // akan di-update
                'status' => 'menunggu_konfirmasi'
            ]);

            foreach ($keranjangs as $item) {
                $produk = $item->product;
                $jumlah = $item->banyak;

                $total_harga += $produk->harga_berat * $jumlah;
                $total_berat += $produk->berat * $jumlah;

                PesananDetail::create([
                    'pesanan_id' => $pesanan->id,
                    'produk_id' => $produk->id,
                    'nama_produk' => $produk->nama,
                    'foto_produk' => $produk->foto,
                    'jumlah' => $item->banyak,
                    'harga' => $produk->harga_berat,
                    'berat' => $produk->berat,
                ]);
            }

            // Update total
            $pesanan->update([
                'total_harga' => $total_harga,
                'total_berat' => $total_berat,
            ]);

            // Kosongkan keranjang user
            Keranjang::where('user_id', $user->id)->delete();

            DB::commit();

            return response()->json([
                'message' => 'Pesanan berhasil dibuat',
                'data' => $pesanan->load(['details.produk', 'user', 'penjual']),
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Gagal membuat pesanan', 'details' => $e->getMessage()], 500);
        }
    }
    public function updateStatus(Request $request, $id)
    {
    $request->validate([
        'status' => 'required|in:menunggu_konfirmasi,dikirim,selesai,dibatalkan',
    ]);

    $pesanan = Pesanan::findOrFail($id);

    // Logika tambahan: hanya user yg bisa batalkan saat menunggu
    if ($request->user()->id === $pesanan->user_id && $pesanan->status === 'menunggu_konfirmasi' && $request->status === 'dibatalkan') {
        $pesanan->status = 'dibatalkan';
        $pesanan->save();
        return response()->json(['message' => 'Pesanan dibatalkan oleh user.']);
    }

    // Penjual mengubah status (dikirim/dibatalkan)
    if (auth('sanctum')->user()->getTable() === 'penjuals') {
        if ($request->status === 'dikirim' || $request->status === 'dibatalkan') {
            $pesanan->status = $request->status;
            $pesanan->save();
            return response()->json(['message' => 'Status pesanan diubah oleh penjual.']);
        }
    }

    // User menyelesaikan pesanan
    if ($request->user()->id === $pesanan->user_id && $request->status === 'selesai') {
        $pesanan->status = 'selesai';
        $pesanan->save();
        return response()->json(['message' => 'Pesanan selesai.']);
    }

    return response()->json(['message' => 'Tidak diizinkan.'], 403);
    }
   public function show($id)
    {
    $pesanan = Pesanan::with([
        'user:id,name,alamat',
        'penjual.toko:id,penjual_id,alamat,nama_resto',
        'details.produk:id,nama,foto'
    ])->findOrFail($id);

    return response()->json([
        'message' => 'Pesanan berhasil dibuat',
        'data' => array_merge($pesanan->toArray(), [
            'alamat_toko' => $pesanan->penjual->toko->alamat ?? null,
            'nama_toko' => $pesanan->penjual->toko->nama_resto ?? null
        ])
    ]);
    }  


}
