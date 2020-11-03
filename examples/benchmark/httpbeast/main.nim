import options, asyncdispatch, random, json, strutils, times

import httpbeast
import allographer/query_builder
randomize()
const range1_10000 = 1..10000

proc plaintextController:Future[string] {.async.} =
  return "Hello World"

proc updateController:Future[string] {.async.} =
  let start = cpuTime()
  echo start
  echo "===update1 " & $(cpuTime() - start)
  let countNum = 500
  var response = newSeq[JsonNode](countNum)
  var getFutures = newSeq[Future[Row]](countNum)
  var updateFutures = newSeq[Future[void]](countNum)
  echo "===update2 " & $(cpuTime() - start)
  for i in 1..countNum:
    let index = rand(range1_10000)
    let number = rand(range1_10000)
    getFutures[i-1] = rdb().table("World").select("id", "randomNumber").asyncFindPlain(index)
    updateFutures[i-1] = rdb()
                        .table("World")
                        .where("id", "=", index)
                        .asyncUpdate(%*{"randomNumber": number})
    response[i-1] = %*{"id":index, "randomNumber": number}

  echo "===update3 " & $(cpuTime() - start)
  try:
    discard await all(getFutures)
    await all(updateFutures)
  except:
    discard
  echo "===update4 " & $(cpuTime() - start)
  return $response

proc onRequest(req: Request): Future[void] {.async, gcsafe.} =
  if req.httpMethod == some(HttpGet):
    case req.path.get()
    of "/plaintext":
      req.send( await plaintextController() )
    of "/update":
      req.send( await updateController() )
    else:
      req.send(Http404)

let settings = initSettings(Port(5000))
run(onRequest, settings)
