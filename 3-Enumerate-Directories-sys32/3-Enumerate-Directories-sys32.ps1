
function Enumerarte-Directoris-Sys32
{

<#

.SYNOPSIS
This powershell cmdlet will read the C:\Windows\system32\ directory.

.DESCRIPTION
The intent of this script is to check the permissions on the directory to find any non Administrator directories.

.EXAMPLE

PS C:\> Enumerarte-Directoris-Sys32 

.LINK
https://github.com/tubesurf/PSPT

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

Inspired by:

Fred, getting list of folders/files
https://social.technet.microsoft.com/Forums/en-US/2aa95771-f24a-4b54-b24d-40be952acf6e/getacl-from-a-getchilditem-list?forum=ITCG

TheMadTechnician, presetnaiton of the Get-ACL output
https://stackoverflow.com/questions/22233262/formatting-get-acl-output

#>

#Get the list of folders/files
$table = get-childitem -Path "C:\Windows\system32\" -Directory -Recurse -ErrorAction SilentlyContinue

#Loop to get ACLs from each entry
foreach ($item in $table)
{
    try{
        #Get the ACLS's of the directories
        $folderACLs = Get-ACL -Path $item.FullName -ErrorAction SilentlyContinue -ErrorVariable erroroutput | ForEach-Object { $_.Access  }
        
        if (!$erroroutput) { 
            # Loop through each ACL that is set on the share
            foreach ($ACL in $folderACLs){
                # Get the user
                $identityReference = $ACL.IdentityReference.ToString()
                # Get if the user is permitted
                $accessControlType = $ACL.AccessControlType.ToString()
                # Get the rights to the share i.e. read, write, full
                $fileSystemRights = $ACL.FileSystemRights.ToString()

                # We want to see if there are any file that aren't adminstrator and has access to write or fullcontrol
                # https://social.technet.microsoft.com/Forums/Azure/en-US/cb822c55-9f96-48e6-9c60-ca64ed13ef94/what-is-the-diference-between-acl-access-rule-quot268435456quot-and-quotfullcontrolquot?forum=winserverpowershell
                # Note: issues with Modify, Delete, FullControl -1610612736, –536805376, and 268435456
               if (!(($identityReference -like '*Administrator*') -or  ($identityReference -like '*SYSTEM*')) -and (($fileSystemRights -like '*Write*') -or ($fileSystemRights -like '*FullControl*')) ) {
                    Write-Host "[+] " $item.FullName"`t User:" $identityReference "File System Rights: " $fileSystemRights -ForegroundColor Green
               }
            }

        } else {
            # Handy to know which directories we don't have access to
            Write-Host "[-] No access to: " $item.FullName -ForegroundColor Red
        }
    }catch {
        Write-Host "[-] No access to: " $item.FullName -ForegroundColor Red
    }  
}

}