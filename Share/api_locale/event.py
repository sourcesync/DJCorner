#
# Configuration...
#
VERBOSE = True

#
# Program...
#
import sys
from dateutil import parser
import datetime
from datetime import timedelta

from pymongo import Connection
import bson

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


def _get_event_col( connection ):
	
	# connection...
	if not connection:
        	connection = Connection()

        # dbase...
        db = connection[dbglobal.DBNAME] 

        # collection...
        events = db['events']

	return events

#
# func to clear all events...
#
def clear_all( connection ):
        
	events = _get_event_col( connection )
	events.remove()

	return True	

# 
# func to add event...
#
def add_event( connection, name, vendorid ):
        
        events = _get_event_col( connection )

	if (vendorid):	
		# see if there is already this event by vendorid...
		evt = events.find_one( {'vendorid':vendorid} )
		if (evt != None):
			return [ False, evt["_id"] ]

        # create an event...
        event = { "name": name }

	if vendorid: event["vendorid"] = vendorid

        # add to collection...
        oid = events.insert( event )

	return [ True, oid ]

#
# func to get event...
#
def get_event( connection, oid ):

        events = _get_event_col( connection )
	_evt = {"_id": oid }
	event = events.find_one( _evt )
	return event


#
# func to get all event info...
#
def get_event_details( connection, location, oid,language, verbose ):

	DBG("INFO: event: oid->", oid)
	event = get_event( connection, oid )
	print "can you see this->",event
	# fixup venue related fields...
	if event.has_key("venueid"):

		# get the linked venue...
		venueid = event["venueid"]
		vn = venue.get_venue( connection, venueid )

		#
                # flatten venue information, like venue name, lat, long...
		#

		# venue name...
		ds = vn["name"]
		if vn.has_key("ds"):
			ds = vn["ds"]	
                event["venuename"] = ds
	
		# venue lat...	
		lat = 0
		if vn.has_key("latitude"):
			lat = vn["latitude"]	
              	event["latitude"] = lat
	
		# venue long...
		lng = 0
		if vn.has_key("longitude"):
			lng = vn["longitude"]	
              	event["longitude"] = lng

		# compute dist for this event...	
		if location and vn.has_key("latitude") and vn.has_key("longitude"):
			latitude = vn["latitude"]
			longitude = vn["longitude"]
			dist = 	common.get_distance( latitude, longitude, location["lat"], location["lng"] )
			event["dist"] = dist
		else:
			event["dist"] = 0

		# remove venueid...
		del event["venueid"]

	# event date...
	dtstr = event["eventdate"]
	dt = parser.parse(dtstr)
	dtstr = dt.strftime("%m/%d/%y")
	event["eventdate"] = dtstr

	# event performers...
	if not event.has_key("pf"):
		event["pf"] = []
		event["pfids"] = []
	else:
		pfids = event["pfids"]
		pfids = [ str(a) for a in pfids ] # make sure its serializable...
		event["pfids"] = pfids
	
	# fix up description...
	if (not verbose) and event.has_key("description"):
		del event["description"]

	# remove vendorid...
	del event["vendorid"]

	# change id field...
	del event["_id"]
	event["id"] = str(oid)

	return event

#
# func to get events...
#
def get_events( connection, paging ,language):
	
        events = _get_event_col( connection )

	# iterate over collection...
	retv = []
	for event in events.find({"language":language}):
		retv.append( event )

	return retv

def _sort_by_dist( a, b ):
	da = a["dist"]
	db = b["dist"]
	if (da<db):	return -1
	elif (da>db):	return 1
	else:	return 0

def _sort_by_date( a, b ):
	#print "A=", a
	#print "B=", b
	da = a["eventdate"]
	ta = parser.parse(da)
	#print "a=",da
	db = b["eventdate"]
	tb = parser.parse(db)
	#print "db=",db
	if (ta<tb):	return -1
	elif (ta>tb):	return 1
	else:	return 0

#
# func to get events details...
#
def get_events_details( connection, location, paging, city, all ,language):

	# get all raw events...	
	events = get_events( connection, paging ,language)
	print "the result->",events
	# get events details...
	events_details = []
	for evt in events:
		event_details = get_event_details( connection, location, evt["_id"],language, False )
		print "the event_details->",event_details
		# don't include old events...
		edt = event_details["eventdate"]
		dt = parser.parse( edt )
		if (  datetime.datetime.today() - dt ) > timedelta( days=1 ):
			print "WARNING: event: event already happened"
			continue

		# filter by city possibly...
		if city and event_details["city"] != city:
			continue

		if not all: # filter by rating...
                        rating = None
                        if evt.has_key("rating"):
                                rating = evt["rating"]
                        if rating!=None and rating>=0 and rating <= 50:
				pass
			else: #skip this one
				continue

		events_details.append( event_details )
	
	# sort it by dist...
	events_details.sort( _sort_by_date )

	# possibly deal with paging...
	if (paging):
		total = len( events_details )
		start = paging["start"]
		end = paging["end"]
		arr = events_details[start:end]
		count = len(arr)
		info = { "total":total, "count":count, "start":start, "end":end }
		return [ arr, info ]
	else:		
		return [ events_details, {} ]

#
# func to update event basic info...
#
def update_event( connection, oid, name, venueid, description, promotor, imgpath, eventDate, startDate, endDate, buyurl, performers,pfids, city):
	
        events = _get_event_col( connection )

	# create the event object...
	event = { "_id":oid }

	# create fields dct...	
	fields = {}
	if name: fields["name"] = name
	if venueid: fields["venueid"] = venueid
	if description!=None: fields["description"] = description
	if promotor: fields["promotor"] = promotor
	if imgpath: fields["imgpath"] = imgpath

	if eventDate: fields["eventdate"] = eventDate
	if startDate: fields["startdate"] = startDate
	if endDate: fields["enddate"] = endDate
	if buyurl: fields["buyurl" ]=buyurl
	if performers: fields["pf"] = performers
	if performers: fields["pfids"] = pfids
	if city: fields["city"] = city

	# update...
	uid = events.update( event, { '$set':fields } , True )

	if ( uid ):
		return False
	else:
		return True

#
# func to update event rating...
#
def update_event_rating( connection, oid ):
        
	evt = get_event( connection, oid )
	
	pfids = []
	if evt.has_key("pfids"):
		pfids = evt["pfids"]

	evtrating = -1
	for pfid in pfids:
		bid = bson.objectid.ObjectId(pfid)
		djobj = dj.get_dj( connection, bid )
		rating = None
		if djobj.has_key("rating"):
			rating = djobj["rating"]
		if rating and rating>=0 and rating<=50:
			if rating> evtrating:
				evtrating = rating
	print "EVTRATING->", evtrating

        events = _get_event_col( connection )
	obj = { "_id":oid }
	fields = { "rating": evtrating }	
	uid = events.update( obj, { '$set':fields } , True )
	if ( uid ):
		return False
	else:
		return True
	 
#
# func to delete event...
#
def delete_event( connection, oid ):

        events = _get_event_col( connection )

	event = { "_id":oid }

	status = events.remove( event, True )

	if status["err"]:
		return False
	else:	
		return True

#
# unit test...
#
if __name__ == "__main__":
	validate = False

	# possibly clear events...
	if len(sys.argv)>1 and ( sys.argv[1]=="clear" ):
		print "WARNING: clearing events..."
		clear_all( None)
	elif len(sys.argv)>1 and ( sys.argv[1]=="validate" ):
		validate = True

	# get connection...
	conxn = _get_connection()

	loc = None
	if validate:
		loc = {'lat':0.1,'lng':0.2}

	# get all events...
	events = get_events_details( conxn, loc, None, None, True)
	print "INFO: There are %d events" % len(events[0])

	# iterate...
	for evt in events[0]:
		print "INFO: event->", evt["id"], evt["name"], evt["pf"], evt["pfids"], evt["eventdate"], evt["venuename"], evt["city"], evt["dist"], evt["eventdate"], evt["rating"]
		if validate:
			if evt["dist"] == 0:
				print "ERROR: event: invalid dist"
				sys.exit(1)
	
	print "INFO: There are %d events" % len(events[0])

	print "INFO: Done."
	
