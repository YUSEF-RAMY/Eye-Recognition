let uploadUrl = "";
let csrfToken = "";
let count = 0;

function startCamera() {
    const video = document.getElementById('video');
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" } })
        .then(stream => { video.srcObject = stream; })
        .catch(err => { alert('خطأ في الكاميرا: ' + err.message); });
    }
}

window.initCapture = function(url, token, initialCount) {
    uploadUrl = url;
    csrfToken = token;
    count = initialCount;
    document.getElementById('image-count').innerText = count;
    startCamera();
}

window.capture = function() {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    const roi = document.querySelector('.roi');
    const wrapper = document.querySelector('.video-wrapper');

    if (!video.srcObject) return;

    // 1️⃣ التقاط الوجه الكامل (Mirror)
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    ctx.save();
    ctx.translate(canvas.width, 0);
    ctx.scale(-1, 1);
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    ctx.restore();
    const fullImage = canvas.toDataURL('image/png');

    // 2️⃣ الحسابات الدقيقة للقص (لحل مشكلة الموبايل)
    const videoRect = video.getBoundingClientRect();
    const roiRect = roi.getBoundingClientRect();

    // حساب حجم الفيديو الفعلي المعروض داخل العنصر (بسبب object-fit: cover)
    const videoRatio = video.videoWidth / video.videoHeight;
    const elementRatio = videoRect.width / videoRect.height;

    let displayedWidth, displayedHeight, offsetX = 0, offsetY = 0;

    if (videoRatio > elementRatio) {
        // الفيديو أعرض من العنصر (يتم قص الجوانب)
        displayedHeight = videoRect.height;
        displayedWidth = videoRect.height * videoRatio;
        offsetX = (displayedWidth - videoRect.width) / 2;
    } else {
        // الفيديو أطول من العنصر (يتم قص الأعلى والأسفل)
        displayedWidth = videoRect.width;
        displayedHeight = videoRect.width / videoRatio;
        offsetY = (displayedHeight - videoRect.height) / 2;
    }

    // مقياس الرسم بين الحجم الفعلي وحجم البكسلات
    const scale = video.videoWidth / displayedWidth;

    // حساب إحداثيات المستطيل بالنسبة للفيديو الأصلي
    // مع مراعاة الـ Offset الناتج عن cover
    const rectXInElement = roiRect.left - videoRect.left + offsetX;
    const rectYInElement = roiRect.top - videoRect.top + offsetY;

    const w = Math.floor(roiRect.width * scale);
    const h = Math.floor(roiRect.height * scale);
    
    // بما أننا عكسنا الصورة (Mirror)، الـ X يجب أن يعكس أيضاً
    const x = Math.floor(video.videoWidth - (rectXInElement * scale) - w);
    const y = Math.floor(rectYInElement * scale);

    const roiCanvas = document.createElement('canvas');
    roiCanvas.width = w;
    roiCanvas.height = h;
    const roiCtx = roiCanvas.getContext('2d');

    // القص من الكانفاس الأول
    roiCtx.drawImage(canvas, x, y, w, h, 0, 0, w, h);
    
    const eyeImage = roiCanvas.toDataURL('image/png');
    sendImages(fullImage, eyeImage);
}

function sendImages(face, eye) {
    const countElement = document.getElementById('image-count');
    
    // تحديث العداد فوراً
    count++;
    countElement.innerText = count;
    countElement.classList.add('pulse');
    setTimeout(() => countElement.classList.remove('pulse'), 300);

    fetch(uploadUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken
        },
        body: JSON.stringify({ face_image: face, eye_image: eye })
    })
    .catch(err => {
        count--;
        countElement.innerText = count;
        console.error("Upload failed", err);
    });
}