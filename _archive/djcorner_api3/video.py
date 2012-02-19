#
# Configuration...
#


#
# Code...
#
import sys
from dateutil import parser
import datetime

from pymongo import Connection

import venue
import common

def _get_connection():
        
        # connection...
        connection = Connection()
        return connection       


def _get_video_col( connection ):
        
        # connection...
        if not connection:
                connection = Connection()

        # dbase...
        db = connection[DBNAME] 

        # collection...
        videos = db['videos']

        return videos


#
# func to get videos...
#
def get_videos( connection, paging ):

	 = { "date":"Dec 31 2011", "dj":"DJ Logic",  "djlink":"http://www.google.com", \
		"location":"New York,NY", "tix":"http://www.google.com" }

        videos = _get_video_col( connection )

        # iterate over collection...
        retv = []
        for video in videos.find():
                retv.append( video )

        return retv

#
# func to add video...
#
def add_video( connection, name ):
	
	videos  = _get_video_col( connection )

        if (name):
                # see if there is already this name by vendorid...
                evt = events.find_one( {'vendorid':vendorid} )
                if (evt != None):
                        return [ False, evt["_id"] ]

        # create an event...
        event = { "name": name }

        if vendorid: event["vendorid"] = vendorid

        # add to collection...
        oid = events.insert( event )

        return [ True, oid ]
	
	

	

