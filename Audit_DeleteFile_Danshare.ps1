#Переменная $Time тут имеет такое же назначение как в предыдущем скрипте.

$time =  (get-date) - (new-timespan -min 60)

#$Events - содержит время и порядковый номер записи евента с ID=4660. И сортируем по порядковому номеру.
#!!!!Это важное замечание!!! При удалении файла создается сразу 2 записи, с ID=4660 и ID=4663.
$Events = Get-WinEvent -FilterHashtable @{LogName="Security";ID=4660;StartTime=$time} | Select TimeCreated,@{n="Запись";e={([xml]$_.ToXml()).Event.System.EventRecordID}} |sort Запись

#Самые важные команды поиска. Опишу принцип ниже, после листинга скрипта.
$BodyL = ""
$TimeSpan = new-TimeSpan -sec 1
foreach($event in $events){
    $PrevEvent = $Event.Запись
    $PrevEvent = $PrevEvent - 1
    $TimeEvent = $Event.TimeCreated
    $TimeEventEnd = $TimeEvent+$TimeSpan
    $TimeEventStart = $TimeEvent- (new-timespan -sec 1)
    $Body = Get-WinEvent -FilterHashtable @{LogName="Security";ID=4663;StartTime=$TimeEventStart;EndTime=$TimeEventEnd} |where {([xml]$_.ToXml()).Event.System.EventRecordID -match "$PrevEvent"}|where{ ([xml]$_.ToXml()).Event.EventData.Data |where {$_.name -eq "ObjectName"}|where {($_.'#text') -notmatch ".*tmp"} |where {($_.'#text') -notmatch ".*~lock*"}|where {($_.'#text') -notmatch ".*~$*"}} |select TimeCreated, @{n="Файл_";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "ObjectName"} | %{$_.'#text'}}},@{n="Пользователь_";e={([xml]$_.ToXml()).Event.EventData.Data | ? {$_.Name -eq "SubjectUserName"} | %{$_.'#text'}}} 
    if ($Body -match ".*Secret*"){
        $BodyL=$BodyL+$Body.TimeCreated+"`t"+$Body.Файл_+"`t"+$Body.Пользователь_+"`n"
    }
}


$Month = $Time.Month
$Year = $Time.Year
$name = "DeletedFiles-"+$Month+"-"+$Year+".txt"
#$Outfile = "\serverServerLogFilesDeletedFilesLog"+$name
$Outfile = "D:\temp"+$name

$BodyL | out-file $Outfile -append
