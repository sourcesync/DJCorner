from txjsonrpc.web import jsonrpc
from twisted.web import server
from twisted.internet import reactor
from twisted.web.static import File
from twisted.web.server import Site
from twisted.web import resource

import base64
import os
import json
import bson.objectid
import math

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

#
# Func to scrub a datastructure for nonjson elements...
#
def scrub_for_json( obj ):
	if type(obj) == type([]):
		for childobj in obj:
			scrub_for_json(childobj)
	elif type(obj) == type({}):
		for key in obj.keys():
			val = obj[key]
			scrub_for_json( val )
	elif type(obj) == type(bson.objectid.ObjectId()):
		print "BSON"
	else:
		print obj, type(obj)

#
# Func to get the distance between users...
#
def get_distance( alat, along, blat, blong ):

        DEG2RAD = math.pi / 180.0
        lat2 = blat
        lat1 = alat
        lon2 = blong
        lon1 = along
        R = 6371 # km
        dLat = (lat2-lat1)*DEG2RAD
        dLon = (lon2-lon1)*DEG2RAD
        lat1 = lat1 * DEG2RAD
        lat2 = lat2 * DEG2RAD

        a = math.sin(dLat/2) * math.sin(dLat/2) + math.sin(dLon/2) * math.sin(dLon/2) * math.cos(lat1) * math.cos(lat2);
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
        d = R * c;
        KM2M = 0.621371192
        d = KM2M*d

        return d


if __name__ == "__main__":

	# Test NotSupportedResource...
	print NotSupportedResource.get_message()
	nsr = NotSupportedResource()
	print nsr.render_GET(None)

	# Test DocResource...
	print DocResource.get_message()
	dr = DocResource()
	print dr.render_GET(None)
