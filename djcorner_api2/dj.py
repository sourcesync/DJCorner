#
# Configuration...
#
DBNAME = "djcorner2"

#
# Code...
#

from pymongo import Connection

import os
import sys

import event

def _get_connection():

        # connection...
        connection = Connection()
        return connection


def _get_djs_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[DBNAME]

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
	
	print "INFO: dj: find_dj->", name

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'name':name} )

	return dj

#
# func to get a dj...
#
def get_dj( connection, djid ):
	
	print "INFO: dj: get_dj->", djid

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'_id':djid} )

	return dj


#
# func to add dj object...
#
def add_dj( connection, name ):

	print "INFO: dj: add_dj->", name

	if name==None or name.strip()=="":
		print "ERROR: Invalid dj name->", name
		return [ False, None ]

	name = name.strip()

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'name':name} )
	if ( dj != None ):
		return [ False, dj["_id"] ]

	# create a dj object...
        dj = { 'name':name }

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
def update_dj( connection, djid, name, events ):

        # get djs collection...
        djs = _get_djs_col( connection )

	# create an obj from id...
	obj = {}
	obj["_id"] = djid

	# create dct with new fields...	
	fields = {}
	if name!=None: fields["name"] = name
	if events!=None: fields["events"] = events

        # update...
        uid = djs.update( obj, { '$set':fields } , True )
        if ( uid ): return False
        else: return True

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

#
# func to get follow dj details...
#
def get_djs_details( connection, paging ):

	# get djs collection...	
	djs = _get_djs_col( connection )

	# sanitize for web service...
	pfs = []
	for dj in djs.find():
		del dj["_id"]
		pfs.append( dj )

	# deal with paging...
        if (paging):
                total = len( pfs )
                start = paging["start"]
                end = paging["end"]
                arr = pfs[start:end]
                count = len(arr)
                info = { "total":total, "count":count, "start":start, "end":end }
                return [ arr, info ]
        else:
                return [ pfs, {} ]


#
# func to get dj schedule...
#
def get_schedule( connection, djid ):
	
	# get djs collection...	
	djs = _get_djs_col( connection )

	# get the dj...
	obj = djs.find_one( { '_id':djid } )
	if not obj: return None

	# get events...
	if ( not obj.has_key("events") ):
		return None

	schedule = []
	eoids = obj["events"]

	# iterate through events and get the schedule...
	for eoid in eoids:
		evt = event.get_event_details( None, None, eoid, False)
		sched = { "city": evt["city"], 	"eventdate":evt["eventdate"] }
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
# 
#
if __name__ == "__main__":

	if len(sys.argv)>1 and sys.argv[1] == "clear":
		print "WARNING: Clearing all djs..."
		clear_all(None)

	djs = get_djs( None )

	print "INFO: dj: djs->", djs

	for djobj in djs:
		print "INFO: dj: ->", djobj
		schedule = get_schedule( None, djobj["_id"] )
		print "INFO: dj: schedule->", djobj["name"], schedule

	details = get_djs_details( None, None )
	print "INFO: dj: get_djs_details->", details

	print "INFO: Done."

