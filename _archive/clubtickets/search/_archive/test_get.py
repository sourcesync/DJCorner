#
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

# Open the sample web service call...
f = open('results.txt','r')
thepage = f.read()
f.close()

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
	cdatanode = d[0].childNodes[0]
	description = cdatanode.wholeText
	print "INFO: Parsed event description->", description

	# Get promotor element, used for the event promotor field...
	p = el.getElementsByTagName("promotor")
	promotor = p.attributes["name"].value 
	print "INFO: parsed event promotor->", promotor

	# Add the event...
	[ status, eoid ] = event.add_event( None, ename, vendorid )
	if status == False:
		print "WARNING: Add event returned false - probably already have this event..."

	# Update the event...
	status = event.update_event( None, eoid )
	if status == False:
		print "ERROR: Cannot update event..."
		sys.exit(1)

	# Get venue element...
        v = el.getElementsByTagName("venue")

	# Get venue name...
	vname = v[0].attributes["name"].value

	# Add the venue...
	[ status, void ] = venue.add_venue( None, vname, "clubtickets-"+vname )
	if status == False:
		print "WARNING: Add venue returned false - probably already have this venue..."

	# Link venue to event...
	status = event.update_event( None, eoid, None, void )
	if not status:
		print "ERROR: could not update event"
		sys.exit(1)

	# Make sure it saved...
	evt = event.get_event_details( None, eoid )
	print "INFO: event details from db->", evt

print "INFO: Done."
