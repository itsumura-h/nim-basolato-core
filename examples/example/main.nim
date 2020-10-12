import asynchttpserver, asyncdispatch, httpcore, re
import ../../src/basolato
# controller
import app/controllers/sample_controller
# middleware
import app/middlewares/sample_middleware

var routes = newRoutes()

routes.middleware("sample/.*", sample_middleware.sample)

routes.get("/", sample_controller.index)
groups "/sample":
  routes.get("/welcome", sample_controller.welcome)
  routes.get("/fib/{num:int}", sample_controller.fib)
  routes.get("/react", sample_controller.react)
  routes.get("/material-ui", sample_controller.materialUi)
  routes.get("/vuetify", sample_controller.vuetify)
  routes.get("/checkLogin", sample_controller.index)
  routes.get("/custom-headers", sample_controller.customHeaders)

  routes.get("/cookie", sample_controller.indexCookie)
  routes.post("/cookie", sample_controller.storeCookie)
  routes.post("/cookie/update", sample_controller.updateCookie)
  routes.post("/cookie/delete", sample_controller.destroyCookie)
  routes.post("/cookie/delete-all", sample_controller.destroyCookies)

  routes.get("/login", sample_controller.indexLogin)
  routes.post("/login", sample_controller.storeLogin)
  routes.post("/logout", sample_controller.destroyLogin)

  routes.get("/dd", sample_controller.presentDd)

serve(routes)
