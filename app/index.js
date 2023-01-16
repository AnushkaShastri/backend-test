"use strict";

const express = require("express");

// Constants
const PORT = 8080;
const HOST = "0.0.0.0";

// App
const app = express();
app.get("/api/ping", (req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "*");
  res.send({
    status: 200,
    message: "Ping Successful!!",
  });
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}/api/ping`);
module.exports = app;
