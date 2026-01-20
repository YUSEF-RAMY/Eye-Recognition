import "./App.css";
import { TokenProvider } from "./contexts/TokenProvider";

import AllRoutes from "./routes/AllRoutes";

function App() {
  return (
    <TokenProvider>
      <AllRoutes />
    </TokenProvider>
  );
}

export default App;
