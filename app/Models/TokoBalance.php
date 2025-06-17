<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


class TokoBalance extends Model
{
    protected $fillable = [
    'toko_id',
    'balance',
    'total_order_selesai',
    'total_berat_terjual',
    'total_stok_terjual',
    ];

    public function toko()
    {
        return $this->belongsTo(Toko::class);
    }

    public function transactions()
    {
        return $this->morphMany(BalanceTransaction::class, 'owner');
    }
    public function syncSalesStats()
    {
    $toko = $this->toko;

    if (!$toko) return;

    // Ambil semua pesanan selesai dari toko ini
    $pesananIds = $toko->pesanans()
        ->where('status', 'selesai')
        ->pluck('id');

    // Total order selesai
    $totalOrder = count($pesananIds);

    // Total berat dan stok dari detail pesanan
    $details = \App\Models\PesananDetail::whereIn('pesanan_id', $pesananIds)->get();

    $totalBerat = $details->sum('berat');
    $totalStok = $details->sum('jumlah');

    // Update database
    $this->update([
        'total_order_selesai' => $totalOrder,
        'total_berat_terjual' => $totalBerat,
        'total_stok_terjual' => $totalStok,
    ]);
    }

}
