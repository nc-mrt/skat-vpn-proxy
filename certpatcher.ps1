#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/skat-vpn-proxy/master/initialize.ps1'))" to launch
function main(){
   
    Get-File-From-Github "skat-root-ca.crt"
    Get-File-From-Github "ImportRootCertificate.ps1"

    Start-Process powershell "$pwd\ImportRootCertificate.ps1 $pwd" -Verb runAs
}

function Get-File-From-Github($filename) {
    if (!(Test-Path ".\$filename")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/skat-vpn-proxy/master/$filename", "$pwd\$filename")
    }    
}

main
