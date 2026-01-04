<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'name' => env('SEED_NAME_ADMIN'),
            'email' => env('SEED_EMAIL_ADMIN'),
            'password' => bcrypt(env('SEED_PASSWD_ADMIN')),
        ]);
        User::factory()->create([
            'name' => env('SEED_NAME_AMR'),
            'email' => env('SEED_EMAIL_AMR'),
            'password' => bcrypt(env('SEED_PASSWD_AMR')),
        ]);
        User::factory()->create([
            'name' => env('SEED_NAME_MARYAM'),
            'email' => env('SEED_EMAIL_MARYAM'),
            'password' => bcrypt(env('SEED_PASSWORD_MARYAM')),
        ]);
        User::factory()->create([
            'name' => env('SEED_NAME_HEBA'),
            'email' => env('SEED_EMAIL_HEBA'),
            'password' => bcrypt(env('SEED_PASSWORD_HEBA')),
        ]);
        User::factory()->create([
            'name' => env('SEED_NAME_SAMER'),
            'email' => env('SEED_EMAIL_SAMER'),
            'password' => bcrypt(env('SEED_PASSWORD_SAMER')),
        ]);
    }
}
