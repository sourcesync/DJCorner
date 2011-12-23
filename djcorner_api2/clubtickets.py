#
# Configuration...
#

# searches...
SEARCH = \
	{ "newyork1": "New+York+City", \
		"newyork2": "NYC", \
		"newyork3": "Pacha" }

# default event buy url...
EVENT_BUY_URL = \
	"http://www.clubtickets.com"
	#"http://m.clubtickets.com/us/2011-11/19/boris-the-jungle-party-pacha-nyc"

CLUBTIX_FIX = \
	{ }


MAX_COUNT = 3
THIS_COUNT = 0

#
# Program...
#
import sys
import event
import venue
import presets

import xml.dom.minidom
import urllib2

#
# Func to access clubtickets api search using search term...
#
def search( fname, searchterm ):

	theurl = 'https://xml.ticketlogic.net/v2.0/search?lang=en&rd=false&sr=rl&s=0&r=10&meta=true&details=true&q=%s' % searchterm
	protocol = 'https://'
	username = 'drac@dgnyenterprises.com'
	password = 'dracguia11'           

	passman = urllib2.HTTPPasswordMgrWithDefaultRealm()      # this creates a password manager
	passman.add_password(None, theurl, username, password)      # because we have put None at the start it will always use this username/password combination

	authhandler = urllib2.HTTPBasicAuthHandler(passman)                 # create the AuthHandler

	opener = urllib2.build_opener(authhandler)                                  # build an 'opener' using the handler we've created
	# you can use the opener directly to open URLs
	# *or* you can install it as the default opener so that all calls to urllib2.urlopen use this opener
	urllib2.install_opener(opener)

	req = urllib2.Request(theurl)
    	handle = urllib2.urlopen(req)
	#except IOError, e:                  # here we shouldn't fail if the username/password is right

	thepage = handle.read()

	f = open(fname,'w')
	f.write( thepage )
	f.flush()
	f.close()

	return True

#
# Func to populate database from a clubtickets api query string...
#
def pop_from_str(str):

	global MAX_COUNT
	global THIS_COUNT

	# Parse the xml...
	a = xml.dom.minidom.parseString(str)
	#print dir(a)

	# Get all the toplevel events...
	els = a.getElementsByTagName("event")

	# Iterate over elements...
	for el in els:

		# Get vendor id for the event...
		vendorid = el.attributes["id"].value

		# Get title element, used for  the event name...
		t = el.getElementsByTagName("title")
		cdatanode = t[0].childNodes[0]
		ename = cdatanode.wholeText
		ename = ename.strip()
		print "INFO: Parsed event name->", ename

		# Get description element, used for the event description...
		d = el.getElementsByTagName("description")
		edescription = None
		if len(d)>0:
			cdatanode = d[0].childNodes[0]
			edescription = cdatanode.wholeText
			edescription = ""
			#print "INFO: Parsed event description->", edescription

		# Get promotor element, used for the event promotor field...
		p = el.getElementsByTagName("promotor")
		epromotor = None
		if len(p)>0:
			epromotor = p[0].attributes["name"].value 
			print "INFO: parsed event promotor->", epromotor

		# Get lineup...
		l = el.getElementsByTagName("lineup")
		performers = None
		if len(l)>0:
			cdatanode = l[0].childNodes[0]
			lineup = cdatanode.wholeText
			lineup = lineup.replace("<p>","")
			lineup = lineup.replace("</p>","")
			lineup = lineup.replace("\t","")
			lineup = lineup.replace("&amp;","&")
			lineup = lineup.replace("<ul>","")	
			lineup = lineup.replace("</ul>","")	
			lineup = lineup.replace("<li>","")	
			lineup = lineup.replace("</li>","")	
			lineup = lineup.replace("&quot;","")
			lineup = lineup.replace("<div class=\"event-lineup\">","")
			lineup = lineup.replace("<pre wrap=\"\">","")
			lineup = lineup.replace("</pre>","")
			lineup = lineup.replace("</div>","")
			lineup = lineup.replace("<div>","")
			lineup = lineup.replace("<strong>","")
			lineup = lineup.replace("</strong>","")
			lineup = lineup.replace("\t","")
			lineup = lineup.replace("\n","")
			performers = lineup.strip()
			print "INFO: parsed lineup->", lineup
		if not performers:
			print "ERROR: performers required!"
			sys.exit(1)

		# Do special parsing...
		performers = performers.replace(",",";").replace("and","")

		# Get dates...
		m = el.getElementsByTagName("meta")
		eventDate = None
		startDate = None
		endDate = None
		if len(m)>0:
			ds = m[0].getElementsByTagName("date")
			for d in ds:
				if d.attributes.has_key("type"):
					val = d.attributes["type"].value
					#print val
					if (val=="starts"):
						startDate = d.childNodes[0].nodeValue
						eventDate = startDate
					elif (val=="ends"):
						endDate = d.childNodes[0].nodeValue

		# Get images element, used for the images path field...
		imgel = el.getElementsByTagName("images")
		imgpath = None
		if len(imgel)>0:
			mel = imgel[0].getElementsByTagName("medium")
			if len(mel)>0:
				imgpath = mel[0].childNodes[0].nodeValue
				print "INFO: parsed event image->", imgpath

		# Add the event...
		print "INFO: adding event->", ename, vendorid
		[ status, eoid ] = event.add_event( None, ename, vendorid )
		if status == False:
			print "WARNING: Add event returned false - probably already have this event..."

		# Get venue element...
        	v = el.getElementsByTagName("venue")

		# Get venue name...
		vname = v[0].attributes["name"].value
		print "INFO: CLUBTICKETS VENUE FOR THIS EVENT->", vname

		# Add the venue...
		[ status, void ] = venue.add_venue( None, vname, "clubtickets-"+vname )
		if status == False:
			print "WARNING: Add venue returned false - probably already have this venue..."
		print "INFO: ", void, type(void)

		# Get the event...
		ve = venue.get_venue( None, void )

		# Do generic fixup...
		if ( not presets.fixup_venue( ve ) ):
			print "ERROR: Cannot fixup venue"
			return False

		# Get the buy url...
		buyurl = EVENT_BUY_URL

		# Link venue to event...
		status = event.update_event( None, eoid, ename, void, edescription, epromotor, imgpath, eventDate, startDate, endDate , buyurl, \
			performers, None )
		if not status:
			print "ERROR: could not update event"
			return False

		# Make sure it saved...
		evt = event.get_event_details( None, None, eoid, True)
		print "INFO: event details from db->", evt

		# Do generic event fixup...
		if ( not presets.fixup_event( evt, True ) ):
                        print "ERROR: cannot fixup event..."
                        return False

	return True	

def test_init():

        # Open the sample web service call...
        f = open('../clubtickets/search/resultsPacha.txt','r')
        thepage = f.read()
        f.close()
       
	# Populate dbase... 
	if not pop_from_str(thepage):
		print "ERROR: Problem populating from page"
		return False

        # Open the sample web service call...
        f = open('../clubtickets/search/resultsNewYorkCity.txt','r')
        thepage = f.read()
        f.close()

	# Populate dbase...
        if not pop_from_str(thepage):
		print "ERROR: Problem populating from page"
		return False

	return True

if __name__ == "__main__":

	# figure out if we are going to clubtickets server via their api...
	sync = True
	if ( ( len(sys.argv)>1 ) and (sys.argv[1]=="nosync") ):
		sync = False

	# get/find the local file(s) to sync to our dbase...
	FILES = []
	if sync:
		print "INFO: syncing club tickets api to local file..."

		# iterate default search terms dct...
		for item in SEARCH.keys():
			localfile = "%s.txt" % item
			searchterm = SEARCH[item]

			print "INFO: searching %s, storing->%s" % (searchterm, localfile )
			if not search( localfile, searchterm ):
				print "ERROR: error in search"
				sys.exit(1)

			FILES.append( localfile )
	else:
		FILES = [ "%s.txt" % a for a in SEARCH.keys() ]

	print "INFO: localfiles->", FILES

	# iterate local files...
	for file in FILES:
		print "INFO: syncing localfile to dbase->", file	
		f = open( file, 'r')
        	thepage = f.read()
        	f.close()
        	if not pop_from_str(thepage):
			print "ERROR: Problem populating page..."
			sys.exit(1)

	print "INFO: Done."
