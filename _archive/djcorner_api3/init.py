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
	"bond":[[51.523538,-0.11879],"Club Bond","London"], \
	"Pacha Buenos Aires":[[51.523538,-0.11879],"Pacha","Buenos Aires"], \
	"Stereo":[[51.523538,-0.11879],"Stereo","Montreal"], \
	"The Kool Haus":[[51.523538,-0.11879],"The Kool Haus","Toronto"], \
	"Le Queen":[[51.523538,-0.11879],"Le Queen","Paris"], \
	"Tresor":[[51.523538,-0.11879],"Tresor","Berlin"], \
	"Cavo Paradiso":[[51.523538,-0.11879],"Cavo Paradiso","Mykanos"], \
	"Paradiso":[[51.523538,-0.11879],"Paradiso","Amsterdam"], \
	"AgeHa":[[51.523538,-0.11879],"AgeHa","Tokyo"], \
	"Pacha":[[40.763966,-73.996911],"Pacha NYC", "New York City"], \
	"Fabrik":[[51.523538,-0.11879],"Fabrik","Madrid"], \
	"Fabric":[[51.523538,-0.11879], "Club Fabric", "London" ], \
	"LIzard Lounge":[[40.791638,-74.254189], "Lizard Lounge", "Dallas" ], \
	"Surrender":[ [ 40.785221,-73.998413 ], "Club Surrender", "Las Vegas"], \
	"Avalon":[ [ 40.785221,-73.998413 ], "Club Avalon", "Los Angeles"], \
	"Set":[ [ 40.785221,-73.998413 ], "Club Set", "Miami"], \
	"Pacha Ibiza":[[51.523538,-0.11879],"Pacha Ibiza","Ibiza"]
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
import presets

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
		print "WARNING: User already exists..."

	print "INFO: updating user..."
	status = user.update_user( None, em, fn, mn, ln, lat, lng )
	if not status:
		print "ERROR: Could not update user"

	print "INFO: User is ok->", em

#
# Validate/fixup venues...
#
if ( not presets.fixup_venues( ) ):
	print "ERROR: Cannot validate/fixup venues..."
	sys.exit(1)


#
# Validate/fixup events...
#
if ( not presets.fixup_events( ) ):
	print "ERROR: Cannot validate/fixup events..."
	sys.exit(1)

sys.exit(0)

