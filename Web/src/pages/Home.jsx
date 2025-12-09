// src/pages/Home.jsx
import { useState } from "react";
import "../styles/home.css"; // غيّري المسار لو ملف الستايل في مكان تاني
import logo from "../assets/images/logo.png";
import footerImg from "../assets/images/ChatGPT Image Oct 16, 2025, 02_28_06 AM.png";
// optional images referenced by CSS (if موجودة) - غيري الأسماء إذا مختلفة
import heroBg from "../assets/images/1235.jpg";
import { Link } from 'react-router-dom';

function Home() {
  const [navOpen, setNavOpen] = useState(false);

  // لو احتجتي تستخدمي الصورة في style بدل الاعتماد على url داخل الـ CSS
  const heroStyle = {
    backgroundImage: `url(${heroBg})`,
    backgroundRepeat: "no-repeat",
    backgroundSize: "cover",
  };

  return (
    <div className="home-page" dir="ltr">
      {/* HEADER */}
      <header>
        <div className="container-head nav-row">
          <div className="brand" style={{ alignItems: "center" }}>
            <img className="logo-img" src={logo} alt="logo" />
            <h2>Eye Recognition</h2>
          </div>

          <div className={`nav-links ${navOpen ? "active" : ""}`} id="navLinks">
            <Link to="/eye-scan">Recognition</Link> 
            <Link to="/sett">Settings</Link> 
            <a className="nav-btn" href="#">
              Log out
            </a>
          </div>

          <div
            className={`hamburger ${navOpen ? "active" : ""}`}
            id="hamburger"
            role="button"
            aria-label="Toggle menu"
            onClick={() => setNavOpen((s) => !s)}
            tabIndex={0}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") setNavOpen((s) => !s);
            }}
          >
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      </header>

      {/* HERO SECTION */}
      <section className="container hero" style={heroStyle}>
        <div className="hero-inner">
          <div className="hero-text">
            <h1>Eye Recognition : know people by their eye</h1>
            <p>Accuracy 98.5% and capable of identifying people wearing a niqab</p>

            <div className="hero-actions">
              <a className="btn-main" href="#">
                Start
              </a>
              <a className="btn-sec" href="#">
                Learn more
              </a>
            </div>
          </div>
          <div className="hero-img" aria-hidden="true"></div>
        </div>
      </section>

      {/* FEATURES */}
      <div className="container-features">
        <div className="top-row">
          <div className="side-text" style={{ textAlign: "left" }}>
            <h3>How can recognise your eye ?</h3>
            <p>we can recognise your both eye </p>
          </div>

          <div className="side-text" style={{ textAlign: "right" }}>
            <h3>Is this website have high accuracy?</h3>
            <p>yes we have a 98.5% accuracy</p>
          </div>
        </div>

        <div className="features-center">
          <div className="feature">
            <div className="feature-icon">⏰</div>
            <h4 className="feature-title">save your time</h4>
            <p className="feature-desc">
              save your time to searching for an efficient site 
            </p>
          </div>

          <div className="feature">
            <div className="feature-icon">👁️</div>
            <h4 className="feature-title">Eye Recognition</h4>
            <p className="feature-desc">
              we can use both your eye to recognition 
            </p>
          </div>

          <div className="feature">
            <div className="feature-icon">🛡️</div>
            <h4 className="feature-title">High Definition </h4>
            <p className="feature-desc">
              to identify people from their other photos 
            </p>
          </div>
        </div>
      </div>

      {/* MID DARK SECTION */}
      <section className="info-section container" aria-label="معلومات وخطوات IrisPass">
        <div className="steps-container" aria-label="خطوات IrisPass">
          <h2 className="steps-title">How It  Work </h2>

          <div className="steps">
            {/* Step 1 */}
            <div className="step" role="region" aria-labelledby="step1-title">
              <div className="icon-wrap" aria-hidden="true">
                <div className="circle outer"></div>
                <div className="circle middle"></div>
                <div className="circle inner"></div>
                <div className="icon">1</div>
              </div>
              <p id="step1-title" className="step-text">
                send image 
              </p>
              <p className="step-desc">you will upload image or take photo for only your eyes</p>
            </div>

            {/* Step 2 */}
            <div className="step" role="region" aria-labelledby="step2-title">
              <div className="icon-wrap" aria-hidden="true">
                <div className="circle outer"></div>
                <div className="circle middle"></div>
                <div className="circle inner"></div>
                <div className="icon">👁️</div>
              </div>
              <p id="step2-title" className="step-text">
                Eye detection 
              </p>
              <p className="step-desc">I'm goimg to specify the part that will reveal your identity</p>
            </div>

            {/* Step 3 */}
            <div className="step" role="region" aria-labelledby="step3-title">
              <div className="icon-wrap" aria-hidden="true">
                <div className="circle outer"></div>
                <div className="circle middle"></div>
                <div className="circle inner"></div>
                <div className="icon">🔒</div>
              </div>
              <p id="step3-title" className="step-text">Identity confirmation</p>
              <p className="step-desc">Predicting a person's identity </p>
            </div>
          </div>
        </div>

        <div className="info-cards">
          <section className="info-card" aria-labelledby="info1-title">
            <h4 id="info1-title">Accuracy </h4>
            <p>high acceracy 98.5% because we training a lot of data </p>
          </section>

          <section className="info-card" aria-labelledby="info2-title">
            <h4 id="info2-title">Validation </h4>
            <p>we have a high validation and when other pepole use the output will be unknown </p>
            <a href="#" className="btn-secondary">
              Learn more
            </a>
          </section>
        </div>

        <div className="info-image" aria-hidden="true">
          <svg viewBox="0 0 300 200" fill="none" xmlns="http://www.w3.org/2000/svg" style={{ maxWidth: 400, width: "100%", height: "auto" }}>
            <circle cx="150" cy="100" r="100" stroke="#00d8cc" strokeWidth="2" opacity="0.4" />
            <circle cx="150" cy="100" r="70" stroke="#00d8cc" strokeWidth="2" />
            <circle cx="150" cy="100" r="40" stroke="#00d8cc" strokeWidth="2" />
            <circle cx="150" cy="100" r="15" fill="#00d8cc" />
            <line x1="230" y1="70" x2="270" y2="70" stroke="#00d8cc" strokeWidth="3" />
            <rect x="270" y="60" width="25" height="20" stroke="#00d8cc" strokeWidth="2" rx="4" ry="4" />
            <path d="M250 80 L275 80" stroke="#00d8cc" strokeWidth="2" />
            <path d="M275 80 L275 95" stroke="#00d8cc" strokeWidth="2" />
            <path d="M150 100 L200 140" stroke="#00d8cc" strokeWidth="2" />
          </svg>
        </div>
      </section>

      {/* TESTIMONIALS */}
      <section className="container test-section">
        <main className="container" role="main" aria-label="آراء العملاء عن IrisPass">
          <div className="content-wrapper" style={{ maxWidth: 1500 }}>
            {/* left panel */}
            <section className="left-panel">
              <h2>Model building stages</h2>
              <p>
              We  faced many challenges in building a highly efficient model 
              </p>
              <a href="#" className="btn-action" aria-label="تواصل الآن">
                Among these stages 
              </a>
            </section>

            {/* right panel */}
            <section className="right-panel">
              <article className="review-card large" aria-label="تقييم المصمم لمكار تمبكرز">
                <div className="review-icon">🖥️</div>
                <h3 className="review-title">Identifying the features of the idea</h3>
                <p className="review-text">We faced difficulties in identifying the most important features</p>
                <div className="review-info">for two weeks</div>
              </article>

              <article className="review-card" aria-label="تقييم التعلم التعليم">
                <div className="review-icon">🌐</div>
                <h3 className="review-title">Generite Data </h3>
                <p className="review-text">we collect data in different corner and lightinng </p>
                <div className="review-info">for 2 weeks </div>
              </article>

              <article className="review-card" aria-label="تقييم الفريق الداخلي">
                <div className="review-icon">👥</div>
                <h3 className="review-title">Team Cooperation </h3>
                <p className="review-text">Teamwork healped achieve the best results </p>
                <div className="review-info">Throughout the term </div>
              </article>

              <article className="review-card" aria-label="تقييم علم واي إيتان">
                <div className="review-icon">💡</div>
                <h3 className="review-title">Model selection </h3>
                <p className="review-text">we have selected the appropriate model for the project </p>
                <div className="review-info">2 weeks </div>
              </article>

              {/* <article className="review-card" aria-label="تقييم أقفاط العتال ميوبا">
                <div className="review-icon">📞</div>
                <h3 className="review-title"></h3>
                <p className="review-text">تطبيق مبتكر تيومار قمصار أكناخ ايرك</p>
                <div className="review-info">
                  <a href="#" style={{ color: "#10e0d5", textDecoration: "underline" }}>
                    عرض المزيد
                  </a>
                </div>
              </article> */}
            </section>
          </div>
        </main>
      </section>

      {/* FOOTER */}
      <footer>
        <div className="footer-logo" aria-label="شعار irisPass">
          <img src={footerImg} alt="irispass logo" />
          Eye Recognition
        </div>

        <nav className="footer-links" aria-label="روابط الفوتر">
          
          <div className="link-group">
            <span>Login / signup</span>
            <a href="#">craete new account </a>
          </div>
          <div className="link-group">
            <span>Recognition </span>
            <a href="#">to try your eye recognition </a>
          </div>
          <div className="link-group">
            <span>Settings </span>
            <a href="#">to show your data </a>
          </div>
        </nav>

        <div>
          

          <div className="footer-social" role="list" aria-label="روابط التواصل الاجتماعي">
            <a href="#" className="twitter" role="listitem" aria-label="تويتر">
              {/* twitter svg */}
              <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" focusable="false">
                <path d="M23.954 4.569c-.885.389-1.83.654-2.825.775 1.014-.609 1.794-1.574 2.163-2.724-.95.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-2.723 0-4.928 2.206-4.928 4.928 0 .39.045.765.127 1.124C7.728 8.087 4.1 6.128 1.67 3.149c-.427.734-.666 1.584-.666 2.488 0 1.717.874 3.231 2.203 4.121-.81-.026-1.57-.249-2.237-.616v.06c0 2.4 1.707 4.394 3.977 4.84-.417.115-.855.176-1.308.176-.32 0-.632-.032-.935-.09.633 1.974 2.466 3.41 4.642 3.448-1.702 1.333-3.844 2.128-6.168 2.128-.401 0-.797-.023-1.188-.07 2.204 1.414 4.82 2.238 7.638 2.238 9.165 0 14.18-7.59 14.18-14.18 0-.216-.004-.43-.015-.642.975-.704 1.82-1.58 2.49-2.578z" />
              </svg>
            </a>

            <a href="#" className="github" role="listitem" aria-label="جيت هاب">
              {/* github svg */}
              <svg fill="currentColor" viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="18" height="18">
                <path d="M12 2C6.48 2 2 6.48 2 12c0 4.42 2.87 8.17 6.84 9.49.5.1.68-.22.68-.48 0-.24-.01-.87-.01-1.7-2.78.6-3.37-1.34-3.37-1.34-.45-1.16-1.1-1.47-1.1-1.47-.9-.62.07-.61.07-.61 1 .07 1.53 1.03 1.53 1.03.9 1.53 2.36 1.09 2.94.83.09-.65.35-1.09.63-1.34-2.22-.26-4.56-1.11-4.56-4.93 0-1.09.39-1.98 1.03-2.68-.1-.26-.45-1.31.1-2.73 0 0 .84-.27 2.75 1.02A9.563 9.563 0 0112 6.8a9.6 9.6 0 012.5.34c1.91-1.29 2.75-1.02 2.75-1.02.55 1.42.2 2.47.1 2.73.64.7 1.03 1.59 1.03 2.68 0 3.83-2.34 4.67-4.58 4.92.36.31.69.92.69 1.85 0 1.33-.01 2.41-.01 2.74 0 .27.18.59.69.48A10.005 10.005 0 0022 12c0-5.52-4.48-10-10-10z" />
              </svg>
            </a>

            <a href="#" className="twitter" role="listitem" aria-label="تويتر">
              {/* twitter svg copy */}
              <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" focusable="false">
                <path d="M23.954 4.569c-.885.389-1.83.654-2.825.775 1.014-.609 1.794-1.574 2.163-2.724-.95.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-2.723 0-4.928 2.206-4.928 4.928 0 .39.045.765.127 1.124C7.728 8.087 4.1 6.128 1.67 3.149c-.427.734-.666 1.584-.666 2.488 0 1.717.874 3.231 2.203 4.121-.81-.026-1.57-.249-2.237-.616v.06c0 2.4 1.707 4.394 3.977 4.84-.417.115-.855.176-1.308.176-.32 0-.632-.032-.935-.09.633 1.974 2.466 3.41 4.642 3.448-1.702 1.333-3.844 2.128-6.168 2.128-.401 0-.797-.023-1.188-.07 2.204 1.414 4.82 2.238 7.638 2.238 9.165 0 14.18-7.59 14.18-14.18 0-.216-.004-.43-.015-.642.975-.704 1.82-1.58 2.49-2.578z" />
              </svg>
            </a>

            <a href="#" className="instagram" role="listitem" aria-label="انستغرام">
              {/* instagram svg */}
              <svg fill="none" stroke="#6b6b6b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true" focusable="false">
                <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
                <path d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37z" />
                <line x1="17.5" y1="6.5" x2="17.51" y2="6.5" />
              </svg>
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default Home;
