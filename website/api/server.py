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

class GetTest( resource.Resource ):

	def render_GET( self, request ):
		return "This is a test"

class GetHomeDetails( resource.Resource ):

	def render_GET( self, request ):
		sanchez1 = { 'name': 'Roger Sanchez', \
			  'id':'', \
			  'thumb':'images/rogersanchez-featured.jpg', \
			  'video':'http://www.youtube.com/watch?v=qEYueRVuqmg' }
		sanchez2 = { 'name': 'Roger Sanchez', \
			  'id':'', \
			  'thumb':'images/rogersanchez2.jpg', \
			  'video':'http://www.youtube.com/watch?v=k9Xtvj_JVSM' }
		sanchez3 = { 'name': 'Roger Sanchez', \
			  'id':'', \
			  'thumb':'images/rogersanchez-featured.jpg', \
			  'video':'http://www.youtube.com/watch?v=5kiQSAu-100' }
		tenaglia1 = { 'name': 'Danny Tenglia', \
			  'id':'', \
			  'thumb':'images/tenaglia-1.jpg', \
			  'video':'http://www.youtube.com/watch?v=3c_kdNMRMDY' }
		tenaglia2 = { 'name': 'Danny Tenglia', \
			  'id':'', \
			  'thumb':'images/dan5.jpg', \
			  'video':'http://www.youtube.com/watch?v=c6c74vbuPKA' }
		tenaglia3 = { 'name': 'Danny Tenglia', \
			  'id':'', \
			  'thumb':'images/danny_tenaglia-1280x1024.jpg', \
			  'video':'http://www.youtube.com/watch?v=q_fe60Uzt-Q' }
		tiesto1 = { 'name': 'DJ Tiesto', \
			  'id':'', \
			  'thumb':'images/dj-tiesto-fun-club8.jpg', \
			  'video':'http://www.youtube.com/watch?v=gtVf3okdNXI' }
		tiesto2 = { 'name': 'DJ Tiesto', \
			  'id':'', \
			  'thumb':'images/dj-tiesto.jpg', \
			  'video':'http://www.youtube.com/watch?v=7AxI4rxCf2E' }
		tiesto3 = { 'name': 'DJ Tiesto', \
			  'id':'', \
			  'thumb':'images/dj_tiesto_by_tzyka.jpg', \
			  'video':'http://www.youtube.com/watch?v=EtPyroGa06s' }
	
		heroes = [ sanchez1, tenaglia1, tiesto1, \
			sanchez2, tenaglia2, tiesto2, \
			sanchez3, tenaglia3, tiesto3 ]

		retv = json.dumps( heroes )
		return retv

# API top level resource...
class API(resource.Resource):

	def getChild(self, path, request):
		if path == "get_test":
			return GetTest()

		elif path=="get_home_details":
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

