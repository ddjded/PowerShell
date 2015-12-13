$OtherCleanPathsArr = “C:\Temp\*”, “C:\Windows\Temp\*”
#системные пути для очистки

$InProfilesCleanPathsArr = “\AppData\Local\Temp\*”, “\AppData\Local\Microsoft\Terminal Server Client\Cache\*”, “\AppData\Local\Microsoft\Windows\Temporary Internet Files\*”, “\AppData\Local\Microsoft\Windows\WER\ReportQueue\*”, “\AppData\Local\Microsoft\Windows\Explorer\*”
#пути в профилях для очистки

$Profiles = Get-ChildItem (Get-ItemProperty -path “HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList”).ProfilesDirectory -Exclude “Администратор”, “Administrator”, “Setup”, “Public”, “All Users”, “Default User”
#извлекли из реестра местоположение профилей, сформировали список

$InProfilesCleanPath1c = "\AppData\Local\1C\1Cv82\*", "\AppData\Roaming\1C\1Cv82\*", "\AppData\Local\1C\1Cv8\*", "\AppData\Roaming\1C\1Cv8\*"
#пути к профилю 1с

ForEach ($Path in $OtherCleanPathsArr) {
Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
}
ForEach ($Profile in $Profiles) {
ForEach ($Path in $InProfilesCleanPathsArr) {
Remove-Item -Path $Profile$Path -Recurse -Force -ErrorAction SilentlyContinue
}
}

ForEach ($Profile in $Profiles) {
ForEach ($Path in $InProfilesCleanPathsArr) {
Remove-Item -Path $Profile$Path -Recurse -Force -ErrorAction SilentlyContinue
}
ForEach ($Path1c in $InProfilesCleanPath1c){
Get-ChildItem $Profile$Path1c | Where {$_.Name -as [guid]} |Remove-Item -Force -Recurse
