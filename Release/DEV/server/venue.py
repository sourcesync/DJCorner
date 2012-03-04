#
# Configuration...
#
VERBOSE = True

#
# Program...
#

from pymongo import Connection

import sys

import bson

import dbglobal

def DBG( *items ):
        if VERBOSE:
                for item in items:
                        print item,
                print

def _get_connection():
	
	# connection...
        connection = Connection()
	return connection	


def _get_venue_col( connection ):
	
	# connection...
	if not connection:
        	connection = Connection()

        # dbase...
        db = connection[dbglobal.DBNAME] 

        # collection...
        venues = db['venues']

	return venues

#
# func to clear all venues...
#
def clear_all( connection ):

        venues = _get_venue_col( connection )
        venues.remove()

        return True


# 
# func to add venue...
#
def add_venue( connection, name, vendorid ):
        
        venues = _get_venue_col( connection )

	if (vendorid):	
		# see if there is already this venue by vendorid...
		venue = venues.find_one( {'vendorid':vendorid} )
		if ( venue != None ):
			return [ False, venue["_id"] ]

        # create an venue...
        venue = { "name": name }

	if vendorid: venue["vendorid"] = vendorid

        # add to collection...
        oid = venues.insert( venue )

	return [ True, oid ]

#
# func to find venue...
#
def find_venue( connection, vname ):

        DBG( "INFO: venue: find_venue->", vname )

        vs = _get_venue_col( connection )

        v = vs.find_one( {'name':vname} )
        if not v:
                return False
        else:
                return v["_id"]


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
# func to get venues details...
#
def get_venues_details( connection, paging ):
        
	venues = _get_venue_col( connection )

	# iterate over collection...
	retv = []
	for venue in venues.find():
		if venue.has_key("_id"):
			venue["id"] = str(venue["_id"])
			del venue["_id"]
		retv.append( venue )

	return retv


#
# func to update venue basic info...
#
def update_venue( connection=None, void=None, name=None, latitude=None, longitude=None, display_name=None, city=None, address=None, website=None, phone=None ):

	if (void==None):
		return False
	
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
	if address: fields["address"] = address
	if phone: fields["phone"] = phone
	if website: fields["website"] = website

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

	if len(sys.argv)>1 and sys.argv[1]=="clear":
		DBG("WARNING: Clearing venues...")
		clear_all( None )

	elif len(sys.argv)>1 and sys.argv[1]=="delete":
		DBG("WARNING: Delete venue with id->%s<-" % sys.argv[2] )

		void = bson.objectid.ObjectId( sys.argv[2] )
		retv = delete_venue( None, void )
		if not retv:
			DBG("ERROR: Could not delete venue")

	else:
		vs = get_venues_details( None, None )
		print vs
	
		for v in vs:
			print "INFO: venue->", v["id"], v["name"],
			if v.has_key("city"):
				print "city=" + v["city"],
			print
			if v.has_key("latitude"):
				print "lat=" + str(v["latitude"]),
				print
			if v.has_key("longitude"):
				print "lat=" + str(v["longitude"]),
				print
			print
	
	print "INFO: Done."
