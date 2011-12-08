#
# Configuration...
#

DBNAME = "djcorner"

#
# Program...
#

from pymongo import Connection

import sys

def _get_connection():
	
	# connection...
        connection = Connection()
	return connection	


def _get_venue_col( connection ):
	
	# connection...
	if not connection:
        	connection = Connection()

        # dbase...
        db = connection[DBNAME] 

        # collection...
        venues = db['venues']

	return venues

#
# clear venues...
#
def clear_all( connection ):

	print "ERROR: not impl"
	sys.exit(1)        

# 
# func to add venue...
#
def add_venue( connection, name, vendorid ):
        
        venues = _get_venue_col( connection )

	if (vendorid):	
		# see if there is already this venue by vendorid...
		venue = venues.find_one( {'vendorid':vendorid} )
		if ( venue != None ):
			#print "FOUND VENUE", venue
			return [ False, venue["_id"] ]

        # create an venue...
        venue = { "name": name }

	if vendorid: venue["vendorid"] = vendorid

        # add to collection...
        oid = venues.insert( venue )

	return [ True, oid ]

#
# func to get venue...
#
def get_venue( connection, oid ):

        venues = _get_venue_col( connection )

	_evt = {"_id": oid }
	venue = venues.find_one( _evt )

	return venue

#
# func to get venues...
#
def get_venues( connection, paging ):
	
        venues = _get_venue_col( connection )

	# iterate over collection...
	retv = []
	for venue in venues.find():
		retv.append( venue )

	return retv

#
# func to update venue basic info...
#
def update_venue( connection, void, name, latitude, longitude, display_name, city ):
	
        venues = _get_venue_col( connection )

	# create the venue object...
	venue = { "_id":void }

	# create fields dct...	
	fields = {}
	if name: fields["name"] = name
	if latitude: fields["latitude"] = latitude
	if longitude: fields["longitude"] = longitude
	if display_name: fields["ds"] = display_name
	if city: fields["city"] = city

	# update...
	uid = venues.update( venue, { '$set':fields } , True )

	if ( uid ):
		return False
	else:
		return True

#
# func to delete venue...
#
def delete_venue( connection, oid ):

        venues = _get_venue_col( connection )

	venue = { "_id":oid }

	status = venues.remove( venue, True )

	if status["err"]:
		return False
	else:	
		return True

#
# unit test...
#
if __name__ == "__main__":

	print "INFO: venue: unit-test..."
	DBNAME = "djcornertest"

	# get connection...
	conxn = _get_connection()

	# clear the collection...
	print "INFO: venue: clearing the current collection..."
	col = _get_venue_col( conxn )
	col.remove()
	
	# get all venues...
	venues = get_venues( conxn, None )
	print "INFO: venue: get_venues: result->", venues
	if len(venues)!=0:
		print "ERROR: There should be no venues."
		sys.exit(1)

	# add venue...
	[ status, origid ] = add_venue( conxn, "original venue name", "tttt" )
	print "INFO: venue: add_venue: result->", origid
	if status == False:
		print "ERROR: Could not add venue!"
		sys.exit(1)

	# update basic props...
	status = update_venue( conxn, origid, "new venue name", "city")
	print "INFO: venue: update_venue: result->", status
	if status==False:
		print "ERROR: Update failed!"
		sys.exit(1)

	# get all venue...
	venues = get_venues( conxn, None )
	print "INFO: venue: get_venues: result->", venues

	# add with same vendor id and verify fail...
	[ status, oid ] = add_venue( conxn, "should fail venue name", "tttt" )
	print "INFO: venue: add_venue: same vendorid, result->", oid
	if status != False:
		print "ERROR: add_venue: should have failed."
		sys.exit(1)
	
	# get all venues...
	venues = get_venues( conxn, None )
	print "INFO: venue: get_venues: result->", venues

	# remove it...
	status = delete_venue( conxn, origid )
	print "INFO: venue: delete_venue: result->", status
	if (status!=True):
		print "ERROR: delete venue failed!"
		sys.exit(1)

	# get all venues...
	venues = get_venues( conxn, None )
	print "INFO: venue: get_venues: result->", venues
	if len(venues)!=0:
		print "ERROR: There should be no venues...", venues
		sys.exit(1)

	print "INFO: venue: unit tests passed."
	print "INFO: Done."
	
