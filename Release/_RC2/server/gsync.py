#
# Config...
#

# TO SYNC THIS SHEET, you must republish the sheet in google docs and restore from None...
DJ_LIST =  { \
	"file":"DJ_LIST.txt", \
	"url": "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdDZhNzVRUEptX3J1MlpPVXBFRmpRVnc/od7/public/basic", \
	"min":2, \
	"max":105, \
	"dct": { "name":"A", "sample":"B", "purchase":"C", "alias":"D", "home_city":"E","home_country":"F","website":"G","pic":"H","genre":"I","soundcloud":"J" } \
	}

# TO SYNC THIS SHEET, you must republish the sheet in google docs and restore from None...
DJ_SCHEDULE = { \
	"file":"DJ_SCHEDULE.txt", \
	"url":"https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdDZhNzVRUEptX3J1MlpPVXBFRmpRVnc/od4/public/basic", \
	"min":316, \
	"max":1045, \
	"dct":{ "eventname":"B","djs":"A","venuename":"C","website":"D","eventdate":"F","purchase":"I","pic":"J","city":"K","country":"L" } \
	}

# TO SYNC THIS SHEET, you must republish the sheet in google docs and restore from None...
CLUB_LIST = [ "CLUB_LIST.txt", "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdDZhNzVRUEptX3J1MlpPVXBFRmpRVnc/od5/public/basic" ]

# TODO: Code not done here yet...
CLUB_SCHEDULE = [ "CLUB_SCHEDULE.txt",  "https://spreadsheets.google.com/feeds/cells/0AuRz1oxD7nNEdHdxVUlMUzg5bWoyX05uc0lCdm9pRWc/oda/public/basic"]

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
import os

if DJ_LIST and False:

	# try the local file first...
	if os.path.exists( DJ_LIST["file"] ):
		f = open( DJ_LIST["file"] )
		st = f.read()
		f.close()
	
	# try the url...
	else:
		# get the contents of sheet...
		f = urllib.urlopen( DJ_LIST["url"] )
		st = f.read()
		f = open (DJ_LIST["file"],"w")
		f.write(st)
		f.flush()
		f.close()
	#print st

	# parse it...
	num_empty_consec = 0
	root = etree.fromstring(st)

	idx = DJ_LIST["min"]
	while True:
	
		dct = DJ_LIST["dct"]	
		vals = {}
		for item in dct.keys():
			col = dct[item]
			vals[item] = None
			rc = col + str(idx)
			matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
			if len(matches)>0:
				vals[item] = matches[0]	
		print "INFO: DJINFO->", idx, vals
	
		if ( vals.has_key("name") ):	
			# Add the DJ...
			status, djid = dj.add_dj( None, vals["name"] )
			if status==False and not djid:
				print "ERROR: Cannot add dj"
				sys.exit(0)
			status = dj.update_dj( djid=djid, rating = idx, pic= vals["pic"] )
			if not status:
				print "ERROR: Cannot update dj"
				sys.exit(0)

		idx += 1
		if idx == DJ_LIST["max"]:
			break

#
# PARSE DJ SCHEDULE...
#

if DJ_SCHEDULE:

        if os.path.exists( DJ_SCHEDULE["file"] ):
                f = open( DJ_SCHEDULE["file"] )
                st = f.read()
                f.close()

        # try the url...
        else:
                # get the contents of sheet...
                f = urllib.urlopen( DJ_SCHEDULE["url"] )
                st = f.read()
		f = open (DJ_SCHEDULE["file"],"w")
                f.write(st)
                f.flush()
                f.close()
	print st

	parent = parseString( st )
	#printx( 0, parent )	

	# parse it...
	root = etree.fromstring(st)

	idx = DJ_SCHEDULE["min"]
	while True:

                dct = DJ_SCHEDULE["dct"]
                vals = {}
                for item in dct.keys():
                        col = dct[item]
                        vals[item] = None
                        rc = col + str(idx)
                        matches = root.xpath("/d:feed/d:entry/d:title[ text() = '%s' ]/../d:content/text()" % rc , namespaces={"d":"http://www.w3.org/2005/Atom"})
                        if len(matches)>0:
                                vals[item] = matches[0]
                print "INFO: DJSCHEDULE INFO->", idx, vals

		# add any djs listed...
		pfids = []
		if vals["djs"]:
			djs = [ a.strip() for a in vals["djs"].split(",") ]
			for _dj in djs:
				status, djid = dj.add_dj( None, _dj )
                        	if status==False and not djid:
                                	print "ERROR: Cannot add dj."
                                	sys.exit(0)
				pfids.append( djid )

		# add any cities listed...
		eventcity = None
		if vals["city"]:
			eventcity = vals["city"].strip().split(",")[0]  
			# TODO: deal with possible state, province...

			print "INFO: Trying to add city->", eventcity

			status, oid = city.add_city( None, eventcity )
                        if status==False and not oid:
                               	print "ERROR: Cannot add city."
                               	sys.exit(1)
	
		# add any venues listed...
		void = None
		if vals["venuename"] and (vals["venuename"].strip()!=""):
			_venue = vals["venuename"].strip()
			print "INFO: Trying to add venue->", _venue

			status, void  = venue.add_venue( None, _venue, _venue + "-googledoc" )
                        if status==False and not void:
                               	print "ERROR: Cannot add venue."
                               	sys.exit(1)
			retv = venue.update_venue( void=void, display_name=_venue, city=eventcity )
			if retv==False:
                               	print "ERROR: Cannot update venue."
                               	sys.exit(1)
	
		# add the event...
		if vals["eventname"]:
			print "INFO: Trying to add event->", vals["eventname"]
	
			status, oid = event.add_event( None, vals["eventname"], vals["eventname"] + "-googledoc" )
			if not status and not oid:
				print "ERROR: Cannot add event."
				sys.exit(1)

			# fixup event date...
			if ( vals["eventdate"] ):
				print "WARNING: Check/converting date format->", vals["eventdate"]
				dt = parser.parse(vals["eventdate"])
        			dtstr = dt.strftime("%m/%d/%y")
				vals["eventdate"] = dtstr

			status = event.update_event( venueid=void, oid=oid, pfids=pfids, city=eventcity, buyurl=vals["purchase"], eventDate=vals["eventdate"] )
			if status == False:
				print "ERROR: Cannot update event."
				sys.exit(1)
			

		idx += 1
		if idx > DJ_SCHEDULE["max"]:
			break

#
# PARSE CLUB LIST...
#

if CLUB_LIST:

        if os.path.exists( CLUB_LIST[0] ):
                f = open( CLUB_LIST[0] )
                st = f.read()
                f.close()

        # try the url...
        else:
                # get the contents of sheet...
                f = urllib.urlopen( CLUB_LIST[1] )
                st = f.read()
		f = open (CLUB_LIST[0])
                f.write(st)
                f.flush()
                f.close()

        parent = parseString( st )
        printx( 0, parent )
	
        # parse it...
        num_empty_consec = 0
        root = etree.fromstring(st)
        print dir(root), root.tag

	matches = root.xpath("/d:feed/d:entry/d:title/text()" , namespaces={"d":"http://www.w3.org/2005/Atom"})
	if not matches:
		print "ERROR: invalid feed content"
		sys.exit(1)
	print matches

	matches = root.xpath("/d:feed/d:entry/d:title[ text() = 'A2' ]/../d:content/text()" , namespaces={"d":"http://www.w3.org/2005/Atom"})
	if not matches:
		print "ERROR: invalid feed/entry/title content"
		sys.exit(1)

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

        if os.path.exists( CLUB_SCHEDULE[0] ):
                f = open( CLUB_SHEDULE[0] )
                st = f.read()
                f.close()

        # try the url...
        else:
                # get the contents of sheet...
                f = urllib.urlopen( CLUB_SCHEDULE[1] )
                st = f.read()

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


