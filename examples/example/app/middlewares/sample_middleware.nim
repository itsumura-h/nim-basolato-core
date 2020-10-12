import ../../../../src/basolato/controller

proc sample*(r:Request, p:Params) =
  echo "sample middleware"
  # raise newException(Exception, "sample middleware")
