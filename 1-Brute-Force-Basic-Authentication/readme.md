# Brute Force Basic Authenticaiton

Basic authenticaiton really shouldn't be used as it offers no protection even, even when SSL is used most people jsut click through.
With the rise of IoT devices also there are many new devices to try and brtueforce that don't even do any logging, so you could smash
away at these for days without anyone noticing. If your looking for some dictnaries to have a try check out the following:
https://crackstation.net/buy-crackstation-wordlist-password-cracking-dictionary.htm

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

For best restuls setup a web server that is comfigured with basic authentication.

## Example

Commands to run the commandlet...

```
PS C:> . ./1-Brute-Force-Basic-Autentication.ps1
PS C:\> Brute-Force-Basic-Authentication -hostname www.target.com -file index.html -usernameList usernames.txt -passwordList passwords.txt -port 80 -protocol http
```

## Acknowledgments

Stack overflow example by "briantist" for base64 encoding for basic authentication
* https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t

Student ID PSP-3061 for tips on how to approach the exam question
* http://lockboxx.blogspot.com/2016/01/brute-force-basic-authentication.html