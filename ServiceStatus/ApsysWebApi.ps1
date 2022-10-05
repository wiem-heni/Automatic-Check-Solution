$ApsysWebApiFilePath="E:\AutomatikCheck\ServiceStatus\ApsysWebApiNames.csv"
$LogPath="E:\AutomatikCheck\log-apsys"
$ApsysWebApiList=Import-Csv -Path $ApsysWebApiFilePath -Delimiter ','
foreach($ApsysName in $ApsysWebApiList){
$ch="ServiceIIS-$($ApsysName.name)-$(Get-Date -Format "yyyy-MM-dd")"
Write-Output $ch
$testFile =Test-Path -Path $LogPath\$ch* -PathType Leaf
Write-Output $testFile
if($env:computername -eq $ApsysName.machine) {
Write-Output $ApsysName.name
[string] $x = $ApsysName.name
$URI="http://"+$ApsysName.machine+":"+$ApsysName.port+"/api/apsys/state"
Write-Output $URI
$URI=[URI]$URI
Write-Output $URI
$var=Invoke-WebRequest -UseDefaultCredentials -Uri $URI -Method POST -ContentType "application/json" | ConvertFrom-Json
if(($var.writeb -ne $true) -or ($var.availableb -ne $true)) {

stop-website -Name $x
Stop-WebAppPool -Name $x
start-website -Name $x
Start-Sleep -Seconds 10
Start-WebAppPool -Name $x
Start-Sleep -Seconds 10
}
$ch="ServiceIIS-$($ApsysName.name)-$(Get-Date -Format "yyyy-MM-dd")"
Write-Output $ch
$testFile=Test-Path -Path $LogPath\$ch* -PathType Leaf
Write-Output $testFile

$URI1="http://"+$ApsysName.machine+":"+$ApsysName.port+"/api/apsys/state"
$URI1=[URI]$URI1
Write-Output $URI1
Start-Sleep -s 5
$var2 =Invoke-WebRequest -UseDefaultCredentials -Uri $URI1 -Method POST -ContentType "application/json" | ConvertFrom-Json

if(($var2.writeb -ne $true) -or ($var2.availableb -ne $true) -and ($testFile -eq $false)) {
$LogFile="ServiceIIS-$($ApsysName.name)-$(Get-Date -Format "yyyy-MM-dd hh-mm").txt"
$Log="Starting the IIS service was failed !!! Service IIS $($ApsysName.Name) is still Stopped, should be Running !! Please solve the problem"
Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
$userName='aymen.fray@newaccess.ch'
$password='Ay$fr2035'
[SecureString]$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force 
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
Send-MailMessage -SmtpServer outlook.office365.com -Port 587 -UseSsl -From aymen.fray@newaccess.ch -To support_tn@newaccess.ch -Subject "Problem with IIS service $($ApsysName.name)" -Body $Log -Credential $credential -Attachments "$LogPath\$LogFile"
}


$time=$(Get-Date -Format "hh:mm:ss")
if($time -eq "23:30:00") {
$testFile2 =Test-Path -Path $LogPath\$ch* -PathType Leaf
if($testFile2){
Remove-Item $LogPath\$ch*
}
}
}
}