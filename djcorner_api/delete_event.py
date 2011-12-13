import event
from pymongo.objectid import ObjectId

id = "4ee131a37289ce2619000001"
id = "4ee131597289ce2462000000"

oid = ObjectId(id)

evt = event.get_event( None, oid) 
print evt

status = event.delete_event( None, oid )
print status
