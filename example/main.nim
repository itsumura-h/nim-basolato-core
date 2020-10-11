import asynchttpserver, asyncdispatch, httpcore
import ../src/basolato

import controllers/controller1
import controllers/controller2
import controllers/benchmarkController

var routes = newRoutes()
routes.get("/", controller1.getString)
routes.post("/", controller1.postString)
routes.get("/json", controller1.getJson)
routes.get("/dd", controller1.dd)
routes.get("/redirect", controller1.redirect)
routes.get("/db", benchmarkController.db)
routes.get("/{id:int}", controller2.getString)

serve(routes)
