<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DataSet extends Model
{
    protected $fillable = [
        'full_image_path',
        'eye_image_path',
        'roi_width',
        'roi_height'
    ];
}
