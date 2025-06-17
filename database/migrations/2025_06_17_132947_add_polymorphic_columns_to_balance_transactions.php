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
        Schema::table('balance_transactions', function (Blueprint $table) {
            $table->string('owner_type')->after('id');
            $table->unsignedBigInteger('owner_id')->after('owner_type');
            
            $table->index(['owner_type', 'owner_id']);
        });
    }

    public function down()
    {
        Schema::table('balance_transactions', function (Blueprint $table) {
            $table->dropIndex(['owner_type', 'owner_id']);
            $table->dropColumn(['owner_type', 'owner_id']);
        });
    }
};
