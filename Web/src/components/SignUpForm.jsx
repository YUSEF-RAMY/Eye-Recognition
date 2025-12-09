import { useState } from "react";
import { FaEnvelope, FaUser, FaEye, FaEyeSlash, FaImage } from "react-icons/fa";
import { useNavigate } from "react-router-dom";

function SignUpForm({ setIsSignUp }) {
  const [step, setStep] = useState(1); // 1 = form , 2 = upload photo

  // Step 1 States
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errors, setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const navigate = useNavigate();

  // Step 2 States
  const [selectedImage, setSelectedImage] = useState(null);

  // -------- Validation Function ----------
  const validate = () => {
    const newErrors = {};

    if (!fullName.trim()) newErrors.fullName = "Full Name is required";

    if (!email) newErrors.email = "Email is required";
    else if (!/\S+@\S+\.\S+/.test(email)) newErrors.email = "Email is invalid";

    if (!password) newErrors.password = "Password is required";
    else if (password.length < 6)
      newErrors.password = "Password must be at least 6 characters";

    if (!confirmPassword)
      newErrors.confirmPassword = "Please confirm your password";
    else if (confirmPassword !== password)
      newErrors.confirmPassword = "Passwords do not match";

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  // -------- Move to Step 2 ----------
  const handleNext = (e) => {
    e.preventDefault();
    if (validate()) {
      setStep(2);
    }
  };

  // -------- Upload Image ----------
  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedImage(URL.createObjectURL(file));
    }
  };

  // -------- Final Submit ----------
  const handleSignUp = () => {
    console.log("Account Created:", {
      fullName,
      email,
      password,
      selectedImage: selectedImage || "No image uploaded",
    });
     navigate("/home");
  };

  return (
    <div className="form-wrapper">

      {/* ---------------- STEP 1 ---------------- */}
      {step === 1 && (
        <>
          <h1 className="login-title">
            <span className="home-emoji">✨</span> Create Account
          </h1>
          <p className="login-subtitle">Join us now.</p>

          <form onSubmit={handleNext}>
            {/* Full Name */}
            <div className="input-group">
              <input
                type="text"
                placeholder="Full Name"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
              />
              <FaUser className="input-icon" />
            </div>
            {errors.fullName && <p className="error">{errors.fullName}</p>}

            {/* Email */}
            <div className="input-group">
              <input
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
              <FaEnvelope className="input-icon" />
            </div>
            {errors.email && <p className="error">{errors.email}</p>}

            {/* Password */}
            <div className="input-group">
              <input
                type={showPassword ? "text" : "password"}
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <span
                className="input-icon password-toggle"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword ? <FaEyeSlash /> : <FaEye />}
              </span>
            </div>
            {errors.password && <p className="error">{errors.password}</p>}

            {/* Confirm Password */}
            <div className="input-group">
              <input
                type={showConfirmPassword ? "text" : "password"}
                placeholder="Confirm Password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
              />
              <span
                className="input-icon password-toggle"
                onClick={() =>
                  setShowConfirmPassword(!showConfirmPassword)
                }
              >
                {showConfirmPassword ? <FaEyeSlash /> : <FaEye />}
              </span>
            </div>
            {errors.confirmPassword && (
              <p className="error">{errors.confirmPassword}</p>
            )}

            <button type="submit" className="login-btn">
              Next
            </button>
          </form>

          <button
            type="button"
            className="signup-btn"
            onClick={() => setIsSignUp(false)}
          >
            Back to Login
          </button>
        </>
      )}

      {/* ---------------- STEP 2 ---------------- */}
      {step === 2 && (
        <>
          <h1 className="login-title">
            <span className="home-emoji">📸</span> Upload Photo
          </h1>
          <p className="login-subtitle">(Optional)</p>

          {/* Image Preview */}
          {selectedImage && (
            <img
              src={selectedImage}
              alt="preview"
              className="preview-img"
              style={{
                width: "120px",
                height: "120px",
                borderRadius: "50%",
                objectFit: "cover",
                margin: "10px auto",
                display: "block",
                border: "3px solid #ddd",
              }}
            />
          )}

          {/* Upload Button */}
          <label className="upload-btn">
            <FaImage className="upload-icon" />
            Upload Photo
            <input
              type="file"
              accept="image/*"
              hidden
              onChange={handleImageChange}
            />
          </label>

          {/* Final Sign Up */}
          <button className="login-btn" onClick={handleSignUp}>
            Sign Up
          </button>

          <button
            className="signup-btn"
            onClick={() => setStep(1)}
          >
            Back
          </button>
        </>
      )}
    </div>
  );
}

export default SignUpForm;
