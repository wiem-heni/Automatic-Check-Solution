$ApsysWebApiFilePath="E:\AutomatikCheck\ServiceStatus\ApsysWebApiNames.csv"
$LogPath="E:\AutomatikCheck\log-apsys"
$LogFile="Services_IIS-$(Get-Date -Format "yyyy-MM-dd hh-mm").txt"
$ApsysWebApiList=Import-Csv -Path $ApsysWebApiFilePath -Delimiter ','

foreach($ApsysName in $ApsysWebApiList){

    if ($env:computername -eq $ApsysName.machine) {
        Write-Output $ApsysName.name
		[string] $x = $ApsysName.name
		
           
        $URI="http://"+$ApsysName.machine+":"+$ApsysName.port+"/api/apsys/state"
        Write-Output $URI
        $URI = [URI]$URI
		Write-Output $URI
        $var = Invoke-WebRequest -UseDefaultCredentials -Uri $URI -Method POST -ContentType "application/json" |  ConvertFrom-Json

        if (($var.writeb -ne "True") -or ($var.availableb -ne "True")) {
       
           stop-website -Name $x
           Stop-WebAppPool -Name $x
           start-website -Name $x
           Start-Sleep -Seconds 10
           Start-WebAppPool  -Name $x
           Start-Sleep -Seconds 10
        }
    
        $URI1="http://"+$ApsysName.machine+":"+$ApsysName.port+"/api/apsys/state"
        $URI1 = [URI]$URI1
        $var2 = Invoke-WebRequest -UseDefaultCredentials -Uri $URI1 -Method POST -ContentType "application/json" |  ConvertFrom-Json

        if (($var2.writeb -ne "True") -or ($var2.availableb -ne "True")) {
            $Log="Starting the IIS service was failed !!! Service IIS $($ApsysName.Name) is still Stopped, should be Running !! Please solve the problem"
            Write-Output $Log
            Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
            
    }
}
   
}

