import '../styles/EyeScanAnalyzer.css';
import React, { useState, useRef } from 'react';


const EyeScanAnalyzer = () => {
  const [uploadedImage, setUploadedImage] = useState(null);
  const [stream, setStream] = useState(null);
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [croppedImageData, setCroppedImageData] = useState(null);
  const videoRef = useRef(null);
  const fileInputRef = useRef(null);

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => setUploadedImage(img);
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  };

  const openCamera = async () => {
  try {
    const mediaStream = await navigator.mediaDevices.getUserMedia({ video: true });
    setStream(mediaStream);
    if (videoRef.current) {
      videoRef.current.srcObject = mediaStream;  // تأكد من أن العنصر موجود
      await videoRef.current.play();  // شغل الفيديو (مهم)
    }
    setIsCameraOpen(true);
  } catch (error) {
    alert('Camera access denied or not available.');
    console.error(error);
  }
};


  const captureEye = () => {
    if (!videoRef.current) return;
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    canvas.width = videoRef.current.videoWidth;
    canvas.height = videoRef.current.videoHeight;
    ctx.drawImage(videoRef.current, 0, 0);

    // Crop to the overlay rectangle (centered, scaled) - Updated size for better eye coverage
    const rectWidth = 150;  // Increased from 250 to 300 for wider coverage
    const rectHeight = 50; // Increased from 100 to 150 for taller coverage
    const scaleX = videoRef.current.videoWidth / videoRef.current.clientWidth;
    const scaleY = videoRef.current.videoHeight / videoRef.current.clientHeight;
    const cropX = (videoRef.current.videoWidth - rectWidth * scaleX) / 2;
    const cropY = (videoRef.current.videoHeight - rectHeight * scaleY) / 2;
    const cropWidth = rectWidth * scaleX;
    const cropHeight = rectHeight * scaleY;

    const croppedCanvas = document.createElement('canvas');
    const croppedCtx = croppedCanvas.getContext('2d');
    croppedCanvas.width = cropWidth;
    croppedCanvas.height = cropHeight;
    croppedCtx.drawImage(canvas, cropX, cropY, cropWidth, cropHeight, 0, 0, cropWidth, cropHeight);

    const dataURL = croppedCanvas.toDataURL();
    const img = new Image();
    img.onload = () => setUploadedImage(img);
    img.src = dataURL;

    // Stop camera
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
      setIsCameraOpen(false);
    }
  };

  const showPrescription = () => {
    if (!uploadedImage) return;
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const cropHeight = uploadedImage.height / 2;
    canvas.width = uploadedImage.width;
    canvas.height = cropHeight;
    ctx.drawImage(uploadedImage, 0, uploadedImage.height - cropHeight, uploadedImage.width, cropHeight, 0, 0, uploadedImage.width, cropHeight);

    setCroppedImageData(canvas.toDataURL());
  };

  return (
    
    <div className="eye-scan-container">
      <h1 className="eye-scan-title">Eye Scan Analyzer</h1>
      <div className="eye-scan-upload-section">
        <div className="eye-scan-button-group">
          <input
            type="file"
            ref={fileInputRef}
            accept="image/*"
            style={{ display: 'none' }}
            onChange={handleImageUpload}
          />
          <button
            className="eye-scan-button"
            onClick={() => fileInputRef.current.click()}
          >
            Upload Image
          </button>
          <button className="eye-scan-button" onClick={openCamera}>
            Open Camera
          </button>
        </div>
      </div>
      {isCameraOpen && (
        <div className="eye-scan-camera-section">
    <div className="eye-scan-video-container">
      <video ref={videoRef} autoPlay muted className="eye-scan-video"></video>
      <div className="eye-scan-overlay"></div>
    </div>
    <button className="eye-scan-button" onClick={captureEye}>
      Capture Eye
    </button>
  </div>
      )}
      {uploadedImage && (
        <div className="eye-scan-image-display">
          <img
            src={uploadedImage.src}
            alt="Captured Eye Scan"
            className="eye-scan-image"
          />
          <br />
          <button className="eye-scan-button" onClick={showPrescription}>
            Get Prescription
          </button>
        </div>
      )}
      {croppedImageData && (
        <div className="eye-scan-cropped-section">
          <h3>Cropped Prescription Area</h3>
          <img
            src={croppedImageData}
            alt="Cropped Prescription"
            className="eye-scan-cropped-image"
          />
        </div>
      )}
    </div>
  );
};

export default EyeScanAnalyzer;