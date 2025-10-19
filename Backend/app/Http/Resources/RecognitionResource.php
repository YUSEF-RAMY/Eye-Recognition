<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RecognitionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'person' => [
                'id' => $this->person->id ?? null,
                'name' => $this->person->name ?? 'Unknown',
                'image_url' => isset($this->person->image_path)
                    ? asset('storage/' . $this->person->image_path)
                    : null,
            ],
            'accuracy' => $this->accuracy ?? null,
            'message' => $this->message ?? 'Recognition completed successfully',
        ];
    }
}
