
# Configuration...
#
import sys
sys.path.append("../..")
from djcorner_api import event
from djcorner_api import venue

#
# Program...
#
import xml.dom.minidom

def pop_from_str(results):

	# Parse the xml...
	a = xml.dom.minidom.parseString(thepage)
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
		print "INFO: Parsed event name->", ename

		# Get description element, used for the event description...
		d = el.getElementsByTagName("description")
		edescription = None
		if False and len(d)>0:
			cdatanode = d[0].childNodes[0]
			edescription = cdatanode.wholeText
			#print "INFO: Parsed event description->", edescription

		# Get promotor element, used for the event promotor field...
		p = el.getElementsByTagName("promotor")
		epromotor = None
		if len(p)>0:
			epromotor = p[0].attributes["name"].value 
			print "INFO: parsed event promotor->", epromotor

		# Get dates...
		m = el.getElementsByTagName("meta")
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
		[ status, eoid ] = event.add_event( None, ename, vendorid )
		if status == False:
			print "WARNING: Add event returned false - probably already have this event..."

		# Get venue element...
        	v = el.getElementsByTagName("venue")

		# Get venue name...
		vname = v[0].attributes["name"].value

		# Add the venue...
		[ status, void ] = venue.add_venue( None, vname, "clubtickets-"+vname )
		if status == False:
			print "WARNING: Add venue returned false - probably already have this venue..."

		# Link venue to event...
		status = event.update_event( None, eoid, None, void, edescription, epromotor, imgpath, startDate, endDate )
		if not status:
			print "ERROR: could not update event"
			sys.exit(1)

		# Make sure it saved...
		evt = event.get_event_details( None, None, eoid )
		print "INFO: event details from db->", evt

# Open the sample web service call...
#f = open('results.txt','r')
#thepage = f.read()
#f.close()
#pop_from_str(thepage)

# Open the sample web service call...
f = open('resultsPacha.txt','r')
thepage = f.read()
f.close()
pop_from_str(thepage)

# Open the sample web service call...
f = open('resultsNewYorkCity.txt','r')
thepage = f.read()
f.close()
pop_from_str(thepage)

print "INFO: Done."
