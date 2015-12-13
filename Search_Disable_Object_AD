CLS
# Блок переменных
# $LDAPPath – ADSI путь к контейнеру с учетными записями пользователей и компьютеров (в формате LDAP://distinguishedName)
# $Mode - Режим поиска учетных записей (1 - Пользователи, 2 - Компьютеры)
# $CountDisabled – Признак необходимости обработки отключенных учетных записей (1 или 0)
# $LastLogonAgeDaysLimit - Количество дней прошедших с момента последнего входа в систему
#
$LDAPPath = 'LDAP://OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet'
$Mode = 2
$CountDisabled = 0
$LastLogonAgeDaysLimit = 60
#
# Блок поиска
#
$RootDomainOU = [ADSI]$LDAPPath
$Searcher = New-Object System.DirectoryServices.DirectorySearcher($RootDomainOU)
If ($Mode -eq 1) {$Filter = '(objectCategory=person)(objectClass=user)'}
ElseIf ($Mode -eq 2) {$Filter = '(objectCategory=computer)'}
If ($CountDisabled -eq 0) {$Filter = $Filter + '(!(userAccountControl:1.2.840.113556.1.4.803:=2))'}
$Filter = '(&' + $Filter + ')'
$Searcher.Filter = $Filter
$Searcher.PageSize = 5000
[Void]$Searcher.PropertiesToLoad.Add('cn')
[Void]$Searcher.PropertiesToLoad.Add('sAMAccountName')
[Void]$Searcher.PropertiesToLoad.Add('description')
[Void]$Searcher.PropertiesToLoad.Add('lastLogonTimestamp')
$Objects = $Searcher.findall()
#
# Блок основного вывода 
#
$LLDays = (Get-Date).AddDays(-$LastLogonAgeDaysLimit).ToFileTime()
$OldObjects = $Objects | Where-Object {$_.properties.lastlogontimestamp -le $LLDays}
$OldObjects | Select `
@{label='Object Name';expression={$_.properties.cn}},`
@{label='sAMAccountName';expression={$_.properties.samaccountname}},`
@{label='Last Logon Timestamp';expression={[datetime]::FromFileTime(($_.properties.lastlogontimestamp)[0])}},`
@{label='Description';expression={$_.properties.description}}`
| Sort -Property 'Last Logon Timestamp'`
| Format-Table –AutoSize
Write-Host '---------------------------------------------------'
write-host 'Domain accounts in OU:' $Objects.Count
write-host 'Domain accounts with old lastLogonTimestamp:' $OldObjects.Count
Write-Host '---------------------------------------------------'
