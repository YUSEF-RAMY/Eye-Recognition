import { createContext, use, useEffect, useState } from "react";

const TokenContext = createContext();

export function TokenProvider({ children }) {
  const [token, setToken] = useState(() => localStorage.getItem("token") || "");

  useEffect(() => {
    !token
      ? localStorage.removeItem("token")
      : localStorage.setItem("token", token);
  }, [token]);

  return <TokenContext value={{ token, setToken }}>{children}</TokenContext>;
}

// eslint-disable-next-line react-refresh/only-export-components
export function useToken() {
  const data = use(TokenContext);

  // prettier-ignore
  if (!data)
    throw new Error("Context Provider used out of its context");

  return data;
}
