<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'nama', 'kategori', 'deskripsi', 'foto', 'harga_berat',
        'diskon', 'berat', 'total_barang', 'total_berat',
        'tanggal_produksi', 'tanggal_kadaluarsa', 'kondisi',
        'syarat_ketentuan', 'catatan_tambahan', 'toko_id'
    ];

    public function toko()
    {
        return $this->belongsTo(Toko::class);
    }
}
