#
# Configuration...
#


TEMPL = "apns.php"

#
# Program...
#

import commands
import os, sys
import subprocess

def send(devtoken,dj):

	# form the message...
	msg = "Congratulations, you are now following %s on DJs Corner" % dj

	# create a new php script...
	f = open( TEMPL, 'r')
	php = f.read()
	php = php.replace("MESSAGE",msg).replace("BADGE","0").replace("MSGCOUNT","0").replace("POLLCOUNT","0").replace("TOKEN",devtoken )
	tfile = os.tmpnam()
	f = open(tfile,'w')
	f.write(php)
	f.flush()
	f.close()

	# form the command...
	cmd = "php -f %s" % tfile

	# run it...
	ok = True
	retv = commands.getstatusoutput( cmd )
	if retv[0]!=0:
		print "ERROR: apns_send: error sending->", retv
		ok = False
	else:
		ok = True

	# delete tmp file...
	cmd = "rm -f %s" % tfile
	retv = commands.getstatusoutput(cmd)
	print "INFO: Running command->", cmd
	if retv[0]!=0:
		print "ERROR: apns_send: cannot delete file->", retv
		ok = False

	return ok
	

if __name__=="__main__":

	if sys.argv[ len(sys.argv) - 1 ] == "test":
		token = "3148b619 7df99a3b 9c6a2a50 d2f7c88c 635d756d a32a4863 6cc8d321 ff3df9c5"
		send( token, "yo")

	elif sys.argv[ len(sys.argv)-1 ] != "subprocess" : # launch self as subprocess...
		print "INFO: apns_send: subprocess"
		sys.stdout.flush()
		newargs = ["python"] + sys.argv + [ "subprocess" ]
		print "INFO: apns_send: subprocess args->", newargs
		print subprocess.Popen( newargs )

	else: # in subproc...
		sys.stdout.flush()
		print "INFO: apns_send: actually sending..."
		token = sys.argv[1]
		msg = ""
		for str in sys.argv[2:]:
			msg += "%s " % str	
		print "INFO: apns_send: parms->", token, msg
		send( token, msg )


