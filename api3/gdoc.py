#
# Configuration...
#

# credentials...
GUSERNAME = "george.williams@gmail.com"
GPASS	= "gg6shooter"

# default docs...
EVENT_DOCS = [ "Events" ]
DJS_DOCS = [ "DJs" ]
VENUE_DOCS = [ "Venues" ]


# default image...
DEFAULT_EVT_IMG = "static/clubgeneric_small.jpg"

#
# Program...
#
import gdata.docs.service
import gdata.spreadsheet.service
import sys
import xml.dom.minidom
from dateutil import parser

import event
import venue
import presets
import dj

#
# Func to get spreadsheet field...
#
def _GETVAL( dct, field, required ):
	val = None
	if dct.has_key(field):
		val = dct[field]
		if val.lower().strip() == "na":
			val = None
		elif val.lower().strip() == "tba":
			val = None
	elif required:
		print "ERROR: gdoc: This field is required %s" % field
		sys.exit(1) #TODO: nasty asset behavior...
	return val


#
# Func to convert/validate time field...
#
def _SCRUBTIME( dtstr ):
	dt = parser.parse( dtstr ) # make sure its a recognizable date format...

	sdstr = dtstr
	try: # see if its in the format we want...
		dt = datetime.strptime( sdstr, "%Y-%m-%dT%H:%M:%S+00:00" )
	except:
		print "WARNING: gdoc: INVALID DATE FORMAT...FIXING..."
		sdstr = dt.strftime( "%Y-%m-%dT%H:%M:%S+00:00" )
	return sdstr

#
# Func to download urls from google doc names...
#
def get_download_urls( doc_names ):

	# Login to docs service...
	client = gdata.docs.service.DocsService()
	client.ClientLogin( GUSERNAME, GPASS )

	# Query the server for an Atom feed containing a list of your documents.
	documents_feed = client.GetDocumentListFeed()

	# Track the docs we want...
	DCT = dict( zip( doc_names, [ False for a in doc_names ] ) )

	# Get download urls for docs we are interested...
	URLS = {}
	for document_entry in documents_feed.entry:

		#print "INFO: DOC-->", document_entry.title.text

		# Check if its in the request list...
		if ( document_entry.title.text	in doc_names ):

			print "INFO: FOUND->", document_entry.title.text, document_entry.content
			DCT[ document_entry.title.text ] = True

			# get the download url...
			content = str(document_entry.content )
			doc = xml.dom.minidom.parseString( content )
			url = doc.childNodes[0].attributes["src"].value
			print "INFO: doc download url->", url

			URLS[ document_entry.title.text ] = url

	return [ client, URLS ]

#
# Func to download urls 
#
def download_docs( client, URLS ):

	sclient = gdata.spreadsheet.service.SpreadsheetsService()
	sclient.ClientLogin( GUSERNAME, GPASS )
	client.SetClientLoginToken(sclient.GetClientLoginToken())

	DOCS = {}

	# Iterate download urls...
	for key in URLS.keys():
	
		url = URLS[key]
		local_name = key + ".txt"
		DOCS[ key ] = local_name

		print "INFO: Downloading->%s to->%s" % ( url, local_name )
		retv = client.Export( url, local_name )
	return DOCS

#
# Func to update database based on downloaded local doc...
#
def sync_to_ven_db( docs ):
        for doc in docs:
                print "INFO: gdoc: Opening doc->", doc
                f = open(doc,'r')
                lines = [ a.strip() for a in f.readlines() ]
                f.close()

                # first line has fields format...
                fields = [ a.strip() for a in lines[0].split(",") ]
                print "INFO: gdoc: ven doc fields->", fields

                # dct which maps field names into idx...
                ifields = dict( zip( fields, range(len(fields))) )

                # iterate over data lines in file...
                for ln in lines[1:]:
                        vals = ln.split(",")
                        if len(vals) != len(fields):
                                print "WARNING: gdoc: skipping row, data len mismatch->", vals[0]
                                continue
			brk = False
			for val in vals:
				if val == None or val.strip() == "":
                                	print "WARNING: gdoc: skipping row, field is None/Empty", vals[0]
					brk = True
					break
			if brk: continue
					
                        # put spreadsheet data into dct...
                        dct = dict( zip( fields, vals ) )

                        # get the venue name from input...
                        vname = _GETVAL( dct, "Venue", True)
                        if vname==None:
                                print "ERROR: gdoc: no vname"
                                return False

                        # get void ( find it or add it )...
                        void = venue.find_venue( None, vname )
                        if not void:
                                print "WARNING: gdoc: adding venue->", vname
                                void = venue.add_venue( None, vname, "djc-%s" % venue )
                                if not void:
                                        print "ERROR: gdoc: cannot add venue->", vname
                                        return False
                        else:
                                print "INFO: gdoc: found venue->", vname, void

			# get the venue latlong...
			latlong = _GETVAL( dct, "Latitude; Longitude", True)
			if not latlong:
				print "ERROR: gdoc: latlong val required for venue->", vname
				return False
			[ lat, lng ] = [ float(a) for a in latlong.split(";") ]
	
			# get venue city...	
			city = _GETVAL( dct, "City", True)
			if not city:
				print "ERROR: gdoc: city required for venue->", vname
				return False
	
                        # update fields...
			print "INFO: gdoc: update_venue fields->", void, vname, lat, lng, city
                        status = venue.update_venue( None, void, None, lat, lng, None, city )
                        if not status:
                                print "ERROR: gdoc: cannot update venue->", vname, lat, lng, city
                                return False

        return True




#
# Func to update database based on downloaded local doc...
#
def sync_to_djs_db( docs ):
	for doc in docs:
		print "INFO: gdoc: Opening doc->", doc
		f = open(doc,'r')
		lines = [ a.strip() for a in f.readlines() ]
		f.close()
		
		# first line has fields format...
		fields = [ a.strip() for a in lines[0].split(",") ]
		print "INFO: gdoc: dj doc fields->", fields
		
		# dct which maps field names into idx...	
		ifields = dict( zip( fields, range(len(fields))) )	
		
		# iterate over data lines in file...
		for ln in lines[2:]:
			vals = ln.split(",")
			if len(vals) != len(fields):
				print "WARNING: gdoc: skipping row, data len mismatch->", doc, len(fields), len(vals), fields, vals
				continue

                        brk = False
                        for val in vals:
                                if val == None or val.strip() == "":
                                        print "WARNING: gdoc: skipping row, field is None/Empty"
                                        brk = True
                                        break
                        if brk: continue

			# put spreadsheet data into dct...
			dct = dict( zip( fields, vals ) )
			#print "INFO: data for line->", dct

			# get the dj name from input...
			djname = _GETVAL( dct, "Official Name", True)
			if djname==None:
				print "ERROR: gdoc: no djname"
				return False

			# get djid ( find it or add it )...
			djid = dj.find_dj( None, djname )
			if not djid:
				print "WARNING: gdoc: adding dj->", djname
				djid = dj.add_dj( None, djname )
				if not djid:
					print "ERROR: gdoc: cannot add dj->", djname
					return False	
			else:
				print "INFO: gdoc: found dj->", djname, djid
	
			# get the dj pic to update, if any...
			djpic = _GETVAL( dct, "Pic", True)

			# get the rating to update, if any...
			rating = _GETVAL(dct, "Rating", True )

			# update fields...
			status = dj.update_dj( None, djid, None, djpic, None, None, rating )
			if not status:
				print "ERROR: gdoc: cannot update dj->", djname, djpic, rating
				return False

	return True


#
# Func to update database based on downloaded local doc...
#
def sync_to_events_db( docs ):
	for doc in docs:
		print "INFO: Opening doc->", doc
		f = open(doc,'r')
		lines = [ a.strip() for a in f.readlines() ]
		f.close()

		# first line has fields format...
		fields = [ a.strip() for a in lines[0].split(",") ]
		print fields
	
		# dct which maps field names into idx...	
		ifields = dict( zip( fields, range(len(fields))) )	

		# iterate over data lines in file...
		for ln in lines[1:]:
			vals = ln.split(",")
			if len(vals) != len(fields):
				print "ERROR: data len mismatch->", doc, len(fields), len(vals), fields, vals
				sys.exit(1)

                        brk = False
                        for val in vals:
                                if val == None or val.strip() == "":
                                        print "WARNING: gdoc: skipping row, field is None/Empty"
                                        brk = True
                                        break
                        if brk: continue

			# put data into dct...
			dct = dict( zip( fields, vals ) )
			print "INFO: data for line->", dct

			# get the event name...
			ename = _GETVAL(dct,"Event Name",True)

			# form the unique vendor id...
			vendorid = "djc-" + ename

                	# Add the event...
                	[ status, eoid ] = event.add_event( None, ename, vendorid )
                	if status == False and eoid:
                        	print "WARNING: gdoc: Add event returned false - probably already have this event..."

                       	# Get the event buy url...
			buyurl = _GETVAL( dct, "Event Purchase URL", True)

			# Get the event image...
			imgpath = _GETVAL( dct, "Event Pic", True)

			# Get the event description...
			edescription = None

			# Get event dates...
			eventdate = _GETVAL(dct, "Event Date", True)
			if not eventdate:
				print "ERROR: gdoc: Event date required->", ename
				return False

			eventdate = _SCRUBTIME( eventdate )
			startdate = eventdate # TODO: get from spreadsheet...
			enddate = eventdate # TODO: get fro spreadsheet...

			# Performers...
			performers = _GETVAL( dct, "Performers", True)
			pfids = []
			pfs = []
			if performers:
				pfs = [ a.strip() for a in performers.split(";") if not a.strip() == "" ]
				print "INFO: gdoc: parsed performers->", pfs
				for pf in pfs:
                        		djid = dj.find_dj( None, pf )
                        		if not djid:
                                		print "WARNING: gdoc: dj for event not present in db->", ename, pf
						# try to add it...
						[ status, djid ] = dj.add_dj( None, pf )
						if not status:
                                			print "ERROR: gdoc: could not add dj to db, from event->", ename, pf
							return False
					pfids.append( djid )
					# link event to performer...
					if not dj.update_dj_event( None, djid, eoid ):
						print "ERROR: gdoc: cannot update dj event->", djid, pf, eoid, ename
						return False	

			# Event city...
			city = _GETVAL(dct,"City", True)
			if not city:
				print "ERROR: gdoc: event city required"
				return False

                	# Get venue name...
                	vname = _GETVAL(dct, "Event Venue", True)
			if not vname:
				print "ERROR: gdoc: venue name required"
				return False
			# in gdoc, venue must already exist in db...
			void = venue.find_venue( None, vname )
			if not void:	
				print "WARNING: gdoc: venue does not exist in db->", vname
				[ status, void ] = venue.add_venue( None, vname, "djc-%s" % vname )
				if not status:
					print "WARNING: gdoc: Cannot add venue->", vname
					return False	

                	# Update event w/attributes...
                	status = event.update_event( None, eoid, None, void, edescription, \
				None, imgpath, eventdate, startdate, enddate, buyurl, pfs, pfids, city )
                	if not status:
                        	print "ERROR: gdoc: could not update event"
                        	sys.exit(1)

                	# Make sure it saved...
                	evt = event.get_event_details( None, None, eoid, True)
			print evt

	return True	

#
# Do default downloading...
#
if __name__=="__main__":

	sync_google = True
	
	if ( (len(sys.argv)> 1) and (sys.argv[1]=="nosync")):
		print "WARNING: gdoc: not syncing to google..."
		sync_google = False
	
	#
	# DJs docs...
	#
	if (sync_google):
		print "INFO: gdoc: getting download urls for->", DJS_DOCS
		[ client, gdoc_urls ] = get_download_urls( DJS_DOCS )

		print "INFO: gdoc: download urls for->", gdoc_urls
		local_docs = download_docs( client, gdoc_urls )	

		print "INFO: gdoc: syncing local docs to dbase->", local_docs
	else:
		local_docs = dict( [ [a,"%s.txt" % a] for a in DJS_DOCS ] )
		print "INFO: gdoc: creating local docs from default->", local_docs
	if True:
		status = sync_to_djs_db( local_docs.values() )
		if not status:
			print "ERROR: gdoc: problem syncing local files to dbase..."
			sys.exit(1)

	#
	# Venue docs...
	#
	if (sync_google):
		print "INFO: gdoc: getting download urls for->", VENUE_DOCS
		[ client, gdoc_urls ] = get_download_urls( VENUE_DOCS )

		print "INFO: gdoc: download urls for->", gdoc_urls
		local_docs = download_docs( client, gdoc_urls )	

		print "INFO: gdoc: syncing local docs to dbase->", local_docs
	else:
		local_docs = dict( [ [a,"%s.txt" % a] for a in VENUE_DOCS ] )
		print "INFO: gdoc: creating local docs from default->", local_docs
	if True:
		status = sync_to_ven_db( local_docs.values() )
		if not status:
			print "ERROR: gdoc: problem syncing local files to dbase..."
			sys.exit(1)

	#
	# Event docs...
	#
        if (sync_google):
                print "INFO: gdoc: getting download urls for->", EVENT_DOCS
                [ client, gdoc_urls ] = get_download_urls( EVENT_DOCS )

                print "INFO: gdoc: download urls for->", gdoc_urls
                local_docs = download_docs( client, gdoc_urls )

                print "INFO: gdoc: syncing local docs to dbase->", local_docs
        else:
                local_docs = dict( [ [a,"%s.txt" % a] for a in EVENT_DOCS ] )
                print "INFO: gdoc: creating local docs from default->", local_docs
        if True:
		status = sync_to_events_db( local_docs.values() )
        	if not status:
                	print "ERROR: gdoc: problem syncing local files to dbase..."
                	sys.exit(1)

	print "INFO: Done."
