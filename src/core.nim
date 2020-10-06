import asynchttpserver, asyncdispatch, macros, strformat, httpcore


type
  Controller* = ref object
  Response* = ref object

proc construct*() =
  echo "=== controller contruct"



type Route* = ref object
  reqMethod: HttpMethod
  path:string
  action*: proc():Response

proc newRoute*(reqMethod:HttpMethod, path:string, action:proc():Response):Route =
  return Route(
    reqMethod:reqMethod,
    path:path,
    action:action
  )


type Routes* = ref object
  values*: seq[Route]

proc newRoutes*():Routes =
  return Routes()

proc add*(this:var Routes, reqMethod:string, path:string, action:proc (): Response) =
  let m =
    case reqMethod
    of "get":
      HttpGet
    of "post":
      HttpPost
    else:
      HttpGet
  this.values.add(
    newRoute(m, path, action)
  )



proc path*(request:Request):string =
  return request.url.path

proc httpMethod*(request:Request):HttpMethod =
  return request.reqMethod