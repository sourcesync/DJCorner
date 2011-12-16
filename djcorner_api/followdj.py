#
# Configuration...
#
DBNAME = "djcorner"

#
# Code...
#

from pymongo import Connection

import os
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


def _send_notification( deviceid, dj ):

	if (deviceid.startswith("<")):
		deviceid = deviceid[1:-1]

        cmd = "python apns_send.py \"%s\" %s" % ( deviceid, dj )
        print "INFO: followdj: add_followdj: send notification via cmd->", cmd
        retv = os.system(cmd)
        print "INFO: followdj: add_followdj: send notification after cmd->", retv
	

#
# func to add follow dj object...
#
def add_followdj( connection, deviceid, dj ):

	followdjs = _get_followdjs_col( connection )

	followdj = followdjs.find_one( {'deviceid':deviceid, 'dj':dj } )
	if ( followdj != None ):
		_send_notification( deviceid, dj )
		return [ False, followdj["_id"] ]

	# create a follow object...
        followdj = { "deviceid": deviceid , 'dj':dj }

        # add to collection...
        oid = followdjs.insert( followdj )

	_send_notification( deviceid, dj )

        return [ True, oid ]

#
# func to add follow dj object...
#
def add_followdjs( connection, deviceid, djs ):

	for dj in djs:
		add_followdj( connection, deviceid, dj )

	return True

#
# func to get follow dj details...
#
def get_followdjs_details( connection, deviceid ):

	# get djs collection...	
	followdjs = _get_followdjs_col( connection )
	print followdjs

	# sanitize for web service...
	fdjs = []
	for fdj in followdjs.find({'deviceid':deviceid}):
		del fdj["_id"]
		fdjs.append( fdj )

	return fdjs

#
# func to remove follow dj...
#
def remove_followdj( connection, deviceid, dj ):

	followdjs = _get_followdjs_col( connection )

	follow = followdjs.find_one( {'deviceid':deviceid, 'dj':dj } )
	if not follow:	
		return False

        status = followdjs.remove( follow, True )
        if status["err"]:
                return False
        else:
                return True
	
#
# 
#
if __name__ == "__main__":

	fdjs = get_followdjs_details( None, None )

	print "INFO: followdj: followjds->", fdjs

	for f in fdjs:
		print "INFO: followdj: ->", f

	print "INFO: Done."

