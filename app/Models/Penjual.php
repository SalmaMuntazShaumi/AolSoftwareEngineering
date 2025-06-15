<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

use Laravel\Sanctum\HasApiTokens;

class Penjual extends Model
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
}
