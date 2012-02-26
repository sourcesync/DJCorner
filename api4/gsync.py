#
# Config...
#

DJ_LIST = None # "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdHdxVUlMUzg5bWoyX05uc0lCdm9pRWc/od7/public/basic"

DJ_SCHEDULE = "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdHdxVUlMUzg5bWoyX05uc0lCdm9pRWc/od4/public/basic"

CLUB_LIST = None #"https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdHdxVUlMUzg5bWoyX05uc0lCdm9pRWc/od5/public/basic"

CLUB_SCHEDULE = None # "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdHdxVUlMUzg5bWoyX05uc0lCdm9pRWc/oda/public/basic"

#
# Program...
#

#
# PARSE DJ LIST...
#

def printx( level, node ):
        print "".join([ "\t" for a in range(level) ]) + node.nodeName
        for n in node.childNodes:
                printx( level + 1, n )

import urllib
from xml.dom.minidom import parseString
from lxml import etree
import sys
import dj
import city
import venue
import event
from dateutil import parser

if DJ_LIST:
	# get the contents of sheet...
	f = urllib.urlopen( DJ_LIST )
	st = f.read()
	#print st

	# parse it...
	num_empty_consec = 0
	root = etree.fromstring(st)

	idx = 2
	while True:
		rc = 'A' + str(idx)
		matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
		if len(matches)==0:
			num_empty_consec += 1
		else:

			# Add the DJ...
			status, djid = dj.add_dj( None, matches[0] )
			if status==False and not djid:
				print "ERROR: Cannot add dj"
				sys.exit(0)
			status = dj.update_dj( djid=djid, rating = idx )
			if not status:
				print "ERROR: Cannot update dj"
				sys.exit(0)
			num_empty_consec = 0

		if num_empty_consec == 2: 
			break
		idx += 1


#
# PARSE DJ SCHEDULE...
#

if DJ_SCHEDULE:

	# get the contents of sheet...
	f = urllib.urlopen( DJ_SCHEDULE )
	st = f.read()
	#print st

	parent = parseString( st )
	#printx( 0, parent )	

	# parse it...
	num_empty_consec = 0
	root = etree.fromstring(st)
	#print dir(root), root.tag

	num_empty_consec = 0
	idx = 2 # 390
	max = 423
	while True:
		firstcol = True
		finish = False
		uppers = [ chr(ii) for ii in range( ord('A'), ord('Q')+1 ) ]
		data = { "eventname":None, "venue":None, "website":None, "djs":None, "date":None, "purchaseurl": None, "city": None, "country":None }
		for upper in uppers:
        		rc = upper + str(idx)
			print "trying ", rc
        		matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
        		if len(matches)==0:
				if firstcol: 
					break
        		else:
                		print rc,matches[0]
                                if upper == "A": # event name
                                        data["eventname"] = matches[0]
                                elif upper == "B": # venue
                                        data["venue"] = matches[0]
                                elif upper == "C": # web site
                                        url = matches[0]
                                        if url.startswith("http:"):
                                                data["website"] = url
                                elif upper == "D": # dj
                                        data["djs"] = matches[0]
                                elif upper == "E": # date
                                        data["date"] = matches[0]
                                elif upper == "F": # purchase url
                                        url = matches[0]
                                        if url.startswith("http:"):
                                                data["purchaseurl"] = url
                                elif upper == "J": # city
                                        data["city"] = matches[0]
                                elif upper == "K": # country
                                        data["country"] = matches[0]
			firstcol = False

		print data

		# add any djs listed...
		pfids = []
		if data["djs"]:
			djs = [ a.strip() for a in data["djs"].split(",") ]
			for _dj in djs:
				status, djid = dj.add_dj( None, _dj )
                        	if status==False and not djid:
                                	print "ERROR: Cannot add dj."
                                	sys.exit(0)
				pfids.append( djid )

		# add any cities listed...
		eventcity = None
		if data["city"]:
			eventcity = data["city"].strip().split(",")[0]  
			# TODO: deal with possible state, province...

			print "INFO: Trying to add city->", eventcity

			status, oid = city.add_city( None, eventcity )
                        if status==False and not oid:
                               	print "ERROR: Cannot add city."
                               	sys.exit(1)
	
		# add any venues listed...
		void = None
		if data["venue"] and (data["venue"].strip()!=""):
			_venue = data["venue"].strip()
			print "INFO: Trying to add venue->", _venue

			status, void  = venue.add_venue( None, _venue, _venue + "-googledoc" )
                        if status==False and not oid:
                               	print "ERROR: Cannot add venue."
                               	sys.exit(1)
			retv = venue.update_venue( void=void, display_name=_venue, city=eventcity )
			if retv==False:
                               	print "ERROR: Cannot update venue."
                               	sys.exit(1)
	
		# add the event...
		if data["eventname"]:

			print "INFO: Trying to add event->", data["eventname"]
	
			status, oid = event.add_event( None, data["eventname"], data["eventname"] + "-googledoc" )
			if not status and not oid:
				print "ERROR: Cannot add event."
				sys.exit(1)

			# fixup event date...
			if ( data["date"] ):
				print "WARNING: Check/converting date format->", data["date"]
				dt = parser.parse(data["date"])
        			dtstr = dt.strftime("%m/%d/%y")
				data["date"] = dtstr

			status = event.update_event( venueid=void, oid=oid, pfids=pfids, city=eventcity, buyurl=data["purchaseurl"], eventDate=data["date"] )
			if status == False:
				print "ERROR: Cannot update event."
				sys.exit(1)
			

		idx += 1
		if idx > max:
			break

#
# PARSE CLUB LIST...
#

if CLUB_LIST:

        # get the contents of sheet...
        f = urllib.urlopen( CLUB_LIST )
        st = f.read()

        parent = parseString( st )
        #printx( 0, parent )

        # parse it...
        num_empty_consec = 0
        root = etree.fromstring(st)
        #print dir(root), root.tag

        num_empty_consec = 0
        idx = 2
        max = 67
        while True:
                firstcol = True
                finish = False
                uppers = [ chr(ii) for ii in range( ord('A'), ord('K')+1 ) ]
		data = { "venuename":None, "address":None, "phone":None, "lat":None, "lng":None, "website":None, "city": None, "country":None }
                for upper in uppers:
                        rc = upper + str(idx)
                        print "trying ", rc
                        matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
                        if len(matches)==0:
                                if firstcol:
                                        break
                        else:
                                print rc,matches
				if upper == "A": # country
					data["country"] = matches[0]
				elif upper == "B": # city
					data["city"] = matches[0]
				elif upper == "C": # venue name
					data["venuename"] = matches[0]
				elif upper == "F": # web site
					url = matches[0]
					if url.startswith("http:"):	
						data["website"] = url
				elif upper == "G": # address
					data["address"] = matches[0]
				elif upper == "H": # phone 
					data["phone"] = matches[0]
				elif upper == "I": # lat/long
					print matches[0]
					entry = matches[0].strip()
					try:
						lat, lng = [a.strip() for a in entry.split(",")]
						data["lat"] = float(lat)
						data["lng"] = float(lng)
					except:
						print "WARNING: Could not convert cell to lat/long"	
                        firstcol = False

		# add the venue...
		if data["venuename"] and data["venuename"].strip()!= "":

			print "TRYING TO ADD VENUE->", data["venuename"]

			status, void = venue.add_venue( None, data["venuename"], data["venuename"] + "-googledoc" )
			if not status and not void:
				print "ERROR: Cannot add venue"
				sys.exit(1)
			status = venue.update_venue( void=void, display_name=data["venuename"], \
				address=data["address"], phone=data["phone"], latitude=data["lat"], longitude=data["lng"] )
			if not status:
				print "ERROR: Cannot update venue"
				sys.exit(1)

                idx += 1
                if idx > max:
                        break


#
# PARSE CLUB SCHEDULE...
#

if CLUB_SCHEDULE:

        # get the contents of sheet...
        f = urllib.urlopen( CLUB_SCHEDULE )
        st = f.read()
        #print st

        parent = parseString( st )
        #printx( 0, parent )

        # parse it...
        num_empty_consec = 0
        root = etree.fromstring(st)
        #print dir(root), root.tag

        num_empty_consec = 0
        idx = 1
        max = 10
        while True:
                firstcol = True
                finish = False
                uppers = [ chr(ii) for ii in range( ord('A'), ord('Q')+1 ) ]
                for upper in uppers:
                        rc = upper + str(idx)
                        print "trying ", rc
                        matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
                        if len(matches)==0:
                                if firstcol:
                                        break
                        else:
                                print rc,matches
                        firstcol = False
                idx += 1
                if idx > max:
                        break


