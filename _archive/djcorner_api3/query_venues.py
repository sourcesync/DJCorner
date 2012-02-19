
import venue

venues = venue.get_venues(None,None)

for v in venues:
	print v["_id"], v["name"],v["ds"], v["city"]
	print v
