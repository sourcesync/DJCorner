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

def send(devtoken,msgcount, pollcount):
	totalcount = msgcount + pollcount
	if (totalcount==0):
		return

	# message count phrase...
	if msgcount==1:
		mphrase = "1 new message"
	elif msgcount>1:
		mphrase  = "%d new messages" % msgcount

	# poll count phrase...	
	if pollcount==1:
		pphrase = "1 new poll"
	elif pollcount>1:
		pphrase = "%d new polls" % pollcount

	# full message...
	if (msgcount>0) and (pollcount>0):
		msg = "You have %s and %s." % (mphrase, pphrase)
	elif (msgcount>0) and (pollcount==0):
		msg = "You have %s." % (mphrase)
	elif (msgcount==0) and (pollcount>0):
		msg = "You have %s." % (pphrase)

	# create a new php script...
	f = open( TEMPL, 'r')
	php = f.read()
	php = php.replace("MESSAGE",msg).replace("BADGE",str(totalcount)).replace("MSGCOUNT",str(msgcount)).replace("POLLCOUNT",str(pollcount)).replace("TOKEN",devtoken )
	#print php
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
	if retv[0]!=0:
		print "ERROR: apns_send: cannot delete file->", retv
		ok = False

	return ok
	

if __name__=="__main__":

	if sys.argv[ len(sys.argv)-1 ] != "subprocess" : # launch self as subprocess...
		print "INFO: apns_send: subprocess"
		sys.stdout.flush()
		newargs = ["python"] + sys.argv + [ "subprocess" ]
		print "INFO: apns_send: subprocess args->", newargs
		print subprocess.Popen( newargs )

	else: # in subproc...
		sys.stdout.flush()
		print "INFO: apns_send: actually sending..."
		token = sys.argv[1]
		msgcount = int(sys.argv[2])
		pollcount = int(sys.argv[3])
		print "INFO: apns_send: parms->", token, msgcount, pollcount
		send( token, msgcount, pollcount )


