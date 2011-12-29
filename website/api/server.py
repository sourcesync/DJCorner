from txjsonrpc.web import jsonrpc
from twisted.web import server
from twisted.internet import reactor
from twisted.web import static

#
# add ogg mime type here...
#
dct = static.File.contentTypes
dct[".ogv"] = "video/ogg"

from twisted.web.static import File
from twisted.web.server import Site
from twisted.web import resource

import bson
import base64
import os
import json
import socket

# Create toplevel web resource...
parent = resource.Resource()

# Create static resources part of site...
staticfiles = File("static")
parent.putChild("static", staticfiles )

class GetHomeDetails( resource.Resource ):

	def render_GET( self, request ):
		hero1 = { 'name': 'Roger Sanchez', \
			  'id':'', \
			  'thumb':'images/rogersanchez-featured.jpg', \
			  'video':'http://www.youtube.com/watch?v=qEYueRVuqmg' }
		heroes = [hero1]
		retv = json.dumps( heroes )
		return retv

# API top level resource...
class API(resource.Resource):

	def getChild(self, path, request):
		if path=="get_home_details":
			return GetHomeDetails()	

a = API()
parent.putChild("api", a)

#reactor.listenTCP(8084, server.Site(Math()))

factory = Site(parent)
reactor.listenTCP(7902, factory )

#
# Use this code to start as main...
#

print "INFO: Starting reactor..."
reactor.run()

