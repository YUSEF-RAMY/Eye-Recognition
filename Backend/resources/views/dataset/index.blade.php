<x-app-layout>
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
    <button class="capture-btn" onclick="capture()">Capture</button>

    <canvas id="canvas" style="display:none;"></canvas>
</div>

<style>
body {
    background-color: #1f2937;
    margin: 0;
    font-family: sans-serif;
}

.camera-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 20px;
    padding: 0 10px;
}

.video-wrapper {
    position: relative;
    width: 100%;
    max-width: 640px;
    aspect-ratio: 4/3; /* يحافظ على نسبة العرض للارتفاع */
    border: 2px solid #333;
    overflow: hidden;
    border-radius: 12px;
}

video {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transform: scaleX(-1);

    /* object-fit: contain; */
    background: black;
}

.roi {
    position: absolute;
    width: 145px;
    height: 40px;
    border: 3px solid red;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    pointer-events: none;
    box-shadow: 0 0 10px red;
}

/* النقطتين داخل ROI */
.point {
    position: absolute;
    width: 18px;
    height: 9.5px;
    background-color: rgba(100, 236, 95, 0.25);
    border-radius: 50%;
    border: 1px solid rgba(136, 255, 81, 0.6);
}

/* ضبط مكان النقطتين داخل ROI */
#point1 {
    top: 50%;
    left: 25%;
    transform: translate(-50%, -50%);
}

#point2 {
    top: 50%;
    left: 75%;
    transform: translate(-50%, -50%);
}

.capture-btn {
    background-color: #2563eb;
    color: white;
    padding: 10px 20px;
    font-size: 16px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    margin-top: 15px;
}

.capture-btn:hover {
    background-color: #1d4ed8;
}
</style>

<script>
const video = document.getElementById('video');

// فتح الكاميرا
navigator.mediaDevices.getUserMedia({
    video: { facingMode: "user" } // للكاميرا الخلفية على الموبايل
})
.then(stream => {
    video.srcObject = stream;
})
.catch(err => {
    alert('Camera permission denied');
});

// التقاط صورتين: كاملة + ROI
function capture() {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');

    /* ======================
       1️⃣ الصورة الكاملة
    ====================== */

    canvas.width  = video.videoWidth;
    canvas.height = video.videoHeight;

    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    const fullImage = canvas.toDataURL('image/png');

    /* ======================
       2️⃣ صورة العين (ROI)
    ====================== */

    const roi = document.querySelector('.roi');

const videoRect = video.getBoundingClientRect();
const roiRect   = roi.getBoundingClientRect();

const videoAR = video.videoWidth / video.videoHeight;
const viewAR  = videoRect.width / videoRect.height;

let sx = 0, sy = 0;
let sWidth = video.videoWidth;
let sHeight = video.videoHeight;

// حساب crop اللي عمله object-fit: cover
if (videoAR > viewAR) {
    sWidth = video.videoHeight * viewAR;
    sx = (video.videoWidth - sWidth) / 2;
} else {
    sHeight = video.videoWidth / viewAR;
    sy = (video.videoHeight - sHeight) / 2;
}

const scaleX = sWidth  / videoRect.width;
const scaleY = sHeight / videoRect.height;

const x = sx + (roiRect.left - videoRect.left) * scaleX;
const y = sy + (roiRect.top  - videoRect.top)  * scaleY;
const w = roiRect.width  * scaleX;
const h = roiRect.height * scaleY;

const roiCanvas = document.createElement('canvas');
roiCanvas.width  = Math.round(w);
roiCanvas.height = Math.round(h);

roiCanvas
    .getContext('2d')
    .drawImage(video, x, y, w, h, 0, 0, roiCanvas.width, roiCanvas.height);

const eyeImage = roiCanvas.toDataURL('image/png');

    /* ======================
       3️⃣ إرسال للـ Backend
    ====================== */

    sendImages(fullImage, eyeImage);
}


function sendImages(full, eye) {
    fetch('https://katydid-champion-mutually.ngrok-free.app/api/dataset/capture', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ full_image: full, eye_image: eye })
    })
    .then(res => res.json())
    .then(() => alert('Images saved successfully'))
    .catch(err => console.error(err));
}
</script>
</x-app-layout>
