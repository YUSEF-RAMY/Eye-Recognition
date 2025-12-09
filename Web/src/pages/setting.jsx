import React, { useState } from "react";

export default function Settings() {
  const containerStyle = {
    display: "flex",
    maxWidth: 900,
    margin: "40px auto",
    borderRadius: 24,
    backgroundColor: "#faf9f7",
    boxShadow: "0 8px 40px rgba(0,0,0,0.1)",
    fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
    color: "#333",
    overflow: "hidden",
  };

  const leftPanelStyle = {
    flex: "0 0 280px",
    backgroundColor: "white",
    padding: "30px",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    gap: 20,
    borderRight: "1px solid #ddd",
  };

  const userImageStyle = {
    width: 130,
    height: 130,
    borderRadius: "50%",
    objectFit: "cover",
    boxShadow: "0 6px 18px rgba(0,0,0,0.2)",
    position: "relative",
  };

  const editIconStyle = {
    position: "absolute",
    bottom: 12,
    right: 12,
    backgroundColor: "#061128",
    borderRadius: "50%",
    width: 30,
    height: 30,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    color: "white",
    fontWeight: "bold",
    fontSize: 18,
    cursor: "pointer",
  };

  const userNameStyle = {
    fontSize: 22,
    fontWeight: "700",
    marginTop: 15,
    textAlign: "center",
  };

  const userRoleStyle = {
    fontWeight: "500",
    color: "gray",
    fontSize: 15,
    marginBottom: 30,
  };

  const navLinkStyle = (active = false) => ({
    width: "100%",
    display: "flex",
    alignItems: "center",
    gap: 10,
    padding: "10px 18px",
    borderRadius: 20,
    marginBottom: 15,
    cursor: "pointer",
    color: active ? "white" : "#777",
    backgroundColor: active ? "#061128" : "transparent",
    fontWeight: active ? "600" : "normal",
    fontSize: 15,
    userSelect: "none",
  });

  const rightPanelStyle = {
    flex: "1 1 auto",
    padding: "40px 50px",
  };

  const sectionTitleStyle = {
    fontSize: 18,
    fontWeight: "700",
    marginBottom: 20,
  };

  const inputGroupRowStyle = {
    display: "flex",
    gap: 20,
    marginBottom: 20,
  };

  const inputWrapperStyle = {
    flex: 1,
    display: "flex",
    flexDirection: "column",
  };

  const labelStyle = {
    fontSize: 12,
    color: "#999",
    marginBottom: 6,
  };

  const inputStyle = {
    padding: "12px 16px",
    borderRadius: 20,
    border: "1px solid #e6e6e6",
    backgroundColor: "#f6f6f6",
    fontSize: 15,
    outline: "none",
    transition: "border 0.3s",
  };

  const verifiedBadgeStyle = {
    marginLeft: 10,
    color: "#44bb44",
    fontWeight: "700",
    fontSize: 13,
  };

  const changePassButtonStyle = {
    marginTop: 30,
    alignSelf: "flex-start",
    padding: "12px 28px",
    borderRadius: 20,
    border: "none",
    fontSize: 16,
    fontWeight: "700",
    cursor: "pointer",
    color: "white",
    background:
      "linear-gradient(135deg, #061128 0%, #0b1c41ff 100%)",
    boxShadow: "0 6px 20px rgba(84, 118, 232, 0.7)",
    transition: "background 0.3s ease",
  };

  // Simulate fetching user data from API
  const [user, setUser] = useState({
    image:
      "https://randomuser.me/api/portraits/men/75.jpg", 
    firstName: "Roland",
    lastName: "Donald",
    email: "rolandDonald@mail.com",
    address: "3605 Parker Rd.",
    phone: "(405) 555-0128",
    dob: "1995-02-01",
    location: "Atlanta, USA",
    postalCode: "30301",
    gender: "Male",
  });

  const [editableUser, setEditableUser] = useState(user);

  // Handle form changes
  const handleChange = (key, val) => {
    setEditableUser((prev) => ({
      ...prev,
      [key]: val,
    }));
  };

  return (
    <div style={containerStyle}>
      {/* Left Panel */}
      <div style={leftPanelStyle}>
        <div style={{ position: "relative" }}>
          <img src={user.image} alt="User Avatar" style={userImageStyle} />
          <div style={editIconStyle} title="Edit Image">
            ✎
          </div>
        </div>
        <div style={userNameStyle}>
          {user.firstName} {user.lastName}
        </div>
        

        <div style={navLinkStyle(true)}>Personal Information</div>
        
        <div style={navLinkStyle(false)}>Log Out</div>
      </div>

      {/* Right Panel */}
      <div style={rightPanelStyle}>
        <h2 style={sectionTitleStyle}>Personal Information</h2>

        {/* Gender radio buttons */}
        

        {/* Name Inputs */}
        <div style={inputGroupRowStyle}>
          <div style={inputWrapperStyle}>
            <label style={labelStyle} htmlFor="firstName">User Name</label>
            <input
              id="firstName"
              style={inputStyle}
              value={editableUser.firstName}
              onChange={(e) => handleChange("firstName", e.target.value)}
              placeholder="First Name"
            />
          </div>
          
        </div>

        {/* Email */}
        <div style={inputWrapperStyle}>
          <label style={labelStyle} htmlFor="email">Email</label>
          <input
            id="email"
            style={inputStyle}
            value={editableUser.email}
            onChange={(e) => handleChange("email", e.target.value)}
            placeholder="Email"
          />
          <span style={verifiedBadgeStyle}>&#10003; Verified</span>
        </div>

        

        {/* Change Password Button */}
        <button
          style={changePassButtonStyle}
          onClick={() => alert("Change Password clicked")}
        >
          Change Password
        </button>
      </div>
    </div>
  );
}
