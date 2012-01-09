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

#
# Call to get search results...
#
class GetVideos(resource.Resource):

        def render_GET( self, request ):
		search1 = { 'thumb':'http://www.yellowdragon-music.co.uk/images/miami/Danny_Tenaglia_M.jpg', \
				'video':'http://www.youtube.com/watch?v=ioJa7UvCqEA&', \
				'rating':4, \
				'name':'Tenaglia Video 1' }
		search2 = { 'thumb':'http://www.houseplanet.dj/portal_images/beatport-artists/beatport-danny-tenaglia.jpg',\
				'video':'http://www.youtube.com/watch?v=IAtSFEbn_I0', \
				'rating':3, \
				'name':'Tenaglia Video 2' }
		search3 = { 'thumb':'http://www.electronicmusic.cc/images/danny-tenaglia-carl-cox.jpg', \
				'video':'http://www.youtube.com/watch?v=AhDSbmiFkSg',\
				'rating':3, \
				'name':'Tenaglia Video 3' }
		search4 = { 'thumb':'http://www.djdownload.com/earworm/wp-content/uploads/dannytenaglia.jpg', \
				'video':'http://www.youtube.com/watch?v=K_6c4XnUggE', \
				'rating':2, \
				 'name':'Tenaglia Video 4' }
		search5 = { 'thumb':'http://www.poslouchej.net/forum/userpix/238_Danny_Tenaglia__Global_Underground_010_Athens_1.jpg', \
				'video':'http://www.youtube.com/watch?v=H0vwthmnpqQ', \
				'rating':1, \
				 'name':'Tenaglia Video 5' }
		search6 = { 'thumb':'http://www.djsets.co.uk/Compilations/dannytanaglia/dan3.jpg', \
				'video':'http://www.youtube.com/watch?v=GPqD_bpA72U', \
				'rating':3, \
				 'name':'Tenaglia Video 6' }
		search7 = { 'thumb':'http://www.beatportal.com/uploads/news/1211524469_danny-tenaglia442.jpg', \
				'video':'http://www.youtube.com/watch?v=cWI8Mmws7Xg', \
				'rating':4, \
				 'name':'Tenaglia Video 7' }
		search8 = { 'thumb':'http://www.yellowdragon-music.co.uk/images/miami/Danny_Tenaglia_M.jpg', \
				'video':'http://www.youtube.com/watch?v=ioJa7UvCqEA&', \
				'rating':4, \
				 'name':'Tenaglia Video 8' }
		search9 = { 'thumb':'http://www.electronicmusic.cc/images/danny-tenaglia-carl-cox.jpg', \
				'video':'http://www.youtube.com/watch?v=AhDSbmiFkSg',\
				'rating':3, \
				 'name':'Tenaglia Video 9' }
		search10 = { 'thumb':'http://www.djdownload.com/earworm/wp-content/uploads/dannytenaglia.jpg', \
				'video':'http://www.youtube.com/watch?v=K_6c4XnUggE', \
				'rating':2, \
				 'name':'Tenaglia Video 10' }
		search11 = { 'thumb':'http://www.poslouchej.net/forum/userpix/238_Danny_Tenaglia__Global_Underground_010_Athens_1.jpg', \
				'video':'http://www.youtube.com/watch?v=H0vwthmnpqQ', \
				'rating':4, \
				 'name':'Tenaglia Video 11' }
		search12 = { 'thumb':'http://www.poslouchej.net/forum/userpix/238_Danny_Tenaglia__Global_Underground_010_Athens_1.jpg', \
				'video':'http://www.youtube.com/watch?v=H0vwthmnpqQ', \
				'rating':1, \
				 'name':'Tenaglia Video 12' }
		results = [ search1, search2, search3, search4, search5, search6, search7, search8, search9, search10, search11, search12 ]
		retstr = json.dumps( results )
		return retstr

# API top level resource...
class API(resource.Resource):

	def getChild(self, path, request):
		if path == "get_test":
			return GetTest()

		elif path=="get_home_details":
			return GetHomeDetails()	

		elif path=="get_videos":
			return GetVideos()

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

