# Audit Dynamic Group

A PowerShell utility that audits Microsoft Entra ID Dynamic Groups using Microsoft Graph and provides visibility into dynamic membership processing health.

## Features

- Retrieves a dynamic group by display name
- Displays the dynamic membership rule
- Checks membership rule processing status
- Displays last membership evaluation timestamp
- Retrieves current member count
- Exports results to CSV
- Useful for troubleshooting:
  - Intune assignments
  - Windows Autopilot groups
  - Dynamic device groups
  - Dynamic user groups
  - Conditional Access targeting

---

## Author

**Sujin Nelladath**

LinkedIn:  
[https://www.linkedin.com/in/sujin-nelladath-8911968a/](https://www.linkedin.com/in/sujin-nelladath-8911968a/)

---

## Prerequisites

### Microsoft Graph PowerShell Module

The script automatically installs the required module if it is not already available.

```powershell
Microsoft.Graph.Authentication
```

### Required Permissions

The account running the script must have:

```text
Group.Read.All
GroupMember.Read.All
```

The script prompts for authentication using Microsoft Graph.

---

## Usage

### Basic Usage

```powershell
.\AuditDynamicGroup.ps1 -GroupName "AutoPilot-Dynamic"
```

### Export Results

```powershell
.\AuditDynamicGroup.ps1 `
    -GroupName "AutoPilot-Dynamic" `
    -ExportCsv "C:\Temp\DynamicGroupAudit.csv"
```

---

## Example Output

```text
Group : AutoPilot-Dynamic
Rule  : (device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))

GroupName             : AutoPilot-Dynamic
GroupId               : b26b453d-62d0-4998-8569-10dd304b3bad
Status                : Succeeded
StatusDetails         : N/A
LastMembershipUpdated : 2026-08-30T12:47:08Z
RuleEvaluationStatus  : N/A
MemberCount           : 487
CheckedAt             : 2026-09-27 12:46:51
```

---

## Information Collected

| Property | Description |
|-----------|-------------|
| GroupName | Display name of the dynamic group |
| GroupId | Unique Entra ID group identifier |
| Status | Dynamic membership processing state |
| StatusDetails | Additional processing information |
| LastMembershipUpdated | Last successful membership evaluation timestamp |
| RuleEvaluationStatus | Dynamic rule evaluation status |
| MemberCount | Current group membership count |
| CheckedAt | Time the audit was executed |

---

## Common Use Cases

### Windows Autopilot Validation

Validate that devices imported into Windows Autopilot are successfully entering the dynamic device group.

Example rule:

```text
(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))
```

### Intune Assignment Troubleshooting

Verify whether a dynamic group is processing correctly before troubleshooting:

- Win32 App deployments
- Configuration Profiles
- Compliance Policies
- Deployment Rings
- Windows Autopatch

### Dynamic Group Health Checks

Quickly determine:

- Is the group processing successfully?
- When was membership last updated?
- How many members are currently in the group?

---

## CSV Export

When the `-ExportCsv` parameter is used, the audit results are exported in UTF-8 format.

Example:

```csv
GroupName,GroupId,Status,StatusDetails,LastMembershipUpdated,RuleEvaluationStatus,MemberCount,CheckedAt
AutoPilot-Dynamic,b26b453d-62d0-4998-8569-10dd304b3bad,Succeeded,N/A,2026-08-30T12:47:08Z,N/A,487,2026-09-27 12:46:51
```

---

## Notes

- The script does not enumerate group members.
- The script does not modify group membership.
- The script performs read-only operations against Microsoft Graph.
- Membership rule processing status is retrieved from the Microsoft Graph Beta endpoint.

---

## License

MIT License
