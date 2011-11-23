
import venue

venues = venue.get_venues(None,None)

for v in venues:
	print v["name"],v["ds"]
