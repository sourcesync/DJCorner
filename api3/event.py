#T
# Configuration...
#

DBNAME = "djcorner3"

#
# Program...
#
import sys
from dateutil import parser
import datetime

from pymongo import Connection

import venue
import common
import dj

def _get_connection():
	
	# connection...
        connection = Connection()
	return connection	


def _get_event_col( connection ):
	
	# connection...
	if not connection:
        	connection = Connection()

        # dbase...
        db = connection[DBNAME] 

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


def fix_event_details(event_details):
	if (True):
	        # HACK: fixup pf...
                pfs = event_details["pf"]
                newpfs = ""
                pfids = ""
                for pf in pfs:
                        if pf==None:
                                print "WARNING: FIX None entry in event pf field"
                                continue
                        #print "INFO: event: get_events_details: pf->", pf, pfs
                        djobj = dj.get_dj( None, pf )
                        pfid = str( djobj["_id"] )
                        pfids += pfid + ";"
                        newpfs += djobj["name"] + ";"
                if newpfs.endswith(";"): newpfs = newpfs[0:-1]
                if pfids.endswith(";"): pfids = pfids[0:-1]

                event_details["pf"] = newpfs
                event_details["pfids"] = pfids

	return event_details

#
# func to get all event info...
#
def get_event_details( connection, location, oid, verbose ):

	event = get_event( connection, oid )
	#print "INFO: event: get_event->", event

	# fixup venue related fields...
	if event.has_key("venueid"):

		# get the linked venue...
		venueid = event["venueid"]
		vn = venue.get_venue( connection, venueid )

                # flatten venue information, like venue name, lat, long...
		#print "INFO: event: flattening from venue->", vn["name"], vn["city"]
		event["venueid"] = str(venueid)
                event["venuename"] = vn["ds"]
                event["latitude"] = vn["latitude"]
                event["longitude"] = vn["longitude"]

		# compute dist for this event...	
		if location and vn.has_key("latitude") and vn.has_key("longitude"):
			latitude = vn["latitude"]
			longitude = vn["longitude"]
			dist = 	common.get_distance( latitude, longitude, location["lat"], location["lng"] )
			#print dist
			event["dist"] = dist
		else:
			event["dist"] = 0

	# fix up the event date...
	if event.has_key("eventdate"):
		dt = parser.parse( event["eventdate" ] )
        	# convert to the format we want
        	cdt = dt.strftime("%a %m/%d")
		event["eventdate"] = cdt
	else:
		print "WARNING: event: get_event_details:  event has no date->", event["name"]

	# fix up description...
	if (not verbose) and event.has_key("description"):
		del event["description"]

	# fix up event name...
	ds = event["name"]
	ds = ds.replace("&amp;","&")
	event["name"]=ds

	event["_id"] = str(oid)
	event["id"] = str(oid)

	return event

#
# func to get events...
#
def get_events( connection, paging ):
	
        events = _get_event_col( connection )

	# iterate over collection...
	retv = []
	for event in events.find():
		retv.append( event )

	return retv

def _sort_by_dist( a, b ):
	da = a["dist"]
	#print "a=",da
	db = b["dist"]
	#print "db=",db
	if (da<db):	return -1
	elif (da>db):	return 1
	else:	return 0

def _sort_by_date( a, b ):
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
def get_events_details( connection, location, paging, city ):
	
	events = get_events( connection, paging )
	events_details = []

	#print "INFO: event: get_events_details:  There are %d events." % len(events)

	for evt in events:

		event_details = get_event_details( connection, location, evt["_id"], False )
	
		# HACK: fixup date
		if ( not event_details.has_key( "eventdate" ) ):
			print "WARNING: event has no date->", evt["name"]
			continue
		dtstr = event_details["eventdate" ] 
                dt = datetime.datetime.strptime(dtstr, "%a %m/%d")

		# HACK: fixup year...
		if dt.month == 12:
			dtstr = dtstr + "/11"
		elif dt.month == 11:
			dtstr = dtstr + "/11"
		else:
			dtstr = dtstr + "/12"
		# HACK...

                dt = datetime.datetime.strptime(dtstr, "%a %m/%d/%y")
		if (dt < datetime.datetime.now() ):
			print "WARNING: Event has passed.", dtstr, dt, datetime.datetime.now()
			continue

		# HACK: fixup pf...
		pfs = evt["pf"]
		newpfs = ""
		pfids = ""
		for pf in pfs:
			if pf==None:
				print "WARNING: FIX None entry in event pf field"
				continue
			#print "INFO: event: get_events_details: pf->", pf, pfs
			djobj = dj.get_dj( None, pf )
			pfid = str( djobj["_id"] )
			pfids += pfid + ";"
			newpfs += djobj["name"] + ";"
		if newpfs.endswith(";"): newpfs = newpfs[0:-1]
		if pfids.endswith(";"): pfids = pfids[0:-1]

		event_details["pf"] = newpfs
		event_details["pfids"] = pfids

                # HACK: fixup city...
                if city and (city!=""):
                        ecity = event_details["city"]
                        if (ecity == city):
                                events_details.append( event_details )
                else:
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
def update_event( connection, oid, name, venueid, description, promotor, imgpath, eventDate, startDate, endDate, buyurl, performers,city):
	
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
	if city: fields["city"] = city

	# update...
	print "SET FIELDS->", fields
	uid = events.update( event, { '$set':fields } , True )

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

	# possibly clear events...
	if len(sys.argv)>1 and ( sys.argv[1]=="clear" ):
		print "WARNING: clearing events..."
		clear_all( None)

	# get connection...
	conxn = _get_connection()

	# get all events...
	events = get_events_details( conxn, None, None, None)
	print "INFO: event: get_events_details: result->", events

	print "INFO: There are %d events" % len(events[0])

	for evt in events[0]:
		print "INFO: event->", evt["_id"], evt["name"], evt["pf"]

	print "INFO: Done."
	
