#
# Configuration... 
#
VERBOSE = True


#
# Program...
#

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

import event
import device
import followdj
import dj
import city

def DBG( *items ):
        if VERBOSE:
                for item in items:
                        print item,
                print

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

        def jsonrpc_get_events(self,location,paging,city,all,sc):
		print "INFO: api: get_events->", location, paging, "city->",city, all, sc

		# get events...
		[ events, info ] = event.get_events_details( None, location, paging, city, all, sc)

		# format return payload as dct...
		dct = { "results":events, "status":1, "paging":info }

		return dct
        
	def jsonrpc_get_event(self,location,eoid):

		bid = bson.objectid.ObjectId(eoid)
		DBG( "INFO: api: get_events->", location, eoid, bid )

		evt = event.get_event_details( None, location, bid,True )
		if not evt:
			dct = {'status':0,'msg':'Cannot get this event.'}
			return dct
		else:
			dct = { "results":evt, "status":1 }
			return dct

	def jsonrpc_register_device(self,deviceid):

		DBG( "INFO: api: register_device->", deviceid )
		[ status, oid ] = device.add_device( None, deviceid )

		if status:
			dct = { 'status':1 }
		else:
			dct = { 'status':0 }

		return dct

	def jsonrpc_followdjs(self,deviceid,djs,djids):

		DBG( "INFO: api: followdj->", deviceid, djs, djids )

		status = followdj.add_followdjs( None, deviceid, djs, djids )
		if not status:
			return { 'status':0, 'msg':'Operation failed' }
		djstr = ""
		for dj in djs:
			djstr += "%s, " % dj
		djstr = djstr.strip()
		djstr = djstr[:-1]	
		dct = { 'status':1, 'msg':'You are now following %s!' % djstr }
		return dct

	def jsonrpc_get_followdjs(self,deviceid):

		DBG( "INFO: api: get_followdjs->", deviceid )

		djs = followdj.get_followdjs_details( None, deviceid )	

		dct = {'status':1, 'results':djs }
		return dct

	def jsonrpc_stop_followdj(self,deviceid,dj):

		DBG( "INFO: api: stop_followdj->", deviceid, dj )

		status = followdj.remove_followdj( None, deviceid, dj )
		if not status:
			dct = {'status':0,'msg':'Problem with this operation.'}

		return self.jsonrpc_get_followdjs( deviceid )

	def jsonrpc_get_djs(self, searchrx, all, paging):

		DBG( "INFO: api: get_djs->", searchrx, all, paging )

		status = dj.get_djs_details( None, searchrx, all, paging )
		if not status:
			dct = {'status':0,'msg':'Problem with this operation.'}
			return dct	
		else:
			dct = {'status':1, 'results':status[0], 'paging':status[1] }
			return dct	
	
	def jsonrpc_get_dj(self, djid):

		DBG( "INFO: api: get_dj->", djid )

		status = dj.get_dj_details( None, djid )
		if not status:
			dct = {'status':0,'msg':'Problem with this operation.'}
			return dct	
		else:
			dct = {'status':1, 'results':status  }
			return dct	
	
	def jsonrpc_get_schedule(self, djid):
		
		DBG( "INFO: api: get_schedule->", djid )

		bid = bson.objectid.ObjectId(djid)
		status = dj.get_schedule( None, bid )
		if status == False:
			dct = {'status':0,'msg':'Problem with this operation.'}
			return dct	
		else:
			dct = {'status':1, 'results':status }
			return dct	
	
	def jsonrpc_get_similar_djs(self, djid):

		DBG( "INFO: api: get_similar_djs->", djid )

		status = dj.get_similar_djs( None,  djid )
		if status == False:
			dct = {'status':0,'msg':'Problem with this operation.'}
			return dct	
		else:
			dct = {'status':1, 'results':status }
			return dct

	def jsonrpc_get_cities(self):

		DBG( "INFO: api: get_cities->" )

		status = city.get_cities_details( None, None, None )
		if status == False:
			dct = {'status':0,'msg':'Problem with this operation.'}
			return dct	
		else:
			dct = {'status':1, 'results':status }
			return dct

a = API()
parent.putChild("api", a)

#reactor.listenTCP(8084, server.Site(Math()))

factory = Site(parent)
reactor.listenTCP(7779, factory )

#
# Use this code to start as main...
#

print "INFO: Starting reactor..."
reactor.run()

