import "../styles/login.css";
import LoginForm from "../components/LoginForm";
import SignupForm from "../components/SignUpForm";
import { useState } from "react";
import { Navigate } from "react-router-dom";

function Login() {
  const [isSignUp, setIsSignUp] = useState(false);
  return (
    <div className={`login-container ${isSignUp ? "sign-up-active" : ""}`}>
      {/* Left side - Form */}
      <div className="login-left">
        {isSignUp ? (
          <SignupForm setIsSignUp={setIsSignUp} />
        ) : (
          <LoginForm setIsSignUp={setIsSignUp} />
        )}
      </div>

      {/* Right side - Image Background */}
      <div className="login-right">
        <img src="/bg-login.jpg" alt="login visual" className="login-image" />
      </div>
    </div>
  );
}

export default Login;
