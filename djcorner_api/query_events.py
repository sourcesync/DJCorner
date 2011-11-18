
import event


loc = [40.731519,-73.997555]

events = event.get_events_details(None,loc,None)
#print events

for evt in events:
	print evt["name"], evt["dist"], evt["venuename"]
	if evt.has_key("imgpath"):
		print evt["imgpath"]
