function Transfer-File-Powershell-Remoting
{ 

<#
.SYNOPSIS
A cmdlet to copy a file from one host to anthoer using Powershell remoting.


.DESCRIPTION
A cmdlet to copy a file from one host to anthoer using Powershell remoting.

.PARAMETER Computername
The computername is the hostname or IP address of the computer to transfer the file to.

.PARAMETER Username
The username is the user that has the required access to run a remote powershell and 
has required file level acccess on the remote computer. 

.PARAMETER LocalFilename
The full path to the file to transfer this could be c:\test\testfile.txt or even \\workstation\test\testfile.txt.

.PARAMETER DestinationFilename

The full path of the desnation filename, note you can't just use a directory, you must use the full filename.

.EXAMPLE

PS C:> Transfer-File-Powershell-Remoting -Computername workstation -LocalFilename C:\test\testfile.txt -DestinationFilename C:\test\newtestfile.txt -Username user

.LINK

# Helpful for testing by enabling windows remoting 
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1

# Also the following is helpful for enabling remote powershell for specific users if your not using admin
Run in a administrator terminal
Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell
Enable-PSRemoting -Force
https://stackoverflow.com/questions/14127050/powershell-remoting-giving-access-is-denied-error

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-XXXX


#>



    [CmdletBinding()] Param( 

            [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
            [String]
            $LocalFilename,
            
            [Parameter(Mandatory = $true)]
            [String]
            $DestinationFilename,
            
            [Parameter(Mandatory = $true)]
            [String]
            $Computername,
            
            [Parameter(Mandatory = $true)]
            [String]
            $Username

        )

    # Example of using Copy-Item 
    # https://blog.ipswitch.com/use-powershell-copy-item-cmdlet-transfer-files-winrm

    $session = New-PSSession -ComputerName $computerName -Credential $username 

    Copy-Item -Path $LocalFilename -Destination $DestinationFilename -ToSession $session

    $session | Remove-PSSession

}