from txjsonrpc.web import jsonrpc
from twisted.web import server
from twisted.internet import reactor
from twisted.web.static import File
from twisted.web.server import Site
from twisted.web import resource

import base64
import os
import json

import api
import session




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
#staticfiles = File("images")
#parent.putChild("static", staticfiles )

# API top level resource...
a = api.rAPI()
parent.putChild("api", a)

# Session resource is child of api...
s = session.rsession()
a.putChild("session", s )

# Users under API...
#users = Users()
#api.putChild("users",users)

# Videos under API...
#videos = Videos()
#api.putChild("videos",videos)

#reactor.listenTCP(8084, server.Site(Math()))

factory = Site(parent)
reactor.listenTCP(6767, factory )

print "INFO: Starting reactor..."

reactor.run()

