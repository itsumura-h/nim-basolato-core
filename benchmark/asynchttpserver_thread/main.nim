import random, json
import asynchttpserver, asyncdispatch, osproc
import allographer/query_builder
randomize()
const range1_10000 = 1..10000

proc serveCore() {.thread.} =
  var server = newAsyncHttpServer(true, true)
  proc cb(req: Request) {.async, gcsafe.} =
    echo "=== cd start"
    let countNum = 500
    var response = newSeq[JsonNode](countNum)
    var getFutures = newSeq[Future[Row]](countNum)
    var updateFutures = newSeq[Future[void]](countNum)
    for i in 1..countNum:
      let index = rand(range1_10000)
      let number = rand(range1_10000)
      getFutures[i-1] = rdb().table("World").select("id", "randomNumber").asyncFindPlain(index)
      updateFutures[i-1] = rdb()
                          .table("World")
                          .where("id", "=", index)
                          .asyncUpdate(%*{"randomNumber": number})
      response[i-1] = %*{"id":index, "randomNumber": number}

    try:
      discard await all(getFutures)
      await all(updateFutures)
    except:
      discard
    let header = newHttpHeaders()
    header.add("Content-type", "application/json; charset=utf-8")
    await req.respond(Http200, $response, header)
    echo "=== cd end"

  waitFor server.serve(Port(5000), cb)

proc serve() =
  let numThreads =
    when compileOption("threads"):
      countProcessors()
    else:
      1
  echo numThreads
  when compileOption("threads"):
    var threads = newSeq[Thread[void]](numThreads)
    for i in 0 ..< numThreads:
      createThread(
        threads[i], serveCore
      )
    joinThreads(threads)
  else:
    serveCore()

serve()