import asyncdispatch, random, json, locks
from osproc import countProcessors
import httpserver
import allographer/query_builder
# const
randomize()
const range1_10000 = 1..10000

proc cb(req: Request, res: Response) {.async, gcsafe.} =
  echo "=== start cd"
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

  await res
    .status(Http200)
    .header("Content-type", "application/json; charset=utf-8")
    .send($response)
  echo "=== end cd"

proc serveCore(lock:Lock) =
  let server = createServer(port=5000)
  waitFor server.serve(cb)
  runForever()

proc serve() =
  let numThreads =
    when compileOption("threads"):
      countProcessors()
    else:
      1
  echo numThreads
  when compileOption("threads"):
    var
      threads = newSeq[Thread[void]](numThreads)
      lock: Lock
    for i in 0 ..< numThreads:
      createThread(
        threads[i], serveCore
      )
      joinThreads(threads)
  else:
    serveCore()

serve()
