#
# Configuration...
#

VENUE_LOCATIONS = { \
        "pier-94": [ [ 40.785221,-73.998413 ], "Pier 94"], \
        "pacha-london": [ [51.497389,-0.144024], "Pacha London"], \
        "kensington-close-hotel-and-spa": [[ 51.499193,-0.191832 ], "Kensington Close Hotel"], \
        "lo-profile":[[51.523538,-0.11879], "Club Lo-Profile" ], \
        "brabanthallen": [[51.715118,5.290947], "Club Brabanthallen"], \
        "the-coronet-theatre":[[51.495252,-0.09892], "Coronet Theatre"], \
        "egg":[[51.543986,-0.124798], "Club Egg" ],\
        "audio":[[50.836083,-0.134583], "Club Audio"],\
	"fire":[[51.49111,-0.12291],"Club Fire"], \
	"pacha-nyc":[[40.763966,-73.996911],"Pacha NYC"], \
	"Pacha NYC":[[40.763966,-73.996911],"Pacha NYC"], \
	"Lavo NYC":[[40.766372,-73.971462],"Lavo NightClub"], \
	"Sullivan Room":[[40.73243,-74.00013],"Sullivan Room"], \
	"link":[[44.517317,11.413937],"Club Link"] \
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

#
# Clear all events...
#
#print "INFO: Clearing all events..."
#status = event.clear_all( None )
#if not status:
#print "ERROR: Could not clear events"
#sys.exit(1)

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
		status = venue.update_venue( None, void, None, loc[0], loc[1], None )
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
		status = venue.update_venue( None, void, None, None, None, ds )
                if not status:
                        print "ERROR: Cannot update display name for venue"
                        sys.exit(1)

	print "INFO: Venue is ok->", v["name"]
