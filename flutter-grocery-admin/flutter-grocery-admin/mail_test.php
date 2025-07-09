<?php
$to = "teamps.is.cool@gmail.com"; // one of your email
$subject = "Testing Email From PHP Script";
$txt = "Yes! I can send the email. ";
$headers = "From: nilesh@digitalduniya.online" . "\r\n" ; // sender email at Backend Setting which is you created at hosting

// mail($to,$subject,$txt,$headers);

if(mail($to,$subject,$txt,$headers)) {
    $status = "Success, I can send email from hosting.";
    echo $status;
} else {
    $status = "Fail sending " . $headers;
    echo $status;
}

?>