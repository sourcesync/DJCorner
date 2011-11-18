#
# Configuration...
#

from pymongo import Connection

# 
# Code...
#

#
# Get all users...
#
def get_users( connection, paging ):

	# get cursor on collection...
	if not connection:
		connection = Connection()
	db = connection["djcorner"]
	users = db.users
	cs = users.find()

	# iterate cursor and collect info...
	info = []
	for user in cs:
		info.append( user )

	return info


