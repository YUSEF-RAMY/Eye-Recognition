import { createBrowserRouter, RouterProvider } from "react-router-dom";
import Login from "../pages/Login";
import Signup from "../pages/SignUp";
import Home from "../pages/Home";
import EyeScanPage from "../pages/EyeScanPage";
import Setting from "../pages/setting";
import ProtectedRoute from "./ProtectedRoute";

const router = createBrowserRouter([
  {
    path: "/",
    element: (
      // <ProtectedRoute>
      <Home />
      // </ProtectedRoute>
    ),
  },
  {
    path: "/login",
    element: (
      <ProtectedRoute>
        <Login />
      </ProtectedRoute>
    ),
  },
  {
    path: "/eye-scan",
    element: (
      <ProtectedRoute>
        <EyeScanPage />
      </ProtectedRoute>
    ),
  },
  {
    path: "/profile",
    element: (
      <ProtectedRoute>
        <Setting />
      </ProtectedRoute>
    ),
  },
]);

export default function AllRoutes() {
  return <RouterProvider router={router} />;
}
