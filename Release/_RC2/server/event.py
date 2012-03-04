#
# Configuration...
#
VERBOSE = True

FAR = 999999

#
# Program...
#
import sys
from dateutil import parser
import datetime
from datetime import timedelta

import pymongo
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
# func to get performer names from ids...
#
def _get_performers( connection, pfids ):
	pfs = []	
	for pfid in pfids:
		info = dj.get_dj( connection, bson.objectid.ObjectId(pfid) ) 
		if info:
			pfs.append( info["name"] )
	return pfs

#
# func to get all event info...
#
def get_event_details( connection, location, oid, verbose ):

	event = get_event( connection, oid )

	# fixup venue related fields...
	if event.has_key("venueid"):

		# get the linked venue...
		venueid = event["venueid"]
		vn = venue.get_venue( connection, venueid )
		if not vn:
			#DBG( "WARNING: venue no longer exists..." )
			event["dist"] = FAR

		elif not vn or not vn.has_key("name"):
			#DBG( "WARNING: venue no longer exists..." )
			event["dist"] = FAR
		
		else:	
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
				#DBG( "WARNING: venue has no lat/long->", vn["name"] )
				event["dist"] = FAR

		# remove venueid...
		del event["venueid"]

	else: # no venueid
		#DBG( "WARNING: event has no venueid" )
		event["dist"] = FAR

	# event date...
	dtstr = event["eventdate"]
	dt = parser.parse(dtstr)
	dtstr = dt.strftime("%m/%d/%y")
	event["eventdate"] = dtstr

	# event performers...
	event["pf"] = []
	if not event.has_key("pfids"):
		event["pfids"] = []
	else:
		pfids = event["pfids"]
		pfids = [ str(a) for a in pfids ] # make sure its serializable...
		event["pfids"] = pfids
		event["pf"] = _get_performers( connection, pfids )
	
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
def get_events( connection= None ):
	
        events = _get_event_col( connection )

	# iterate over collection...
	retv = []

	for event in events.find():
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
def get_events_details( connection, location, paging, city, all, sort_criteria ):

	events = _get_event_col( connection )

	# create cursor...
	now = datetime.datetime.utcnow()
	matches = events.find({"dti":{"$gt":now}}).sort("dti", pymongo.ASCENDING)
	total = matches.count()
	if (paging):
		events = matches[ paging["start"]: paging["end"] ]
	else:
		events = matches

	# get events details...
	events_details = []
	for evt in events:
		event_details = get_event_details( connection, location, evt["_id"], False )

		# don't include old events...
		#edt = event_details["eventdate"]
		#dt = parser.parse( edt )
		#if (  datetime.datetime.today() - dt ) > timedelta( days=1 ):
		#	continue

		# filter by city possibly...
		#if city and event_details["city"] != city:
		#continue
		
		# TODO: return this code !!!
		#if not all and False: # filter by rating...
                #       rating = None
                #        if evt.has_key("rating"):
                #                rating = evt["rating"]
		#	if type(rating)==type(""):
		#		rating = float(rating)
                #       if rating!=None and rating>=0 and rating <= 50:
		#		pass
		#	else: #skip this one
		#		DBG( "WARNING: event: rating filter failed" )
		#	continue

		events_details.append( event_details )

	#if (sort_criteria==0):	# def date...
	## sort it by dist...
	#events_details.sort( _sort_by_date )
	#elif (sort_criteria==1): # dist...
	#events_details.sort( _sort_by_dist )

	# possibly deal with paging...
	if (paging):
		start = paging["start"]
		end = paging["end"]
		arr = events_details
		count = len(arr)
		info = { "total":total, "count":count, "start":start, "end":end }
		DBG( "INFO: event: get_events_details, paing info to return->", str(info) )
		return [ arr, info ]
	else:		
		return [ events_details, {} ]

#
# func to update event basic info...
#
def update_event( connection=None, oid=None, name=None, venueid=None, description=None, promotor=None, \
	imgpath=None, eventDate=None, startDate=None, endDate=None, buyurl=None, performers=None, pfids=None, city=None, thumbpath=None ):

	if (oid==None):
		raise Exception("Event: update_event: invalid objectid")

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
	if eventDate:
		dt = parser.parse(eventDate)
        	dtstr = dt.strftime("%m/%d/%y") 
		fields["eventdate"] = eventDate
	if startDate: fields["startdate"] = startDate
	if endDate: fields["enddate"] = endDate
	if buyurl: fields["buyurl" ]=buyurl
	#if performers: fields["pf"] = performers
	if pfids: fields["pfids"] = pfids
	if city: fields["city"] = city
	if thumbpath: fields["thumbpath"] = thumbpath

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

def sync_events_to_djs( connection= None ):

	# get raw event objects...
	evts = get_events( connection )

	# iterate events...
	for evt in evts:
			
		if not evt.has_key("name"):
			continue
	
		print "INFO: event: sync_events_to_djs: event->", evt["_id"], evt["name"]
	
		# get pfids...
		pfids = evt["pfids"]

		# iterate performers...
		for pfid in pfids:
		
			print "INFO: event: sync_events_to_djs: event->", pfid
			
			info = dj.get_dj( connection, pfid )
			if info:
				retv = dj.update_dj_event( connection, pfid, evt["_id"] )
				if not retv:
					DBG("ERROR: event: sync_events_to_djs: cannot update event to dj->", pfid, evt["_id"] )

	return True

#
# Func to create/update the date index...
#
def create_date_index_field( connection = None, force = False ):
	
	DBG("INFO: Getting all items")

	evts = get_events( connection )

	for evt in evts:
		if evt.has_key( "dti" ) and not force:
			continue

		if (evt.has_key("eventdate")):
			dtstr = evt["eventdate"]
		else:
			DBG("WARNING: Invalid date!")
			dtstr = "1/1/2000"		
		dt = parser.parse(dtstr)				

        	# create fields dct...
        	fields = {}
		fields['eventdate'] = dtstr
		fields['dti'] = dt
	
        	# update...
		DBG("INFO: Creating date index field for->", evt["_id"])

		events = _get_event_col ( connection )
		uevt = {"_id":evt["_id"]}
        	uid = events.update( uevt, { '$set':fields } , True )
        	if ( uid ):
			DBG("ERROR: Cannot update date index field for object->", evt["_id"], str(uid) )
                	return False

	# Make sure the column is indexed...
	print events.ensure_index("dti")
	
#
# unit test...
#
if __name__ == "__main__":

	global VERBOSE
	validate = False

	# possibly clear events...
	if len(sys.argv)>1 and ( sys.argv[1]=="clear" ):
		DBG( "WARNING: clearing events..." )
		clear_all( None)
		sys.exit(0)

	# sync event to dj...
	if (len(sys.argv)>1) and ( sys.argv[1]=="sync_to_djs"):
		DBG( "WARNING: syncing to dj..." )
		sync_events_to_djs( None )
		sys.exit(0)

	# possibly also validate event...
	elif len(sys.argv)>1 and ( sys.argv[1]=="validate" ):
		validate = True

	# create date index...
	elif len(sys.argv)>1 and (sys.argv[1]=="date_index"):
		VERBOSE = True
		create_date_index_field(None,True)	
		sys.exit(0)	

	# get connection...
	conxn = _get_connection()

	# simulate a device gps...
	loc = None
	if validate:
		loc = {'lat':0.1,'lng':0.2}

	# get all events...
	events = get_events_details( conxn, loc, None, None, True, 0 )
	DBG( "INFO: There are %d events" % len(events[0]) )

	# iterate...
	for evt in events[0]:

		venuename = None
		if evt.has_key("venuename"):
			venuename = evt["venuename"]
		
		cty = None
		if evt.has_key("city"):
			cty = evt["city"]

		DBG( "INFO: event->", evt["id"], evt["name"], evt["pf"], evt["pfids"], \
			evt["eventdate"], venuename, cty, evt["dist"], evt["eventdate"], \
			evt["dti"] )
		if validate:
			if evt["dist"] == 0:
				DBG( "ERROR: event: invalid dist" )
				sys.exit(1)
	
	DBG( "INFO: There are %d events" % len(events[0]) )

	DBG( "INFO: Done." )
	
