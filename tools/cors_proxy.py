# USAGE:
#  mitmproxy -p 8200 --mode reverse:localhost:3000 -s ~/git/dotq/tools/cors_proxy.py
#
from mitmproxy import http

from mitmproxy.connection import Server
from mitmproxy.net.server_spec import ServerSpec

def request(flow: http.HTTPFlow) -> None:
    #flow.request.headers["authorization"] = "Bearer 6a09206f266243ed34c24c0c85e0035d590aea27ce23491b5c59dd09b5537368"
    pass


def response(flow: http.HTTPFlow) -> None:
    flow.response.headers['Access-Control-Allow-Origin'] = '*'
    flow.request.headers['Access-Control-Allow-Credentials'] = 'true'

