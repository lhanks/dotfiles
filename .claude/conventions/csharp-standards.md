# C# Coding Standards

**ALL AGENTS working with C# MUST FOLLOW THESE CONVENTIONS**

## Naming Conventions

### Classes, Interfaces, Structs, Enums
- **Style**: `PascalCase`
- **Examples**: `UserService`, `IRepository`, `CustomerDto`, `OrderStatus`
- **Interfaces**: Prefix with `I` (e.g., `IUserService`, `IRepository`)
- **Abstract classes**: Consider prefix `Base` or suffix `Base` (e.g., `BaseController`, `RepositoryBase`)
- **DTOs**: Suffix with `Dto` (e.g., `UserDto`, `OrderDto`)

### Methods
- **Style**: `PascalCase`
- **Examples**: `GetUser()`, `CalculateTotal()`, `ValidateInput()`, `IsValid()`
- **Pattern**: Verb + noun, describes action performed
- **Async methods**: Suffix with `Async` (e.g., `GetUserAsync()`, `SaveDataAsync()`)

### Properties
- **Style**: `PascalCase`
- **Examples**: `UserName`, `TotalCount`, `IsActive`, `CreatedDate`
- **Booleans**: Use `Is`, `Has`, `Can`, `Should` prefix (e.g., `IsActive`, `HasPermission`)

### Fields
- **Private fields**: `_camelCase` with underscore prefix
- **Public/Protected fields**: `PascalCase` (rare, prefer properties)
- **Constants**: `PascalCase`
- **Static readonly**: `PascalCase`
- **Examples**:
  ```csharp
  private readonly IUserService _userService;
  private string _userName;
  public const int MaxRetries = 3;
  public static readonly string DefaultName = "Unknown";
  ```

### Local Variables and Parameters
- **Style**: `camelCase`
- **Examples**: `userName`, `totalCount`, `isValid`
- **Pattern**: Descriptive nouns

### Namespaces
- **Style**: `PascalCase`
- **Pattern**: `Company.Product.Feature.SubFeature`
- **Examples**: `MyCompany.MyApp.Services`, `MyCompany.MyApp.Data.Repositories`

### Files
- **Style**: `PascalCase` (matches primary type name)
- **Examples**: `UserService.cs`, `IRepository.cs`, `CustomerDto.cs`
- **Pattern**: One primary type per file

## Code Style

### General Rules
- **Indentation**: 4 spaces (Visual Studio default)
- **Braces**: Always use braces, even for single-line statements
- **Brace style**: Allman style (braces on new line)
  ```csharp
  // Good
  if (condition)
  {
      DoSomething();
  }

  // Avoid
  if (condition) {
      DoSomething();
  }
  ```
- **Max line length**: 120 characters
- **Using directives**: At top of file, outside namespace
- **Order usings**: System namespaces first, then others, alphabetically

### File Organization
```csharp
// 1. Using directives (System first, then alphabetical)
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Logging;
using MyCompany.MyApp.Models;

// 2. Namespace
namespace MyCompany.MyApp.Services
{
    // 3. Class with XML documentation
    /// <summary>
    /// Provides user management services.
    /// </summary>
    public class UserService : IUserService
    {
        // 4. Private fields
        private readonly ILogger<UserService> _logger;
        private readonly IUserRepository _repository;

        // 5. Constructor
        public UserService(ILogger<UserService> logger, IUserRepository repository)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }

        // 6. Properties
        public bool IsInitialized { get; private set; }

        // 7. Public methods
        public async Task<User> GetUserAsync(string userId)
        {
            // implementation
        }

        // 8. Private methods
        private void ValidateUserId(string userId)
        {
            // implementation
        }
    }
}
```

### Properties
```csharp
// Auto-properties (preferred when no logic needed)
public string UserName { get; set; }
public string FirstName { get; private set; }
public int Count { get; }

// Expression-bodied properties (C# 6+)
public string FullName => $"{FirstName} {LastName}";
public bool IsValid => !string.IsNullOrEmpty(UserName);

// Full properties (when logic is needed)
private string _email;
public string Email
{
    get => _email;
    set
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Email cannot be empty");
        _email = value;
    }
}
```

### Methods

#### Async/Await
- **Always** use `async`/`await` for I/O operations
- **Suffix** async methods with `Async`
- **Return** `Task` or `Task<T>`
- **Use** `ConfigureAwait(false)` in library code

```csharp
// Good
public async Task<User> GetUserAsync(string userId)
{
    try
    {
        var user = await _repository.GetByIdAsync(userId).ConfigureAwait(false);
        return user;
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Failed to get user {UserId}", userId);
        throw;
    }
}

// Avoid
public User GetUser(string userId)
{
    return _repository.GetByIdAsync(userId).Result; // Don't block on async!
}
```

#### Expression-Bodied Methods (for simple methods)
```csharp
public bool IsAdult(int age) => age >= 18;
public string GetDisplayName() => $"{FirstName} {LastName}";
```

### LINQ
- **Prefer** method syntax over query syntax (unless query is more readable)
- **Use** line breaks for readability in complex queries

```csharp
// Good
var activeUsers = users
    .Where(u => u.IsActive)
    .OrderBy(u => u.LastName)
    .Select(u => new UserDto
    {
        Id = u.Id,
        Name = u.FullName
    })
    .ToList();
```

### Null Handling

#### Null-conditional and Null-coalescing Operators
```csharp
// Null-conditional (?.)
var length = user?.Name?.Length;

// Null-coalescing (??)
var name = user?.Name ?? "Unknown";

// Null-coalescing assignment (??=) - C# 8+
_cache ??= new Dictionary<string, object>();
```

#### Nullable Reference Types (C# 8+)
- **Enable** nullable reference types in projects
- **Use** `?` for nullable reference types
- **Use** `!` only when you're certain value is not null

```csharp
// Nullable
public string? MiddleName { get; set; }

// Non-nullable
public string FirstName { get; set; } = string.Empty;
```

### String Handling
```csharp
// String interpolation (preferred)
var message = $"User {userName} logged in at {DateTime.Now}";

// String.Format (when needed for reuse)
var template = "User {0} logged in at {1}";
var message = string.Format(template, userName, DateTime.Now);

// Verbatim strings (for paths, regex, etc.)
var path = @"C:\Users\Documents\file.txt";

// String comparison
if (string.Equals(str1, str2, StringComparison.OrdinalIgnoreCase))
{
    // ...
}
```

## Error Handling

### Exceptions
```csharp
// Throw specific exceptions
public void ProcessUser(User user)
{
    if (user == null)
        throw new ArgumentNullException(nameof(user));

    if (string.IsNullOrWhiteSpace(user.Email))
        throw new ArgumentException("Email is required", nameof(user));

    if (user.Age < 0)
        throw new InvalidOperationException("Age cannot be negative");
}

// Catch specific exceptions
try
{
    await ProcessDataAsync();
}
catch (ArgumentException ex)
{
    _logger.LogWarning(ex, "Invalid argument provided");
    throw; // Re-throw to preserve stack trace
}
catch (Exception ex)
{
    _logger.LogError(ex, "Unexpected error processing data");
    throw new ApplicationException("Data processing failed", ex);
}
```

### Guard Clauses
```csharp
// Good - early return
public void ProcessOrder(Order order)
{
    if (order == null)
        throw new ArgumentNullException(nameof(order));

    if (order.Items.Count == 0)
        return;

    if (!order.IsValid)
    {
        _logger.LogWarning("Invalid order {OrderId}", order.Id);
        return;
    }

    // Main logic here
}
```

## Object-Oriented Patterns

### Dependency Injection
```csharp
public class UserService : IUserService
{
    private readonly IUserRepository _repository;
    private readonly ILogger<UserService> _logger;
    private readonly IEmailService _emailService;

    // Constructor injection (preferred)
    public UserService(
        IUserRepository repository,
        ILogger<UserService> logger,
        IEmailService emailService)
    {
        _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        _emailService = emailService ?? throw new ArgumentNullException(nameof(emailService));
    }
}
```

### Interface Segregation
```csharp
// Good - small, focused interfaces
public interface IUserReader
{
    Task<User> GetByIdAsync(string id);
    Task<IEnumerable<User>> GetAllAsync();
}

public interface IUserWriter
{
    Task<User> CreateAsync(User user);
    Task UpdateAsync(User user);
    Task DeleteAsync(string id);
}

// Avoid - large interfaces with many responsibilities
public interface IUserService
{
    // Too many methods...
}
```

## XML Documentation

### Required for Public APIs
```csharp
/// <summary>
/// Retrieves a user by their unique identifier.
/// </summary>
/// <param name="userId">The unique user identifier.</param>
/// <returns>The user if found; otherwise, null.</returns>
/// <exception cref="ArgumentNullException">Thrown when userId is null or empty.</exception>
public async Task<User?> GetUserAsync(string userId)
{
    // implementation
}
```

## Testing

### Test Class Naming
- **Pattern**: `{ClassUnderTest}Tests`
- **Example**: `UserServiceTests`, `OrderValidatorTests`

### Test Method Naming
- **Pattern**: `MethodName_Scenario_ExpectedBehavior`
- **Example**: `GetUser_ValidId_ReturnsUser`, `CreateOrder_InvalidData_ThrowsException`

```csharp
[TestClass]
public class UserServiceTests
{
    private UserService _userService;
    private Mock<IUserRepository> _mockRepository;

    [TestInitialize]
    public void Setup()
    {
        _mockRepository = new Mock<IUserRepository>();
        _userService = new UserService(_mockRepository.Object);
    }

    [TestMethod]
    public async Task GetUserAsync_ValidId_ReturnsUser()
    {
        // Arrange
        var userId = "123";
        var expectedUser = new User { Id = userId, Name = "Test" };
        _mockRepository.Setup(r => r.GetByIdAsync(userId))
            .ReturnsAsync(expectedUser);

        // Act
        var result = await _userService.GetUserAsync(userId);

        // Assert
        Assert.IsNotNull(result);
        Assert.AreEqual(userId, result.Id);
    }
}
```

## Common Patterns

### Repository Pattern
```csharp
public interface IRepository<T> where T : class
{
    Task<T?> GetByIdAsync(string id);
    Task<IEnumerable<T>> GetAllAsync();
    Task<T> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(string id);
}
```

### Unit of Work Pattern
```csharp
public interface IUnitOfWork : IDisposable
{
    IUserRepository Users { get; }
    IOrderRepository Orders { get; }
    Task<int> SaveChangesAsync();
}
```

### Options Pattern
```csharp
public class EmailSettings
{
    public string SmtpServer { get; set; } = string.Empty;
    public int Port { get; set; }
    public string FromAddress { get; set; } = string.Empty;
}

// In Startup.cs or Program.cs
services.Configure<EmailSettings>(configuration.GetSection("Email"));

// In service
public class EmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> options)
    {
        _settings = options.Value;
    }
}
```

## Code Review Checklist

Before completing any task, verify:
- [ ] All naming conventions followed (PascalCase, camelCase, _fields)
- [ ] Async methods suffixed with `Async`
- [ ] Public APIs have XML documentation
- [ ] Null checks for parameters
- [ ] Proper exception handling
- [ ] Using statements for IDisposable
- [ ] LINQ queries are readable
- [ ] No hardcoded strings (use constants or configuration)
- [ ] Dependency injection used correctly
- [ ] Unit tests follow naming conventions
