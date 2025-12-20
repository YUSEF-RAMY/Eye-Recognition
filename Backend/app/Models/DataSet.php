<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DataSet extends Model
{
    protected $fillable = ['image_path' , 'user_id' , 'user_name'];
}
