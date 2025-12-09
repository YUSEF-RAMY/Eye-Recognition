// LoginForm.jsx
import { useState } from "react";
import { FaEnvelope, FaApple, FaGoogle, FaFacebook, FaEye, FaEyeSlash, FaUser } from "react-icons/fa";
import { useNavigate } from "react-router-dom";

function LoginForm({ setIsSignUp }) {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false); // state للتحكم في الرؤية
  const navigate = useNavigate();

  const validate = () => {
    const newErrors = {};
    if (!username.trim()) newErrors.username = "Username is required";
    if (!password) newErrors.password = "Password is required";
    else if (password.length < 6) newErrors.password = "Password must be at least 6 characters";
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validate()) {
      console.log("Sending to API:", { username, password });
      // Simulate a successful login (in a real app, you'd check API response)
      navigate("/home");
    }
    // If validation fails, do nothing (errors are displayed, and navigation doesn't happen)
  };

  return (
    <div className="formm-wrapper">
      <h1 className="login-title">
        <span className="home-emoji">🏠</span> Welcome home
      </h1>
      <p className="login-subtitle">Please enter your details.</p>

      <form onSubmit={handleSubmit}>
        <div className="input-group">
          <input
            type="text"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <FaUser className="input-icon" />
        </div>
        {errors.username && <p className="error">{errors.username}</p>}

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
          <a href="#">Forgot password?</a>
        </div>

        <button type="submit" className="login-btn">Login</button>
        <button
          type="button"
          className="signup-btn"
          onClick={() => setIsSignUp(true)}
        >
          Sign Up
        </button>
      </form>

      <div className="divider">or</div>

      <div className="social-login">
        <FaApple className="social-icon" />
        <FaGoogle className="social-icon" />
        <FaFacebook className="social-icon" />
      </div>
    </div>
  );
}

export default LoginForm;
