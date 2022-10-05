 
 $varS = Invoke-WebRequest -UseDefaultCredentials -Uri http://localhost:8592/api/apsys/state -Method POST -ContentType "application/json" 
 if ($varS.Status -eq "200"){
 $var = Invoke-WebRequest -UseDefaultCredentials -Uri http://localhost:8590/api/apsys/state -Method POST -ContentType "application/json" |  ConvertFrom-Json

 if (($var.writeb -ne "True") -or ($var.availableb -ne "True")) {

    stop-website -Name "ApsysWebApi_G2_EBK"
    Stop-WebAppPool -Name "ApsysWebApi_G2_EBK"
    start-website -Name "ApsysWebApi_G2_EBK"
    Start-Sleep -s 5
    Start-WebAppPool  -Name "ApsysWebApi_G2_EBK"
 }
 
 
 }


<#
 $var1 = Invoke-WebRequest -UseDefaultCredentials -Uri http://localhost:8590/api/apsys/state -Method POST -ContentType "application/json" |  ConvertFrom-Json

 if (($var1.writeb -ne "True") -or ($var1.availableb -ne "True")) {
    
    stop-website -Name "ApsysWebApi_G2_EBK"
    Stop-WebAppPool -Name "ApsysWebApi_G2_EBK"
    start-website -Name "ApsysWebApi_G2_EBK"
    Start-Sleep -s 5
    Start-WebAppPool  -Name "ApsysWebApi_G2_EBK"

 }

 $var2 = Invoke-WebRequest -UseDefaultCredentials -Uri http://localhost:9090/api/apsys/state -Method POST -ContentType "application/json" |  ConvertFrom-Json

 if (($var2.writeb -ne "True") -or ($var2.availableb -ne "True")) {
    
    stop-website -Name "ApsysWebApiRef2"
    Stop-WebAppPool -Name "ApsysWebApiRef2"
    start-website -Name "ApsysWebApiRef2"
    Start-Sleep -s 5
    Start-WebAppPool  -Name "ApsysWebApiRef2"

 }

 $var3 = Invoke-WebRequest -UseDefaultCredentials -Uri http://localhost:9091/api/apsys/state -Method POST -ContentType "application/json" |  ConvertFrom-Json

 if (($var3.writeb -ne "True") -or ($var3.availableb -ne "True")) {
    
    stop-website -Name "ApsysWebApiRefEBK"
    Stop-WebAppPool -Name "ApsysWebApiRefEBK"
    start-website -Name "ApsysWebApiRefEBK"
    Start-Sleep -s 5
    Start-WebAppPool  -Name "ApsysWebApiRefEBK"

 }

 #>