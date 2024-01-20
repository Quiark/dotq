# USAGE:
#  mitmproxy -p 8200 --mode reverse:localhost:3000 -s ~/git/dotq/tools/multihost_proxy.py
#
import json
import random
from mitmproxy import http

from mitmproxy.connection import Server
from mitmproxy.net.server_spec import ServerSpec

API_IP = 'localhost'
API_PORT = 8088

LOSSY = True

def abort_err(flow: http.HTTPFlow) -> None:
    flow.response = http.Response.make(500)

def abort_timeout(flow: http.HTTPFlow) -> None:
    flow.server_connv = Server('http://10.0.0.1:8080')

def request(flow: http.HTTPFlow) -> None:
    r = random.random() if LOSSY else 1.0
    if '/api/' in flow.request.url:
        if r < 0.3:
            abort_err(flow)
        elif r < 0.7:
            abort_timeout(flow)
        else:
            flow.server_connv = Server(f'http://{API_IP}:{API_PORT}')
            flow.request.host = API_IP
            flow.request.port = API_PORT
    else:
        if r < 0.15:
            abort_err(flow)
        elif r < 0.3:
            abort_timeout(flow)

def response(flow: http.HTTPFlow) -> None:
    return
    if '/weborder/order/items' in flow.request.url:
        if r < 0.4:
            flow.response.status_code = 500
    elif '/weborder/order' in flow.request.url:
        if r < 0.3:
            flow.response.set_text(json.dumps('None'))
            flow.response.headers.add('X-Manipulated', 'by multihost_proxy.py')
        elif r < 0.6:
            flow.response.set_text(json.dumps({'IdOnly': 'aaaaaabaabababbb'}))
            flow.response.headers.add('X-Manipulated', 'by multihost_proxy.py')
