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
# Resource associated with "session" uri...
#
class rsession( resource.Resource ):

        #def render_GET(self, request):
	#print "INFO: rsession: GET"
	#return common.NotSupportedResource.get_message()

	# login...
        def render_POST(self, request):
		#print dir(request), request.content, dir(request.content)
		#print request.content.read()
		#print dir(request.responseHeaders)
		#request.responseHeaders['sessionid'] = 'stuff'
		#print request.responseHeaders
		request.responseHeaders.addRawHeader("sessionid","stuff")
		print request.responseHeaders
                return '<html><body>LOGIN OK</body></html>'

#
# Main session object...
#
class session( restify.Restify ):
	def  __init__(self):
		self.email = ""
		self.password = ""

