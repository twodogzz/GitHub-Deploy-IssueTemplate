# =====================================================================
# Deploy-IssueTemplate.ps1
# Copies the master issue template into every repo under SoftwareProjects
# =====================================================================

$Root = "E:\SoftwareProjects\"
$Template = Join-Path $Root "Documentation\Templates\standard_issue.md"
$Log = Join-Path $Root "Deploy-IssueTemplate.log"

"=== Deploy Issue Template - $(Get-Date) ===" | Out-File $Log -Append

if (-not (Test-Path $Template)) {
    "ERROR: Template not found at $Template" | Out-File $Log -Append
    Write-Host "Template missing. Aborting."
    exit
}

# Get all project folders except Documentation
$Projects = Get-ChildItem $Root -Directory | Where-Object { $_.Name -ne "Documentation" }

foreach ($Project in $Projects) {

    $TargetFolder = Join-Path $Project.FullName ".github\ISSUE_TEMPLATE"
    $TargetFile = Join-Path $TargetFolder "standard_issue.md"

    # Ensure folder exists
    if (-not (Test-Path $TargetFolder)) {
        New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
        "Created folder: $TargetFolder" | Out-File $Log -Append
    }

    # Copy template
    Copy-Item -Path $Template -Destination $TargetFile -Force
    "Deployed template to: $TargetFile" | Out-File $Log -Append
}

"Deployment complete." | Out-File $Log -Append
Write-Host "Issue template deployed to all repos."