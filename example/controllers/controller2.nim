import asyncdispatch, asynchttpserver
import ../../src/core

proc construct() =
  echo "controller 2"

proc getProc2*(request:Request):Future[Response] {.async.} =
  construct()
  echo "=== getProc2"
  return render("=== getProc2")
