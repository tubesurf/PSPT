function Registry-Scrapper
{

<#

.SYNOPSIS
This powershell cmdlet will check the windows registry for credentials.

.DESCRIPTION
The intent of this script is to check for snmp and wireless credentials.

.PARAMETER wifi
Dumps all credentials and SSIDs for stored wireless networks.

.PARAMETER snmp
Dumps all credentials for the SNMP server.

.PARAMETER all
Runs all the avalaible searches for credentials!

.EXAMPLE

PS C:\> Registry-Scrapper -snmp True
PS C:\> Registry-Scrapper -wifi True
PS C:\> Registry-Scrapper -all True

.LINK
https://github.com/tubesurf/PSPT

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

Inspired by:

Ideas for credentials in the registry such as SNMP
https://pentestlab.blog/2017/04/19/stored-credentials/

Wireless credentials based on https://gist.github.com/gfoss/c6a594d868d7a3efbc21b582aef32c3c and also http://blog.jocha.se/tech/display-all-saved-wifi-passwords

#>



[CmdletBinding()] Param( 
        
        [Parameter(Mandatory = $false)]
        [String]
        $wifi = $False,
        
        [Parameter(Mandatory = $false)]
        [String]
        $snmp= $False,
        
        [Parameter(Mandatory = $false)]
        [String]
        $all = $False

    )


function Get-Wireless-Credentials {
# Based on https://gist.github.com/gfoss/c6a594d868d7a3efbc21b582aef32c3c
# And also http://blog.jocha.se/tech/display-all-saved-wifi-passwords

    # Get a list of AP's
    $networks = netsh.exe wlan show profiles key=clear | findstr "All"  # List all the profiles
    
    # Check if the host has connected to any networks
    if(!$networks) {
        Write-Host "[-] No wireless networks found" -ForegroundColor Gray
        return
    }

    # Filter out the acrtual SSID name
    $SSIDs = @($networks.Split(":") | findstr -v "All").Trim()           

    # Loop through each of the SSID's trying to get the passwords
    foreach ( $SSID in $SSIDs ) {
        try {
                # Extract the index of the key, if there has been more than one over time
                $password = netsh.exe wlan show profiles name=$SSID key=clear | findstr "Key" | findstr -v "Index"
                $passwordDetail = @($password.Split(":") | findstr -v "Key").Trim()
                Write-Host "[+] SSID: $SSID password: $passwordDetail" -ForegroundColor Green
            } catch {
                # Check if it was a open network i.e. no password thus if the key is absent
                $key = netsh.exe wlan show profiles name=$SSID | findstr "key"
                if($key -like "*Absent*"){
                    Write-Host "[-] SSID: $SSID is a open network no password" -ForegroundColor Gray
                }else {
                    Write-Host "[-] SSID: $SSID could be 802.1x network" -ForegroundColor Red
                }
            }
        }


}


function Get-SNMP-Credentials {
#https://pentestlab.blog/2017/04/19/stored-credentials/
# Help enabling SNMP on windows 10 - https://superuser.com/questions/959387/is-there-an-snmp-feature-for-windows-10
# Help configuring SNMP on winodws 10 - https://support.microsoft.com/en-us/help/324263/how-to-configure-the-simple-network-management-protocol-snmp-service-i
# Idea for display of the value was from https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/11/use-powershell-to-enumerate-registry-property-values/
   
    $path = 'HKLM:\SYSTEM\ControlSet001\Services\SNMP\Parameters\ValidCommunities'

    # Check if the registry entry is there and thus installed
    if (Test-Path $path ) {
        Write-Host "[+] SNMP Registry Path exits, checking for credentials"
    } else {
        Write-Host "[-] SNMP Regisrty path does not exit, looks like its not configured?"
        return
    }
   

   Get-Item $path |

   Select-Object -ExpandProperty property |

   ForEach-Object {
        $Property = $_
        $Value = (Get-ItemProperty -Path $path -Name $_).$_
        
        # Display the diffrent types of SNMP vaules that are found in the registry, all in the clear 
        switch ( $Value)
        {
            1 { Write-Host "[+] SNMP None credential: $Property" -ForegroundColor Green} 
            2 { Write-Host "[+] SNMP Notify credential: $Property" -ForegroundColor Green} 
            4 { Write-Host "[+] SNMP Read credential: $Property" -ForegroundColor Green} 
            8 { Write-Host "[+] SNMP Write credential: $Property" -ForegroundColor Green} 
            16 { Write-Host "[+] SNMP Read and Create credential: $Property" -ForegroundColor Green} 
            default { Write-Host "[-] Unkown Value: $Value for Property: $Property " -ForegroundColor Red}
        }
   }
    

}


If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # We need to run as admin so we can set permissions on the registry
    Write-Warning "[-] You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
} else {
   
    Write-Host "[+] Administrator permission confirmed" 
    if ($all -eq $True)
    {
        Write-Host "[+] Attempting to extract SNMP credentials"
        Get-SNMP-Credentials
        Write-Host "[+] Attempting to extract wireless keys"
        Get-Wireless-Credentials
    }
    else
    {
        if ($wifi -eq $True)
        {
            Write-Host "[+] Attempting to extract wireless keys"
            Get-Wireless-Credentials
        }
        if ($snmp -eq $True)
        {
            Write-Host "[+] Attempting to extract SNMP credentials"
            Get-SNMP-Credentials
        }
        
        if (($snmp -eq $False) -and ($wifi -eq $False))
        {
            Write-Warning "[-] Please Select  'wifi', 'snmp', or 'all'"
            
        }
    }


}


}