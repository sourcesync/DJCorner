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
# func to add dj object...
#
def add_dj( connection, dj ):

	djs = _get_djs_col( connection )

	dj = djs.find_one( {'dj':dj } )
	if ( dj != None ):
		return [ False, dj["_id"] ]

	# create a dj object...
        dj = { "deviceid": deviceid , 'dj':dj }

        # add to collection...
        oid = djs.insert( dj )

        return [ True, oid ]

#
# func to add follow dj object...
#
def add_djs( connection, deviceid, djs ):

	for dj in djs:
		add_dj( connection, deviceid, dj )

	return True

#
# func to get follow dj details...
#
def get_djs_details( connection  ):

	# get djs collection...	
	djs = _get_djs_col( connection )
	print djs

	# sanitize for web service...
	djs = []
	for dj in djs.find():
		del dj["_id"]
		djs.append( dj )

	return djs

#
# func to remove follow dj...
#
def remove_followdj( connection, deviceid, dj ):

	djs = _get_djs_col( connection )

	follow = djs.find_one( { 'dj':dj } )
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

	djs = get_djs_details( None, None )

	print "INFO: dj: djs->", djs

	for dj in djs:
		print "INFO: dj: ->", dj

	print "INFO: Done."

