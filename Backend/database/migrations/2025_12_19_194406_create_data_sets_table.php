<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('data_sets', function (Blueprint $table) {
            $table->id();

            $table->string('full_image_path');
            $table->string('eye_image_path');
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            // مهم للـ AI
            $table->integer('roi_width')->nullable();
            $table->integer('roi_height')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_sets');
    }
};
