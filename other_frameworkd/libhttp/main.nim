import asyncdispatch, random, json
import httpserver
import allographer/query_builder
# const
randomize()
const range1_10000 = 1..10000


proc cb(req: Request, res: Response) {.async, gcsafe.} =
  let i = rand(range1_10000)
  let response = await rdb().table("world").asyncFind(i)
  await res
    .status(Http200)
    .header("Content-type", "text/plain; charset=utf-8")
    .send($response)

proc main =
  var server = createServer(maxHandlers=100000, port=5000)
  waitFor server.serve(cb)
  runForever()

main()
