# Configuration...
#
VERBOSE = True

GEOCODE_URL = "http://maps.googleapis.com/maps/api/geocode/json?address=%s&sensor=false"

#
# Program...
#
import sys
from dateutil import parser
import datetime
from datetime import timedelta
import urllib2
import json

from pymongo import Connection
import bson

import event
import venue
import common
import dj
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

def _get_cities_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[dbglobal.DBNAME]

        # collection...
        cities = db['cities']

        return cities

def _get_cities_names( connection ):

	cts = get_cities( connection )

	names = []
	for cty in cts:
		names.append( cty["name"] )

	return names

#
# func to get cities as list of objects...
#
def get_cities( connection ):
	
	# collection...
	cities = _get_cities_col( connection )

        # iterate over collection...
        retv = []
        for city in cities.find():
                retv.append( city )
        
	return retv

#
# func to clear all cities...
#
def clear_all( connection ):

        cities = _get_cities_col( connection )
        cities.remove()

        return True

#
# func to repopulate cities from other collections...
#
def repopulate( connection=None ):

	# get the current cities collection...
        cities = _get_cities_col( connection )

	# get from events...
	evts = event.get_events( connection )

	# accumulate unique cities...
	cts = []
	for evt in evts:
		if evt.has_key("city"):
			city = evt["city"]
			if city not in cts:
				cts.append(city)

	for cty in cts:
		retv = add_city( connection, cty, True )
		
	return

#
# func to geocode cites...
#
def geocode_cities( connection=None ):

	cts = get_cities( connection )

        for cty in cts:

		print cty

		oid = cty["_id"]
		cname = cty["name"]

		# see if it has lat/long...
		if not cty.has_key("lat"):	

			response = urllib2.urlopen( GEOCODE_URL % cname.replace(" ","+") )
			_data = response.read()	
			data = json.loads( _data )
			if data["status"] != "OK":
				raise Exception("city: geocode_cities: invalid url resp->" + data["status"])
			results = data["results"]
			if len(results)>0:
				print "WARNING: city: geocode_cities: multiple matches for city " + cname

			#print results
			lat = float(results[0]["geometry"]["location"]["lat"])
			lng = float(results[0]["geometry"]["location"]["lng"])
			location = [ lat, lng ]
			
			update_city( connection, oid, location )

	return

#
# func to add a city...
#
def add_city( connection=None, name=None, geocode=False):

	if name==None:
		raise Exception("City: add_city: invalid name")

        cities = _get_cities_col( connection )

	# see if its already there...
	cty = cities.find_one( {'name':name} )
	if (cty != None):
		return [ False, cty["_id"] ]

        # create an event...
        city = { "name": name }

        # add to collection...
        oid = cities.insert( city )

        return [ True, oid ]

#
# func to update a city...
#
def update_city( connection=None, oid=None, location=None, country= None ):

	if (oid==None):
		raise Exception("City: update_city: invalid objectid.")

	cities = _get_cities_col( connection )

        # create the event object...
        city = { "_id":oid }

        # create fields dct...
        fields = {}
        if type(location)==type([]):
		fields["lat"] = location[0]
		fields["long"] = location[1]
	if country: fields["country"] = country

        # update...
        uid = cities.update( city, { '$set':fields } , True )
	if ( uid ):
		return False
	else:
		return True


#
# func to get cities...
#
def get_cities_details( connection=None, location=None, paging=None ):

	cities = get_cities( connection )

	details = []
	for cty in cities:
		cty["id"] = str( cty["_id"] )
		del cty["_id"]	
		details.append( cty )

	return [ details, None ]

#
# UNIT TEST...
#

if __name__ == "__main__":

	if (len(sys.argv)>1) and sys.argv[1]=="clear":
		DBG( "WARNING: Clearing all cities..." )
		clear_all(None)
		sys.exit(0)

	elif (len(sys.argv)>1) and sys.argv[1]=="repopulate":
		DBG( "WARNING: Repopulating cities..." )

		# make sure cities collection is in sync with other collections...
		repopulate()

		sys.exit(0)
	
	elif (len(sys.argv)>1) and sys.argv[1]=="geocode":
		DBG( "WARNING: Geocoding cities..." )

		# make sure we have lat/long for cities...
		geocode_cities()

		sys.exit(0)

	details = get_cities_details()
	cities = details[0]

	for city in cities:
		lat = None
		lng = None
		if city.has_key("lat"):
			lat = city["lat"]
			lng = city["long"]	
		print "INFO: city->", city["name"], lat, lng

	print "INFO: Done."
