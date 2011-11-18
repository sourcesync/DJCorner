#
# Configuration...
#

#
# Code...
#
from txjsonrpc.web import jsonrpc
from twisted.web import server
from twisted.internet import reactor
from twisted.web.static import File
from twisted.web.server import Site
from twisted.web import resource

import base64
import os
import json

import common
import restify

#
# API resource...
#
class rAPI(resource.Resource):

	# Show api doc node...
	def render_GET(self, request):
		return '<html><body>DOCUMENTATION NODE</body></html>'
        
	# Func to capture trailing /
	def getChild(self, path, request):
		return common.NotSupported()

