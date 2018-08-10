## Powershell For Penetration Testers Exam Task 2 - Enumerarte Open Windows Shares
function Enumerarte-SMB-Open-Shares
{

<#

.SYNOPSIS
This powershell cmdlet will try to list the SMB shares on a given host and then identify the open shares to check if they have read or write access.

.DESCRIPTION
The intent of the script is to check if a host running the SMB protocol has any open shares.

.PARAMETER hostname
The hostname or IP address to brute force against, use the -hostname switch.

.EXAMPLE
PS C:> . ./2-Enumerate-SMB-Open-Shares.ps1
PS C:\> Enumerarte-SMB-Open-Shares -hostname www.target.com 

.LINK
https://github.com/tubesurf/PSPT

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

Technically heavily inspired by:
Krzysztof Pytko, use of "Get-ACL -Path <Path-To-Share> | Select AccessToString | Format-List"
https://www.experts-exchange.com/questions/27467768/Viewing-Share-Permissions-Remotely.html

John Savill, parsing of the net view command
http://www.itprotoday.com/management-mobility/view-all-shares-remote-machine-powershell

TheMadTechnician, presetnaiton of the Get-ACL output
https://stackoverflow.com/questions/22233262/formatting-get-acl-output

#>

[CmdletBinding()] Param(
    
        # A single hostname that could be passed from another function or commandline
        [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
        [String]
        $hostname,


        # A List of hostname or IP addresses that should be scanned
        [Parameter(Mandatory = $false)]
        [String]
        $hostList = $null

)


    function Get-Remote-Share-Access($hostname) { 

        # Use the new view command to get a list of shares
        $shares = net view \\$hostname /all 2>&1 | select -Skip 7 | ?{$_ -match 'disk*'} | %{$_ -match '^(.+?)\s+Disk*'| out-null;$matches[1]} 

        # Test if we found any shares on the server
        if ($shares) {
            Write-Host "[+] Shares found, now checking permissions on host " $hostname -ForegroundColor Green
        } else {
            
            Write-Host "[-] No shares found, check connectivity to host " $hostname  -ForegroundColor Red
            return
        }

        foreach ($share in $shares){
            $path = "\\" + $hostname + "\" + $share

            # Get the folder ACLS 
            Write-Host "[-] Testing path:" $path 
            $folderACLs = Get-ACL -Path $path -ErrorAction SilentlyContinue -ErrorVariable erroroutput | ForEach-Object { $_.Access  }
            
            # Check to see if we could get the details of the share
            if (!$erroroutput) { 
                # Loop through each ACL that is set on the share
                foreach ($ACL in $folderACLs){
                    # Get the user
                    $identityReference = $ACL.IdentityReference.ToString()
                    # Get if the user is permitted
                    $accessControlType = $ACL.AccessControlType.ToString()
                    # Get the rights to the share i.e. read, write, full
                    $fileSystemRights = $ACL.FileSystemRights.ToString()

                    # We want to see if there are any shares that Everyone has access to and flag any that have read, write, or fullcontrol of the share
                    if ( $identityReference -eq "Everyone" -and (($fileSystemRights -like '*Read*' ) -or ($fileSystemRights -like '*Write*') -or ($fileSystemRights -like '*FullControl*')) ){
                        Write-Host "[+]`t User:" $identityReference " Access:" $accessControlType "File System Rights: " $fileSystemRights -ForegroundColor Green
                    }
                }

            } else {
                Write-Host "[-] No access to: " $path -ForegroundColor Red
            }
        }
    }

    Write-Host "[*] Enumerating permissions on shares"  
    if ($hostList) {
        # Grab the list of hosts to try, needs to be at least 1
        $hosts = Get-Content $hostList
        if ( $hosts.Count -gt 0){
            Write-Host "[*] Hosts list read," $hosts.Count " hosts."
        }
        else {
            Write-Host "[-] No hosts read from file: " $hostList -ForegroundColor Red
            return
        }
        # Check the permissions on the host shares
        foreach ($hostname in $hosts) {
            Write-Host "[*] Enumerating permissions on host: " $hostname
            Get-Remote-Share-Access($hostname)
        }
    } elseif ($hostname) {
        Write-Host "[*] Enumerating permissions on host: " $hostname
        Get-Remote-Share-Access($hostname)
    } else {
        Write-Host "[-] No option found" -ForegroundColor Red
    }
}