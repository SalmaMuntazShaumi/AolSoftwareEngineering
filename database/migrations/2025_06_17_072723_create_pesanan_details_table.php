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
    Schema::create('pesanan_details', function (Blueprint $table) {
        $table->id();

        $table->unsignedBigInteger('pesanan_id');
        $table->foreign('pesanan_id')->references('id')->on('pesanans')->onDelete('cascade');

        $table->unsignedBigInteger('produk_id');
        $table->foreign('produk_id')->references('id')->on('products')->onDelete('cascade');

        $table->string('nama_produk');
        $table->string('foto_produk')->nullable();
        $table->integer('jumlah');
        $table->decimal('harga', 12, 2);
        $table->decimal('berat', 10, 2);
        $table->timestamps();
    });


    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanan_details');
    }
};
