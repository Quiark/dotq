# USAGE:
#  mitmproxy -p 8200 --mode reverse:localhost:3000 -s ~/git/dotq/tools/multihost_proxy.py
#
from mitmproxy import http

from mitmproxy.connection import Server
from mitmproxy.net.server_spec import ServerSpec

API_IP = '3.38.125.145'

def request(flow: http.HTTPFlow) -> None:
    if '/api/' in flow.request.url:
        flow.server_connv = Server(f'http://{API_IP}:8080')
        flow.request.host = API_IP
        flow.request.port = 8080
