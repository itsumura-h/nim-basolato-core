import asynchttpserver, asyncdispatch, httpcore
import ../../src/basolato

import app/controllers/controller2
import app/controllers/controller1
import app/controllers/benchmark_controller
import app/controllers/validation_controller

var routes = newRoutes()
routes.get("/", controller1.getString)
routes.post("/", controller1.postString)
routes.get("/json", controller1.getJson)
routes.get("/dd", controller1.dd)
routes.get("/redirect", controller1.redirect)
routes.get("/db", benchmarkController.db)
routes.get("/{id:int}", controller2.getString)

routes.post("/validation/store", validation_controller.store)

serve(routes)
