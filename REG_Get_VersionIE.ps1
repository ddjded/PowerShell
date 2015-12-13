<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.93
	 Created on:   	17.09.2015 17:55
	 Created by:   	Kolosowsky Yuriy 
	 Organization: 	 
	 Filename:     	REG_Get_VersionIE_from.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Function IEVersion
{
	$Prop = [ordered]@{ }
	$ComputerName = get-adcomputer -filter * -SearchBase 'OU=Computers,OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet' | ForEach-Object { $_.Name }
	#$ComputerName = Cat C:\Computers.txt
	$ErrorActionPreference = "Stop"
	foreach ($computer in $ComputerName)
	{
		
		Try
		{
			$Syntax = GWMI win32_operatingsystem -cn $computer
			$Prop.Computername = $Syntax.CSName
			$Prop.OperatingSystem = $Syntax.Caption
			$Prop.ServicePack = $Syntax.CSDVersion
			$Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer)
			$RegKey = $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Internet Explorer")
			$Prop.IEVersion = $Regkey.GetValue("svcVersion")
			
			New-Object PSObject -property $Prop
		}
		
		Catch
		{
			
			Add-Content "$computer is not reachable" -path $env:USERPROFILE\Desktop\UnreachableHosts.txt
		}
	}
}
#HTML Color Code 
#http://technet.microsoft.com/en-us/librProp/ff730936.aspx 
$a = "<!--mce:0-->"
IEVersion | ConvertTo-HTML -head $a -body "<H2> IE Version</H2>" |
Out-File $env:USERPROFILE\Desktop\DomainController.htm #HTML Output 
Invoke-Item $env:USERPROFILE\Desktop\DomainController.htm
