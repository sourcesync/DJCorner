#
# Configuration...
#

#
# Code...
#


def object_from_rest_set( cl, parms ):

	# get name/value pairs from request parameters string...
	nv_pairs = parms.split("&")

	# create an empty object of class...
	o = cl()

	# initialize a link dictionary...
	#link_dct = {}

	# iterate over name/value pairs...
	for nv_pair in nv_pairs:

		# get name/value pair...
		[ attr, val ] = nv_pair.split("=")

		# check if its a link...
		#if attr.startswith("_l"):
		#link_dct[attr] = val
			
		if not o.__dict__.has_key(attr): # check its an attribute...
			raise Exception("No attribute ->%s<-" % attr )

		else: # set the class attribute value...
			o.__dict__[attr] = val

	# add links dct to the object...
	#o.__dict__["__links"] = link_dct

	return o

#
# All classes that want restify features should inherit this class...
#
class Restify:
	
	@classmethod
	def object_from_rest_set(cls, parms):
		print cls
		return object_from_rest_set(cls, parms )

if __name__ == "__main__":
	print "INFO: restify: test..."
	class inst(Restify):
		def __init__(self):
			print "inst init"
	class obj(Restify):
		def __init__(self):
			self.ID = None
			self.Name = None
			self.URL = None
			self._linst = None
	print obj.object_from_rest_set( "ID=1&Name=yo&URL=stuff&_linst=111111" )
