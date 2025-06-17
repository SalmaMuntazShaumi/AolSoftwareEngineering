<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Toko extends Model
{
    use HasFactory;

    protected $fillable = [
        'penjual_id',
        'nama_resto',
        'alamat',
        'no_telp',
        'jenis_resto',
        'tipe_resto',
        'produk_layak',
        'produk_tidak_layak',
        'deskripsi'
    ];

    public function penjual()
    {
    return $this->belongsTo(Penjual::class, 'penjual_id', 'penjualid');
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }
    public function pesanans()
    {
    return $this->hasMany(\App\Models\Pesanan::class, 'toko_id');
    }


}
