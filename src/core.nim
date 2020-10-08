import asynchttpserver, asyncdispatch, macros, strformat, httpcore, json


type Controller* = ref object
type Response* = ref object
  status:HttpCode
  body:string
  header:JsonNode

proc render*(body:string):Response =
  return Response(
    status:Http200,
    body:body,
    header: newJObject()
  )

proc render*(status:HttpCode, body:string):Response =
  return Response(
    status:status,
    body:body,
    header: newJObject()
  )

type Route* = ref object
  reqMethod*: HttpMethod
  path*:string
  action*: proc(request:Request):Future[Response]

type Routes* = ref object
  values*: seq[Route]

proc newRoutes*():Routes =
  return Routes()

proc newRoute(reqMethod:HttpMethod, path:string, action:proc(request:Request):Future[Response]):Route =
  return Route(
    reqMethod:reqMethod,
    path:path,
    action:action
  )

proc add*(this:var Routes, reqMethod:HttpMethod, path:string, action:proc(request:Request):Future[Response]) =
  this.values.add(
    newRoute(reqMethod, path, action)
  )

proc get*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpGet, path, action)

proc post*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpPost, path, action)

proc put*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpPut, path, action)

proc patch*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpPatch, path, action)

proc delete*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpDelete, path, action)

proc head*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpHead, path, action)

proc options*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpOptions, path, action)

proc trace*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpTrace, path, action)

proc connect*(this:var Routes, path:string, action:proc(request:Request):Future[Response]) =
  add(this, HttpConnect, path, action)



proc path*(request:Request):string =
  return request.url.path

proc httpMethod*(request:Request):HttpMethod =
  return request.reqMethod



template serve*(this:var Routes) =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async, gcsafe.} =
    var response = render(Http404, "")
    for route in this.values:
      if route.path == req.path and route.reqMethod == req.httpMethod:
        response = await route.action(req)
        break
    await req.respond(response.status, response.body)
  waitFor server.serve(Port(5000), cb)
