
import sys

import event

print "WARNING: CLEARING EVENTS!!!"

status = event.clear_all(None )

if status:
	print "INFO: EVENTS CLEARED"
else:
	print "ERROR: PROBLEM CLEARING EVENTS"

print "INFO: Done."
