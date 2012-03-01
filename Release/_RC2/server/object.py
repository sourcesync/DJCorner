#
# Configuration...
#

#
# Code...
#

def set_status( objid, status ):

        fields = {'status':status }
        status = djs.update( dj, { '$set': fields }, True )
        if ( status ):
                print "ERROR: object: set_status: cannot set status field"
                return False
        else:
                return True

def validate( obj, REQ, OPT ):

        has_keys = obj.keys() # keys the obj has...

        req_fields = REQ.keys() # keys required to be there...

	status = 1 # ready...

        for field in req_fields: # make sure required are there...
                if not field in has_keys:
                        print "WARNING: object: Required key %s not present->" % field, has_keys
	
                val = obj[field]
                typecheck = REQ[field]
                if type(val) != typecheck:
                        print "WARNING: object: Required type %s not present-> % field, typecheck
                        return False

        for field in opt_fields: # make sure optional is there w/ right type...
                val = obj[field]
                typecheck = REQ[field]
                if type(val) != typecheck:
                        print "WARNING: object: Required type %s not present-> % field, typecheck
                        return False

        return True

