import event
import bson
import urllib
import urllib2
import PIL
from PIL import ImageFile, Image
import sys
from urlparse import urlparse
import os

# Get all events...
info = event.get_events_details(None,None,None,None,True,0)
evts = info[0]
#print type(evts)

for evt in evts:
	_id = evt["id"]
	oid =  bson.objectid.ObjectId(_id)
	imgpath = evt["imgpath"]
	print imgpath

	#print oid, imgpath
	#f = urllib2.urlopen( imgpath )
	#img = f.read()
	#print type(img)
	#parser = ImageFile.Parser()
	#while True:
    	#s = f.read(1024)
    	#if not s:
       	#break
    	#parser.feed(s)
	#image = parser.close()
	# make thumbnail
	#size = (75, 75)
	#image.thumbnail(size, Image.ANTIALIAS)
	#background = Image.new('RGBA', size, (255, 255, 255, 0))
	#background.paste( image, ((size[0] - image.size[0]) / 2, (size[1] - image.size[1]) / 2))
	#background.save('copy.jpg')

	parts = urlparse( imgpath )
	fname = os.path.basename(parts.path)
	
	try:
		image = urllib.URLopener()
		image.retrieve( imgpath, "%s/%s" % ( "static", fname ) )
	except:
		print sys.exc_info()[0]

	retv = event.update_event( None, oid, thumbpath = fname )
	if retv == False:
		print "update failed"
