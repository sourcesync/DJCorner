#
# Configuration...
#


#
# Code...
#
import users
import videos
import json

#
# Func to get all users...
#
def get_users( session, paging ):
	return users.get_users( None, paging )

#
# Func to get all videos...
#
def get_videos( session, paging ):
	return videos.get_videos( None, paging )


#
# Func to get all events...
#
def get_events( session, paging ):
	return events.get_events( None, paging )
