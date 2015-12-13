$servers = 'wuakyib688', 'wuakyib897', 'wuakyib332', 'wuakreb001', 'wuakheb002' 
$source = 'c:\Management1C\AdminScript\ResetSess\logins.txt'
$dest = 'c$\Management1C\AdminScript\ResetSess\'

$servers | % { if (Test-Connection $_ -quiet) { cp $source \\$_\$dest -r } else { "$_ is not online" } }
