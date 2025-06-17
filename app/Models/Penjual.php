<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;


class Penjual extends  Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $primaryKey = 'penjualid';

    protected $fillable = [
        'namalengkap',
        'email',
        'notelp',
        'katasandi',
    ];

    protected $hidden = [
        'katasandi',
    ];
    public function toko()
    {
        return $this->hasOne(Toko::class, 'penjual_id','penjualid'); // adjust key if needed
    }

}
