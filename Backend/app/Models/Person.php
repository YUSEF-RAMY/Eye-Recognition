<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Person extends Model
{
    protected $fillable = ['name', 'image_path'];

    public function recognitions()
    {
        return $this->hasMany(Recognition::class);
    }
}
