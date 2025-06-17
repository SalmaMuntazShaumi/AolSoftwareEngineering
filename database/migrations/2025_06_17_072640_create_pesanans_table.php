<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
     Schema::create('pesanans', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->onDelete('cascade');
        $table->unsignedBigInteger('penjual_id');
        $table->foreign('penjual_id')->references('penjualid')->on('penjuals')->onDelete('cascade');  
        $table->decimal('total_harga', 12, 2);
        $table->decimal('total_berat', 10, 2);
        $table->enum('status', ['menunggu_konfirmasi', 'dikirim', 'selesai', 'dibatalkan'])->default('menunggu_konfirmasi');
        $table->timestamps();
     });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanans');
    }
};
