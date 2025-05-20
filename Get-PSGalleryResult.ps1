<#
 
.SYNOPSIS
    This PowerShell script checks if a Module or Script exists in PowerShell Gallery with provided parameter.
 
.DESCRIPTION
    This PowerShell script provides a list of PowerShell Gallery Modules or Scripts that matches given Name or Description
    
.PARAMETER ModuleName
    Name or Description of the existing package in PowerShell Gallery
 
.EXAMPLE
    .\Get-PSGalleryResult.ps1 -ModuleName lamp
    Search for Module or Script at PowerShell Gallery with Name or Description containing ModuleName parameter
 
.OUTPUTS
    Saves a log file (findat-psgallery.log) at %temp% folder

.NOTES
    Author: Thiago Beier (thiago.beier@gmail.com)
    Social: https://x.com/thiagobeier https://thebeier.com/ https://www.linkedin.com/in/tbeier/
    Date created: May 20, 2025
    Date updated: May 20, 2025
 
#> 

param(
    [Parameter()]
    [string]$ModuleName
)

$LogPath = "$env:TEMP\findat-psgallery.log"

if (Test-Path $LogPath) {
    Remove-Item -Path $LogPath -Force
}

$result = @() # Initialize result array

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "$timestamp $Message"
}

if (-not $PSBoundParameters.ContainsKey('ModuleName')) {
    Write-Host "Parameter -ModuleName was not specified."
    Write-Log "Parameter -ModuleName was not specified."
    $ModuleName = "Default-Module"
}
else {

    $findpsgallerymodule = Find-Module -Filter $ModuleName -ErrorAction SilentlyContinue
    $findpsgalleryscript = Find-Script -Filter $ModuleName -ErrorAction SilentlyContinue

    if (-not $findpsgallerymodule) {
        Write-Host ""
        Write-Host "Module '$ModuleName' not found in PowerShell Gallery."
        Write-Log "Module '$ModuleName' not found in PowerShell Gallery."
        Write-Host ""
    }
    else {

        Write-Host ""
        Write-Host "Found $($findpsgallerymodule.name.count) Modules"
        Write-Log "Found $($findpsgallerymodule.name.count) Modules for '$ModuleName'"

        foreach ($item in $findpsgallerymodule) {

            <# 
            Write-Host ""
            Write-Host "-----------------------------"
            Write-Host "Module found: $($item.Name) - $($item.Version) - $($item.Author)"
            Write-Host "Published:    $($item.PublishedDate)"
            Write-Host "-----------------------------"
            Write-Host ""
            #>
            Write-Log "Module found: $($item.Name) - $($item.Version) - $($item.Author) - Published: $($item.PublishedDate)"
            
            # Add module result to array
            $result += [PSCustomObject]@{
                Type      = "Module"
                Name      = $item.Name
                Version   = $item.Version
                Author    = $item.Author
                Published = $item.PublishedDate
            }
        }

    }

    if (-not $findpsgalleryscript) {
        Write-Host ""
        Write-Host "Script '$ModuleName' not found in PowerShell Gallery."
        Write-Log "Script '$ModuleName' not found in PowerShell Gallery."
        Write-Host ""
    }
    else {

        Write-Host ""
        Write-Host "Found $($findpsgalleryscript.name.count) Scripts"
        Write-Log "Found $($findpsgalleryscript.name.count) Scripts for '$ModuleName'"

        foreach ($item in $findpsgalleryscript) {

            <#
            Write-Host ""
            Write-Host "-----------------------------"
            Write-Host "Module found: $($item.Name) - $($item.Version) - $($item.Author)"
            Write-Host "Published:    $($item.PublishedDate)"
            Write-Host "-----------------------------"
            Write-Host ""
            #>
            Write-Log "Script found: $($item.Name) - $($item.Version) - $($item.Author) - Published: $($item.PublishedDate)"
            
            # Add script result to array
            $result += [PSCustomObject]@{
                Type      = "Script"
                Name      = $item.Name
                Version   = $item.Version
                Author    = $item.Author
                Published = $item.PublishedDate
            }
        }

    }

}

# Write-Host "Result: $($result | Out-String)"
explorer.exe $LogPath   

# $result now contains all found modules and scripts as objects