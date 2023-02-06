import axios from "axios";
import React, { useState } from "react";
import Hero from "./assets/Hero.png";
import './styles/index.css'

import { environment } from "./environments/environment";
function App() {
  
  const [isPing, setisPing] = useState(false);
  const [isResponse, setisResponse] = useState(false);
  const [apiResponse, setapiResponse] = useState({});
  const ping = () => {
    return axios.get(environment.PING_API).then((response) => {
      console.log(response.data);
      var res = JSON.stringify(response.data);

      console.log(res);
      setapiResponse(res);
      setisResponse(true);
      setisPing(false);
    });
  };
 
  return (
    <div className="main-div">
      <div className="img-div">
        <img
          src={Hero}
          alt="logo"
          className="custom-logo"
        />
      </div>
      <div>
        <div className="about-outer-div">
          <div className="about-inner-div">
            <p className="custom-p-about">
              About
            </p>
          </div>
        </div>
        <div>
          <ul className="main-ul-div">
            <li className="custom-li-margin">
              <a
                className="custom-li-link"
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/1_KloudJet_Overview.pdf"
                rel="noreferrer"
              >
                Kloudjet Overview
              </a>
            </li>
            <li className="custom-li-margin">
              <a
                className="custom-li-link"
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/5_KloudJet_BuildingBlocks_DesignPortal.pdf"
                rel="noreferrer"
              >
                Design Portal
              </a>
            </li>
            <li className="custom-li-margin">
              <a
                className="custom-li-link"
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/3_KloudJet_BuildingBlocks_Template_Example.pdf"
                rel="noreferrer"
              >
                Template Example
              </a>
            </li>
          </ul>
        </div>
        <div className="header-div ">
          <pre className="custom-header-text">
            Congratulations,
          </pre>
          <pre className="custom-header-text">
            Your project is deployed successfully!!!!
          </pre>
          <div className="ping-div">
            <button
              className="custom-button"
              type="submit"
              onClick={(e) => {
                e.preventDefault();
                ping();
              }}
            >
              Ping
              <span
                className="spinner-grow spinner-grow-sm"
                role="status"
                aria-hidden="true" 
              ></span>
            </button>
          </div>
          <div className="terminal-main-div">
            <div
              className="coding inverse-toggle px-5 pt-4 shadow-lg text-gray-100 text-sm font-mono subpixel-antialiased 
                bg-gray-800  pb-6 rounded-lg leading-normal overflow-hidden"
            >
              <div className="top mb-2 flex">
                <div className="h-3 w-3 bg-red-500 rounded-full"></div>
                <div className="ml-2 h-3 w-3 bg-orange-300 rounded-full"></div>
                <div className="ml-2 h-3 w-3 bg-green-500 rounded-full"></div>
              </div>
              <div className="custom-terminal-msg-div">
                <span className="custom-terminal-role">computer:~$</span>

                {isResponse ? (
                  <pre>{apiResponse}</pre>
                ) : (
                  <pre ng-bind-html="apiResponse.html"> Welcome </pre>
                 )}
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        className="footer-div"
      >
        &copy;2021 Impetus Technologies, Inc. All Rights Reserved
      </div>
    </div>
  );
}

export default App;
