import { Navigate, useLocation } from "react-router-dom";
import { useToken } from "../contexts/TokenProvider";

export default function ProtectedRoute({ children }) {
  const location = useLocation();
  const { token } = useToken();

  // prettier-ignore
  if (location.pathname === "/login" && token) 
    return <Navigate to={"/"} />;

  // prettier-ignore
  if (location.pathname === "/login" && !token)
    return children;

  return token ? children : <Navigate to="/login" replace />;
}
