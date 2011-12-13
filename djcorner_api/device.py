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


def _get_device_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[DBNAME]

        # collection...
        devices = db['devices']

        return devices

#
# func to clear all devices...
#
def clear_all( connection ):

        devices = _get_device_col( connection )
        devices.remove()
        return True


#
# func to add device...
#
def add_device( connection, deviceid ):

	devices = _get_device_col( connection )

	# see if there is already this venue by vendorid...
	device = devices.find_one( {'deviceid':deviceid} )
	if ( device != None ):
		return [ False, device["_id"] ]

        # create a device...
        device = { "name": name }

        if deviceid: venue["deviceid"] = deviceid

        # add to collection...
        oid = devices.insert( device )

        return [ True, oid ]


