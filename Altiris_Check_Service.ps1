function check
{
#$file = 'd:\check.csv'
$service = 'AeXNSClient'
$complist=get-adcomputer -filter * -SearchBase 'OU=Computers,OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet' | ForEach-Object {$_.Name}
foreach ($line in $complist)
    {
$connect=Test-Connection -ComputerName $line -Count 1
	if($connect)
	    {
	    Get-WmiObject -Class Win32_Service -Filter "name='$service'" -ComputerName $line | Select SystemName , Name, State
        if ($state -eq 'stopped') {Write-Host "$service on $line is down"}

        }
    	else
		    {
		    Write-Host "$line is "down""
		    }
    }
}
check | Out-File -filepath d:\123.csv -append
Send-MailMessage -to "name.name@name.com" -From "Spooler <no-reply@name.com>" -Subject "Report $service" -SmtpServer "10.14.20.40" -attachment d:\123.csv
