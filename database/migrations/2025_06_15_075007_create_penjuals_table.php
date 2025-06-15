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
        Schema::create('penjuals', function (Blueprint $table) {
            $table->id('penjualid'); // primary key
            $table->string('namalengkap');
            $table->string('email')->unique();
            $table->string('notelp');
            $table->string('katasandi'); // usually this should be hashed
            $table->timestamps();
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('penjuals');
    }
};
