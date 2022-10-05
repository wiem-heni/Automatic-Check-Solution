$ServicesFilePath="E:\AutomatikCheck\ServiceStatus\ServicesName.csv"
$LogPath="E:\AutomatikCheck\log-service"
$ServicesList=Import-Csv -Path $ServicesFilePath -Delimiter ','


foreach($Service in $ServicesList){

   $CurrentServiceStatus=(Get-Service -Name $Service.Name).status


        if($Service.Status -ne $CurrentServiceStatus){
      
        Set-Service -Name $Service.Name -Status $Service.Status
        $AfterServiceStatus=(Get-Service -Name $Service.Name).Status


        $ch="Service-$($Service.Name)-$(Get-Date -Format "yyyy-MM-dd")"
        Write-Output $ch
        $testFile =Test-Path -Path $LogPath\$ch* -PathType Leaf
       Write-Output $testFile
        
        if(($Service.Status -ne $AfterServiceStatus) -and ($testFile -eq $false))
        {
          
                $Log="Starting the service $($Service.Name) was failed !
                Service $($Service.Name) is still $AfterServiceStatus at $(Get-Date -Format "hh:mm dd-MM-yyyy"), should be $($Service.Status) !! Please solve the problem"
                Write-Output $Log
                $LogFile="Service-$($Service.Name)-$(Get-Date -Format "yyyy-MM-dd hh-mm").txt"
                Out-File -FilePath "$LogPath\$LogFile" -Append -InputObject $Log
                $userName = 'aymen.fray@newaccess.ch'
                $password = 'Ay$fr2035'
                [SecureString]$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force 
                $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
                Send-MailMessage -SmtpServer outlook.office365.com -Port 587 -UseSsl -From aymen.fray@newaccess.ch -To support_tn@newaccess.ch -Subject "Problem with service $($Service.Name)" -Body $Log -Credential $credential -Attachments "$LogPath\$LogFile"
                            
           
        }
    }
    $time = $(Get-Date -Format "hh:mm:ss")
    if ($time -eq "23:30:00") {
        $testFile2 =Test-Path -Path $LogPath\$ch* -PathType Leaf
        if ($testFile2) {
          Remove-Item $LogPath\$ch*
        }
    }


}

