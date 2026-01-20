// LoginForm.jsx
import { useState } from "react";
import {
  FaEnvelope,
  // FaApple,
  // FaGoogle,
  // FaFacebook,
  FaEye,
  FaEyeSlash,
} from "react-icons/fa";
import { useNavigate } from "react-router-dom";
import { useToken } from "../contexts/TokenProvider";
function LoginForm({ setIsSignUp }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false); // state للتحكم في الرؤية
  const { setToken } = useToken();

  const navigate = useNavigate();
  const validate = () => {
    const newErrors = {};
    if (!email.trim()) newErrors.email = "Email is required";
    if (!password) newErrors.password = "Password is required";
    else if (password.length < 6)
      newErrors.password = "Password must be at least 6 characters";
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };
  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrors({});
    if (!validate()) return;
    try {
      const response = await fetch(
        "https://katydid-champion-mutually.ngrok-free.app/api/login",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            email,
            password,
          }),
        }
      );
      let data;
      // حاول قراءة JSON بأمان
      try {
        data = await response.json();
        console.log(data);
      } catch {
        data = null;
      }
      console.log("Parsed response:", data);
      if (!response.ok) {
        setErrors({
          api: data?.error || "Invalid credentials",
        });
        return;
      }
      // Save token
      setToken(data.token);
      // localStorage.setItem("token", data.token);
      // Navigate home
      navigate("/");
    } catch (err) {
      console.error("Login error:", err);
      setErrors({
        api: "Something went wrong. Please try again.",
      });
    }
  };

  return (
    <div className="formm-wrapper">
      <h1 className="login-title">
        <span className="home-emoji">🏠</span> Welcome Home
      </h1>
      <p className="login-subtitle">Please Enter Your Details.</p>
      {errors.api && <p className="error">{errors.api}</p>}
      <form onSubmit={handleSubmit}>
        <div className="input-group">
          <input
            type="text"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <FaEnvelope className="input-icon" />
        </div>
        {errors.email && <p className="error">{errors.email}</p>}
        <div className="input-group">
          <input
            type={showPassword ? "text" : "password"}
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {/* أيقونة العين */}
          <span
            className="input-icon password-toggle"
            onClick={() => setShowPassword(!showPassword)}
            style={{ cursor: "pointer" }}
          >
            {showPassword ? <FaEyeSlash /> : <FaEye />}
          </span>
        </div>
        {errors.password && <p className="error">{errors.password}</p>}
        <div className="login-options">
          <label>
            <input type="checkbox" /> Remember for 30 days
          </label>
          <a href="#">Forgot Password?</a>
        </div>
        <button type="submit" className="login-btn">
          Login
        </button>
        <button
          type="button"
          className="signup-btn"
          onClick={() => setIsSignUp(true)}
        >
          Sign Up
        </button>
      </form>
      {/* <div className="divider">or</div> */}
      {/* <div className="social-login">
        <FaApple className="social-icon" />
        <FaGoogle className="social-icon" />
        <FaFacebook className="social-icon" />
      </div> */}
    </div>
  );
}
export default LoginForm;
