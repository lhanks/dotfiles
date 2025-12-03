# Bash Coding Standards

**ALL AGENTS working with Bash scripts MUST FOLLOW THESE CONVENTIONS**

## Script Header

Always start scripts with:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `set -e`: Exit on error
- `set -u`: Exit on undefined variable
- `set -o pipefail`: Exit on pipe failure

## Naming Conventions

### Variables
- **Local variables**: `lower_snake_case`
- **Examples**: `user_name`, `file_path`, `total_count`

### Constants/Environment Variables
- **Style**: `UPPER_SNAKE_CASE`
- **Examples**: `MAX_RETRIES`, `DEFAULT_TIMEOUT`, `API_BASE_URL`
- **Export**: Use `export` for environment variables
  ```bash
  export API_KEY="abc123"
  readonly MAX_RETRIES=3
  ```

### Functions
- **Style**: `lower_snake_case`
- **Examples**: `print_usage()`, `validate_input()`, `fetch_data()`
- **Use `local`**: Always declare local variables
  ```bash
  my_function() {
  	local input="$1"
  	local result
  	result=$(process "$input")
  	echo "$result"
  }
  ```

### Files
- **Style**: `kebab-case` or no extension
- **Examples**: `init-dotfiles`, `setup-env`, `deploy-app`
- **With extension**: `.sh` for sourced files
- **Examples**: `utils.sh`, `colors.sh`, `config.sh`

## Quoting

### Always Quote Variables
```bash
# Good
echo "$user_name"
cp "$source_file" "$dest_dir/"

# Bad
echo $user_name
cp $source_file $dest_dir/
```

### Use Double Quotes for Variables, Single for Literals
```bash
# Variables need double quotes
echo "Hello, $name"

# Literal strings use single quotes
echo 'This is a literal $string'
```

## Conditionals

### Use `[[` for Tests
```bash
# Good - use [[ for string/file tests
if [[ -f "$file" ]]; then
	echo "File exists"
fi

if [[ "$string" == "value" ]]; then
	echo "Match"
fi

# Use (( for arithmetic
if (( count > 10 )); then
	echo "Count exceeded"
fi
```

### String Comparisons
```bash
# Equality
[[ "$var" == "value" ]]

# Not equal
[[ "$var" != "value" ]]

# Empty check
[[ -z "$var" ]]

# Not empty
[[ -n "$var" ]]
```

## Functions

### Declaration Style
```bash
# Preferred style (no 'function' keyword)
my_function() {
	local arg1="$1"
	local arg2="${2:-default}"

	# function body
}
```

### Return Values
```bash
# Use return for status codes (0 = success)
validate_input() {
	local input="$1"
	if [[ -z "$input" ]]; then
		return 1
	fi
	return 0
}

# Use echo/printf for output
get_username() {
	echo "$USER"
}

# Capture output
username=$(get_username)
```

## Error Handling

### Check Command Success
```bash
if ! command -v git &> /dev/null; then
	echo "Error: git is not installed" >&2
	exit 1
fi
```

### Redirect Errors to stderr
```bash
echo "Error: Something went wrong" >&2
```

### Cleanup on Exit
```bash
cleanup() {
	rm -f "$temp_file"
}
trap cleanup EXIT
```

## Arrays

### Declaration and Usage
```bash
# Declare array
declare -a files=("file1.txt" "file2.txt" "file3.txt")

# Append to array
files+=("file4.txt")

# Iterate
for file in "${files[@]}"; do
	echo "$file"
done

# Length
echo "Count: ${#files[@]}"
```

## Command Substitution

### Use `$()` Not Backticks
```bash
# Good
current_date=$(date +%Y-%m-%d)

# Bad
current_date=`date +%Y-%m-%d`
```

## Comments

### Script Documentation
```bash
#!/usr/bin/env bash
#
# Script: deploy-app
# Description: Deploys the application to production
# Usage: ./deploy-app [environment]
#
```

### Inline Comments
```bash
# Check if config file exists
if [[ -f "$config_file" ]]; then
	source "$config_file"  # Load configuration
fi
```

## Best Practices

1. **Use `shellcheck`**: Validate scripts with shellcheck
2. **Avoid `eval`**: Security risk, find alternatives
3. **Use `printf` over `echo`**: More portable for formatted output
4. **Check exit codes**: Use `$?` or `if` statements
5. **Use `readonly`**: For constants that shouldn't change
6. **Prefer `[[` over `[`**: More features, safer
7. **Use `local`**: Prevent variable leakage in functions
8. **Quote all expansions**: Prevent word splitting issues
