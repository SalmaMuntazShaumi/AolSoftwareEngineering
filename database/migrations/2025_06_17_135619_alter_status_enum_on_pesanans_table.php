<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        DB::statement("ALTER TABLE pesanans MODIFY status ENUM(
            'menunggu_pembayaran',
            'menunggu_konfirmasi',
            'dikirim',
            'selesai',
            'dibatalkan'
        ) NOT NULL DEFAULT 'menunggu_pembayaran'");
    }

    public function down()
    {
        DB::statement("ALTER TABLE pesanans MODIFY status ENUM(
            'menunggu_konfirmasi',
            'dikirim',
            'selesai',
            'dibatalkan'
        ) NOT NULL DEFAULT 'menunggu_konfirmasi'");
    }
};
