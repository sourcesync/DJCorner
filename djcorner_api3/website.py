

def get_events( paging ):
	evt = { "date":"Dec 31 2011", "dj":"DJ Logic",  "djlink":"http://www.google.com", \
                "location":"New York,NY", "tix":"http://www.google.com" }

	events = []
	for i in range(15):
		events.append( evt )

	return events	
