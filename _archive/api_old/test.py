#
# Program...
#

import mongoify
import restify

class A( mongoify.Mongoify, restify.Restify ):
	def __init__(self):
		self.ID = None

		# attributes...
		self.p1 = None
		self.p2 = None

		# links...
		self._lB = None

class B( mongoify.Mongoify, restify.Restify ):
	def __init__(self):
		self.ID = None

		# attributes...
		self.p1 = None
		self.p2 = None

		# links...
		self._lA = None

#
# A
#
# rest create new A...
argsa = "p1=yes&p2=no"
a = A.object_from_rest_set( argsa )
# commit a to db...
ida = a.write_to_mongo()
print "INSERTED NEW A->", ida

#
# B
#
# rest create new B...
argsb = "p1=no&p2=yes"
b = B.object_from_rest_set( argsb )
# commit b to db...
idb = b.write_to_mongo()
print "INSERTED NEW B->", idb

# link a and b...
argsab = "ID=%s&_lB=%s" % (ida,idb)
a = A.object_from_rest_set(argsab)
ida = a.write_to_mongo() 

# create another b
argsb = "p1=no&p2=yes"
b = B.object_from_rest_set( argsb )
# commit b to db...
idb = b.write_to_mongo()
print "INSERTED ANOTHER B->", idb

# link a to new b...
argsab = "ID=%s&_lB=%s" % (ida,idb)
a = A.object_from_rest_set(argsab)
ida = a.write_to_mongo() 

# test objectid equality...
from pymongo.objectid import ObjectId
p1 = ObjectId('4e8215edbc2b5d82da000001')
p2 = ObjectId('4e8215edbc2b5d82da000002')
print p1==p2
