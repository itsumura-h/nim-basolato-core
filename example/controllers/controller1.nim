import asyncdispatch, asynchttpserver
import ../../src/core

proc construct() =
  echo "controller 1"

proc getProc*(request:Request):Future[Response] {.async.} =
  construct()
  echo "=== getProc"
  echo request.path()
  return render("=== getProc")

proc postProc*(request:Request):Future[Response] {.async.} =
  construct()
  echo "=== postProc"
  return render("=== postProc")
