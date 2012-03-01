#
# Configuration...
#

#
# Code...
#

from pymongo import Connection

import sys
import dbglobal

def _get_connection():

        # connection...
        connection = Connection()
        return connection


def _get_device_col( connection ):

        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[dbglobal.DBNAME]

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
        device = { "deviceid": deviceid }

        # add to collection...
        oid = devices.insert( device )

        return [ True, oid ]

#
# func to get device details...
#
def get_devices_details( connection ):
	
	devices = _get_device_col( connection )

	devs = []
	for dev in devices.find():
		devs.append( dev )

	return devs


#
# 
#
if __name__ == "__main__":

	devs = get_devices_details( None )

	print "INFO: device: devices->", devs

	for dev in devs:
		print "INFO: device->", dev
	print "INFO: Done."

