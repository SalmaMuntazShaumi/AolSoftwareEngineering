<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pesanan extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'penjual_id',
        'toko_id',
        'total_harga',
        'total_berat',
        'status',
    ];

    public function details()
    {
        return $this->hasMany(PesananDetail::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function penjual()
    {
        return $this->belongsTo(Penjual::class, 'penjual_id', 'penjualid');
    }
    public function toko()
    {
    return $this->belongsTo(Toko::class, 'toko_id');
    }

}
