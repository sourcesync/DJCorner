from txjsonrpc.web import jsonrpc
from twisted.web import server
from twisted.internet import reactor
from twisted.web.static import File
from twisted.web.server import Site
from twisted.web import resource

import base64
import os
import json

#
# Generic NotSupported resource...
#
class NotSupportedResource(resource.Resource):

        def render_GET(self, request):
		return NotSupportedResource.get_message()

	@classmethod
	def get_message(cls):
                return '<html><body>NOT SUPPORTED</body></html>'
	
#
# Generic DocResource...
#
class DocResource(resource.Resource):

        def render_GET(self, request):
		return DocResource.get_message()
	
	@classmethod
	def get_message(cls):
                return '<html><body>DOCUMENTATION NODE</body></html>'


if __name__ == "__main__":

	# Test NotSupportedResource...
	print NotSupportedResource.get_message()
	nsr = NotSupportedResource()
	print nsr.render_GET(None)

	# Test DocResource...
	print DocResource.get_message()
	dr = DocResource()
	print dr.render_GET(None)
