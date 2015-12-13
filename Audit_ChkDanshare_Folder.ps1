$SearchRoot='OU=FSTOOL,OU=ITCC,OU=EMEA,OU=Danone,DC=nead,DC=danet'

$groups = Get-QADGroup -SearchRoot $SearchRoot -Description '\\wuakyif001*'
ForEach ($group in $groups)
{
#Write-Host "Группа " $group.DirectoryEntry.description
#Get-QADGroupMember $group  -Indirect | Select Name -ExpandProperty Name
$groupDS = $group.DirectoryEntry.description -replace '.$' -replace '.$'

$a = Get-ChildItem $groupDS
#Test-Path $a

if ($a.Count)
{
#    "C:\Scripts contains files"
    Write-Host "Группа " $groupDS ' содержит файлы'
    Get-QADGroupMember $group  | Select Name -ExpandProperty Name
}
else
{
    Write-Host "Группа " $groupDS ' не содержит файлы'
#    "C:\Scripts does not contain files"
}
#
}
