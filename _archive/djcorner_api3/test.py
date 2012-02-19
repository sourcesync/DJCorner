#
# Configuration...
#


#
# Program...
#
import urllib2

if __name__ == "__main__":

	#
	# Test getting events...
	#
	req = urllib2.Request('http://localhost:7777/api/event')
        handle = urllib2.urlopen(req)
        print handle.read()                
