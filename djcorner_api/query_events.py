
import event


loc = {"lat":40.731519, \
	"lng":-73.997555}

events = event.get_events_details(None,loc,None)
#print events

for evt in events:
	print evt["name"], evt["dist"], evt["venuename"], evt["imgpath"], evt["latitude"], evt["latitude"]
