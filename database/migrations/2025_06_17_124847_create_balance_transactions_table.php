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
        Schema::create('balance_transactions', function (Blueprint $table) {
        $table->id();
        
        // Kolom untuk relasi polymorphic
        $table->string('owner_type'); // Ini akan menyimpan nama model (contoh: App\Models\UserBalance)
        $table->unsignedBigInteger('owner_id'); // Ini akan menyimpan ID dari model terkait
        
        // Kolom referensi transaksi
        $table->string('reference_type')->nullable();
        $table->unsignedBigInteger('reference_id')->nullable();
        
        $table->decimal('amount', 15, 2);
        $table->string('type'); // deposit, withdrawal, payment, income
        $table->text('description');
        $table->timestamps();
        
        // Index untuk performa query
        $table->index(['owner_type', 'owner_id']);
        $table->index(['reference_type', 'reference_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('balance_transactions');
    }
};
