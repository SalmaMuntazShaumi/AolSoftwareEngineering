<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserBalance extends Model
{
    protected $fillable = ['user_id', 'balance','total_berat_terbeli'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function transactions()
    {
        return $this->morphMany(BalanceTransaction::class, 'owner');
    }
    public function syncTotalBeratTerbeli()
    {
    $userId = $this->user_id;

    $totalBerat = \App\Models\Pesanan::where('user_id', $userId)
        ->where('status', 'selesai')
        ->sum('total_berat'); // pastikan field ini ada di tabel `pesanans`

    $this->total_berat_terbeli = $totalBerat;
    $this->save();
    }

}
