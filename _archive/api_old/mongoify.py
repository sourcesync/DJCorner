#
# Configuration...
#
from pymongo import Connection
from pymongo.collection import Collection
from pymongo.objectid import ObjectId

import uuid

import links

#
# Code...
#

def write_to_mongo( obj ):

	print "INFO: mongoify: class name->", obj.__class__.__name__
	attrs = obj.__dict__

	# Extract any link objects...
	link_dct = {}
	setattrs = {}
	for attr in attrs.keys():
		if attr.startswith("_l"):
			if attrs[attr] != None:	
				link_dct[attr] = attrs[attr]
		elif attrs[attr] != None:
			setattrs[attr] = attrs[attr]

	# Get mongo connection...
	connection = Connection()

	# Get db...
	db = connection["djcorner"]

	# Form collection name...
	this_clname = obj.__class__.__name__ 
	
	# Create if doesn't exist...
	if not this_clname in db.collection_names():
		db.create_collection(this_clname)

	# Get collection object...
	this_col = Collection( db, this_clname )

	# Figure out if we are updating or inserting new...
	if obj.ID == None:  # insert new...
		print "INFO: mongoify: inserting new->", this_clname
		this_o = this_col.save(setattrs)
	else: # update...	
		print "INFO: mongoify: updating->", this_clname, obj.ID
		this_o = ObjectId(obj.ID)
		print "UPDATER objid->", this_o, type(this_o)
		this = this_col.find_one( {"_id":this_o } )
		for attr in setattrs.keys():
			this[attr] = setattrs[attr]	
		this_o = this_col.save(this)

	print "INFO: mongoify, after save->", this_clname, this_o, type(this_o)

	# Deal with linking...
	print "INFO: links dct->", link_dct
	for this_link_item in link_dct.keys():

		# get the other object name...
		other_clname = this_link_item.replace("_l","")

		# get the other object id...
		other_id = link_dct[this_link_item]

		# get the other object...
		other_col = Collection( db, other_clname )
		other_o = ObjectId( other_id )
		other = other_col.find_one( {"_id": other_o} )
		print "GOT OTHER BEFORE LINKING->", other

		# create/update the link field as necessary for other...
		other_link_field = "_l" + this_clname
		if other.has_key( unicode( other_link_field ) ): # append
			other_links = other[ unicode( other_link_field ) ]
			if this_o in other_links:
				pass
			else:
				other_links.append( this_o )
		else: # initialize...
			other_links = [ this_o ] 

		# commit the new link information for other...
		other[ unicode(other_link_field) ] = other_links
		other_o = other_col.save( other )	 

		# debug print updated "other"...
		other = other_col.find_one( {"_id": other_o} )
		print "UPDATED OTHER->", other

		# get this object...
		print "GETTING THIS WITH->", this_o, type(this_o)
		this = this_col.find_one( {"_id": this_o} )
		print "GOT THIS BEFORE LINKING->", this

		# create/update the link field as necessary for this...
		this_link_field = "_l" + other_clname
		if this.has_key( unicode( this_link_field ) ): # append
			this_links = this[ unicode(this_link_field) ]
			if other_o in this_links:
				pass
			else:
				this_links.append( other_o )
		else: # initialize...
			this_links = [ other_o ] 

		# commit the new link information for this...
		this[ unicode(this_link_field) ] = this_links
		this_o = this_col.save( this )	 
	
		# debug print updated "this"...	
		this = this_col.find_one( {"_id": this_o} )
		print "UPDATED THIS->",this

	# Return the id...	
	return str(this_o)

#
# Inherit from this class to get the mongo goodies...
#
class Mongoify:

	def write_to_mongo(self):
		return write_to_mongo( self )

if __name__ == "__main__":

	class inst( Mongoify ):
		def __init__(self):
			self.ID = ""

	class test( Mongoify ):
		def __init__(self):
			self.ID = ""
			self.A = ""
			self._linst = None

	t = test()
	t.ID = ""
	t.A = "yo"
	t._linst = 1111

	id = t.write_to_mongo()
	t.ID = id

	id = t.write_to_mongo()
	print id


