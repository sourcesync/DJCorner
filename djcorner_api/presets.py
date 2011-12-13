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

#
# Program...
#
import venue
import event
from dateutil import parser
from datetime import datetime
from pymongo.objectid import ObjectId

def fixup_venues():
	#
	# Make sure venues have lat long...
	#
	venues = venue.get_venues( None, None )
	for v in venues:
		if ( not fixup_venue( v ) ):
			print "ERROR: preset: Cannot fixup venue->", v
			return False

	return True

def fixup_venue(v):

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
			return False
               	loc = VENUE_LOCATIONS[vname][0]

               	# update in dbase...
               	print "INFO: updating venue loc->", vname, loc
               	status = venue.update_venue( None, void, None, loc[0], loc[1], None, None )
               	if not status:
                       	print "ERROR: Cannot update location for venue"
			return False

        # see if venue has display name info in dbase...
        if not v.has_key("ds"):
                # get ds info...
                if not VENUE_LOCATIONS.has_key(vname):
                        print "ERROR: No ds information for venue."
			return False
                ds = VENUE_LOCATIONS[vname][1]

                print "WARNING: Venue in dbase is missing display name information", v
                status = venue.update_venue( None, void, None, None, None, ds, None )
                if not status:
                        print "ERROR: Cannot update display name for venue"
			return False

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
			return False

        print "INFO: Venue is ok->", v["name"]

	return True

def fixup_events():
	#
	# Make sure events have proper date format...
	#
	events_info = event.get_events_details( None, None, None, None )

	events = events_info[0]
	#print len(events)

	for evt in events:
		if ( not fixup_event( evt ) ):
			print "ERROR: cannot fixup event..."
			return False

	return True


def fixup_event(evt):

	# check start date...  
       	if not evt.has_key("startdate"):
               	evt["startdate"] = "12/31/2011"
       	print "INFO: start event date->", evt["startdate"]
       	stdt = evt["startdate"]
       	dt = parser.parse( stdt )
       	sdstr = None
       	try:
               	dt = datetime.strptime( stdt, "%Y-%m-%dT%H:%M:%S+00:00" )
       	except:
               	print "WARNING: INVALID START DATE FORMAT...FIXING..."
               	sdstr = dt.strftime( "%Y-%m-%dT%H:%M:%S+00:00" )
		
        # check end date...
        if not evt.has_key("enddate"):
                evt["enddate"] = "1/1/2012"
        print "INFO: end event date->", evt["enddate"]
        etdt = evt["enddate"]
        dt = parser.parse( stdt )
        edstr = None
        try:
                dt = datetime.strptime( etdt, "%Y-%m-%dT%H:%M:%S+00:00" )
        except:
                print "WARNING: INVALID END DATE FORMAT...FIXING..."
                edstr = dt.strftime( "%Y-%m-%dT%H:%M:%S+00:00" )

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
                print "WARNING: Event in dbase is getting city information", city, oid, eoid, type(evt["_id"]), sdstr, edstr
                status = event.update_event( None, eoid, None, None, None, None, None, None, sdstr, edstr, None, None, city)
                if not status:
                        print "ERROR: Cannot update city for venue"
			return False

                # check it...
                revt = event.get_event_details( None, None, eoid,  None )
                print "REPEATING->", revt

	return True

