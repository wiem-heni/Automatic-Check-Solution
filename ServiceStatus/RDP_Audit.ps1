Param(
    [array]$ServersToQuery = (hostname),
    [datetime]$StartTime = (get-date).AddDays(-2)
	
)
    
    foreach ($Server in $ServersToQuery) {

        $LogFilter = @{
            LogName = 'Microsoft-Windows-TerminalServices-LocalSessionManager/Operational'
            ID = 21, 23, 24, 25
            StartTime = $StartTime
            }

        $AllEntries = Get-WinEvent -FilterHashtable $LogFilter -ComputerName $Server

        $AllEntries | Foreach { 
            $entry = [xml]$_.ToXml()
            [array]$Output += New-Object PSObject -Property @{
                TimeCreated = $_.TimeCreated
                User = $entry.Event.UserData.EventXML.User
                IPAddress = $entry.Event.UserData.EventXML.Address
                EventID = $entry.Event.System.EventID
                ServerName = $Server
                }        
            } 

    }

    $FilteredOutput += $Output | Select TimeCreated, User, ServerName, IPAddress, @{Name='Action';Expression={
                if ($_.EventID -eq '21'){"logon"}
                if ($_.EventID -eq '22'){"Shell start"}
                if ($_.EventID -eq '23'){"logoff"}
                if ($_.EventID -eq '24'){"disconnected"}
                if ($_.EventID -eq '25'){"reconnection"}
                }
            }

   

	  $testFile =Test-Path -Path $env:E:\AutomatikCheck\log-session\RDP_Report* -PathType Leaf
        if ($testFile) {
          Remove-Item $env:E:\AutomatikCheck\log-session\RDP_Report*
        }
		
	$Date = (Get-Date -Format s) -replace ":", "."
    $FilePath = "$env:E:\AutomatikCheck\log-session\RDP_Report_$Date.csv"
    $FilteredOutput | Sort TimeCreated | Export-Csv $FilePath -NoTypeInformation -Encoding utf8

Write-host "Writing File: $FilePath" -ForegroundColor Cyan
Write-host "Done!" -ForegroundColor Cyan


#End

