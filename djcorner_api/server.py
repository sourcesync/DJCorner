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

import base64
import os
import json
import socket

import event
import device
import followdj

class FormPage(resource.Resource):
    def render_GET(self, request):
        return '<html><body>NO!</form></body></html>'

    def render_POST(self, request):
	print request.args.keys()
	pic = request.args["photo"][0]
	name = request.args["name"][0]
	path = os.path.join( "images", name )
	print path
	f = open( path, 'w')
	f.write( pic )
	f.flush()
        return '<html><body>ok</body></html>'

# Create toplevel web resource...
parent = resource.Resource()

# Create post/upload part of the site...
#upload = FormPage()
#parent.putChild("upload", upload )

# Create static resources part of site...
staticfiles = File("static")
parent.putChild("static", staticfiles )

#class API(jsonrpc.JSONRPC):
#        def jsonrpc_echo(self,a):
#                return a

# API top level resource...
class API(jsonrpc.JSONRPC):

        def jsonrpc_get_events(self,location,paging,city):
		print "INFO: api: get_events->", location, paging, "city->",city
		[ events, info ] = event.get_events_details( None, location, paging, city )
		dct = { "results":events, "status":1, "paging":info }
		return dct
        
	def jsonrpc_get_event(self,location,eoid):
		print "INFO: api: get_events->", location, eoid
		events = event.get_event_details( None, location, paging, True )
		dct = { "results":event, "status":1 }
		return dct

	def jsonrpc_register_device(self,deviceid):
		print "INFO: api: register_device->", deviceid
		[ status, oid ] = device.add_device( None, deviceid )
		if status:
			dct = { 'status':1 }
		else:
			dct = { 'status':0 }
		return dct

	def jsonrpc_followdj(self,deviceid,dj):
		print "INFO: api: followdj->", deviceid, dj
		[ status, oid ] = followdj.add_followdj( None, deviceid, dj )
		dct = { 'status':1 }
		#	dct = { 'status':0, 'msg':'Cannot follow dj' }
		return dct

	def jsonrpc_get_followdjs(self,deviceid):
		print "INFO: api: get_followdjs->", deviceid
		djs = followdj.get_followdjs_details( None, deviceid )	
		dct = {'status':1, 'results':djs }
		return dct

	def jsonrpc_stop_followdj(self,deviceid,dj):
		print "INFO: api: stop_followdj->", deviceid, dj
		status = followdj.remove_followdj( None, deviceid, dj )
		if not status:
			dct = {'status':0,'msg':'Problem with this operation.'}
		return self.jsonrpc_get_followdjs( deviceid )

#a = api.API()
a = API()
parent.putChild("api", a)

#reactor.listenTCP(8084, server.Site(Math()))

factory = Site(parent)
reactor.listenTCP(7777, factory )

#
# Use this code to start as main...
#

print "INFO: Starting reactor..."
reactor.run()

