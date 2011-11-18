#
# Configuration...
#

#
# Code...
#
import restify
import mongoify

#
# user twisted resource...
#
class Users(resource.Resource):

        # Show users doc node...
        def render_GET(self, request):
                return '<html><body>DOCUMENTATION NODE</body></html>'

        # Create a user...
        def render_POST(self, request):
                return '<html><body>USERS DOC NODE</body></html>'

        # Show collection...
        def show_collection(self, request):
                col = dbaccess.get_users( None, None )
                return CollectionResource(col)

        # Func to capture trailing /
        def getChild(self, path, request):
                if path == "": #trailing slash, show the collection...
                        return self.show_collection( request )
                else:
                        return NotSupported()

#
# Main user object...
#
class user(restify.Restify, mongoify.Mongoify):
	def __init__(self):
		self.ID = ""
		self.FirstName = ""
		self.MiddleName = ""
		self.LastName = ""


if __name__ == "__main__":
	u = user.object_from_rest_set( "ID=4e8101e13cfffe7fc4000000&FirstName=f&MiddleName=m&LastName=l" )
	print u, u.ID, u.FirstName, u.MiddleName, u.LastName
	u.write_to_mongo()	
	
