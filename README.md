# split-vpn

#RU

Скрипт *"vpnupdate.ps1"* ищет IP адреса доменов перечисленных в текстовом файле *"sites.txt"* и добавляет маршруты до этих адресов к существующему VPN соединению и перезапускает соединение. Split tunneling для VPN соединения включается автоматически самим скриптом.

До запуска скрипта нужно установить значение переменной `$VPNConnectionName` названием вашего VPN соединения. Например: `$VPNConnectionName = "My super VPN"`.

Домен, к которому вы хотите получить доступ через VPN, добавляется в файл *"sites.txt"* в чистом виде, без "http://" или "https://" или других посторонних символов. В указанном файле уже содержатся примеры нескольких доменов.

Вследствие того, что иногда домены меняют свои IP адреса, рекомендую добавить скрипт как задание в "Планировщик задач" Windows. Неактуальные маршруты будут удалены автоматически.

Требования: Windows 10/11 и наличие установленного Powershell


#EN

The *"vpnupdate.ps1"* script lookup for the IP addresses of the domains listed in the text file *"sites.txt"* and adds routes to these addresses to the existing VPN connection and restarts the connection. Split tunneling for VPN connection is enabled automatically by the script itself.

Before running the script, you need to set the value of the `$VPNConnectionName` variable with the name of your VPN connection. For example: `$VPNConnectionName = "My super VPN"`.

The domain you want to access via VPN is added to the file *"sites.txt"* in its pure form, without "http://" or "https://" or other extraneous characters. The specified file already contains examples of several domains.

Due to the fact that sometimes domains change their IP addresses, I recommend adding the script as a task to the Windows Task Scheduler. Irrelevant routes will be deleted automatically.

Requirements: Windows 10/11 and the presence of installed Powershell