<?php

namespace App\Http\Controllers;

use App\Models\Pesanan;
use App\Services\BalanceService;
use Illuminate\Http\Request;

class BalanceController extends Controller
{
    protected $balanceService;

    public function __construct(BalanceService $balanceService)
    {
        $this->balanceService = $balanceService;
    }

    // === USER ===

    public function getUserBalance(Request $request)
    {
        $balance = $this->balanceService->getUserBalance($request->user()->id);
        return response()->json([
            'balance' => $balance->balance,
            'updated_at' => $balance->updated_at
        ]);
    }

    public function getUserTransactions(Request $request)
    {
        $transactions = $this->balanceService->getUserTransactions($request->user()->id);
        return response()->json($transactions);
    }

    public function topUp(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:10000'
        ]);

        $userBalance = $this->balanceService->getUserBalance($request->user()->id);
        $userBalance->increment('balance', $request->amount);

        $userBalance->transactions()->create([
            'amount' => $request->amount,
            'type' => 'deposit',
            'description' => 'Top up saldo'
        ]);

        return response()->json([
            'message' => 'Top up berhasil',
            'new_balance' => $userBalance->balance
        ]);
    }

    // === PENJUAL ===

    public function getTokoBalance(Request $request)
    {
        $penjual = $request->user();
        $toko = $penjual->toko;

        if (!$toko) {
            return response()->json(['message' => 'Penjual belum memiliki toko'], 404);
        }

        $balance = $this->balanceService->getTokoBalance($toko->id);
        return response()->json([
            'balance' => $balance->balance,
            'updated_at' => $balance->updated_at
        ]);
    }

    public function getTokoTransactions(Request $request)
    {
        $penjual = $request->user();
        $toko = $penjual->toko;

        if (!$toko) {
            return response()->json(['message' => 'Penjual belum memiliki toko'], 404);
        }

        $transactions = $this->balanceService->getTokoTransactions($toko->id);
        return response()->json($transactions);
    }

    // === TAMBAHAN UNTUK PEMESANAN ===

    public function holdPayment(Request $request)
    {
        $request->validate([
            'pesanan_id' => 'required|exists:pesanans,id',
            'amount' => 'required|numeric|min:1',
        ]);

        $pesanan = Pesanan::findOrFail($request->pesanan_id);

        try {
            $this->balanceService->holdPayment($request->user()->id, $request->amount, $pesanan);
            return response()->json(['message' => 'Saldo berhasil ditahan']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }

    public function releaseToToko(Request $request)
    {
        $request->validate([
            'pesanan_id' => 'required|exists:pesanans,id',
            'amount' => 'required|numeric|min:1',
        ]);

        $pesanan = Pesanan::findOrFail($request->pesanan_id);
        $userId = $request->user()->id;
        $tokoId = $pesanan->toko_id; // pastikan kamu punya kolom ini di tabel `pesanans`

        try {
            $this->balanceService->releaseToToko($userId, $tokoId, $request->amount, $pesanan);
            return response()->json(['message' => 'Dana berhasil dirilis ke toko']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 400);
        }
    }
}
