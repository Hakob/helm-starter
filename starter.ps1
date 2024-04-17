<#
.SYNOPSIS
Fetch, list, and delete helm starters from github.

.DESCRIPTION
This script allows you to interact with Helm starters by fetching, listing, updating, deleting, or inspecting them.

.NOTES
Copyright (c) 2024
All rights reserved.
For full license text, see the LICENSE file in the repo root
#>

# Define variables
$HELP = $false
$PASSTHRU = @()

# Define function to display usage information
function Show-Usage {
@"
Fetch, list, and delete helm starters from github.

Available Commands:
    helm starter fetch GITURL       Install a bare Helm starter from Github (e.g git clone)
    helm starter list               List installed Helm starters
    helm starter update NAME        Refresh an installed Helm starter
    helm starter delete NAME        Delete an installed Helm starter
    helm starter inspect NAME       Print out a starter's readme
    --help                          Display this text
"@
}

# Parse arguments
foreach ($arg in $args) {
    switch -regex ($arg) {
        "--help" {
            $HELP = $true
        }
        default {
            $PASSTHRU += $arg
        }
    }
}

# Show help if flagged
if (($HELP) -OR ($PASSTHRU.Length -eq 0)) {
    Show-Usage
    exit 0
}

# Determine the command
$COMMAND = $PASSTHRU[0]

# Create the /starters directory if needed
New-Item -ItemType Directory -Path "$Env:HELM_DATA_HOME\starters" -ErrorAction SilentlyContinue | Out-Null

# Execute the appropriate command
switch ($COMMAND) {
    "fetch" {
        $REPO = $PASSTHRU[1]
        Set-Location "$Env:HELM_DATA_HOME\starters"
        git clone $REPO --quiet
        exit 0
    }
    "update" {
        $STARTER = $PASSTHRU[1]
        Set-Location "$Env:HELM_DATA_HOME\starters\$STARTER"
        git pull origin $(git rev-parse --abbrev-ref HEAD) --quiet
        exit 0
    }
    "list" {
        Get-ChildItem -Path "$Env:HELM_DATA_HOME\starters" | Select-Object -ExpandProperty Name
        exit 0
    }
    "delete" {
        $STARTER = $PASSTHRU[1]
        Remove-Item -Path "$Env:HELM_DATA_HOME\starters\$STARTER" -Recurse -Force
        exit 0
    }
    "inspect" {
        $STARTER = $PASSTHRU[1]
        Get-ChildItem -Path "$Env:HELM_DATA_HOME\starters\$STARTER" -Filter "*readme*" -Recurse | ForEach-Object { Get-Content $Env:_.FullName }
        exit 0
    }
    default {
        Write-Host "Error: Invalid command."
        Show-Usage
        exit 1
    }
}
