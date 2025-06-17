<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


class TokoBalance extends Model
{
    protected $fillable = ['toko_id', 'balance'];

    public function toko()
    {
        return $this->belongsTo(Toko::class);
    }

    public function transactions()
    {
        return $this->morphMany(BalanceTransaction::class, 'owner');
    }
}
