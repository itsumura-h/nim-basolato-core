import asynchttpserver, asyncdispatch, random, json, httpcore
import allographer/query_builder
import ../src/core

import controllers/controller1
import controllers/controller2

var routes = newRoutes()
routes.get("/", controller1.getProc)
routes.get("/2", controller2.getProc2)
routes.post("/", controller1.postProc)

serve(routes)
