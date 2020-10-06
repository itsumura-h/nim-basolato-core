import jester, random, json, asyncdispatch
import allographer/query_builder
# const
randomize()
const range1_10000 = 1..10000

proc controller():Future[JsonNode] {.async.} =
  let i = rand(range1_10000)
  let response = await rdb().table("world").asyncFind(i)
  return response

routes:
  get "/":
    resp await controller()
