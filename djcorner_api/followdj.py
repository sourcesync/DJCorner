#
# Configuration...
#
DBNAME = "djcorner"

#
# Code...
#

from pymongo import Connection

import sys

def _get_connection():

        # connection...
        connection = Connection()
        return connection


def _get_followdjs_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[DBNAME]

        # collection...
        followdjs = db['followdjs']

        return followdjs

#
# func to clear all devices...
#
def clear_all( connection ):

        followdjs = _get_followdjs_col( connection )
        followdjs.remove()
        return True


#
# func to add follow dj object...
#
def add_followdj( connection, deviceid, dj ):

	followdjs = _get_followdjs_col( connection )

	followdj = devices.find_one( {'deviceid':deviceid, 'dj':dj } )
	if ( followdj != None ):
		return [ False, device["_id"] ]

	# create a follow object...
        followdj = { "deviceid": deviceid , 'dj':dj }

        # add to collection...
        oid = followdjs.insert( followdj )

        return [ True, oid ]

#
# func to get follow dj details...
#
def get_followdjs_details( connection, deviceid ):

	# get djs collection...	
	followdjs = _get_followdjs_col( connection )

	# sanitize for web service...
	fdjs = []
	for fdj in followdjs.find():
		del fdj["_id"]
		fjds.append( fdj )

	return fdjs

#
# 
#
if __name__ == "__main__":

	fdjs = get_followdjs_details( None, None )

	print "INFO: followdj: followjds->", fdjs

	print "INFO: Done."

