$pathToCertificate = Join-Path (Get-Location) "skat-root-ca.crt"
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($pathToCertificate)

# Add the certificate to the Trusted Root Certification Authorities store
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")
$store.Open("ReadWrite")
$store.Add($cert)
$store.Close()