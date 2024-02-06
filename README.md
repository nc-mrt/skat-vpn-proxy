1.	Install Docker, and get it running. https://docs.docker.com/docker-for-windows/install/ 
1.	Create a folder to store files in. eg. C:\Source\skat-vpn-proxy. Open a PowerShell and point it to this folder (cd C:\Source\skat-vpn-proxy).
1.	Execute this command in PowerShell:  
```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/skat-vpn-proxy/master/initialize.ps1'))
```
1.	When asked, Install FoxyProxy (https://addons.mozilla.org/da/firefox/addon/foxyproxy-standard/ or https://chrome.google.com/webstore/detail/foxyproxy-standard/gcknhkkoolaabfmlnjonogaaifnjlfnp?hl=da) 
1.	Press the FoxyProxy icon in your browser, choose "Use proxies based on their pre-defined patterns and priorities", open Options and import the configuration from the folder you unpacked, that matches your browser.
