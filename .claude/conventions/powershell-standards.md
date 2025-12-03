# PowerShell Coding Standards

**ALL AGENTS working with PowerShell MUST FOLLOW THESE CONVENTIONS**

## Script Header

Always start scripts with:
```powershell
#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
```

## Naming Conventions

### Variables
- **Style**: `PascalCase`
- **Examples**: `$UserName`, `$FilePath`, `$TotalCount`
- **Booleans**: Use `Is`, `Has`, `Should`, `Can` prefix
  - Examples: `$IsEnabled`, `$HasError`, `$ShouldContinue`

### Constants
- **Style**: `PascalCase` with `readonly` or script-scope
- **Examples**: `$MaxRetries`, `$DefaultTimeout`
```powershell
Set-Variable -Name 'MaxRetries' -Value 3 -Option ReadOnly
```

### Functions
- **Style**: `Verb-Noun` (approved verbs only)
- **Examples**: `Get-UserData`, `Set-Configuration`, `Invoke-Deployment`
- **Get approved verbs**: `Get-Verb`
```powershell
# Good
function Get-UserProfile { }
function Set-Configuration { }
function Invoke-BuildProcess { }

# Bad
function Fetch-Data { }      # Use Get-
function Do-Something { }    # Use Invoke-
function Setup-Environment { } # Use Initialize-
```

### Parameters
- **Style**: `PascalCase`
- **Examples**: `$Path`, `$UserName`, `$Force`

### Files
- **Style**: `Verb-Noun.ps1` or `PascalCase.ps1`
- **Examples**: `Get-UserData.ps1`, `Initialize-Environment.ps1`
- **Modules**: `.psm1` extension
- **Module manifests**: `.psd1` extension

## Function Structure

### Basic Template
```powershell
function Get-Something {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter()]
		[int]$Count = 10,

		[Parameter()]
		[switch]$Force
	)

	begin {
		# Initialization code
	}

	process {
		# Main logic
	}

	end {
		# Cleanup code
	}
}
```

### Parameter Validation
```powershell
param(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$Path,

	[ValidateRange(1, 100)]
	[int]$Count,

	[ValidateSet('Dev', 'Staging', 'Prod')]
	[string]$Environment,

	[ValidateScript({ Test-Path $_ })]
	[string]$ConfigFile
)
```

## Output and Return Values

### Use Write-* Cmdlets Appropriately
```powershell
# Information to user
Write-Host "Processing..." -ForegroundColor Cyan

# Verbose logging (use -Verbose to see)
Write-Verbose "Connecting to server $ServerName"

# Debug information (use -Debug to see)
Write-Debug "Variable value: $SomeVar"

# Warnings
Write-Warning "File not found, using default"

# Errors
Write-Error "Failed to connect to server"

# Output to pipeline (for data)
Write-Output $Result
# Or simply:
$Result
```

### Return Objects, Not Strings
```powershell
# Good - return structured object
function Get-ServerInfo {
	[PSCustomObject]@{
		Name      = $env:COMPUTERNAME
		OS        = (Get-CimInstance Win32_OperatingSystem).Caption
		Memory    = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
		Timestamp = Get-Date
	}
}

# Bad - return formatted string
function Get-ServerInfo {
	"Server: $env:COMPUTERNAME, OS: Windows"
}
```

## Error Handling

### Try/Catch/Finally
```powershell
try {
	$Result = Get-Content -Path $FilePath -ErrorAction Stop
	# Process result
}
catch [System.IO.FileNotFoundException] {
	Write-Error "File not found: $FilePath"
}
catch {
	Write-Error "Unexpected error: $_"
}
finally {
	# Cleanup code (always runs)
}
```

### ErrorAction Parameter
```powershell
# Stop on error (throws exception)
Get-Item -Path $Path -ErrorAction Stop

# Silently continue
Get-Item -Path $Path -ErrorAction SilentlyContinue

# Continue with warning
Get-Item -Path $Path -ErrorAction Continue
```

## Pipelines

### Use Pipeline Efficiently
```powershell
# Good - single pipeline
Get-ChildItem -Path $Path -Filter "*.log" |
	Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
	Remove-Item -Force

# Bad - multiple loops
$Files = Get-ChildItem -Path $Path -Filter "*.log"
foreach ($File in $Files) {
	if ($File.LastWriteTime -lt (Get-Date).AddDays(-30)) {
		Remove-Item $File -Force
	}
}
```

### ForEach-Object for Pipeline Processing
```powershell
Get-Content $LogFile |
	ForEach-Object {
		if ($_ -match 'ERROR') {
			Write-Warning $_
		}
	}
```

## Comparison Operators

```powershell
# Use PowerShell operators
-eq    # Equal
-ne    # Not equal
-gt    # Greater than
-lt    # Less than
-ge    # Greater or equal
-le    # Less or equal
-like  # Wildcard match
-match # Regex match
-contains # Collection contains

# Examples
if ($Count -gt 10) { }
if ($Name -like "User*") { }
if ($Status -eq 'Active') { }
```

## String Handling

### String Interpolation
```powershell
# Double quotes for variable expansion
$Message = "Hello, $UserName"
$Path = "C:\Users\$UserName\Documents"

# Subexpressions for complex expressions
$Message = "Count: $($Items.Count)"
$Message = "Date: $(Get-Date -Format 'yyyy-MM-dd')"

# Single quotes for literals
$Pattern = 'ERROR:\s+\d+'
```

### Here-Strings for Multi-line
```powershell
$Query = @"
SELECT *
FROM Users
WHERE Status = 'Active'
"@
```

## Comments

### Function Documentation
```powershell
function Get-UserData {
	<#
	.SYNOPSIS
		Retrieves user data from the database.

	.DESCRIPTION
		Connects to the user database and retrieves
		information for the specified user.

	.PARAMETER UserName
		The username to look up.

	.EXAMPLE
		Get-UserData -UserName "jsmith"

	.OUTPUTS
		PSCustomObject with user properties.
	#>
	[CmdletBinding()]
	param(
		[string]$UserName
	)
	# Function body
}
```

## Best Practices

1. **Use `[CmdletBinding()]`**: Enable common parameters
2. **Use approved verbs**: Run `Get-Verb` for list
3. **Validate parameters**: Use `[Validate*]` attributes
4. **Use `-ErrorAction Stop`**: For proper error handling in try/catch
5. **Return objects**: Not formatted strings
6. **Use pipeline**: When processing collections
7. **Use splatting**: For cmdlets with many parameters
   ```powershell
   $Params = @{
   	Path        = $FilePath
   	Destination = $DestPath
   	Force       = $true
   }
   Copy-Item @Params
   ```
8. **Avoid aliases in scripts**: Use full cmdlet names
   ```powershell
   # Good
   Get-ChildItem | Where-Object { $_.Length -gt 1MB }

   # Bad
   gci | ? { $_.Length -gt 1MB }
   ```
