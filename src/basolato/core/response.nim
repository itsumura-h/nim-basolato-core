import httpcore, json
import header

type Response* = ref object
  status*:HttpCode
  body*:string
  headers*:Headers


proc render*(status:HttpCode, body:string):Response =
  var headers = newDefaultHeaders()
  headers.set("Content-Type", "text/html; charset=UTF-8")
  return Response(
    status:status,
    body:body,
    headers: headers
  )

proc render*(status:HttpCode, body:string, headers:var Headers):Response =
  if not headers.hasKey("Content-Type"):
    headers.set("Content-Type", "text/html; charset=UTF-8")
  headers.setDefaultHeaders()
  return Response(
    status:status,
    body:body,
    headers: headers
  )

proc render*(body:string, headers:var Headers):Response =
  if not headers.hasKey("Content-Type"):
    headers.set("Content-Type", "text/html; charset=UTF-8")
  headers.setDefaultHeaders()
  return Response(
    status:Http200,
    body:body,
    headers: headers
  )

proc render*(body:string):Response =
  var headers = newDefaultHeaders()
  headers.set("Content-Type", "text/html; charset=UTF-8")
  return Response(
    status:Http200,
    body:body,
    headers: headers
  )

proc render*(status:HttpCode, body:JsonNode):Response =
  var headers = newDefaultHeaders()
  headers.set("Content-Type", "application/json; charset=utf-8")
  return Response(
    status:status,
    body: $body,
    headers: headers
  )

proc render*(status:HttpCode, body:JsonNode, headers:var Headers):Response =
  if not headers.hasKey("Content-Type"):
    headers.set("Content-Type", "application/json; charset=utf-8")
  headers.setDefaultHeaders()
  return Response(
    status:status,
    body: $body,
    headers: headers
  )

proc render*(body:JsonNode, headers:var Headers):Response =
  if not headers.hasKey("Content-Type"):
    headers.set("Content-Type", "application/json; charset=utf-8")
  headers.setDefaultHeaders()
  return Response(
    status:Http200,
    body: $body,
    headers: headers
  )

proc render*(body:JsonNode):Response =
  var headers = newDefaultHeaders()
  headers.set("Content-Type", "application/json; charset=utf-8")
  return Response(
    status:Http200,
    body: $body,
    headers: headers
  )

proc redirect*(url:string):Response =
  var headers = newDefaultHeaders()
  headers.set("Location", url)
  return Response(
    status:Http303,
    body: "",
    headers: headers
  )

proc errorRedirect*(url:string):Response =
  var headers = newDefaultHeaders()
  headers.set("Location", url)
  return Response(
    status:Http302,
    body: "",
    headers: headers
  )



# ========== Header ====================
proc setHeader*(response:Response, headers:Headers):Response =
  for header in headers:
    var index = 0
    var tmpValue = ""
    for i, row in response.headers:
      if row.key == header.key:
        index = i
        tmpValue = row.val
        break
    if tmpValue.len == 0:
      response.headers.add((header.key, header.val))
    else:
      response.headers[index] = (header.key, tmpValue & ", " & header.val)
  return response