
import urllib2

theurl = 'https://xml.ticketlogic.net/v2.0/search?lang=en&rd=false&sr=rl&s=0&r=10&meta=true&details=true&q=New+York+City'
protocol = 'https://'
username = 'drac@dgnyenterprises.com'
password = 'dracguia11'            # a very bad password

#theurl = 'www.someserver.com/highestlevelprotectedpath/somepage.htm'
#protocol = 'http://'
#username = 'johnny'
#password = 'XXXXXX'         # a great password

passman = urllib2.HTTPPasswordMgrWithDefaultRealm()      # this creates a password manager
passman.add_password(None, theurl, username, password)      # because we have put None at the start it will always use this username/password combination

authhandler = urllib2.HTTPBasicAuthHandler(passman)                 # create the AuthHandler

opener = urllib2.build_opener(authhandler)                                  # build an 'opener' using the handler we've created
# you can use the opener directly to open URLs
# *or* you can install it as the default opener so that all calls to urllib2.urlopen use this opener
urllib2.install_opener(opener)

req = urllib2.Request(theurl)
try:
    handle = urllib2.urlopen(req)
except IOError, e:                  # here we shouldn't fail if the username/password is right
    print "Some ERROR->"
    print str(e)
    sys.exit(1)
thepage = handle.read()
print thepage

f = open('results.txt','w')
f.write( thepage )
f.flush()
f.close()

import xml.dom.minidom

a = xml.dom.minidom.parseString(thepage)
print dir(a)
els = a.getElementsByTagName("event")
for el in els:
	v = el.getElementsByTagName("venue")
	print el, el.attributes["id"].value, v[0].attributes["name"].value
	
