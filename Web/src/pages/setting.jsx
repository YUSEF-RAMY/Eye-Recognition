import React, { useEffect, useState } from "react";

export default function Settings() {
  /* ================== Styles ================== */
  const containerStyle = {
    display: "flex",
    maxWidth: 900,
    minHeight: "500px",
    margin: "40px auto",
    borderRadius: 24,
    backgroundColor: "#faf9f7",
    boxShadow: "0 8px 40px rgba(0,0,0,0.1)",
    fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
    color: "#333",
    overflow: "hidden",
  };

  const leftPanelStyle = {
    flex: "0 0 300px",
    backgroundColor: "white",
    padding: "40px 20px",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    borderRight: "1px solid #eee",
  };

  const userImageContainer = {
    position: "relative",
    width: 140,
    height: 140,
    marginBottom: 20,
    borderRadius: "50%",
    backgroundColor: "#061128", 
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    border: "4px solid #f0f0f0",
    overflow: "hidden",
  };

  const userImageStyle = {
    width: "100%",
    height: "100%",
    objectFit: "cover",
  };

  const rightPanelStyle = {
    flex: 1,
    padding: "50px 60px",
    display: "flex",
    flexDirection: "column",
    justifyContent: "center"
  };

  const infoBoxStyle = {
    width: "100%",
    padding: "18px 0",
    borderRadius: 20,
    backgroundColor: "#f6f6f6",
    fontSize: 18,
    color: "#333",
    textAlign: "center",
    border: "1px solid #efefef",
    fontWeight: "500"
  };

  const labelStyle = {
    display: "block",
    fontSize: 13,
    color: "#aaa",
    marginBottom: 8,
    textAlign: "center",
    textTransform: "uppercase",
  };

  const navLinkStyle = (active = false) => ({
    width: "100%",
    padding: "12px 0",
    borderRadius: 25,
    marginBottom: 10,
    cursor: "pointer",
    color: active ? "white" : "#888",
    backgroundColor: active ? "#061128" : "transparent",
    fontWeight: active ? "600" : "500",
    fontSize: 15,
    textAlign: "center",
  });

  /* ================== State ================== */
  const [user, setUser] = useState({ name: "", email: "" });
  const [imageBlob, setImageBlob] = useState(null); // لتخزين الصورة كبيانات خام

  /* ================== Fetch Data & Image ================== */
  useEffect(() => {
    const fetchData = async () => {
      try {
        const token = localStorage.getItem("token");
        const headers = {
          "Authorization": `Bearer ${token}`,
          "ngrok-skip-browser-warning": "69420",
        };

        // 1. جلب بيانات المستخدم
        const res = await fetch("https://katydid-champion-mutually.ngrok-free.app/api/show-user-info", { headers });
        if (res.ok) {
          const result = await res.json();
          const userData = result.data;
          setUser({ name: userData.name, email: userData.email });

          // 2. جلب الصورة كـ Blob لتخطي حظر المتصفح (Opaque Blocking)
          if (userData.image) {
            const imgRes = await fetch(userData.image, { headers });
            const blob = await imgRes.blob();
            setImageBlob(URL.createObjectURL(blob)); // تحويل البيانات لرابط مؤقت يظهر فوراً
          }
        }
      } catch (error) {
        console.error("Error fetching data or image:", error);
      }
    };

    fetchData();
  }, []);

  return (
    <div style={containerStyle}>
      {/* Left Panel */}
      <div style={leftPanelStyle}>
        <div style={userImageContainer}>
          {imageBlob ? (
            <img src={imageBlob} alt="Profile" style={userImageStyle} />
          ) : (
            <span style={{ fontSize: 60, color: "white" }}>
              {user.name ? user.name.charAt(0).toUpperCase() : "U"}
            </span>
          )}
        </div>

        <h3 style={{ fontSize: 24, marginBottom: 40, fontWeight: "700" }}>{user.name || "Loading..."}</h3>

        <div style={{ width: "100%" }}>
          <div style={navLinkStyle(true)}>Personal Information</div>
          <div style={navLinkStyle(false)} onClick={() => { localStorage.removeItem("token"); window.location.reload(); }}>
            Log Out
          </div>
        </div>
      </div>

      {/* Right Panel */}
      <div style={rightPanelStyle}>
        <h2 style={{ textAlign: "center", fontSize: 32, marginBottom: 50, fontWeight: "800" }}>
          Personal Information
        </h2>

        <div style={{ marginBottom: 35 }}>
          <label style={labelStyle}>User Name</label>
          <div style={infoBoxStyle}>{user.name || "---"}</div>
        </div>

        <div style={{ marginBottom: 35 }}>
          <label style={labelStyle}>Email Address</label>
          <div style={infoBoxStyle}>{user.email || "---"}</div>
        </div>
      </div>
    </div>
  );
}