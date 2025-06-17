<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BalanceTransaction extends Model
{
    protected $fillable = [
        'owner_type',
        'owner_id',
        'reference_type',
        'reference_id',
        'amount',
        'type',
        'description'
    ];

    public function owner()
    {
        return $this->morphTo();
    }

    public function reference()
    {
        return $this->morphTo();
    }
}