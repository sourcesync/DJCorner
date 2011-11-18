#
# Configuration...
#

from pymongo import Connection

# 
# Code...
#

#
# Get all users...
#
def get_videos( connection, paging ):

	# get cursor on collection...
	if not connection:
		connection = Connection()
	db = connection["djcorner"]
	videos = db.videos
	cs = videos.find()

	# iterate cursor and collect info...
	info = []
	for video in cs:
		info.append( video )

	return info


