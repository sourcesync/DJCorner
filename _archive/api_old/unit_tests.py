#
# Configuration...
#

SERVER = "localhost:6767"

#
# Program...
#
import httplib, urllib
import time
import sys

SCRIPT = [ \
	[ "/api/session", "GET", 	None, 					[], 	405 ], \
	[ "/api/session", "PUT", 	None, 					[],	501 ], \
	[ "/api/session", "DELETE", 	None, 					[], 	501 ], \
	[ "/api/session", "POST", 	{'name':'test','password':'pass'}, 	[], 	200 ]  ]

#print dir(httplib)

# iterate over tests...
for test in SCRIPT:

	# get items for this test...
	url = test[0]
	method = test[1]
	params = test[2]
	headers = test[3]
	exp_resp = test[4]

	# open connection to server...
	conn = httplib.HTTPConnection( SERVER )

	print "INFO: Test->", url, method
	if method == "GET":
		conn.request( method, url )
	elif method == "POST":
		eparams = urllib.urlencode( params )
		conn.request( method, url, eparams )
	else:
		conn.request( method, url )
	resp = conn.getresponse()
	if resp.status != exp_resp:
		print "INFO: GOT RESPONSE %d, expected %d" % ( resp.status, exp_resp )
		sys.exit(1)
	if exp_resp == 200:
		r = resp.read()
		print "INFO: got response->", r


#params = urllib.urlencode({'spam': 1, 'eggs': 2, 'bacon': 0})
#headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
#resp = conn.getresponse()
#print resp
