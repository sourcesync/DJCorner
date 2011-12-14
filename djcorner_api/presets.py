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
        "Pacha Buenos Aires":[[-34.550221,-58.427782],"Pacha","Buenos Aires"], \
        "Stereo":[[45.51611,-73.558238],"Stereo","Montreal"], \
        "The Kool Haus":[[43.644261,-79.368383],"The Kool Haus","Toronto"], \
        "Le Queen":[[48.871705,2.302719],"Le Queen","Paris"], \
        "Tresor":[[52.510537,13.418716],"Tresor","Berlin"], \
        "Cavo Paradiso":[[51.523538,-0.11879],"Cavo Paradiso","Mykanos"], \
        "Paradiso":[[52.36227,4.883943],"Paradiso","Amsterdam"], \
        "AgeHa":[[35.64222,139.82531],"AgeHa","Tokyo"], \
        "Pacha":[[40.763966,-73.996911],"Pacha NYC", "New York City"], \
        "Fabrik":[[40.26493,-3.840789],"Fabrik","Madrid"], \
        "Fabric":[[51.519571,-0.102557], "Club Fabric", "London" ], \
        "LIzard Lounge":[[32.78492,-96.790433], "Lizard Lounge", "Dallas" ], \
        "Surrender":[ [ 36.130163,-115.165134 ], "Club Surrender", "Las Vegas"], \
        "Avalon":[ [ 34.102717,-118.327126 ], "Club Avalon", "Los Angeles"], \
        "Set":[ [ 25.790562,-80.130935 ], "Club Set", "Miami"], \
        "Pacha Ibiza":[[38.917867,1.444058],"Pacha Ibiza","Ibiza"], \
        "Voyeur":[[32.71334,-117.160022],"Voyeur","San Diego"], \
	"Orfeo Superdomo":[[-31.35986,-64.226981],"Orfeo Superdomo","Buenos Aires"], \
	"Laguna Escondida":[[-34.962532,-54.948957],"Laguna Escondida","Punta del Este"], \
	"Green Valley":[[-27.037492,-48.625445],"Green Valley","Camboriu" ], \
	"Amsterdam Rai":[[52.34099,4.889646],"Amsterdam Rai","Amsterdam"], \
	"xoyo":[[51.525714,-0.085745],"Club XoYo","London"], \
	"secret-east-london-location":[[51.525714,-0.085745],"Secret East London Location", "London" ]
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
       	#if not v.has_key("latitude"):
	if True:
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
        #if not v.has_key("ds"):
	if True:
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
        update_city = True
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

