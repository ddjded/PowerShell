Cls
#Импортируем модуль для работы с Active Directory
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
#OU Откуда берем пользователей
$sourceOU="OU=Users,OU=Dairy,OU=UA,OU=RUSSIA,OU=Danone,DC=nead,DC=danet"
# Указываем исходный файл
$impfile = "\\10.14.20.39\DanShare\IT-IS\IT\in process\Users\UserAttrAD.csv"
# Импортируем файл, указывая в качестве разделителя символ точку с запятой
$users = Import-CSV $impFile -Delimiter ";"
#Запускаем цикл и парсим каждую строчку
foreach ($user in $users)
{
#Считываем данные из каждой ячейки матрицы в свою переменную
$sAMAccountName = $user.login
$Name = $user.Name
$mail = $user.email
$mailpass = $user.MailPass
$webpage = $user.webpage
$mobileph = $user.mobile
$phone = $user.Ext
$pager = $user.trueloc
#Ищем пользователя в AD и проверяем его актуальность
$userset=get-aduser -f {enabled -eq $false -and name -eq $Name} -SearchBase $sourceOU
if ($userset -eq $Null)
{
# Если пользователь активен
write-host "Пользователь $Name активен"
#Получаем все данные о пользователе в переменную getname
$getname=get-aduser -f {name -eq $Name} -SearchBase $sourceOU
$adname=$getname.SamAccountName
#Изменяем атрибуты пользователя
#write-host "Локация- $pager , Емейл- $mailpass , Таб- $webpage , Моб- $mobileph , Вн- $phone"

# Почта для скрипта по паролям
Set-ADUser $adname -Replace @{telephoneNumber = $mailpass}

# WebPage
Set-ADUser $adname -Replace @{wWWHomePage = $webpage}

# Мобильный
Set-ADUser $adname -Replace @{mobile = $mobileph}

# Внутренний
Set-ADUser $adname -Replace @{ipPhone = $phone}

# Локация
Set-ADUser $adname -Replace @{pager = $pager}

# End If True
}
# Конец цикла For
}
