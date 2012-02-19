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
import urllib

import event
import venue
import common

#
# events...
#
class Event(resource.Resource):

        def render_GET(self, request):

		events = event.get_events_details(None, None)
		print events

		jretv = json.dumps( events )

		return jretv

#
# API resource...
#
class API(jsonrpc.JSONRPC):

	#
	# get events...
	#
	def jsonrpc_get_events( self, paging ):
		print "get events"
                events = event.get_events_details(None, None)
                print events
                #jretv = json.dumps( events )
                #return jretv
		return events

	# Show api doc node...
	#def render_GET(self, request):
	#return common.NotSupported()
       
	# Dispatch for api objects... 
	#def getChild(self, path, request):
	#if ( path == "event" ):
	#return Event()
	#else:	
	#return common.NotSupported()


