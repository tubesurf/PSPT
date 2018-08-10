# Enumerarte Open Windows Sharesn

This powershell cmdlet will try to list the SMB shares on a given host and then identify the open shares to check if they have read or write access.

The main part of the code is the use of net view command thanks to John Savil's example, then using the Get-ACL to determine the permissions of the folder.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Setup a SMB server (windows or linux) with some network shares, the PC running the scan dosen't have to be in the domain as the net view command is used.

## Example

Commands to run the commandlet...

```
PS C:> . ./2-Enumerate-SMB-Open-Shares.ps1
PS C:\> Enumerarte-SMB-Open-Shares -hostname www.target.com 
```

## Acknowledgments

Krzysztof Pytko, use of "Get-ACL -Path <Path-To-Share> | Select AccessToString | Format-List"
* https://www.experts-exchange.com/questions/27467768/Viewing-Share-Permissions-Remotely.html

John Savill, parsing of the net view command
* http://www.itprotoday.com/management-mobility/view-all-shares-remote-machine-powershell

TheMadTechnician, presetnaiton of the Get-ACL output
* https://stackoverflow.com/questions/22233262/formatting-get-acl-output

