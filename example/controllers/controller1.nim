import json
import ../../src/controller


proc construct() =
  discard

proc getString*(request:Request, params:Params):Future[Response] {.async.} =
  construct()
  return render("=== getProc")

proc getJson*(request:Request, params:Params):Future[Response] {.async.} =
  construct()
  let response = %*{"key":"val"}
  let headers = (%*{"key1": "val1", "key2": 2}).toHeaders()
  return render(response).setHeader(headers)

proc dd*(request:Request, params:Params):Future[Response] {.async.} =
  construct()
  let present = %*{"key1": "val1", "key2": "val2"}
  dd($present)
  return render("===")

proc redirect*(request:Request, params:Params):Future[Response] {.async.} =
  construct()
  return redirect("https://google.com")

proc postString*(request:Request, params:Params):Future[Response] {.async.} =
  construct()
  echo params.requestParams.repr
  let response = %*{
    "filename": params.requestParams["postFile"].filename,
    "value": params.requestParams["postFile"].value
  }
  return render(response)
