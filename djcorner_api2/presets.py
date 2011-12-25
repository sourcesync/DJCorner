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
	"secret-east-london-location":[[51.525714,-0.085745],"Secret East London Location", "London" ], \
	"cathouse-at-the-luxor-hotel":[[36.097817,-115.175793],"CatHouse At the Luxor","Las Vegas"], \
	"highline-ballroom":[[40.744818,-74.005837],"Highline Ballroom", "New York City" ],\
	"copacabana-nightclub":[[40.761041,-73.987083],"Copacabana NightClub","New York City" ], \
	"eden-downtown":[[40.767542,-73.98674],"Eden Downtown","New York City" ], \
	"penthouse-760":[[40.73682,-73.993564],"Penthouse 760","New York City" ], \
	"Copacabana Beach":[[-22.968549,-43.179789],"Copacabana Beach","Rio de Janeiro"], \
	"Cafe Curacao":[[-22.968549,-43.179789],"Cafe Curacao", "Guaratuba" ], \
	"El Jaguel":[[-34.916658,-54.896343],"El Jaguel","Punta del Este" ], \
	"Music Park":[[-27.472924,-48.489532],"Music Park","Florianopolis"], \
	"Dubai World Trade Center":[[25.216565,55.279003],"Dubai World Trade Center","Dubai" ], \
	"PNE Colliseum":[[49.285849,-123.042712],"PNE Colliseum","Vancouver" ], \
	"The Observatory":[[33.699779,-117.919028],"The Observatory","Santa Ana" ], \
	"XS":[[36.128233,-115.167001],"XS","Las Vegas" ], \
        "Fontainebleau Pool & Arkadia":[[25.82338,-80.123978],"Fontainebleau","Miami" ], \
	"JUNO Awards":[[25.912968,-80.204659],"JUNO Awards","Miami"], \
	"Royal Dublin Society":[[53.339073,-6.228561],"Royal Dublin Socity","Dublin" ], \
	"Atlantis Hotel":[[26.133402,-80.102863],"Atlantis Hotel","Ft. Lauderdale" ], \
	"K-Arena":[[25.804837,-80.187836],"K Arena","Miami"], \
	"Kintex Convention Center":[[37.673767,126.745319],"Kintex Convention Center","South Korea"], \
	"LAVO":[[36.131879,-115.16942],"Lavo NightClub","Las Vegas"], \
	"Axis Radius":[[33.505188,-111.922359],"Axis Radius","ScottsDale" ], \
	"Wet at the W":[[25.802209,-80.127754],"W Hotel","Miami"], \
	"O2 Academy":[[53.812815,-1.547012],"O2 Academy","Leeds"] \
}

BUYURL_FIX = { \
	"4ee891de7289ce1719000000":"http://www.clubtickets.com/gb/2012-01/21/gasp-feat-italoboyz", \
	"4ee123237289ce1239000001":"http://www.clubtickets.com/us/2011-12/31/avicii-new-years-eve-2012-pier-94-nyc", \
	"4ee123237289ce1239000002":"http://www.clubtickets.com/it/2011-12/31/rebel-rave-new-year-event-damian-lazarus-clive-henry-art-department", \
	"4ee123237289ce1239000003":"http://www.clubtickets.com/gb/2011-12/31/space-presents-the-vegas-hotel-nye-2011", \
	"4ee123237289ce1239000004":"http://www.clubtickets.com/gb/2011-12/31/bond-ball-presents-the-secret-spy-soiree-the-kensington-close-hotel-spa", \
	"4ee123237289ce1239000005":"http://www.clubtickets.com/it/2011-12/31/-9733-f-9679-r-9679-e-9679-a-9679-k-9679-a-9679-d-9679-e-9679-l-9679-i-9679-k-973",\
	"4ee123437289ce12ac000000":"http://www.clubtickets.com/gb/2011-12/31/empire-state-of-mind-new-years-eve-2011", \
	"4ee123a57289ce1332000000":"http://www.clubtickets.com/gb/2011-12/31/pink-panther-party-nye-2011", \
	"4ee123e97289ce13e9000000":"http://www.clubtickets.com/gb/2011-12/31/bodymove-presents-nye-eves-white-gold-rio-carnival-2011",\
	"4ee8922d7289ce1746000000":"http://www.clubtickets.com/gb/2011-12/31/lost-cosmic-nye-party",\
	"4ee8928e7289ce17ce000000":"http://www.clubtickets.com/us/2012-02/18/chus-ceballos-present-crash-part-2", \
	"4ee123e97289ce13e9000002":"http://www.clubtickets.com/gb/2012-02/04/shit-party-reunion", \
	"4ee8928e7289ce17ce000001":"http://www.clubtickets.com/us/2012-01/14/chus-ceballos-present-crash-part-1", \
	"4ee123e97289ce13e9000003":"http://www.clubtickets.com/gb/2012-01/07/kinky-malinki", \
	"4ee123e97289ce13e9000004":"http://www.clubtickets.com/us/2012-01/01/benny-benassi-with-congorock-pacha-nyc", \
	"4ee123e97289ce13e9000005":"http://www.clubtickets.com/us/2012-01/01/apocalypse-2012-new-years-day-with-boris-victor-calderone-pier-94", \
	"4ee123e97289ce13e9000006":"http://www.clubtickets.com/us/2011-12/31/super-you-me-new-years-eve-w-laidback-luke-pacha-nyc", \
	"4ee123e97289ce13e9000007":"http://www.clubtickets.com/us/2011-12/31/super-you-me-nye-w-laidback-luke-pacha-nyc-vip-options", \
	"4ee123e97289ce13e9000008":"http://www.clubtickets.com/us/2011-12/31/chus-ceballos-new-years-eve-4sixty6", \
	"00014229":"http://www.clubtickets.com/gb/2012-01/21/gasp-feat-italoboyz", \
	"00014259":"http://www.clubtickets.com/gb/2012-01/20/technicolour-v", \
	"00014242":"http://www.clubtickets.com/us/2011-12/31/cathouse-las-vegas-nye-3rd-annual-drink-till-you-drop-party", \
	"00013660":"http://www.clubtickets.com/us/2011-12/31/avicii-new-years-eve-2012-pier-94-nyc", \
	"00014261":"http://www.clubtickets.com/us/2011-12/31/new-year-at-the-highline-ballroom", \
	"00014243":"http://www.clubtickets.com/us/2011-12/31/copacabana-new-year-s-eve-2012", \
	"00014263":"http://www.clubtickets.com/us/2011-12/31/new-years-eve-at-club-eden-downtown", \
	"00014264":"http://www.clubtickets.com/us/2011-12/31/new-years-eve-at-penthouse-760", \
	"00014152":"http://www.clubtickets.com/it/2011-12/31/rebel-rave-new-year-event-damian-lazarus-clive-henry-art-department", \
	"00013686":"http://www.clubtickets.com/gb/2011-12/31/space-presents-the-vegas-hotel-nye-2011", \
	"00014239":"http://www.clubtickets.com/us/2012-02/18/chus-ceballos-present-crash-part-2", \
	"00014265":"http://www.clubtickets.com/us/2012-02/04/pacha-nyc-presents-chris-liebing", \
	"00013981":"http://www.clubtickets.com/gb/2012-02/04/shit-party-reunion", \
	"00014247":"http://www.clubtickets.com/us/2012-01/28/pacha-nyc-presents-sander-von-doorn", \
	"00014286":"http://www.clubtickets.com/us/2012-01/27/pacha-nyc-presents-cosmic-gate", \
	"00014285":"http://www.clubtickets.com/us/2012-01/21/pacha-nyc-presents-oscar-g", \
	"00014238":"http://www.clubtickets.com/us/2012-01/14/chus-ceballos-present-crash-part-1", \
	"00014284":"http://www.clubtickets.com/us/2012-01/13/pacha-nyc-presents-arty", \
	"00014158":"http://www.clubtickets.com/gb/2012-01/07/kinky-malinki", \
	"00014200":"http://www.clubtickets.com/us/2012-01/01/benny-benassi-with-congorock-pacha-nyc", \
	"djc-Copacabana Beach":"http://www.ticketmaster.com", \
	"djc-Cafe Curacao":"http://www.cafecuracao.com.br", \
	"djc-David Guetta":"http://www.ticketmaster.com" \
}

PF_FIX = { \
	"4ee891de7289ce1719000000":"'Johnny Fiore;Gabriel amaru;Jamma;Mr Venom;Thomas James;Chris Gee;Franklin", \
	"4ee123237289ce1239000001":"Glenn Morrison;Cazzette;Arty;Avicii;Swanky Tunes", \
	"4ee123237289ce1239000002":"Damian Lazarus;Clive Henry;Art Department", \
	"4ee123237289ce1239000003":"To Be Announced", \
	"4ee123237289ce1239000004":"Victor Simonelli;Nicky Holloway;Brandon Block;Alex P;DJ Marie;Technical Twins;Danny Julian;Scott More;Pa Nick House;Harry Marks;Purple Gorilias;DJ Sting;Dan Hill;Kev Harper;Colin Dale;James McLaughlin", \
	"4ee123237289ce1239000005":"TRISTAN;ANIMATRONICA;MARIO BROSS;PULSAR;METHAPHASE;TIME IN MOTION;SHYISMA;METROYD;SUBLIMINAL POTION;ERRO;DIGITAL IMPULSE;ALION;SOLARIS PHASE;TRIP;FRASCKY;TRIPPYHIPPIES;PEACE-KA;VIRTUANOISE;ASSAULT JUNKIES;INSTINCT WAVE;MARKAYN;IL PREZ;PULSAR;MICHEL;OMEGADELTA;JIMMY 9;PSY BOY;CANSAS CITY;ELECTRICITY;OKTOPUSS;ZIGHY;KARMALOGIC;MAIKY;CISCO;JOYL",\
	"4ee123437289ce12ac000000":"Dj Suave;Dj 2", \
	"4ee123a57289ce1332000000":"DJ Simba", \
	"4ee123e97289ce13e9000000":"Karizma;Audiowhores;Anderson Noize;Tomasuchy;Darren Gregory;Justin Time;Digital Mike;Boletz;Zero C;Dani D",\
	"4ee8922d7289ce1746000000":"JUAN ATKINS;STEVE BICKNELL;CHRIS CARRIER;TOMOKI TAMURA;TORU",\
	"4ee8928e7289ce17ce000000":"DJ Chus;DJ Ceballos", \
	"4ee123e97289ce13e9000002":"Brandon Block;Slipmatt;Miss Divine;Vicky Devine;Alex Ellenger;Dermot C;Jay Moore;Lee John", \
	"4ee8928e7289ce17ce000001":"DJ Chus;DJ Ceballos", \
	"4ee123e97289ce13e9000003":"Luigi Rocca;Timo Garcia", \
	"4ee123e97289ce13e9000004":"BENNY BENASSI;Congorock", \
	"4ee123e97289ce13e9000005":"Boris;Victor Calderone", \
	"4ee123e97289ce13e9000006":"Laidback Luke", \
	"4ee123e97289ce13e9000007":"Laidback Luke", \
	"4ee123e97289ce13e9000008":"DJ Chus;DJ Ceballos", \
	"00014229":"Italoboyz;Johnny Fiore;Gabriel amaru;Jamma;Mr Venom;Thomas James;Chris Gee;Franklin", \
	"00014259":"Namito;Antonio Vinciguerra;Deegan;Jack Brazzo", \
	"00014242":"Glenn Morrison;Cazzette;Arty;Avicii;Swanky Tunes", \
	"00013660":"", \
	"00014261":"DJ L", \
	"00014243":"DJ Brinka;DJ Lucio;DJ Yoshi;Christian Jae;Scottie", \
	"00014263":"", \
	"00014264":"", \
	"00014152":"Damian Lazarus;Clive Henry;Art Department", \
	"00013686":"", \
	"00014239":"DJ Chus;DJ Ceballos", \
	"00014265":"Chris Liebing", \
	"00013981":"Brandon Block;Slipmatt;Miss Divine;Vicky Devine;Alex Ellenger;Dermot C;Jay Moore;Lee John;Marco Loco;Tristan Ingrim;Dan Jolly;Nathan Viva;Matt Carter", \
	"00014247":"Sander Von Doorn", \
	"00014286":"Emma Hewitt", \
	"00014285":"Oscar G", \
	"00014238":"DJ Chus;DJ Ceballos", \
	"00014284":"Arty", \
	"00014158":"Luigi Rocca;Timo Garcia", \
	"00014200":"BENNY BENASSI;Congorock" \
	}


#
# Program...
#
import venue
import event
from dateutil import parser
from datetime import datetime
from pymongo.objectid import ObjectId
import dj
import bson

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

def add_djs(performers):
	oids = []
	for pf in performers:
		pfadd = pf.lower()
		print "INFO: Adding dj->", pfadd
		[ status, oid ] = dj.add_dj( None, pfadd )
		oids.append( oid )
	return oids	
	
def fixup_event(evt, usepfdct):

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

	# update dates...
	eoid = ObjectId( evt["_id"] )
	print "WARNING: Event in dbase is updating date information", eoid, sdstr, edstr
	status = event.update_event( None, eoid, None, None, None, None, None, None, sdstr, edstr, None, None, None)

        # check city...
        update_city = True
        if (update_city):
                venueid = evt["venueid"]
                oid = ObjectId(venueid)
                vn = venue.get_venue( None, oid )
                city = vn["city"]
                print "WARNING: Event in dbase is updating city information", eoid, city
                status = event.update_event( None, eoid, None, None, None, None, None, None, sdstr, edstr, None, None, city)
                if not status:
                        print "ERROR: Cannot update city for event"
			return False
                # check it...
                revt = event.get_event_details( None, None, eoid,  None )
                print "REPEATING->", revt

	# check buyurl...
	fix_buyurl = False
	if not evt.has_key("buyurl"):
		vid = evt["vendorid"]
		print BUYURL_FIX[vid]
		if not BUYURL_FIX.has_key( evt["vendorid"] ):
			print "ERROR: (NP) Fix buyurl info is not present for->", evt["vendorid"], evt["name"]
			return False
	elif evt["buyurl"] == "http://www.clubtickets.com":
		fix_buyurl = True
		if not BUYURL_FIX.has_key( evt["vendorid"] ):
			print "ERROR: Fix buyurl info is not present for->", evt["vendorid"], evt["name"]
			return False
	if BUYURL_FIX.has_key( evt["vendorid"] ):
		fix_buyurl = True
	if fix_buyurl:	
		fixurl = BUYURL_FIX[ evt["vendorid"] ]
                eoid = ObjectId( evt["_id"] )
                print "WARNING: Event in dbase is updating buyurl information", city, oid, eoid, type(evt["_id"]), sdstr, edstr
                status = event.update_event( None, eoid, None, None, None, None, None, None, None, None, fixurl, None, None)
                if not status:
                        print "ERROR: Cannot update buyurl for event"
			return False

	# get cur val of pf...
	curpf = evt["pf"]
	print "CURPF->", curpf, type(curpf), type("")
	if type(curpf) == type("") or type(curpf)==type(u""): # string
		if usepfdct: # use lookup value...
			if not PF_FIX.has_key( evt["vendorid"] ): 
				print "ERROR: No pf fix dct information for event->", evt["vendorid"]
				return False 
			pffix = PF_FIX[ evt["vendorid"] ]
			if pffix == "FIXME":
				print "ERROR: Cannot update performer for event, need to update pffix dct"
				return False
		else:
			pffix = curpf
		# make sure that these performers in the dj collection...
		djs = pffix.split(";")
		print "INFO: Adding djs->", djs
		oids = add_djs( djs )
		print "INFO: djs oids->", oids
               	print "WARNING: Event in dbase is updating performer information", pffix
               	status = event.update_event( None, eoid, None, None, None, None, None, None, None, None, None, oids, None)
               	if not status:
                       	print "ERROR: Cannot update performer for event"
			return False
	
	return True


def fixup_event_performers():
	# get all events...
	events = event.get_events( None, None )
	# iterate events...
	for evt in events:
		# see if there are performers for this event...
		if evt.has_key("pf"):
			eoid = evt["_id"]
			# iterate performers...
			if evt["pf"] == None: continue
			djids = evt["pf"]
			for djid in djids:
				performer = dj.get_dj( None, djid )
				print "INFO: performer->", djid, performer
				if performer==None:
					print "WARNING: presets: no performer with that id->", djid
					continue
				# get their events...
				pfevents = []
				if performer.has_key("events"):
					pfevents= performer["events"]
				# add to it...
				if not eoid in pfevents:
					pfevents.append( eoid )
					print "INFO: adding event to performer events->", djid, eoid, pfevents
					if not dj.update_dj( None, djid, None, None, pfevents ):
						print "ERROR: cannot update dj events->", eoid, djid, pfevents

def fixup_performers():
	[pfs,paging] = dj.get_djs_details( None, None, None )
	for pf in pfs:
		print pf
		sid = pf["id"]
		oid = bson.objectid.ObjectId(sid)
		
		if not pf.has_key("pic"):
			print "INFO: fixing performer pic->", sid, oid
			status = dj.update_dj( None, oid, None, "", None )
			
	
			
if __name__ == "__main__":

	# make sure events map to performers...
	fixup_event_performers()

	# fixup performers...
	fixup_performers()
