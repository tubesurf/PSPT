# HTTP Web Server

A powershell HTTP webserver that uses specific urls to run commands on the hsot.

This powershell web server provides a number of functions to upload and download files, list files, shows current time. 


This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Setup two hosts, one that can run the powershell server, then another host with a web browser.

## Example

Commands to run the commandlet...

```
PS C:> Run-Simple-WebServer -hostname 127.0.0.1 -port 8080 -url http://localhost:8080/

```

## Acknowledgments

Some of the concepts are from 
* https://github.com/ahhh/PSSE/blob/master/Run-Simple-WebServer.ps1

However the code is heavly based on code from
* http://community.idera.com/powershell/powertips/b/tips/posts/creating-powershell-web-server

Concept of return structre from
* https://gist.github.com/19WAS85/5424431

A example of a powershell webserver
* https://gallery.technet.microsoft.com/scriptcenter/Powershell-Webserver-74dcf466


