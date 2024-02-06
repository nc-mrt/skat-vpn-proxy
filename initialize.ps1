#Run "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/nc-brj/skat-vpn-proxy/master/initialize.ps1'))" to launch
function main(){
    #Test if docker is installed
    if (!( Test-Command -cmdname 'docker'))
    {
         Write-Host 'You need to install Docker'
         exit
    }

    #FoxyProxy policy files
    Get-File-From-Github "FoxyProxy.json"
    
    Write-Host "Please install Foxyproxy (firefox/chrome plugin), and load config through plugin. $pwd\FoxyProxy_chrome.fpx in Chrome, $pwd\FoxyProxy_firefox.json in Firefox"
    Write-Host "Click enter when done"
    Pause
    
    #Start and stop bat files and icon, for shortcuts.
    Get-File-From-Github "skat-root-ca.crt"
    Get-File-From-Github "ImportRootCertificate.ps1"    
    Get-File-From-Github "ShortcutCreate.ps1"    
    Get-File-From-Github "vars.config.template"
    Get-Release-Github "1.0.0"

    Write-Host "Please elevate privileges to admin"
    Write-Host "Click enter when done"
    Pause

    Start-Process powershell "$pwd\ShortcutCreate.ps1 $pwd" -Verb runAs

    $question = "Do need access to timereg iut.ccta.dk (requires Admin)?"

    $choices = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) { 
        Start-Process powershell "$pwd\ImportRootCertificate.ps1 $pwd" -Verb runAs
    }
    #variable file, for saving username and password -ADDED TO avoid UTF-8 Format bug.
    Create-Vars-Config

    Input-To-Vars-Config

    #Launch image
    docker run -v $pwd\vars.config:/mnt/vars.config --cap-add=NET_ADMIN -p 8888:8080 -it --name skat_proxy ncbrj/skat-vpn-proxy
}
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Get-File-From-Github($filename) {
    if (!(Test-Path ".\$filename")) {
        (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/nc-brj/skat-vpn-proxy/master/$filename", "$pwd\$filename")
    }    
}

function Get-Release-Github($version) {
    (New-Object System.Net.WebClient).DownloadFile("https://github.com/nc-brj/skat-vpn-proxy/releases/download/$version/start.exe", "$pwd\start.exe")    
}

function Create-Vars-Config() {
    Copy-Item ".\vars.config.template" "vars.config"
}

function Input-To-Vars-Config() {
    Write-Host "Setting up username and password for SKAT VPN. Press enter to keep value written in [brackets]"

    #Create file if doesnt exist
    if (!(Test-Path ".\vars.config"))
    {
        #Create file silently
    New-Item .\vars.config | Out-Null
    }
    #Load username from file with regex
    $userMatchFromVars = Get-Content .\vars.config | Select-String -Pattern 'user (.*)$'

    #initialize user parameter
    $user

    #If file has value
    if($userMatchFromVars.Matches.Groups.Count -ne 0){
        $user = $userMatchFromVars.Matches.Groups[1]
        # Var for input
        $userAutoComplete = Read-Host -Prompt "Updating vars.config - Input username [$user]"
        # if enter is hit, then this is false, and input is ignored
        if($userAutoComplete){
            $user = $userAutoComplete
        }
    } else {
        #If file is to be created
        $user = Read-Host -Prompt "Creating vars.config - Input username (w-number in format w999999)"
    }
    $fileContent = "set user $user"

    $fileContent | Out-File -Encoding utf8 .\vars.config    
}

main
