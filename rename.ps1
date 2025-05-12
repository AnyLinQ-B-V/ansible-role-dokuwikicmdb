# filepath: /powershell-rename-project/powershell-rename-project/Rename-Role.ps1
param (
    [string]$YourName,
    [string]$YourEmail,
    [string]$Namespace,
    [string]$RoleName,
    [string]$Description
)

# Prompt user for input if parameters are not provided
if (-not $YourName) {
    $YourName = Read-Host "Your Name (e.g., John Doe)"
}
if (-not $YourEmail) {
    $YourEmail = Read-Host "Your Email (e.g., john.doe@example.com)"
}
if (-not $Namespace) {
    $Namespace = Read-Host "Galaxy namespace (e.g., anylinq)"
}
if (-not $RoleName) {
    $RoleName = Read-Host "Galaxy role name (e.g., systemupdates)"
}
if (-not $Description) {
    $Description = Read-Host "Galaxy description (e.g., Ansible role to manage system updates)"
}

Write-Host ""
Write-Host "- Updating role information..."

# Define the files to update
$filesToUpdate = @(
    ".github/workflows/ci.yml",
    ".github/workflows/release.yml",
    "meta/main.yml",
    "tasks/main.yml",
    "tests/test.yml",
    "vars/main.yml",
    "handlers/main.yml",
    "defaults/main.yml",
    "README.md"
)

# Update files with the provided input
foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        (Get-Content $file) -replace 'ansibletemplate', $RoleName `
                             -replace 'Ronny Roethof <ronny@roethof.net>', "$YourName <$YourEmail>" `
                             -replace 'A template for creating new Ansible roles', $Description `
                             -replace 'anylinq', $Namespace `
                             -replace 'template-ansible-role', "ansible-role-$RoleName" |
        Set-Content $file
    }
}

Write-Host ""
Write-Host "Note:"
Write-Host "This script does not replace AnyLinQ-specific information, so check the meta/main.yml and README.md for additional updates."
Write-Host "Done! Review the changes before committing."