#
# Configuration...
#

VENUE_LOCATIONS = { \
        "pier-94": [ [ 40.785221,-73.998413 ], "Pier 94", "New York City"], \
        "pacha-london": [ [51.497389,-0.144024], "Pacha London", "London"], \
        "kensington-close-hotel-and-spa": [[ 51.499193,-0.191832 ], "Kensington Close Hotel", "London"], \
        "lo-profile":[[51.523538,-0.11879], "Club Lo-Profile", "London" ], \
        "brabanthallen": [[51.715118,5.290947], "Club Brabanthallen", "London"], \
        "the-coronet-theatre":[[51.495252,-0.09892], "Coronet Theatre", "London"], \
        "egg":[[51.543986,-0.124798], "Club Egg", "London"],\
        "audio":[[50.836083,-0.134583], "Club Audio", "London"],\
	"fire":[[51.49111,-0.12291],"Club Fire", "London"], \
	"pacha-nyc":[[40.763966,-73.996911],"Pacha NYC", "New York City"], \
	"Pacha NYC":[[40.763966,-73.996911],"Pacha NYC", "New York City"], \
	"Lavo NYC":[[40.766372,-73.971462],"Lavo NightClub", "New York City"], \
	"Sullivan Room":[[40.73243,-74.00013],"Sullivan Room", "New York City"], \
	"link":[[44.517317,11.413937],"Club Link", "Bologna"], \
	"zoom":[[54.281224,-0.404263],"Club Zoom", "Toronto"], \
	"hidden":[[51.490469,-0.121515],"Club Hidden", "London"], \
	"4sixty6":[[40.791638,-74.254189], "Club 4Sixty6","New Jersey"], \
	"revolution":[[40.791638,-74.254189], "Club Revolution", "New York City" ], \
	"bond":[[51.523538,-0.11879],"Club Bond","London"]
	}

SYN_GROUPS = [ [ "pacha-nyc", "Pacha NYC" ] ]

INIT_USERS = [ \
	[ "george.williams@gmail.com", "George","","Williams", 40.731519,-73.997555  ] ]

#
# Program...
#

import sys
import venue
import user
import event
import clubtickets
from dateutil import parser
from datetime import datetime
from pymongo.objectid import ObjectId 

#
# Clear all events...
#
CLEAR_EVENTS = False
if CLEAR_EVENTS:
	print "INFO: Clearing all events..."
	status = event.clear_all( None )
	if not status:
		print "ERROR: Could not clear events"
	sys.exit(1)

#
# Populate from clubtickets...
#

#
# Make sure we have the init users...
#
for init_user in INIT_USERS:
	em = init_user[0]
	fn = init_user[1]
	mn = init_user[2]
	ln = init_user[3]
	lat = init_user[4]
	lng = init_user[5]
	[ status , uiod ] = user.add_user( None, em )
	if not status:
		print "WARNING: user already exists..."

	print "INFO: updating user..."
	status = user.update_user( None, em, fn, mn, ln, lat, lng )
	if not status:
		print "ERROR: could not update user"

	print "INFO: User is ok->", em
#
# Make sure venues have lat long...
#
venues = venue.get_venues( None, None )
for v in venues:
       
	# get venue id...         
	void = v["_id"]
	# get venue name...
	vname = v["name"]

	print "INFO: venue object-", v

        # see if venue has loc info in dbase...
        if not v.has_key("latitude"):
                print "WARNING: Venue in dbase is missing location information", v

                # get loc info...
                if not VENUE_LOCATIONS.has_key(vname):
                        print "ERROR: No location information for venue."
                        sys.exit(1)
                loc = VENUE_LOCATIONS[vname][0]

                # update in dbase...
                print "INFO: updating venue loc->", vname, loc
		status = venue.update_venue( None, void, None, loc[0], loc[1], None, None )
                if not status:
                        print "ERROR: Cannot update location for venue"
                        sys.exit(1)
               
	# see if venue has display name info in dbase... 
        if not v.has_key("ds"):
                # get ds info...
                if not VENUE_LOCATIONS.has_key(vname):
                        print "ERROR: No ds information for venue."
                        sys.exit(1)
                ds = VENUE_LOCATIONS[vname][1]

                print "WARNING: Venue in dbase is missing display name information", v
		status = venue.update_venue( None, void, None, None, None, ds, None )
                if not status:
                        print "ERROR: Cannot update display name for venue"
                        sys.exit(1)

	# see if venue has city..
	update_city = False
	if not v.has_key("city"):
		update_city = True
	elif v["city"].strip() == "":
		update_city = True
	if (update_city):
		city = VENUE_LOCATIONS[vname][2]
                print "WARNING: Venue in dbase is missing city information", v, city
                status = venue.update_venue( None, void, None, None, None, None, city )
                if not status:
                        print "ERROR: Cannot update city for venue"
                        sys.exit(1)

	print "INFO: Venue is ok->", v["name"]

#
# Make sure events have proper date format...
#
events_info = event.get_events_details( None, None, None, None )

#print events
#sys.exit(1)

events = events_info[0]
print len(events)

for evt in events:
	print "INFO: evt type->", type(evt), evt.keys()

	# check start date...	
	print "INFO: start event date->", evt["startdate"]
	stdt = evt["startdate"]
	dt = parser.parse( stdt )
	dt = datetime.strptime( stdt, "%Y-%m-%dT%H:%M:%S+00:00" )
	print dt

	# check end date...	
	print "INFO: end event date->", evt["enddate"]
	stdt = evt["enddate"]
	dt = parser.parse( stdt )
	dt = datetime.strptime( stdt, "%Y-%m-%dT%H:%M:%S+00:00" )

	# check city...
	update_city = True
		
	if (update_city):
                venueid = evt["venueid"]
		oid = ObjectId(venueid)
                vn = venue.get_venue( None, oid )
                city = vn["city"]
		print
		print
		eoid = ObjectId( evt["_id"] )
		print "WARNING: Event in dbase is getting city information", city, oid, eoid, type(evt["_id"])
		status = event.update_event( None, eoid, None, None, None, None, None, None, None, None, None, None, city)
		if not status:
			print "ERROR: Cannot update city for venue"
			sys.exit(1)
		# check it...
		revt = event.get_event_details( None, None, eoid,  None )
		print "REPEATING->", revt
