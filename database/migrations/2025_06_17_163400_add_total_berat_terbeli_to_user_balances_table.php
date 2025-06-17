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
        Schema::table('user_balances', function (Blueprint $table) {
            $table->decimal('total_berat_terbeli', 10, 2)->default(0)->after('balance');
        });
    }

    public function down(): void
    {
        Schema::table('user_balances', function (Blueprint $table) {
            $table->dropColumn('total_berat_terbeli');
        });
    }
};
