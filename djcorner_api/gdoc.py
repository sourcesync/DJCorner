#
# Configuration...
#

# credentials...
GUSERNAME = "george.williams@gmail.com"
GPASS	= "gg6shooter"

# default docs...
DOCS = [ "DJ's Corner" ]

# default image...
DEFAULT_EVT_IMG = "static/clubgeneric_small.jpg"

#
# Program...
#
import gdata.docs.service
import gdata.spreadsheet.service
import sys
import xml.dom.minidom

import event
import venue

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
def sync_to_db( docs ):
	for doc in docs:
		print "INFO: Opening doc->", doc
		f = open(doc,'r')
		lines = [ a.strip() for a in f.readlines() ]
		f.close()

		# first line has fields format...
		fields = [ a.strip() for a in lines[0].split(",") ]
	
		# dct which maps field names into idx...	
		ifields = dict( zip( fields, range(len(fields))) )	

		# iterate over data lines in file...
		for ln in lines[1:]:
			vals = ln.split(",")
			if len(vals) != len(fields):
				print "ERROR: data len mismatch->", doc, len(fields), len(vals), fields, vals
				sys.exit(1)

			# put data into dct...
			dct = dict( zip( fields, vals ) )
			print "INFO: data for line->", dct

			# get the event name...
			ename = dct["Event Name"]

			# for the vendor id...
			vendorid = "djc-" + ename

                	# Add the event...
                	[ status, eoid ] = event.add_event( None, ename, vendorid )
                	if status == False:
                        	print "WARNING: Add event returned false - probably already have this event..."

                       	# Get the event buy url...
                        #buyurl = "http://www.google.com"
			buyurl = dct["Event Purchase URL"]

			# Get the event image...
			#imgpath = DEFAULT_EVT_IMG
			imgpath = dct["Event Pic"]

			# Get the event description...
			edescription = "A Cool Event"

			# Get event dates...
			eventdate = dct["Event Date"]
			startdate = dct["Event Date"]
			enddate = dct["Event Date"]

			# Performers...
			performers = dct["Performers"]

                	# Get venue name...
                	vname = dct["Event Venue"]

                	# Add the venue...
                	[ status, void ] = venue.add_venue( None, vname, "djc-"+vname )
                	if status == False:
                        	print "WARNING: Add venue returned false - probably already have this venue..."

                	# Update event attributes, link venue to event...
                	status = event.update_event( None, eoid, None, void, edescription, \
				None, imgpath, eventdate, startdate, enddate, buyurl, performers, None )
                	if not status:
                        	print "ERROR: could not update event"
                        	sys.exit(1)

                	# Make sure it saved...
                	evt = event.get_event_details( None, None, eoid, True)
                	#print "INFO: event details from db->", evt

	return True	

#
# Do default downloading...
#
if __name__=="__main__":

	sync_google = True
	
	#print sys.argv, len(sys.argv)
	if ( (len(sys.argv)> 1) and (sys.argv[1]=="nosync")):
		print "WARNING: gdoc: not syncing to google..."
		sync_google = False

	if (sync_google):
		print "INFO: gdoc: getting download urls for->", DOCS
		[ client, gdoc_urls ] = get_download_urls( DOCS )

		print "INFO: gdoc: download urls for->", gdoc_urls
		local_docs = download_docs( client, gdoc_urls )	

		print "INFO: gdoc: syncing local docs to dbase->", local_docs
	else:
		local_docs = dict( [ [a,"%s.txt" % a] for a in DOCS ] )
		print "INFO: gdoc: creating local docs from default->", local_docs

	status = sync_to_db( local_docs.values() )
	if not status:
		print "ERROR: gdoc: problem syncing local files to dbase..."
		sys.exit(1)

	print "INFO: Done"
