
import './App.css'
import {  BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Signup from "./pages/SignUp";
import Home from "./pages/Home";
import EyeScanPage from './pages/EyeScanPage';
import Setting from "./pages/setting";

function App() {
  
  return (
     <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
         <Route path="/home" element={<Home />} />
         <Route path="/eye-scan" element={<EyeScanPage />} />
         <Route path="/sett" element={<Setting />} />
      </Routes>
    </BrowserRouter>
  );
}


export default App
