<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->enum('kategori', ['roti', 'lemak', 'nasi', 'daging', 'buah dan sayur', 'tulang']);
            $table->text('deskripsi')->nullable();
            $table->string('foto')->nullable();
            $table->decimal('harga_berat', 10, 2);
            $table->decimal('diskon', 5, 2)->nullable();
            $table->decimal('berat', 8, 2);
            $table->integer('total_barang');
            $table->decimal('total_berat', 8, 2);
            $table->date('tanggal_produksi');
            $table->date('tanggal_kadaluarsa');
            $table->string('kondisi');
            $table->text('syarat_ketentuan')->nullable();
            $table->text('catatan_tambahan')->nullable();
            $table->foreignId('toko_id')->constrained()->onDelete('cascade');
            $table->timestamps();
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
