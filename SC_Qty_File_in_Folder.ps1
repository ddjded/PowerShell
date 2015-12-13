<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.93
	 Created on:   	20.08.2015 11:34
	 Created by:   	Kolosowsky Yuriy 
	 Organization: 	Danone 
	 Filename:     	SC_Qty_File_in_Folder.ps1
	===========================================================================
	.DESCRIPTION
		Подсчет файлов в папке и отправка на почту результата
#>
$totalfiles = (Get-ChildItem -Path "\\ouakyicl01sql\in_out\PRODIS\K9ToProcess" -Filter *.* | Measure-Object).Count

$smtpServer = "10.14.20.40"
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "no_reply@name.com"
$msg.To.Add("name.name@name.com")
$msg.subject = "Количетсво файлов в папке \\ouakyicl01sql\in_out\PRODIS\K9ToProcess - $totalfiles"
$msg.body = "Общее количество файлов $totalfiles"
$smtp.Send($msg)
