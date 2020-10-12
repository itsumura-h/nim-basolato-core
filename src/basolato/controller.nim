import asyncdispatch, asynchttpserver, os, asyncfile
export asyncdispatch, asynchttpserver

import
  core/base, core/request, core/response, core/route, core/header,
  core/security
export
  base, request, response, route, header, security


proc html*(r_path:string):Future[string] {.async.} =
  ## arg r_path is relative path from /resources/
  let path = getCurrentDir() & "/resources/" & r_path
  let f = openAsync(path, fmRead)
  defer: f.close()
  let data = await f.readAll()
  return $data
