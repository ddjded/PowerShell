#Print Servers
$ServerArray = @("10.14.20.66")
$exchangeserver = "10.14.20.40"
$To = "name.name@name.com"
$From = "report.name@name.com"
 
#Output File
$Date = (get-date) - (new-timespan -day 1)
$OutputPath = "d:\temp\print\"
$csvfile = $OutputPath + "Printing Audit 2- " + (Get-Date).ToString("yyyy-MM-dd") + ".csv"
	if ((Test-Path -Path $OutputPath+$csvfile) -eq $true) {remove-item $csvfile}
write-output "Server,Time,ID,Color,Copy" | Out-File $csvfile
 
#COLLECT EVENT LOGS FROM EACH PRINT SERVER
	
ForEach ($PrintServer in $ServerArray)
	{
	write-Host "Parsing event log entries for" $PrintServer
	$strOutput = ""

    $filterxml = 	'<QueryList>
						<Query Id="0" Path="Microsoft-Windows-PrintService/Operational">
						<Select Path="Microsoft-Windows-PrintService/Operational">*[System[(EventID=805)]]</Select>
                        </Query>
					</QueryList>'
	$EventLog = Get-WinEvent -ea SilentlyContinue -ComputerName $PrintServer -Filterxml $filterXml
	
	ForEach ($LogEntry in $EventLog)
		{ 
		#Get print job details
		$time = $LogEntry.TimeCreated
		$entry = [xml]$LogEntry.ToXml() 
		$Color = $entry.Event.UserData.RenderJobDiag.Color
        $Copy = $entry.Event.UserData.RenderJobDiag.Copies
		$IDD = $entry.Event.UserData.RenderJobDiag.JobId
	 
		#$Write Log to CSV file
		$strOutput = $PrintServer+ "," +$time.ToString()+ "," +$IDD+ "," +$Color+ "," +$Copy+ ","
		write-output $strOutput | Out-File $csvfile -append  
		}
	}

 
	
#REPORTING VIA EMAIL
#-------------------
 
#HTML style sheet
$header = "<H3>Print Server Log Report "+(get-date -f D)+"</H3>"  
$title = "Example HTML Output" 
$body = '<style>  
BODY{font-family:Verdana; background-color:white;}  
TABLE{border-width: 1px;border-style:solid;border-color: black;border-collapse: collapse;}  
TH{font-size:1em; border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:#C2B8AF}  
TD{border-width: 1px;padding: 5px;border-style:  solid;border-color: black;background-color:#F6F8FC}  
</style>  
'
$EmailText = '<style> 
Log report Attached<BR>
<BR>
Regards,<BR>
<BR>
Admin Scripts<BR>
' 	
	
#Send email (with attached CSV)
$emailsubject = "[AUTO] Print Server Logs Report ("+(get-date -f dd-MM-yyyy)+")"
Send-MailMessage -To $To -From $From -Subject $emailsubject -SmtpServer $exchangeserver -body ($EmailText | Out-String) -BodyAsHtml -attachment $csvfile
