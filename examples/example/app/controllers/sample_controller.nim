import json, times, strformat, strutils
# framework
import ../../../../src/basolato/controller
import ../../../../src/basolato/core/base
import allographer/query_builder
# view
import ../../resources/pages/welcome_view
import ../../resources/pages/sample/react
import ../../resources/pages/sample/material_ui
import ../../resources/pages/sample/vuetify
import ../../resources/pages/sample/cookie
import ../../resources/pages/sample/login


proc index*(request:Request, params:Params):Future[Response] {.async.} =
  return render(await html("pages/sample/index.html"))


proc welcome*(request:Request, params:Params):Future[Response] {.async.} =
  let name = "Basolato " & basolatoVersion
  return render(welcomeView(name))


proc fib_logic(n: int): int =
  if n < 2:
    return n
  return fib_logic(n - 2) + fib_logic(n - 1)

proc fib*(request:Request, params:Params):Future[Response] {.async.} =
  let num = params.urlParams["num"].getInt
  var results: seq[int]
  let start_time = getTime()
  for i in 0..<num:
    results.add(fib_logic(i))
  let end_time = getTime() - start_time # Duration type
  var data = %*{
    "version": "Nim " & NimVersion,
    "time": &"{end_time.inSeconds}.{end_time.inMicroseconds}",
    "fib": results
  }
  return render(data)


proc react*(request:Request, params:Params):Future[Response] {.async.} =
  let users = %*RDB().table("users")
              .select("users.id", "users.name", "users.email", "auth.auth")
              .join("auth", "auth.id", "=", "users.auth_id")
              .get()
  # dd($users)
  return render(reactHtml($users))

proc materialUi*(request:Request, params:Params):Future[Response] {.async.} =
  let users = %*RDB().table("users")
              .select("users.id", "users.name", "users.email", "auth.auth")
              .join("auth", "auth.id", "=", "users.auth_id")
              .get()
  return render(materialUiHtml($users))


proc vuetify*(request:Request, params:Params):Future[Response] {.async.} =
  let users = %*RDB().table("users")
              .select("users.id", "users.name", "users.email", "auth.auth")
              .join("auth", "auth.id", "=", "users.auth_id")
              .get()
  let header = %*[
    {"text": "id", "value": "id"},
    {"text": "name", "value": "name"},
    {"text": "email", "value": "email"},
    {"text": "auth", "value": "auth"},
    {"text": "created_at", "value": "created_at"},
    {"text": "updated_at", "value": "updated_at"}
  ]
  return render(vuetifyHtml($header, $users))


proc customHeaders*(request:Request, params:Params):Future[Response] {.async.} =
  var header = newHeaders()
  header.set("Controller-Header-Key1", "Controller-Header-Val1")
  header.set("Controller-Header-Key1", "Controller-Header-Val2")
  header.set("Controller-Header-Key2", ["val1", "val2", "val3"])
  header.set("setHeaderTest", "aaaa")
  return render("with header").setHeader(header)

# ========== Cookie ====================
proc indexCookie*(request:Request, params:Params):Future[Response] {.async.} =
  let auth = newAuth(request)
  return render(cookieHtml(auth))

proc storeCookie*(request:Request, params:Params):Future[Response] {.async.} =
  let auth = newAuth(request)
  let key = params.requestParams.get("key")
  let value = params.requestParams.get("value")
  var cookie = newCookie(request)
  cookie.set(key, value)
  return render(cookieHtml(auth)).setCookie(cookie)

proc updateCookie*(request:Request, params:Params):Future[Response] {.async.} =
  let key = params.requestParams.get("key")
  let days = params.requestParams.get("days").parseInt
  var cookie = newCookie(request)
  cookie.updateExpire(key, days, Days)
  return redirect("/sample/cookie").setCookie(cookie)

proc destroyCookie*(request:Request, params:Params):Future[Response] {.async.} =
  let key = params.requestParams.get("key")
  var cookie = newCookie(request)
  cookie.delete(key)
  return redirect("/sample/cookie").setCookie(cookie)

proc destroyCookies*(request:Request, params:Params):Future[Response] {.async.} =
  # TODO: not work until https://github.com/dom96/jester/pull/237 is mearged and release
  var cookie = newCookie(request)
  cookie.destroy()
  return redirect("/sample/cookie").setCookie(cookie)

# ========== Login ====================
proc indexLogin*(request:Request, params:Params):Future[Response] {.async.} =
  let auth = newAuth(request)
  return render(loginHtml(auth))

proc storeLogin*(request:Request, params:Params):Future[Response] {.async.} =
  let name = params.requestParams.get("name")
  let password = params.requestParams.get("password")
  # auth
  let auth = newAuth()
  auth.login()
  auth.set("name", name)
  return redirect("/sample/login").setAuth(auth)

proc destroyLogin*(request:Request, params:Params):Future[Response] {.async.} =
  let auth = newAuth(request)
  return redirect("/sample/login").destroyAuth(auth)

proc presentDd*(request:Request, params:Params):Future[Response] {.async.} =
  var a = %*{
    "key1": "value1",
    "key2": "value2",
    "key3": "value3",
    "key4": "value4",
  }
  dd(
    $a,
    "abc",
    # this.request.repr,
  )
  return render("dd")
