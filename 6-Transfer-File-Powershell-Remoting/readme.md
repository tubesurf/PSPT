# Transfer File Powershell Remoting

Just a cmdlet to transfer a file using windows powershell remoting.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Setup another host to transfer files between and ensure that windows remoting is enabled.

## Example

Commands to run the commandlet...

```
PS C:> Transfer-File-Powershell-Remoting -Computername workstation -LocalFilename C:\test\testfile.txt -DestinationFilename C:\test\newtestfile.txt -Username user

```

## Acknowledgments

Helpful for testing by enabling windows remoting 
* https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1

Also the following is helpful for enabling remote powershell for specific users if your not using admin
Run in a administrator terminal
Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell
Enable-PSRemoting -Force
* https://stackoverflow.com/questions/14127050/powershell-remoting-giving-access-is-denied-error

