import ../../../../src/basolato/middleware

proc authCheck*(r:Request, p:Params) =
  checkCsrfToken(r, p).catch(Error403)
  checkAuthToken(r).catch(Error403)
