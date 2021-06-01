# Create variables

$sourcefolder = "{Source Folder Here}" # Set the share and folder where you put the custom backgrounds
$TeamsStarted = "$env:APPDATA\Microsoft\Teams"
$DirectoryBGToCreate = "$env:APPDATA\Microsoft\Teams\Backgrounds"
$Uploadfolder = "$env:APPDATA\Microsoft\Teams\Backgrounds\Uploads"
$Logfile = "$env:LOCALAPPDATA\Logs\BG-copy.log"
$Logfilefolder = "$env:LOCALAPPDATA\Logs"

# Create logfile and function

# Check if %localappdata%\Logs is present, if not create folder and logfile

if (!(Test-Path -LiteralPath $Logfilefolder -PathType container)) 
    {
    
        try 
            {
                New-Item -Path $Logfilefolder -ItemType Directory -ErrorAction Stop | Out-Null #-Force
                New-Item -Path $Logfilefolder -Name "BG-copy.log" -ItemType File -ErrorAction Stop | Out-Null #-Force

                Start-Sleep -s 10

            }

        catch 

            {
                Write-Error -Message "Unable to create directory '$Logfilefolder' . Error was: $_" -ErrorAction Stop    
            }

    "Successfully created directory '$Logfilefolder' ."

    }

else 

    {
        "Directory '$Logfilefolder' already exist"
    }

# Clear the logfile before starting

Clear-Content $Logfile

# Create the logwrite function

Function LogWrite
{
   Param ([string]$logstring)
   $Stamp = (Get-Date).toString("dd/MM/yyy HH:mm:ss")
    $Line = "$Stamp $logstring"
 
   Add-content $Logfile -value $Line
}

# Check if teams is started once before for current user

if ( (Test-Path -LiteralPath $TeamsStarted) ) 
    { 
        logwrite "Teams started once before by the current user."
    }

else

    {
        logwrite "Teams has never been started by user"
        Exit 1
    }

# Check if %appdata%\Microsoft\Teams\Background is present, if not create folder

if (!(Test-Path -LiteralPath $DirectoryBGToCreate -PathType container)) 
    {
    
        try 
            {
                New-Item -Path $DirectoryBGToCreate -ItemType Directory -ErrorAction Stop | Out-Null #-Force
            }
        catch 
            {
                Write-Error -Message "Unable to create directory '$DirectoryBGToCreate' . Error was: $_" -ErrorAction Stop    
            }

    logwrite "Successfully created directories '$DirectoryBGToCreate' ."
    }

else 
    {
        logwrite "Directory '$DirectoryBGToCreate' already exist"
    }

# Check if %appdata%\Microsoft\Teams\Background\Uploads is present, if not create folder

if (!(Test-Path -LiteralPath $Uploadfolder -PathType container)) 
    {
    
        try 
            {
                New-Item -Path $Uploadfolder -ItemType Directory -ErrorAction Stop | Out-Null #-Force
            }
        catch 
            {
                Write-Error -Message "Unable to create directory '$Uploadfolder' . Error was: $_" -ErrorAction Stop    
            }

     logwrite "Successfully created directories '$Uploadfolder' ."
    }

else 
    {
        logwrite "Directory '$Uploadfolder' already exist"
    }
Copy-Item -Path L:\Source\Teams_Backgrounds\* -Destination $env:APPDATA\Microsoft\Teams\Backgrounds\Uploads -PassThru


 # Stop Teams
 Get-Process "Teams" -ErrorAction SilentlyContinue | Stop-Process
 #
 # Do what you need to here
 #
 # change to the correct directory
 Set-Location ($ENV:USERPROFILE + '\AppData\Local\Microsoft\Teams')
 # start Teams
 Start-Process -File "$($env:USERProfile)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList '--processStart "Teams.exe"'