<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BalanceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
   public function run()
    {
    // Beri saldo awal 100.000 untuk semua user
    $users = \App\Models\User::all();
    foreach ($users as $user) {
        \App\Models\UserBalance::create([
            'user_id' => $user->id,
            'balance' => 100000
        ]);
    }

    // Beri saldo awal 0 untuk semua toko
    $tokos = \App\Models\Toko::all();
    foreach ($tokos as $toko) {
        \App\Models\TokoBalance::create([
            'toko_id' => $toko->id,
            'balance' => 0
        ]);
    }
    }
}
