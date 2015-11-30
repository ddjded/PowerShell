####################################################
# SetSompDesc.ps1 20090112 ShS
#
#Записываем в атрибут Description каждого объекта Computer, имя, залогоненого на нем пользователя
# test
####################################################
cls
#Функция возращает true, если заданный хост пингуется и false  - в противном случае (спасибо Xaerg'у)
function Test-Host ($Name)
{
    $ping = new-object System.Net.NetworkInformation.Ping
    trap {Write-Verbose "Ошибка пинга"; $False; continue}
    if ($ping.send($Name).Status -eq "Success" ) { $True }
    else { $False }
}
#Filter Where-Online
#{
#    $ping = new-object System.Net.NetworkInformation.Ping
#    trap {Write-Verbose "Ошибка пинга"; Continue}
#    if ($ping.send($_).Status -eq "Success" ) { $_ }
#}
#
#Зададим корневое OU, с которого будет начат поиск компьютеров
$SearchRoot="OU=Computers,OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet"
#

 $Comps = Get-QADComputer -ErrorAction SilentlyContinue -SearchRoot $SearchRoot -SizeLimit 0 #|Select-Object -property "Name","Description"
 foreach ($Comp in $Comps)
 {
  if (Test-Host $Comp.Name)
     {
    $LoggedonUserName = (gwmi Win32_ComputerSystem -ErrorAction SilentlyContinue -ComputerName $Comp.Name).UserName
    #Write-Host "CompName=",$Comp.Name, "  CompDescription=", $Comp.Description, "  LoggedonUser=", $LoggedonUserName
    if (($Comp.Description -ne $LoggedonUserName) -and ($LoggedonUserName -ne $null))
        {
        #Write-Host "`nОтсутствует (или устаревшее) описание компа!`nМеняем на новое...`n`n"
        Set-QADObject $Comp.DN -Description $LoggedonUserName | Out-Null
        }
     }
 }