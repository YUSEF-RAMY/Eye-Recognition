<x-app-layout>
    @vite(['resources/css/capture.css', 'resources/js/capture.js'])
    <div class="camera-container">
        <h3 style="text-align:center; color:white; margin-bottom:20px;">Capture Eye Image</h3>

        <div class="video-wrapper">
            <video id="video" autoplay playsinline></video>
            <div class="roi">
                <!-- نقطتين للتوجيه -->
                <div class="point" id="point1"></div>
                <div class="point" id="point2"></div>
            </div> <!-- مستطيل العين -->

        </div>

        <br>

        <div class="controls-bar">
            <button class="capture-btn" onclick="capture()">
                <svg xmlns="http://www.w3.org/2000/svg" class="btn-icon" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                    <circle cx="12" cy="13" r="4" />
                </svg>
                <span>Capture Image</span>
            </button>

            <div class="divider"></div>

            <div class="counter-badge">
                <span class="label">IMAGES CAPTURED</span>
                <span id="image-count" class="number">{{ $initialCount ?? 0 }}</span>
            </div>
        </div>
        <canvas id="canvas" style="display:none;"></canvas>
    </div>

   <script>
    document.addEventListener('DOMContentLoaded', function() {
        // تأكد أن الاسم مطابق لما في window.initCapture
        if (window.initCapture) {
            window.initCapture(
                "{{ route('capture.store') }}", 
                "{{ csrf_token() }}", 
                {{ $initialCount ?? 0 }}
            );
        }
    });
</script>
</x-app-layout>
