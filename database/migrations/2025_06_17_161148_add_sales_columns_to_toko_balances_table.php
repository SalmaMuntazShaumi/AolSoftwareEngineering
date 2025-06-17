<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void {
        Schema::table('toko_balances', function (Blueprint $table) {
            $table->unsignedBigInteger('total_order_selesai')->default(0);
            $table->decimal('total_berat_terjual', 12, 2)->default(0);
            $table->unsignedBigInteger('total_stok_terjual')->default(0);
        });
    }

    public function down(): void {
        Schema::table('toko_balances', function (Blueprint $table) {
            $table->dropColumn(['total_order_selesai', 'total_berat_terjual', 'total_stok_terjual']);
        });
    }
};
