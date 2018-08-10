# Windows registry scrapper

If there are any file that aren't adminstrator and has access to write or fullcontrol

This powershell cmdlet will try to list the SMB shares on a given host and then identify the open shares to check if they have read or write access.

The main part of the code is the use of net view command thanks to John Savil's example, then using the Get-ACL to determine the permissions of the folder.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Ensure that the system the script is to be run on has connected to encrypted wireless networks. For SNMP you will need to add the pacakage and configure at least a public community string.

## Example

Commands to run the commandlet...

```
PS C:\> Registry-Scrapper -snmp True
PS C:\> Registry-Scrapper -wifi True
PS C:\> Registry-Scrapper -all True
```

## Acknowledgments

Ideas for credentials in the registry such as SNMP
* https://pentestlab.blog/2017/04/19/stored-credentials/

Wireless credentials based on 
* https://gist.github.com/gfoss/c6a594d868d7a3efbc21b582aef32c3c 
* http://blog.jocha.se/tech/display-all-saved-wifi-passwords

