var http = require('http');
var express = require("express");
var RED = require("node-red");
var bodyParser = require('body-parser');
var oauthserver = require('oauth2-server');
var model = require('./memory.js');

// Create an Express app
var app = express();

app.use("/oauth/token", bodyParser.urlencoded({ extended: true }));
app.use("/oauth/token", bodyParser.json());

app.oauth = oauthserver({
  model: model, // See below for specification
  grants: ['password','refresh_token'],
  debug: true
});

app.all('/oauth/token', app.oauth.grant());


// Add a simple route for static content served from 'public'
app.use("/",express.static("public"));

// Create a server
var server = http.createServer(app);

// Create the settings object - see default settings.js file for other options
var settings = {
    httpAdminRoot:"/red",
    httpNodeRoot: "/api",
    userDir:"/home/pm2user/.nodered/",
    adminAuth: {
        type: "credentials",
        users: [{
            username: "admin",
            password: "$2a$08$zZWtXTja0fB1pzD4sHCMyOCMYz2Z6dNbM6tl8sJogENOMcxWV9DN.",
            permissions: "*"
        }]
    },
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    },
    functionGlobalContext: { }    // enables global context
};

// Initialise the runtime with a server and settings
RED.init(server,settings);

// Serve the editor UI from /red
app.use(settings.httpAdminRoot,RED.httpAdmin);

// Serve the http nodes UI from /api
app.use(settings.httpNodeRoot,app.oauth.authorise(), RED.httpNode);

app.use(settings.httpNodeRoot,app.oauth.errorHandler());

server.listen(8000);

// Start the runtime
RED.start();