import asynchttpserver, json, strutils, re, cgi, tables


proc path*(request:Request):string =
  return request.url.path

proc httpMethod*(request:Request):HttpMethod =
  return request.reqMethod

proc isNumeric(str:string):bool =
  result = true
  for c in str:
    if not c.isDigit:
      return false

proc isMatchUrl*(requestPath, routePath:string):bool =
  var requestPath = requestPath.split("/")[1..^1]
  var routePath = routePath.split("/")[1..^1]
  for i in 0..<routePath.len:
    if not routePath[i].contains("{") and routePath[i] != requestPath[i]:
      return false
    if routePath[i].contains("{"):
      let typ = routePath[i].replace("{", "").replace("}", "").split(":")[1]
      if typ == "str" and requestPath[i].isNumeric:
        return false
      if typ == "int" and not requestPath[i].isNumeric:
        return false
  return true


proc getUrlParams*(requestPath, routePath:string):JsonNode =
  let requestPath = requestPath.split("/")[1..^1]
  let routePath = routePath.split("/")[1..^1]
  var urlParams = newJObject()
  for i in 0..<routePath.len:
    if routePath[i].contains("{"):
      let keyInUrl = routePath[i].replace("{", "").replace("}", "").split(":")
      let key = keyInUrl[0]
      let typ = keyInUrl[1]
      if typ == "int":
        urlParams[key] = %requestPath[i].split(":")[0].parseInt
      elif typ == "str":
        urlParams[key] = %requestPath[i].split(":")[0]
  return urlParams

proc getQueryParams*(request:Request):JsonNode =
  var queryParams = newJObject()
  let query = request.url.query
  for key, val in cgi.decodeData(query):
    queryParams[key] = %val
  return queryParams


type RequestParam* = ref object
  fileName*:string
  value*:string

type RequestParams* = Table[string, RequestParam]

proc getRequestParamsFormData(request:Request):RequestParams =
  type DataType = enum
    Text
    File
  var params: RequestParams
  let body = request.body.split(re"------\S*")[1..^2]
  for row in body:
    let dataType:DataType =
      if row.toLowerAscii.contains( "Content-Type".toLowerAscii ) and
      row.toLowerAscii.contains("filename="):
        File
      else:
        Text
    var row = row
    row.removePrefix
    let columns = row.splitLines()
    let key =
      if dataType == Text:
        columns[0].splitWhitespace()[^1].replace("name=\"").replace("\"")
      else:
        columns[0].split("; ")[1].replace("name=\"").replace("\"")
    let originalFileName =
      if dataType == Text:
        ""
      else:
        columns[0].split("; ")[^1].replace("filename=\"").replace("\"")
    let val =
      if dataType == Text:
        columns[2..^2].join("\n")
      else:
        columns[3..^2].join("\n")
    params[key] = RequestParam(
      filename:originalFileName,
      value:val
    )
  return params

proc getRequestParamsXWwwForm*(request:Request):RequestParams =
  var params: RequestParams
  for row in request.body.split("&"):
    let rowData = row.split("=")
    let key = rowData[0]
    let val = rowData[1]
    params[key] = RequestParam(
      filename: "",
      value: val
    )
  return params

proc getRequestParams*(request:Request):RequestParams =
  if request.headers.hasKey("content-type") and
  request.headers["content-type"].toString.contains("multipart/form-data"):
    result = getRequestParamsFormData(request)
  elif request.headers.hasKey("content-type") and
  request.headers["content-type"].toString.contains("application/x-www-form-urlencoded"):
    result = getRequestParamsXWwwForm(request)


proc `[]`*(params:RequestParams, key:string):RequestParam =
  return tables.`[]`(params, key)


when isMainModule:
  block:
    let requestPath = "/name/john/id/1"
    let routePath = "/name/{name:str}/id/{id:int}"
    let params = getUrlParams(requestPath, routePath)
    echo params
    assert params["name"].getStr == "john"
    assert params["id"].getInt == 1

  block:
    var requestPath = "/name/john/id/1"
    var routePath = "/name/{name:str}/id/{id:int}"
    assert isMatchUrl(requestPath, routePath) == true

    requestPath = "/name"
    routePath = "/{id:int}"
    assert isMatchUrl(requestPath, routePath) == false

    requestPath = "/1"
    routePath = "/{name:str}"
    assert isMatchUrl(requestPath, routePath) == false

    requestPath = "/1"
    routePath = "/{id:int}"
    assert isMatchUrl(requestPath, routePath) == true

    requestPath = "/john"
    routePath = "/{name:str}"
    assert isMatchUrl(requestPath, routePath) == true
