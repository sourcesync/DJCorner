#
# Configuration...
#
VERBOSE = False

REQUIRED_FIELDS = { 	"name": type("") }
OPTIONAL_FIELDS = { 	"events": type([]), \
			"pic": type(""), \
			"rating": type(1), \
			"rel": type([]) }
#
# Code...
#

from pymongo import Connection

import os
import sys
import re
from dateutil import parser
import datetime
from datetime import timedelta

import dbglobal
import bson
import event

def DBG( *items ):
	if VERBOSE: 
		for item in items:
			print item,
		print

def _get_connection():

        # connection...
        connection = Connection()
        return connection


def _get_djs_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[dbglobal.DBNAME]

        # collection...
        djs = db['djs']

        return djs

#
# func to clear all devices...
#
def clear_all( connection ):

        djs = _get_djs_col( connection )
        djs.remove()
        return True

#
# func to find a dj...
#
def find_dj( connection, name ):
	
	DBG( "INFO: dj: find_dj->", name )

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'name':name} )
	if not dj:
		return False
	else:
		return dj["_id"]

#
# func to get a dj...
#
def get_dj( connection, djid ):

	#bid = bson.objectid.ObjectId(djid)
	
	#print "INFO: dj: get_dj->", djid, bid, type(djid), type(bid)

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'_id':djid} )

	return dj


#
# func to add dj object...
#
def add_dj( connection, name ):

	DBG("INFO: dj: add_dj->", name)

	if name==None or name.strip()=="":
		DBG("ERROR: Invalid dj name->", name)
		return [ False, None ]

	name = name.strip()

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'name':name} )
	if ( dj != None ):
		return [ False, dj["_id"] ]

	# create a dj object...
        dj = { 'name':name, 'status':0 }

        # add to collection...
        oid = djs.insert( dj )

        return [ True, oid ]

#
# func to add follow dj object...
#
def add_djs( connection, djs ):

	for dj in djs:
		add_dj( connection, dj )

	return True

#
# func to update dj...
#
def update_dj( connection=None, djid=None, name=None, pic=None, events=None, related=None, rating=None ):

	if djid==None:
		DBG("ERROR: dj: Invalid djid")
		return False

        # get djs collection...
        djs = _get_djs_col( connection )

	# create an obj from id...
	obj = {}
	obj["_id"] = djid

	# create dct with new fields...	
	fields = {}
	if name!=None: fields["name"] = name
	if pic!=None: fields["pic"] = pic
	if events!=None: fields["events"] = events
	if related!=None: fields["rel"] = related
	if rating!=None: fields["rating"] = rating

        # update...
        status = djs.update( obj, { '$set':fields } , True )
        if ( status ): 
		DBG("ERROR: dj: update_dj: mongo update failed->", status)
		return False  # means an error

	return True

#
# func to link dj event...
#
def update_dj_event( connection, djid, eoid ):

	if type(eoid)!=type( bson.objectid.ObjectId() ):
		DBG( "ERROR: dj: event id not right type")
		return False

	djobj = get_dj( connection, djid )
	if not djobj:
		DBG( "ERROR: dj: no dj by that id->", djid )
		return False

	events = []
	if djobj.has_key("events"):
		events = djobj["events"]
		print "DJEVENTS->", djobj["name"], events

	if eoid in events:
		DBG( "INFO: dj: event already present" )
		return True

	events.append(eoid)

	status = update_dj( connection, djid, None, None, events, None, None )
	if not status:
		DBG( "ERROR: dj: cannot update events" )
		return False
	else:
		return True

#
# func to get all djs...
#
def get_djs( connection ):

	# get djs collection...	
	djs = _get_djs_col( connection )

	# sanitize for web service...
	pfs = []
	for dj in djs.find():
		pfs.append( dj )

	return pfs

def _djssort(a,b):
	na = a["name"]
	nb = b["name"]
	if (na<nb): return -1
	elif (na>nb): return 1
	else: return 0

#
# func to get follow dj details...
#
def get_dj_details( connection, djid ):

        # get djs collection...
        djs = _get_djs_col( connection )

	bid = bson.objectid.ObjectId( djid )
	obj = djs.find_one( { "_id":bid } )
	if not obj:
		return False
	obj["id"] = str( obj["_id"] ) # replace id with something serializable...
	del obj["_id"] # delete old one...
	
	if obj.has_key("events"):
		del obj["events"] # delete events...
	return obj
	
#
# func to get dj details...
#
def get_djs_details( connection, searchrx, all, paging ):

	# get djs collection...	
	djs = _get_djs_col( connection )

	# sanitize for web service...
	pfs = []

	# get all, or use regex...	
	if searchrx == None or searchrx.strip() == "":
		results = djs.find()
	else:
		regex = ".*%s.*" % searchrx
		results = djs.find( {"name": re.compile(searchrx,re.IGNORECASE) } )
		
	for dj in results:
		
		# deal with the id...
		dj["id"] = str( dj["_id"] ) # replace id with something serializable...
		del dj["_id"] # delete old one...

		# deal with events...
		if dj.has_key("events"):
			dj["events"] = [ str(a) for a in dj["events"] ]
		else:
			dj["events"] = []

		# get upcoming date...
		dj["upcoming"] = "No upcoming events"
		upcoming = get_upcoming( connection, bson.objectid.ObjectId( dj["id"] ) )
		if upcoming:
			dj["upcoming"] = "Next Event: %s %s" % ( upcoming["city"], upcoming["eventdate"] )
	
		# possibly filter by dj rating...	
		if not all:  # use rating...
			rating = None
			if dj.has_key("rating"):
				rating = dj["rating"]
			if rating!=None and rating>=0 and rating <= 50:
				pfs.append( dj )
		else: # no, return all...
			pfs.append( dj )

	# sort
	pfs.sort( _djssort )

	# deal with paging...
        if (paging):
                total = len( pfs )
                start = paging["start"]
                end = paging["end"]
                arr = pfs[start:end]
                count = len(arr)
		if count<(end-start+1): end=total-1
                info = { "total":total, "count":count, "start":start, "end":end }
                return [ arr, info ]
        else:
                return [ pfs, {} ]

#
# func to get upcoming date...
#
def get_upcoming( connection, djid ):

	schedule = get_schedule( connection, djid )
	if schedule == False:
		DBG("WARNING: Could not get dj schedule")
		return None
	elif len(schedule)==0:
		return []
	else:
		return schedule[0]
	
#
# func to get dj schedule...
#
def get_schedule( connection, djid ):

	DBG("INFO: dj: get_schedule: djid->", djid, type( djid ) )
	
	# get djs collection...	
	djs = _get_djs_col( connection )

	# get the dj...
	obj = djs.find_one( { '_id': bson.objectid.ObjectId(djid) } )
	if not obj: 
		DBG("WARNING: dj: get_schedule: no dj by that id->", djid, type(djid))
		return False

	# get events...
	if ( not obj.has_key("events") ):
		DBG("WARNING: dj: get_schedule: dj has no events field->", djid, type(djid), obj)
		return []

	schedule = []

	eoids = obj["events"]

	DBG("INFO: dj: get_schedule: eiods->", eoids)

	# iterate through events and get the schedule...
	for eoid in eoids:
		evt = event.get_event_details( connection, None, eoid, False)

		# don't include old events...
                edt = evt["eventdate"]
                dt = parser.parse( edt )
                if (  datetime.datetime.today() - dt ) > timedelta( days=1 ):
                        DBG( "WARNING: event: event already happened" )
                        continue

		DBG("INFO: dj: get_schedule: evt->", evt)
		city = None
		if evt.has_key("city"):
			city = evt["city"]
		sched = { "eid": evt["id"], "city": city, "eventdate":evt["eventdate"] }
		schedule.append( sched )

	return schedule
	
#
# func to remove dj...
#
def remove_dj( connection, name ):

	djs = _get_djs_col( connection )

	follow = djs.find_one( { 'name':name } )
	if not follow:	
		return False

        status = djs.remove( follow, True )
        if status["err"]:
                return False
        else:
                return True
	
#
# func to make djs similar...
#
def relate_djs( connection, dja, djb ):
	if type(dja)==type(""):
		djas = dja
		dja = bson.objectid.ObjectId(dja)
	else:
		djas = str(dja)
	if type(djb)==type(""):
		djbs = djb
		djb = bson.objectid.ObjectId(djb)
	else:
		djbs = str(djb)

	# update a...
	obja = get_dj(connection,dja)
	if not obja:
		return False
	relateda = []
	if obja.has_key("rel"):
		relateda = obja["rel"]
	if not djbs in relateda:
		relateda.append(djbs)
	status = update_dj( connection, dja, None, None, None, relateda )
	if not status:
		return False
		
	# update b...
	objb = get_dj(connection,djb)
	if not objb:
		return False
	relatedb = []
	if objb.has_key("rel"):
		relatedb = objb["rel"]
	if not djas in relatedb:
		relatedb.append(djas)
	status = update_dj( connection, djb, None, None, None, relatedb )
	if not status:
		return False

	return True

#
# func to get similar djs...
#
def get_similar_djs( connection, djid ):

	if type(djid)==type(""):
		djid = bson.objectid.ObjectId(djid)

	obj = get_dj( connection, djid )
	if not obj:
		return False

	related = []
	if obj.has_key("rel"):
		related = obj["rel"]

	items = []
	for rel in related:
		bid = bson.objectid.ObjectId(rel)
		tobj = get_dj( connection, bid )
		item = { "name": tobj["name"], "id":rel }
		items.append(item)

	#items = [ {"name":"yo","id":"4ef692b57289ce1de800003a"}, \
	#{"name":"yo","id":"4ef692b57289ce1de800003a"}]

	return items	

#
# 
#
if __name__ == "__main__":

	if len(sys.argv)>1 and sys.argv[1] == "clear":
		print "WARNING: Clearing all djs..."
		clear_all(None)
	
	elif  len(sys.argv)>1 and sys.argv[1] == "schedule":
		bid = bson.objectid.ObjectId(sys.argv[2])
		djs = get_schedule( None, bid )
		print djs
		sys.exit(0)
	
	elif  len(sys.argv)>1 and sys.argv[1] == "relate":
		aid = bson.objectid.ObjectId(sys.argv[2])
		bid = bson.objectid.ObjectId(sys.argv[3])
		status = relate_djs( None, aid, bid )
		print status
		sys.exit(0)
	
	elif  len(sys.argv)>1 and sys.argv[1] == "get":
		bid = bson.objectid.ObjectId(sys.argv[2])
		obj = get_dj_details( None, bid )
		print obj
		sys.exit(1)

	elif  len(sys.argv)>1:
		djs = get_djs_details( None, sys.argv[1], True, None )
		print djs
		sys.exit(1)

	info = get_djs_details( None, None, True, None )
	djs = info[0]
	for djobj in djs:
		print "INFO: dj: ->", djobj["id"], djobj["name"], djobj["events"], djobj["pic"]
		if djobj.has_key("rating"):
			print "rating=" +  str(djobj["rating"]),
		print
		schedule = get_schedule( None, djobj["id"] )
		print "INFO: dj: schedule->", djobj["name"], schedule

	print "INFO: Done."

