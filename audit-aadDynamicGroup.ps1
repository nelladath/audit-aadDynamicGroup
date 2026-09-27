##########################################################################

#AuditDynamicGroup.ps1

#Author: Sujin Nelladath

#LinkedIn : https://www.linkedin.com/in/sujin-nelladath-8911968a/

############################################################################


param(

    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$ExportCsv
)

# Make sure the Graph module is available
if (-not (Get-Module -ListAvailable Microsoft.Graph.Authentication)) 

{
    Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Authentication

Connect-MgGraph -Scopes "Group.Read.All","GroupMember.Read.All" -NoWelcome

# Find the group by display name
$uri = "https://graph.microsoft.com/v1.0/groups?`$filter=displayName eq '$GroupName'&`$select=id,displayName,membershipRule"

$result = Invoke-MgGraphRequest -Method GET -Uri $uri 

if (-not $result.value) 
{
    Write-Error "Could not find a group named '$GroupName'" 
    return
}

$group = $result.value[0]
Write-Host "Group : $($group.displayName) ($($group.id))" -ForegroundColor Green
Write-Host "Rule  : $($group.membershipRule)" -ForegroundColor Green

# Get membership rule processing status
$statusUri = "https://graph.microsoft.com/beta/groups/$($group.id)?`$select=membershipRuleProcessingStatus"
$data = Invoke-MgGraphRequest -Method GET -Uri $statusUri 
$s = $data.membershipRuleProcessingStatus


# Get Member Count
try
{
    $memberUri = "https://graph.microsoft.com/v1.0/groups/$($group.id)/members/`$count"
    
    $memberCount = (Invoke-MgGraphRequest `
        -Method GET `
        -Uri $memberUri `
        -Headers @{ConsistencyLevel="eventual"})
}
catch
{
    $memberCount = "Unable to retrieve"
}


$result = [PSCustomObject]@{
    GroupName             = $group.displayName
    GroupId               = $group.id
    Status                = if ($s.status) { $s.status } else { 'N/A' }
    StatusDetails         = if ($s.statusDetails) { $s.statusDetails } else { 'N/A' }
    LastMembershipUpdated = if ($s.lastMembershipUpdated) { $s.lastMembershipUpdated } else { 'N/A' }
    RuleEvaluationStatus  = if ($s.membershipRuleEvaluationStatus) { $s.membershipRuleEvaluationStatus } else { 'N/A' }
    MemberCount           = $memberCount
    CheckedAt             = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
}

$result | Format-List

if ($ExportCsv) 

{
    $result | Export-Csv -Path $ExportCsv -NoTypeInformation -Encoding UTF8
    Write-Host "Saved to $ExportCsv"
}
