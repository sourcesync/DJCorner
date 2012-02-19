#
# Configuration...
#

DBNAME = "djcorner2"

#
# Program...
#

from pymongo import Connection

import sys

def _get_connection():
	
	# connection...
        connection = Connection()
	return connection	


def _get_user_col( connection ):
	
	# connection...
	if not connection:
        	connection = Connection()

        # dbase...
        db = connection[DBNAME] 

        # collection...
        users = db['users']

	return users

# 
# func to add user...
#
def add_user( connection, email ):
        
        users = _get_user_col( connection )

	if (email):	
		# see if there is already this user by vendorid...
		user = users.find_one( {'em':email} )
		if ( user != None ):
			return [ False, user["_id"] ]

        # create a user...
        user = { "em": email }

        # add to collection...
        oid = users.insert( user )

	return [ True, oid ]

#
# func to get user...
#
def get_user( connection, oid ):

        users = _get_user_col( connection )

	_evt = {"_id": oid }
	user = users.find_one( _evt )

	return user

#
# func to get users...
#
def get_users( connection, paging ):
	
        users = _get_user_col( connection )

	# iterate over collection...
	retv = []
	for user in users.find():
		retv.append( user )

	return retv

#
# func to update user basic info...
#
def update_user( connection, uoid, fn, mn, ln, latitude, longitude ):
	
        users = _get_user_col( connection )

	# create the user object...
	user = { "_id":uoid }

	# create fields dct...	
	fields = {}
	if fn: fields["fn"] = fn
	if mn: fields["mn"] = mn
	if ln: fields["ln"] = ln
	if latitude: fields["latitude"] = latitude
	if longitude: fields["longitude"] = longitude

	# update...
	uid = users.update( user, { '$set':fields } , True )

	if ( uid ):
		return False
	else:
		return True

#
# func to delete user...
#
def delete_user( connection, oid ):

        user = _get_user_col( connection )

	user = { "_id":oid }

	status = users.remove( user, True )

	if status["err"]:
		return False
	else:	
		return True

#
# unit test...
#
if __name__ == "__main__":

	print "INFO: user: unit-test..."
	DBNAME = "djcornertest"

	# get connection...
	conxn = _get_connection()

	# clear the collection...
	print "INFO: user: clearing the current collection..."
	col = _get_user_col( conxn )
	col.remove()
	
	# get all users...
	users = get_users( conxn, None )
	print "INFO: user: get_users: result->", users
	if len(users)!=0:
		print "ERROR: There should be no users."
		sys.exit(1)

	# add user...
	[ status, origid ] = add_user( conxn, "original user name", "tttt" )
	print "INFO: user: add_user: result->", origid
	if status == False:
		print "ERROR: Could not add user!"
		sys.exit(1)

	# update basic props...
	status = update_user( conxn, origid, "new user name"  )	
	print "INFO: user: update_user: result->", status
	if status==False:
		print "ERROR: Update failed!"
		sys.exit(1)

	# get all user...
	users = get_users( conxn, None )
	print "INFO: user: get_users: result->", users

	# add with same vendor id and verify fail...
	[ status, oid ] = add_user( conxn, "should fail user name", "tttt" )
	print "INFO: user: add_user: same vendorid, result->", oid
	if status != False:
		print "ERROR: add_user: should have failed."
		sys.exit(1)
	
	# get all users...
	users = get_users( conxn, None )
	print "INFO: user: get_users: result->", users

	# remove it...
	status = delete_user( conxn, origid )
	print "INFO: user: delete_user: result->", status
	if (status!=True):
		print "ERROR: delete user failed!"
		sys.exit(1)

	# get all users...
	users = get_users( conxn, None )
	print "INFO: user: get_users: result->", users
	if len(users)!=0:
		print "ERROR: There should be no users...", users
		sys.exit(1)

	print "INFO: user: unit tests passed."
	print "INFO: Done."
	
