function HTTP-Web-Server
{ 
<#
.SYNOPSIS
A powershell HTTP webserver with specific urls.

.DESCRIPTION
This powershell web server provides a number of functions to upload and download files, list files, shows current time.

.PARAMETER hostname
The hostname of the server.

.PARAMETER port
The TCP port to listen on.

.PARAMETER WebRoot
The webroot of the server, the local directory to be shared for listing, reading, writing, and deleting files. Defaults to the current working directory, may be dangerous so use w/ caution. -d or -l or -f for short

.PARAMETER url
The hostname

.EXAMPLE
PS C:\> Run-Simple-WebServer -hostname 127.0.0.1 -port 8080 -url http://localhost:8080/

.LINK
# Concepts from 
https://github.com/ahhh/PSSE/blob/master/Run-Simple-WebServer.ps1

# However the code is heavly based on code from
# http://community.idera.com/powershell/powertips/b/tips/posts/creating-powershell-web-server

# Concept of return strucutre from
https://gist.github.com/19WAS85/5424431

# A example of a powershell webserver
https://gallery.technet.microsoft.com/scriptcenter/Powershell-Webserver-74dcf466


.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3237


#>


   [CmdletBinding()] Param( 

       [Parameter(Mandatory = $false)]
       [String]
       $WebRoot = ".",
       

       [Parameter(Mandatory = $true)]
       [String]
       $hostname = $Null,
       
       [Parameter(Mandatory = $false)]
       [String]
       $port = 8080,
       
       [Parameter(Mandatory = $false)]
       [String]
       $url = 'http://localhost:8080/'

    )


    # enter this URL to reach PowerShell’s web server
    $url = 'http://' + $hostname + ':' + $port + '/'

    # Reponse to urls requested by client
    $htmlcontent = @{

      # Simple HTML returned for the base     
      "/"  =  { return '<html><building> Yet another PowerShell webserver </building></html>' }
      
      # Testing the response from function call's, in this case services running on host
      "/services"  =  { return Get-Service | ConvertTo-Html }
      # Listing of the files in the WebRoot
      "/list" = { return ls $WebRoot | ConvertTo-Html }
      # Download a file based on the query string
      "/download" = { return (Get-Content (Join-Path $WebRoot ($querystring))) }
       # Call using the following /upload?file=test.txt&content=testdatainfile note it dosen't matter what the querystrings are
       # 
      "/upload" = { (Set-Content -Path (Join-Path $WebRoot ($context.Request.QueryString[0])) -Value ($context.Request.QueryString[1])) 
                    return "[+] File uploaded: "+$context.Request.QueryString[0] }
      # Return the time on the web server
      "/time" = { return Get-Date -Format s}
    }

    # Create a web server object
    $listener = New-Object System.Net.HttpListener
    # Set the url
    $listener.Prefixes.Add($url)
    # Start the webserver 
    $listener.Start()

    try
    {
        # Start a while loop to listen forver
        while ($listener.IsListening) {  
       
            $context = $listener.GetContext()
            # The request from the client
            $Request = $context.Request
            # The respone to make, based on the request 
            $Response = $context.Response
            # Only going to exist when a ? added
            $querystring = $context.Request.QueryString[0]
          
            Write-Host "[+] Request URL: "$Request.Url
            Write-Host "[+] Request LocalPath: "$Request.Url.LocalPath
            Write-Host "[+] Query String: " $querystring
           
            # process received request
            $html = $htmlcontent.Get_Item($Request.Url.LocalPath)

            Write-Host "[+] Content" $html
            if ($html -eq $null) {
                # So if there is  no url then just return 404
                $Response.statuscode = 404
                $html = { return 'Oops, the page is not available!' }
            } else {
                # Since the url exisits then return the content back to the client
                
                # Run the command returned to genertate the output
                $content = & $html
                # Encode the content so it can be sent to the web browser
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                $Response.ContentLength64 = $buffer.length
                # Send the content to the web client
                $Response.OutputStream.Write($buffer, 0, $buffer.length)
                    
            } 
            Write-Host "[+] The Response code: " $Response.StatusCode
            $Response.Close()
        }
    }
    finally
    {
      $listener.Stop()
    }


}