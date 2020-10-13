# framework
import basolato
# controller
import app/controllers/welcome_controller
# middleware

var routes = newRoutes()
routes.get("/", welcome_controller.index)

serve(routes)
