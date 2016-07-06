#Exosphere NodeJS Cheatsheet

###Introduction

This is a summary of all the essential elements that go into building NodeJS using the MEAN stack. "MEAN" stands for MongoDB, ExpressJS, AngularJS and NodeJS. We will use this framework when building single page apps backed by Ethereum.

###The App Object

* `app.set(name, value)` = env variables
* `app.get(name)` = get env variables
* `app.engine(ext.callback)` = define a template engine, e.g. Jade
* `app.locals` = send app variables to all rendered templates
* `app.use([path], callback) = assign a middleware to handle HTTP requests over a given path.
* `app.verb(path, [callback], callback) = define middleware functions that correspond to particular HTTP verbs along a path.
* `app.route(path).verb[callback..], callback) = defines middleware functions with multiple HTTP verb inputs
* `app.param([name], callback) = attaches functionality to any path that includes a certain parameter= e.g. "userID".

###The Request Object

* `req.query` = contains parsed query string parameters
* `req.params(name)` = retrieves a value of a requested parameter. Can be a query-string, route or JSON req body
* `req.path, req.host, req.ip` = retrives the current request path, hostname, or ip address
* `req.cookies` used with cookieParser() to tretrives cookies sent by the user agent

###The Response Object

* `res.status(code)` = sets HTTP ressponse status code
* `res.set(field, [value])` = sets response HTTP header
* `res.cookie(name, value, [options])` = sets a response cookie. Defines common cookie configs
* `res.redirects([status], url)` = redirects to given status code
* `res.send([body | status], [body])` = for non-streaming responses, responds with proper cache headers
* `res.json([status | body], [body])` = identical to res.send
* `res.render(view, [locals], callback)` = used to render a view and send back a response

###The MVC Pattern

MVC stands for "Model-View-Controller" and describes the best-practice way of structuring an Express Node app. 
* Models refers to the structure of MongoDB database elements: for example, a "user" would be one relevant database model(containing things like name, email and password which are stored on the database). 
* Views are the pages that people see: for example the home page would be a View, as would a signup form. 
* Controllers are functions which respond to HTTP requests and interact with other elements of the application to serve up their required functionality.

Here's how the folders of an MVC-based app would be structured:
```
**app**
    **controllers**
    **models**
    **views**
    **routes**
**config**
    **env.js**
    **config.js**
    **express.js**
**public**
    **config**
    **controllers**
    **config**
    **img**
package.json
server.js
```
As you can see there are three root level directories, app (which contains all the Model-View-Controller functionality), a config directory and a public directory (which contains a lot of front-end Angular.JS functionality. It's not necessary to know exactly what everything does here, just that it does so.

###Vertical and Horizontal Structure

The MVC pattern can be implemented in a number of ways. The simplest for single-page-applications (such as what we'll be doing in Exosphere) is based on the vertical structure, where the full app can be represented by something that looks like the above. The "horizontal" structure on the other hand implements seperate units of MVC functionality in terms of the single features of the app. However we will be keeping our front-ends very simple so we'll stick with the vertical structure for now.

###Hello World Server

To get started, write a simple server using the Express library. Open a javascript file called "server.js":

```
var express = require('express');
var app = express();

var app.use('/', function(req, res) {
	res.send('Hello World');
});
app.listen(3000);
console.log('Server running at http://localhost:3000/');
module.exports = app; 
``` 
This will display the message "Hello World" in the browser.

###Routes

A route is a string in a url which Node can use to
