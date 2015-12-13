$LDAPPath = "OU=Computers,OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet"
#$RootDomainOU = [ADSI]$LDAPPath
#$Searcher = New-Object System.DirectoryServices.DirectorySearcher($RootDomainOU)
#Get-ADComputer $Searcher.Filter {operatingsystem -eq "Windows XP Professional" -and operatingsystemservicepack -eq "Service Pack 3"}

Get-ADComputer -SearchBase $LDAPPath -Filter * -Property * | Select-Object Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion | Export-CSV D:\AllWindows.csv -NoTypeInformation -Encoding UTF8
