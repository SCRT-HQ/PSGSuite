function Get-HTTPStatus{
Param
(
  [parameter(Mandatory=$true)]
  [int]
  $Code
)
$CodeHash=@{
    100="100 - Continue"
    101="101 - Switching Protocols"
    200="200 - OK"
    201="201 - Created"
    202="202 - Accepted"
    203="203 - Non-Authoritative Information"
    204="204 - No Content"
    205="205 - Reset Content"
    206="206 - Partial Content"
    207="207 - Multi-Status"
    300="300 - Multiple Choices"
    301="301 - Moved Permanently"
    302="302 - Found"
    303="303 - See Other"
    304="304 - Not Modified"
    305="305 - Use Proxy"
    306="306 - (Reserved)"
    307="307 - Temporary Redirect"
    400="400 - Bad Request"
    401="401 - Unauthorized"
    402="402 - Payment Required"
    403="403 - Forbidden"
    404="404 - Not Found"
    405="405 - Method Not Allowed"
    406="406 - Not Acceptable"
    407="407 - Proxy Authentication"
    408="408 - Request Timeout"
    409="409 - Conflict"
    410="410 - Gone"
    411="411 - Length Required"
    412="412 - Precondition Failed"
    413="413 - Request Entity Too Large"
    414="414 - Request-URI Too Long"
    415="415 - Unsupported Media Type"
    416="416 - Requested Range Not Satisfiable"
    417="417 - Expectation Failed"
    422="422 - Unprocessable Entity"
    423="423 - Locked"
    424="424 - Failed Dependency"
    500="500 - Internal Server Error"
    501="501 - Not Implemented"
    502="502 - Bad Gateway"
    503="503 - Service Unavailable"
    504="504 - Gateway Timeout"
    505="505 - HTTP Version Not Supported"
    507="507 - Insufficient Storage"
    }
return $CodeHash.Item($Code)
}