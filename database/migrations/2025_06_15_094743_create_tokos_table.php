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
        if (!Schema::hasTable('tokos')) {
        Schema::create('tokos', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('penjual_id');
            $table->foreign('penjual_id')->references('penjualid')->on('penjuals')->onDelete('cascade');
            $table->string('nama_resto');
            $table->string('alamat');
            $table->string('no_telp');
            $table->enum('jenis_resto', ['individu', 'perusahaan']);
            $table->string('tipe_resto')->nullable();
            $table->boolean('produk_layak')->default(false);
            $table->boolean('produk_tidak_layak')->default(false);
            $table->text('deskripsi')->nullable();
            $table->timestamps();

        });
        }

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tokos');
    }
};
