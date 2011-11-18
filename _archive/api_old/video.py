#
# Configuration...
#


#
# Program...
#
import operator
import restify

#
# video twisted resource...
#
class rvideo(resource.Resource):

        # Show users doc node...
        def render_GET(self, request):
                return '<html><body>DOCUMENTATION NODE</body></html>'

        # Create a user...
        def render_POST(self, request):
                return '<html><body>VIDEOS DOC NODE</body></html>'

        # Show collection...
        def show_collection(self, request):
                col = dbaccess.get_videos( None, None )
                return CollectionResource(col)

        # Func to capture trailing /
        def getChild(self, path, request):
                if path == "": #trailing slash, show the collection...
                        return self.show_collection( request )
                else:
                        return NotSupported()

#
# main video object...
#
class video(restify.Restify):
	def __init__(self):
		self.ID = ""
		self.Name = ""
		self.URL = ""

if __name__ == "__main__":
	v = video.object_from_rest_set( "ID=1&Name=yo&URL=stuff&_luser=111111" )
	print v, v.ID, v.Name, v.URL
