<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recognition extends Model
{
    protected $fillable = ['person_id', 'status', 'confidence'];

    public function person()
    {
        return $this->belongsTo(Person::class);
    }
}
