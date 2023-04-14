import axios from "axios";
import Head from "next/head";
import Image from "next/image";

import { useState } from "react";

function Home() {
  const [isPing, setisPing] = useState(false);
  const [isResponse, setisResponse] = useState(false);
  const [apiResponse, setapiResponse] = useState({});
  const ping = () => {
    return axios.get(process.env.PING_API).then((response) => {
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
      <div className="image-div">
        <img
          src="/Hero.png"
          alt="logo"
          className="logo"
        />
      </div>
      <div>
        <div className="content-div">
          <div className="w-full bg-gray-400 h-8">
            <p className="text-base text-center font-medium text-gray-900">
              About
            </p>
          </div>
        </div>
        <div>
          <ul className="links">
            <li className="mr-6">
              <a
                className="text-blue-500 hover:text-blue-800"
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/1_KloudJet_Overview.pdf"
                rel="noreferrer"
              >
                Kloudjet Overview
              </a>
            </li>
            <li className="mr-6">
              <a
                className="text-blue-500 hover:text-blue-800" 
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/5_KloudJet_BuildingBlocks_DesignPortal.pdf"
              >
                Design Portal
              </a>
            </li>
            <li className="mr-6">
              <a
                className="text-blue-500 hover:text-blue-800"
                target="_blank"
                href="https://ee-designportal.s3.amazonaws.com/assets/pdfs/3_KloudJet_BuildingBlocks_Template_Example.pdf"
              >
                Template Example
              </a>
            </li>
          </ul>
        </div>
        <div className="w-full mt-10 ">
          <pre className="message">
            Congratulations,
          </pre>
          <pre className="message">
            Your project is deployed successfully!!!!
          </pre>
          <div className="div-button">
            <button
              className="app-btn"
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
          <div className="div-terminal">
            <div
              className="coding inverse-toggle terminal"
            >
              <div className=" top t-header-div">
                <div className=" bg-red-500 terminal-header"></div>
                <div className="ml-2  bg-yellow-500 terminal-header"></div>
                <div className="ml-2 bg-green-500 terminal-header"></div>
              </div>
              <div className="mt-4 flex">
                <span className="text-green-400">computer:~$</span>

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
        className="footer"
      >
        &copy;2021 Impetus Technologies, Inc. All Rights Reserved
      </div>
    </div>
  );
}

export default Home;
