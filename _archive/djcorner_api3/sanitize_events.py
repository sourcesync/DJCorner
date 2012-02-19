#
# Config...
#
import event

loc = {"lat":40.731519, \
	"lng":-73.997555}

#
# Program...
#
from dateutil import parser

print
print
[events,pageinfo] = event.get_events_details(None,loc,None)
print "INFO: total events->", len(events)

for evt in events:
	
	print "INFO: event->", evt["name"]
	print evt

	#
	# sanitize the event date...
	#
	dtstr = evt["eventdate"]
	print "INFO: event date raw->", dtstr
	# make sure we can parse it...
	dt = parser.parse(dtstr)

	#
	# sanitize performers...
	#
	if not evt.has_key("pf"):
		print "WARNING: sanitizing event for performer->", evt
		sys.exit(1)
		eoid = evt["_id"]
		status = event.update_event( None, eoid, None, None, None, None, None, None, None, None, None, "To be announced!" )
		if not status:
			print "ERROR: Could not update event"
			sys.exit(1)

	#update_event( connection, oid, name, venueid, description, promotor, imgpath, eventDate, startDate, endDate, buyurl, performers):		
	
	# make sure we can convert to the format we want...
	print dt, type(dt), dt.strftime("The date is %a %m/%d") 

	# get print remainder of required elements...
	print evt["dist"], evt["venuename"], evt["imgpath"], evt["latitude"], evt["latitude"]

print "INFO: Done"
