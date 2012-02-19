import event

events = event.get_events(None,None)
#print events[0]

for evt in events:
	print evt["name"]

