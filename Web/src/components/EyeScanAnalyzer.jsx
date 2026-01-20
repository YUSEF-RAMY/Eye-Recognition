import { postEyeImage } from "../services/apiEyeImage";
import "../styles/EyeScanAnalyzer.css";
import React, { useState, useRef, useEffect } from "react";
import { dataURItoFile } from "../utils/dataToFile";
import Swal from "sweetalert2";

const EyeScanAnalyzer = () => {
  const [stream, setStream] = useState(null);
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const [croppedImageData, setCroppedImageData] = useState(null);
  const [_isPulsing, setIsPulsing] = useState(false);
  const [_responsedStatus, setResponsedStatus] = useState({
    name: null,
    bestScore: null,
    status: null,
  });

  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const roiRef = useRef(null);

  const handleSuccessDetection = function (name, bestScore) {
    setResponsedStatus({
      name,
      bestScore,
      status: "Successful",
    });
    Swal.fire({
      title: "Detection Result",
      html: `Name: <strong>${name}</strong><br>Confidence Score: <strong>${bestScore}</strong>`,
      icon: "success",
      confirmButtonText: "OK",
    });
  };

  const handleFailureDetection = function (status) {
    setResponsedStatus({
      name: null,
      bestScore: null,
      status,
    });
    Swal.fire({
      title: "Detection Failed",
      text: status,
      icon: "error",
      confirmButtonText: "OK",
    });
  };

  // Assign stream to video element when both are ready
  useEffect(() => {
    if (stream && videoRef.current) {
      videoRef.current.srcObject = stream;
      videoRef.current.onloadedmetadata = () => {
        videoRef.current.play().catch((err) => {
          console.error("Error playing video:", err);
        });
      };
    }
  }, [stream, isCameraOpen]);

  const handleUploadCroppedImage = async function () {
    const file = dataURItoFile(croppedImageData, crypto.randomUUID());
    const formData = new FormData();
    formData.append("image", file);

    const {
      name,
      status,
      best_score: bestScore,
    } = await postEyeImage(formData);
    name && bestScore
      ? handleSuccessDetection(name, bestScore)
      : handleFailureDetection(status);
  };

  const openCamera = async () => {
    try {
      const mediaStream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "user" },
      });
      setStream(mediaStream);
      setIsCameraOpen(true);
    } catch (error) {
      alert("Camera access denied or not available.");
      console.error(error);
    }
  };

  const capture = () => {
    const video = videoRef.current;
    const canvas = canvasRef.current;
    const roi = roiRef.current;

    if (!video || !video.srcObject || !canvas || !roi) return;

    const ctx = canvas.getContext("2d");

    // 1️⃣ Capture full frame with mirror effect
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    ctx.save();
    ctx.translate(canvas.width, 0);
    ctx.scale(-1, 1);
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    ctx.restore();

    // 2️⃣ Precise ROI calculations (handles mobile + object-fit: cover)
    const videoRect = video.getBoundingClientRect();
    const roiRect = roi.getBoundingClientRect();

    const videoRatio = video.videoWidth / video.videoHeight;
    const elementRatio = videoRect.width / videoRect.height;

    let displayedWidth,
      displayedHeight,
      offsetX = 0,
      offsetY = 0;

    if (videoRatio > elementRatio) {
      // Video is wider than element (sides are cropped)
      displayedHeight = videoRect.height;
      displayedWidth = videoRect.height * videoRatio;
      offsetX = (displayedWidth - videoRect.width) / 2;
    } else {
      // Video is taller than element (top/bottom are cropped)
      displayedWidth = videoRect.width;
      displayedHeight = videoRect.width / videoRatio;
      offsetY = (displayedHeight - videoRect.height) / 2;
    }

    const scale = video.videoWidth / displayedWidth;

    const rectXInElement = roiRect.left - videoRect.left + offsetX;
    const rectYInElement = roiRect.top - videoRect.top + offsetY;

    const w = Math.floor(roiRect.width * scale);
    const h = Math.floor(roiRect.height * scale);

    // Since we mirrored the image, X must also be mirrored
    const x = Math.floor(video.videoWidth - rectXInElement * scale - w);
    const y = Math.floor(rectYInElement * scale);

    // 3️⃣ Crop ROI from mirrored canvas
    const roiCanvas = document.createElement("canvas");
    roiCanvas.width = w;
    roiCanvas.height = h;
    const roiCtx = roiCanvas.getContext("2d");
    roiCtx.drawImage(canvas, x, y, w, h, 0, 0, w, h);

    const eyeImage = roiCanvas.toDataURL("image/png");
    setCroppedImageData(eyeImage);

    // 4️⃣ Update counter with pulse effect
    setIsPulsing(true);
    setTimeout(() => setIsPulsing(false), 300);
  };

  const closeCamera = () => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
      setIsCameraOpen(false);
    }
  };

  return (
    <div className="camera-container">
      <h3 className="camera-title" class="color:white">Eye Scan Analyzer</h3>

      {!isCameraOpen ? (
        <button className="capture-btn" onClick={openCamera}>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            className="btn-icon"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
            <circle cx="12" cy="13" r="4" />
          </svg>
          <span>Open Camera</span>
        </button>
      ) : (
        <>
          <div className="video-wrapper">
            <video ref={videoRef} autoPlay playsInline muted></video>
            <div className="roi" ref={roiRef}>
              <div className="point" id="point1"></div>
              <div className="point" id="point2"></div>
            </div>
          </div>

          <div className="controls-bar">
            <button className="capture-btn" onClick={capture}>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="btn-icon"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                <circle cx="12" cy="13" r="4" />
              </svg>
              <span>Get Cropped Image</span>
            </button>
          </div>

          <button className="close-btn" onClick={closeCamera}>
            Close Camera
          </button>
        </>
      )}

      <canvas ref={canvasRef} style={{ display: "none" }}></canvas>

      {croppedImageData && (
        <div className="captured-preview">
          <h4>Captured Eye</h4>
          <img src={croppedImageData} alt="Captured Eye" />
          <button className="capture-btn" onClick={handleUploadCroppedImage}>
            Get Prescription
          </button>
        </div>
      )}
    </div>
  );
};

export default EyeScanAnalyzer;
