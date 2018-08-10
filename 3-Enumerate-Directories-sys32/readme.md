# Enumerarte the Windows System32 Directory

if there are any file that aren't adminstrator and has access to write or fullcontrol

This powershell cmdlet will try to list the SMB shares on a given host and then identify the open shares to check if they have read or write access.

The main part of the code is the use of net view command thanks to John Savil's example, then using the Get-ACL to determine the permissions of the folder.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Just run the following cmdlet on a windows system.

## Example

Commands to run the commandlet...

```
PS C:\> Enumerarte-Directoris-Sys32 
```

## Acknowledgments


Fred, getting list of folders/files
* https://social.technet.microsoft.com/Forums/en-US/2aa95771-f24a-4b54-b24d-40be952acf6e/getacl-from-a-getchilditem-list?forum=ITCG

TheMadTechnician, presetnaiton of the Get-ACL output
* https://stackoverflow.com/questions/22233262/formatting-get-acl-output
