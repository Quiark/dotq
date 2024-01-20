# USAGE:
#  mitmproxy -p 8200 --mode reverse:localhost:3000 -s ~/git/dotq/tools/cors_proxy.py
#
from mitmproxy import http

from mitmproxy.connection import Server
from mitmproxy.net.server_spec import ServerSpec

def request(flow: http.HTTPFlow) -> None:
    #flow.request.headers["authorization"] = "Bearer 6ea78cc691d0757e3fda925dd4d0dcb64b8e49a17e7bef7ee6fee4b4ba347174"
    pass


def response(flow: http.HTTPFlow) -> None:
    flow.response.headers['Access-Control-Allow-Origin'] = '*'
    flow.response.headers['Access-Control-Allow-Headers'] = '*'
    flow.request.headers['Access-Control-Allow-Credentials'] = 'true'
    flow.response.status_code = 200

