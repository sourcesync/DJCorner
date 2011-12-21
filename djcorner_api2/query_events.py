import event

events = event.get_events_details(None,None,None,"New York City")
#print events[0]

for evt in events[0]:
	print evt["name"], evt["city"]

