<?php
echo "1\n";
//$apnsHost = 'gateway.sandbox.push.apple.com';
$apnsHost = 'gateway.push.apple.com';
$apnsPort = 2195;
//$apnsCert = 'apns-dev-mypush3.pem';
$apnsCert = 'apns-dev.pem';
echo "2\n";

$streamContext = stream_context_create();
stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
echo "3\n";

$apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
echo "4\n";
echo $apns;
echo $errorString;
echo "5\n";

$payload['aps'] = array('alert' => 'MESSAGE', 'badge' => BADGE, 'sound' => 'default');
$payload['info'] = array('messages' => MSGCOUNT,'polls' => POLLCOUNT);
$payload = json_encode($payload);
echo $payload;
echo "\n6\n";

// sprawl first test $deviceToken = 'd964a713 0b232bcf fc352085 9b9625ed 272f86a0 8bdc9b15 d1cbc249 26b54e0b';
//$deviceToken = '932d733e da535954 0d6e6193 342e6fb8 b9aa5f33 7bae02b4 a9d2c91d 9ae6bce7'; //mypushapp works
//$deviceToken = 'd964a713 0b232bcf fc352085 9b9625ed 272f86a0 8bdc9b15 d1cbc249 26b54e0b'; //mypushapp2 doesnt work
//$deviceToken = 'd964a713 0b232bcf fc352085 9b9625ed 272f86a0 8bdc9b15 d1cbc249 26b54e0b'; //mypushapp3 
//$deviceToken = '33a32e63 1d0e2f25 889dabcb 04cca56c ed6eca80 e003d41d 46134465 483fbee3'; // peter mypushapp3
//$deviceToken = 'd964a713 0b232bcf fc352085 9b9625ed 272f86a0 8bdc9b15 d1cbc249 26b54e0b'; //sprawl alpha8 adhoc prod
$deviceToken = 'TOKEN' ; //sprawl alpha8 adhoc prod george iphone after reset

$packed = pack('H*', str_replace(' ','',$deviceToken) );
echo "packed->" . strlen($packed);
echo "\n";
$apnsMessage = chr(0) . chr(0) . chr(32) . $packed . chr(0) . chr(strlen($payload)) . $payload;
$retv = fwrite($apns, $apnsMessage);
echo $retv;
echo "\n";
echo "7\n";

//echo "before sock close\n";
//socket_close($apns);
echo "before fclose\n";
echo fclose($apns);
echo "\n";
echo "8\n";

?>
