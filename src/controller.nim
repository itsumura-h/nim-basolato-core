import asyncdispatch, asynchttpserver
export asyncdispatch, asynchttpserver

import core/request, core/base, core/response, core/route, core/header
export request, response, route, header

proc dd*(outputs: varargs[string]) =
  when not defined(release):
    var output:string
    for i, row in outputs:
      if i > 0: output &= "\n\n" else: output &= "\n"
      output.add(row)
    raise newException(DD, output)
