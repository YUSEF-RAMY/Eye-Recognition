// signup.jsx
import "../styles/login.css";
import SignUpForm from "../components/SignUpForm";

function SignUp() {
  return (
     <div className="login-container signup-page">
        <div className="login-left">
             
        <SignUpForm />
      </div>

      <div className="login-right">
        <img 
          src="/bg-login.jpg" 
          alt="signup visual" 
          className="login-image"
        />
      </div>
     </div>
  );
}

export default SignUp;
 