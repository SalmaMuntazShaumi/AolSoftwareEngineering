<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pesanan;
use App\Models\PesananDetail;
use App\Models\Keranjang;
use Illuminate\Support\Facades\DB;
use App\Services\BalanceService;

class PesananController extends Controller
{
    /**
     * Membuat pesanan baru
     */
    public function store(Request $request)
    {
    $user = $request->user();

    // Ambil keranjang user beserta relasi product dan toko
    $keranjangs = Keranjang::with(['product.toko'])
        ->where('user_id', $user->id)
        ->get();

    if ($keranjangs->isEmpty()) {
        return response()->json(['message' => 'Keranjang kosong'], 400);
    }

    $total_harga = 0;
    $total_berat = 0;
    $penjual_id = null;
    $toko_id = null;
    $invalidProducts = [];

    // Validasi isi keranjang
    foreach ($keranjangs as $item) {
        $product = $item->product;

        if (!$product || !$product->toko) {
            $invalidProducts[] = [
                'product_id' => $product->id ?? null,
                'product_name' => $product->nama ?? 'Produk tidak ditemukan',
                'available' => $product->total_barang ?? null,
                'requested' => $item->banyak,
            ];
            continue;
        }

        // Validasi stok produk
        if ($product->total_barang < $item->banyak) {
            $invalidProducts[] = [
                'product_id' => $product->id,
                'product_name' => $product->nama,
                'available' => $product->total_barang,
                'requested' => $item->banyak,
            ];
            continue;
        }

        // Validasi hanya dari 1 toko
        if ($toko_id && $product->toko_id != $toko_id) {
            return response()->json(['message' => 'Tidak bisa memesan dari toko berbeda dalam satu pesanan'], 400);
        }

        // Set toko dan penjual
        $toko_id = $product->toko_id;
        $penjual_id = $product->toko->penjual_id;

        // Akumulasi total
        $total_harga += $product->harga_berat * $item->banyak;
        $total_berat += $product->berat * $item->banyak;
    }

    if (!empty($invalidProducts)) {
        return response()->json([
            'message' => 'Beberapa produk tidak bisa diproses',
            'invalid_products' => $invalidProducts
        ], 400);
    }

    // Validasi saldo user
    $balanceService = app(BalanceService::class);
    $userBalance = $balanceService->getUserBalance($user->id);

    if ($userBalance->balance < $total_harga) {
        return response()->json([
            'message' => 'Saldo tidak mencukupi',
            'required' => $total_harga,
            'current_balance' => $userBalance->balance
        ], 400);
    }

    DB::beginTransaction();

    try {
        $toko = \App\Models\Toko::where('penjual_id', $penjual_id)->first();

        if (!$toko) {
            throw new \Exception("Toko tidak ditemukan untuk penjual terkait");
        }

        $toko_id = $toko->id;
        // Buat pesanan
        $pesanan = Pesanan::create([
            'user_id' => $user->id,
            'penjual_id' => $penjual_id,
            'toko_id' => $toko_id,
            'total_harga' => $total_harga,
            'total_berat' => $total_berat,
            'status' => 'menunggu_pembayaran',
        ]);

        // Buat detail pesanan
        foreach ($keranjangs as $item) {
            $product = $item->product;

            PesananDetail::create([
                'pesanan_id' => $pesanan->id,
                'produk_id' => $product->id,
                'nama_produk' => $product->nama,
                'foto_produk' => $product->foto,
                'jumlah' => $item->banyak,
                'harga' => $product->harga_berat,
                'berat' => $product->berat,
            ]);

            // Update stok
            $product->decrement('total_barang', $item->banyak);
        }

        // Hapus keranjang
        Keranjang::where('user_id', $user->id)->delete();

        DB::commit();

        return response()->json([
            'message' => 'Pesanan berhasil dibuat',
            'data' => $pesanan->load([
                'details.produk',
                'user:id,name,email',
                'penjual.toko:id,penjual_id,nama_resto,alamat'
            ])
        ], 201);
    } catch (\Exception $e) {
        DB::rollBack();

        return response()->json([
            'error' => 'Gagal membuat pesanan',
            'details' => $e->getMessage()
        ], 500);
    }
    }


    /**
     * Bayar pesanan
     */
    public function bayar(Request $request, $id)
    {
        $pesanan = Pesanan::findOrFail($id);

        if ($request->user()->id != $pesanan->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($pesanan->status !== 'menunggu_pembayaran') {
            return response()->json(['message' => 'Pesanan tidak bisa dibayar saat ini'], 400);
        }

        $balanceService = app(BalanceService::class);
        $userBalance = $balanceService->getUserBalance($request->user()->id);

        if ($userBalance->balance < $pesanan->total_harga) {
            return response()->json([
                'message' => 'Saldo tidak mencukupi',
                'required' => $pesanan->total_harga,
                'current_balance' => $userBalance->balance
            ], 400);
        }

        $paymentSuccess = $balanceService->holdPayment($request->user()->id, $pesanan->total_harga, $pesanan);

        if (!$paymentSuccess) {
            return response()->json(['message' => 'Gagal memproses pembayaran'], 500);
        }

        $pesanan->status = 'menunggu_konfirmasi';
        $pesanan->save();

        return response()->json([
            'message' => 'Pembayaran berhasil, menunggu konfirmasi penjual',
            'data' => $pesanan
        ]);
    }

    /**
     * Daftar pesanan milik user
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $pesanans = Pesanan::with([
                'details.produk',
                'penjual.toko:id,penjual_id,nama_resto,alamat'
            ])
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'message' => 'Daftar pesanan berhasil diambil',
            'data' => $pesanans
        ]);
    }

    /**
     * Daftar pesanan milik penjual
     */
    public function pesananPenjual(Request $request)
    {
        $penjual = $request->user();

        $pesanans = Pesanan::with([
                'details.produk',
                'user:id,name,email',
                'penjual.toko'
            ])
            ->where('penjual_id', $penjual->penjualid)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'message' => 'Daftar pesanan penjual berhasil diambil',
            'data' => $pesanans
        ]);
    }

    /**
     * Detail pesanan
     */
    public function show($id)
    {
        $pesanan = Pesanan::with([
                'user:id,name,email,alamat',
                'penjual.toko:id,penjual_id,nama_resto,alamat',
                'details.produk:id,nama,foto,harga_berat,berat'
            ])
            ->findOrFail($id);

        return response()->json([
            'message' => 'Detail pesanan berhasil diambil',
            'data' => $pesanan
        ]);
    }

    /**
     * Ubah status pesanan menjadi "dikirim" (penjual)
     */
    public function kirim(Request $request, $id)
    {
        $pesanan = Pesanan::findOrFail($id);

        if ($request->user()->penjualid != $pesanan->penjual_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($pesanan->status != 'menunggu_konfirmasi') {
            return response()->json(['message' => 'Pesanan tidak bisa dikirim dalam status saat ini'], 400);
        }

        $pesanan->status = 'dikirim';
        $pesanan->save();

        return response()->json([
            'message' => 'Pesanan berhasil dikirim',
            'data' => $pesanan
        ]);
    }

    /**
     * Batalkan pesanan (user)
     */
    public function batal(Request $request, $id)
    {
        $pesanan = Pesanan::findOrFail($id);

        if ($request->user()->id != $pesanan->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($pesanan->status != 'menunggu_konfirmasi') {
            return response()->json(['message' => 'Pesanan hanya bisa dibatalkan saat menunggu konfirmasi'], 400);
        }

        $pesanan->status = 'dibatalkan';
        $pesanan->save();

        return response()->json([
            'message' => 'Pesanan berhasil dibatalkan',
            'data' => $pesanan
        ]);
    }

    /**
     * Selesaikan pesanan (user)
     */
    public function selesai(Request $request, $id)
    {
        $pesanan = Pesanan::findOrFail($id);

        if ($request->user()->id != $pesanan->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($pesanan->status !== 'dikirim') {
            return response()->json(['message' => 'Pesanan belum bisa diselesaikan'], 400);
        }

        $pesanan->status = 'selesai';
        $pesanan->save();

        $balanceService = app(BalanceService::class);
        $balanceService->releaseToToko(
            $pesanan->user_id,     // userId (pembeli)
            $pesanan->toko_id,     // tokoId (penjual)
            $pesanan->total_harga, // amount
            $pesanan               // seluruh data pesanan
        );
         $tokoBalance = $pesanan->toko->balance ?? null;
            if ($tokoBalance) {
                $tokoBalance->syncSalesStats();
        }
        return response()->json([
            'message' => 'Pesanan berhasil diselesaikan dan dana diteruskan ke penjual',
            'data' => $pesanan
        ]);
    }
}
