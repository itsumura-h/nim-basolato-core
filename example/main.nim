import asynchttpserver, asyncdispatch, random, json, httpcore
import allographer/query_builder
import ../src/core


proc controller():Response =
  construct()
  echo "=== controller"
  return Response()

var routes = newRoutes()
echo routes.repr

routes.add("get", "/", controller)
echo routes.repr

for route in routes.values:
  discard route.action()
