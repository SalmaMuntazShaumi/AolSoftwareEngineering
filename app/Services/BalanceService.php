<?php

namespace App\Services;

use App\Models\UserBalance;
use App\Models\TokoBalance;
use App\Models\BalanceTransaction;
use Illuminate\Support\Facades\DB;

class BalanceService
{
    /**
     * Ambil saldo user, jika belum ada maka buat dengan balance 0
     */
    public function getUserBalance($userId)
    {
        return UserBalance::firstOrCreate(
            ['user_id' => $userId],
            ['balance' => 0]
        );
    }

    /**
     * Ambil saldo toko, jika belum ada maka buat dengan balance 0
     */
    public function getTokoBalance($tokoId)
    {
        return TokoBalance::firstOrCreate(
            ['toko_id' => $tokoId],
            ['balance' => 0]
        );
    }

    /**
     * Simulasikan "hold" pembayaran user saat buat pesanan
     * - saldo user dikurangi
     * - transaksi dicatat sebagai "hold"
     */
    public function holdPayment($userId, $amount, $pesanan)
    {
        return DB::transaction(function () use ($userId, $amount, $pesanan) {
            $userBalance = $this->getUserBalance($userId);

            if ($userBalance->balance < $amount) {
                throw new \Exception("Saldo tidak cukup untuk memesan.");
            }

            $userBalance->decrement('balance', $amount);

            BalanceTransaction::create([
                'owner_type' => get_class($userBalance),
                'owner_id' => $userBalance->id,
                'reference_type' => get_class($pesanan),
                'reference_id' => $pesanan->id,
                'amount' => $amount,
                'type' => 'hold',
                'description' => 'Menahan saldo untuk pesanan #' . $pesanan->id
            ]);

            return true;
        });
    }

    /**
     * Setelah pesanan selesai, dana dari user diberikan ke toko
     */
    public function releaseToToko($userId, $tokoId, $amount, $pesanan)
    {
        return DB::transaction(function () use ($userId, $tokoId, $amount, $pesanan) {
            $userBalance = $this->getUserBalance($userId);
            $tokoBalance = $this->getTokoBalance($tokoId);

            // Tambah ke saldo toko
            $tokoBalance->increment('balance', $amount);

            // Catat transaksi toko (penerimaan uang)
            BalanceTransaction::create([
                'owner_type' => get_class($tokoBalance),
                'owner_id' => $tokoBalance->id,
                'reference_type' => get_class($pesanan),
                'reference_id' => $pesanan->id,
                'amount' => $amount,
                'type' => 'release',
                'description' => 'Dana dirilis ke toko dari pesanan #' . $pesanan->id
            ]);

            return true;
        });
    }

    /**
     * Cara cepat: langsung transfer dari user ke toko saat pesanan dibuat
     */
    public function transferToToko($userId, $tokoId, $amount, $pesanan)
    {
        return DB::transaction(function () use ($userId, $tokoId, $amount, $pesanan) {
            $userBalance = $this->getUserBalance($userId);

            if ($userBalance->balance < $amount) {
                throw new \Exception("Saldo tidak cukup.");
            }

            // Kurangi saldo user
            $userBalance->decrement('balance', $amount);

            BalanceTransaction::create([
                'owner_type' => get_class($userBalance),
                'owner_id' => $userBalance->id,
                'reference_type' => get_class($pesanan),
                'reference_id' => $pesanan->id,
                'amount' => $amount,
                'type' => 'payment',
                'description' => 'Pembayaran langsung ke toko untuk pesanan #' . $pesanan->id
            ]);

            // Tambah saldo toko
            $tokoBalance = $this->getTokoBalance($tokoId);
            $tokoBalance->increment('balance', $amount);

            BalanceTransaction::create([
                'owner_type' => get_class($tokoBalance),
                'owner_id' => $tokoBalance->id,
                'reference_type' => get_class($pesanan),
                'reference_id' => $pesanan->id,
                'amount' => $amount,
                'type' => 'income',
                'description' => 'Pendapatan dari pesanan #' . $pesanan->id
            ]);

            return true;
        });
    }

    /**
     * Ambil riwayat transaksi user
     */
    public function getUserTransactions($userId, $limit = 10)
    {
        $userBalance = $this->getUserBalance($userId);
        return $userBalance->transactions()
            ->latest()
            ->paginate($limit);
    }

    /**
     * Ambil riwayat transaksi toko
     */
    public function getTokoTransactions($tokoId, $limit = 10)
    {
        $tokoBalance = $this->getTokoBalance($tokoId);
        return $tokoBalance->transactions()
            ->latest()
            ->paginate($limit);
    }
}
