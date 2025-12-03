# TypeScript/JavaScript Coding Standards

**ALL AGENTS working with TypeScript/JavaScript MUST FOLLOW THESE CONVENTIONS**

## Naming Conventions

### Variables
- **Style**: `camelCase`
- **Examples**: `userName`, `totalCount`, `apiResponse`
- **Booleans**: Use `is`, `has`, `should`, `can` prefix
  - Examples: `isLoading`, `hasError`, `shouldUpdate`, `canEdit`

### Constants
- **Style**: `UPPER_SNAKE_CASE`
- **Examples**: `API_BASE_URL`, `MAX_RETRIES`, `DEFAULT_TIMEOUT`
- **Location**: Top of file or separate constants file

### Functions/Methods
- **Style**: `camelCase` with verb prefix
- **Examples**: `fetchUser()`, `calculateTotal()`, `validateInput()`
- **Event handlers**: `handle` prefix or `on` prefix
  - Examples: `handleClick()`, `handleSubmit()`, `onUserLogin()`
- **Async functions**: Clear but no special suffix required
  - Examples: `fetchData()`, `saveUser()`, `loadConfig()`

### Decorators
- Always put decorators on their own line.

### Classes
- **Style**: `PascalCase`
- **Examples**: `UserService`, `HttpClient`, `DatabaseConnection`

### Interfaces (TypeScript)
- **Style**: `PascalCase`
- **No prefix**: Just the name (e.g., `User`, `Config`, not `IUser`)
- **Examples**: `User`, `ApiResponse`, `DatabaseConfig`

### Types (TypeScript)
- **Style**: `PascalCase`
- **Examples**: `UserId`, `ApiResponse`, `ErrorHandler`

### Enums (TypeScript)
- **Enum name**: `PascalCase`
- **Enum values**: `PascalCase`
```typescript
enum OrderStatus {
    Pending,
    Approved,
    Shipped,
    Delivered
}
```

### Files
- **Style**: `kebab-case`
- **Examples**: `user-service.ts`, `api-client.js`, `http-utils.ts`
- **React components**: `PascalCase.tsx` (e.g., `UserProfile.tsx`)
- **Test files**: `{filename}.test.ts` or `{filename}.spec.ts`

### Directories
- **Style**: `kebab-case`
- **Examples**: `user-services/`, `api-clients/`, `shared-utils/`

## TypeScript vs JavaScript

### When to Use TypeScript
- **New projects**: Always prefer TypeScript
- **Existing JS projects**: Migrate incrementally (rename .js to .ts)
- **Configuration files**: Can stay as .js if simple

### TypeScript-Specific Rules
```typescript
// Define types for function parameters and return values
function calculateTotal(items: OrderItem[]): number {
    return items.reduce((sum, item) => sum + item.price, 0);
}

// Use interfaces for object shapes
interface User {
    id: string;
    name: string;
    email: string;
    isActive: boolean;
}

// Use type for unions, intersections, primitives
type UserId = string;
type Status = 'active' | 'inactive' | 'pending';
type UserWithTimestamp = User & { createdAt: Date };

// Avoid 'any' - use 'unknown' or specific types
// Bad
function processData(data: any): void { }

// Good
function processData(data: unknown): void {
    if (typeof data === 'string') {
        // TypeScript knows data is string here
    }
}
```

## Code Style

### General Rules
- **Indentation**: 2 spaces
- **Quotes**: Single quotes `'` (except when avoiding escapes)
- **Semicolons**: Always use them
- **Trailing commas**: Use in multi-line objects/arrays
- **Max line length**: 100 characters
- **Line breaks**: Use for readability
- **Braces**:
  - Use braces around single-line if statements
  - Use braces for all blocks (functions, classes, loops, etc.)

#### Examples
```typescript
if (condition) {
    // code
}
for (let i = 0; i < 10; i++) {
    // code
}
function foo() {
    // code
}
```

### Import Organization
```typescript
// 1. Node.js built-in modules
import fs from 'fs';
import path from 'path';

// 2. External dependencies
import express from 'express';
import { chromium } from 'playwright';

// 3. Internal modules (absolute paths)
import { CONFIG } from '@/config';
import { UserService } from '@/services/user-service';

// 4. Relative imports
import { validateUser } from './validation';
import { formatDate } from '../utils/date-utils';

// 5. Type imports (TypeScript) - group separately
import type { User, ApiResponse } from '@/types';
```

### Export Patterns
```typescript
// Named exports (preferred for utilities, services)
export function calculateTotal(items: Item[]): number { }
export class UserService { }

// Default exports (for React components, main classes)
export default class ApiClient { }

// Re-exports
export { UserService } from './user-service';
export type { User } from './types';
```

### Object and Array Destructuring
```typescript
// Object destructuring
function createUser({ username, email, role = 'user' }: CreateUserParams) {
    // ...
}

const { id, name, email } = user;
const { data, error } = await fetchUser(id);

// Array destructuring
const [first, second, ...rest] = items;
const [isLoading, setIsLoading] = useState(false);

// Nested destructuring (use sparingly)
const { user: { profile: { name } } } = response;
```

### Spread Operator
```typescript
// Object spread
const updatedUser = { ...user, email: newEmail };
const mergedConfig = { ...defaultConfig, ...userConfig };

// Array spread
const allItems = [...oldItems, ...newItems];
const copiedArray = [...original];
```

### Template Literals
```typescript
// String interpolation (preferred)
const message = `User ${userName} logged in at ${timestamp}`;

// Multi-line strings
const html = `
    <div>
        <h1>${title}</h1>
        <p>${description}</p>
    </div>
`;

// Tagged templates (for special cases)
const query = sql`SELECT * FROM users WHERE id = ${userId}`;
```

## Functions

### Arrow Functions vs Regular Functions
```typescript
// Arrow functions (preferred for callbacks, short functions)
const double = (x: number) => x * 2;
const greet = (name: string) => `Hello, ${name}!`;

// Regular functions (for methods, functions needing 'this')
function processUser(user: User): void {
    // ...
}

// Method definition in class
class UserService {
    getUser(id: string): User {
        // 'this' context preserved
    }
}
```

### Async/Await
```typescript
// Always use async/await over promise chains
// Good
async function fetchUserData(userId: string): Promise<User> {
    try {
        const response = await api.get(`/users/${userId}`);
        return response.data;
    } catch (error) {
        console.error('Failed to fetch user:', error);
        throw error;
    }
}

// Avoid
function fetchUserData(userId: string): Promise<User> {
    return api.get(`/users/${userId}`)
        .then(response => response.data)
        .catch(error => {
            console.error('Failed to fetch user:', error);
            throw error;
        });
}

// Parallel async operations
const [users, orders] = await Promise.all([
    fetchUsers(),
    fetchOrders()
]);
```

### Default Parameters
```typescript
function createUser(name: string, role: string = 'user', isActive: boolean = true): User {
    return { name, role, isActive };
}
```

### Rest Parameters
```typescript
function sum(...numbers: number[]): number {
    return numbers.reduce((total, n) => total + n, 0);
}
```

## TypeScript Types

### Type Annotations
```typescript
// Primitive types
const username: string = 'john';
const age: number = 30;
const isActive: boolean = true;
const data: null = null;
const value: undefined = undefined;

// Arrays
const numbers: number[] = [1, 2, 3];
const users: User[] = [];
const matrix: number[][] = [[1, 2], [3, 4]];

// Tuples
const point: [number, number] = [10, 20];
const entry: [string, number] = ['age', 30];

// Objects
const user: { name: string; age: number } = {
    name: 'John',
    age: 30
};

// Functions
const add: (a: number, b: number) => number = (a, b) => a + b;
```

### Interfaces
```typescript
// Basic interface
interface User {
    id: string;
    name: string;
    email: string;
    age?: number; // Optional property
    readonly createdAt: Date; // Read-only property
}

// Interface extension
interface AdminUser extends User {
    permissions: string[];
    canDelete: boolean;
}

// Interface for functions
interface SearchFunction {
    (query: string, limit?: number): Promise<User[]>;
}

// Index signatures
interface Dictionary {
    [key: string]: string;
}
```

### Type Aliases
```typescript
// Primitive aliases
type UserId = string;
type Timestamp = number;

// Union types
type Status = 'pending' | 'approved' | 'rejected';
type Result = User | Error;

// Intersection types
type UserWithTimestamp = User & { timestamp: Date };

// Function types
type EventHandler = (event: Event) => void;
type AsyncOperation<T> = () => Promise<T>;

// Generic types
type ApiResponse<T> = {
    data: T;
    error?: string;
    timestamp: Date;
};
```

### Generics
```typescript
// Generic function
function firstElement<T>(arr: T[]): T | undefined {
    return arr[0];
}

// Generic interface
interface Repository<T> {
    getById(id: string): Promise<T>;
    getAll(): Promise<T[]>;
    create(item: T): Promise<T>;
    update(id: string, item: T): Promise<T>;
    delete(id: string): Promise<void>;
}

// Generic class
class Cache<T> {
    private data: Map<string, T> = new Map();

    set(key: string, value: T): void {
        this.data.set(key, value);
    }

    get(key: string): T | undefined {
        return this.data.get(key);
    }
}
```

### Type Guards
```typescript
// typeof guard
function processValue(value: string | number): string {
    if (typeof value === 'string') {
        return value.toUpperCase();
    }
    return value.toString();
}

// instanceof guard
if (error instanceof CustomError) {
    console.log(error.customProperty);
}

// Custom type guard
function isUser(obj: unknown): obj is User {
    return (
        typeof obj === 'object' &&
        obj !== null &&
        'id' in obj &&
        'name' in obj
    );
}
```

## Error Handling

### Try-Catch-Finally
```typescript
async function processData(data: unknown): Promise<void> {
    try {
        validateData(data);
        await saveData(data);
        console.log('Data processed successfully');
    } catch (error) {
        if (error instanceof ValidationError) {
            console.error('Validation failed:', error.message);
        } else if (error instanceof DatabaseError) {
            console.error('Database error:', error.message);
        } else {
            console.error('Unexpected error:', error);
        }
        throw error; // Re-throw if needed
    } finally {
        // Cleanup code
        await closeConnections();
    }
}
```

### Custom Errors
```typescript
class ValidationError extends Error {
    constructor(
        message: string,
        public field: string,
        public value: unknown
    ) {
        super(message);
        this.name = 'ValidationError';
    }
}

throw new ValidationError('Invalid email', 'email', userInput);
```

### Error Results Pattern
```typescript
type Result<T, E = Error> =
    | { success: true; data: T }
    | { success: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
    try {
        const user = await api.get(`/users/${id}`);
        return { success: true, data: user };
    } catch (error) {
        return { success: false, error: error as Error };
    }
}

// Usage
const result = await fetchUser('123');
if (result.success) {
    console.log(result.data.name);
} else {
    console.error(result.error.message);
}
```

## Modern JavaScript Features

### Optional Chaining
```typescript
const userName = user?.profile?.name;
const firstItem = items?.[0];
const result = obj?.method?.();
```

### Nullish Coalescing
```typescript
const name = user.name ?? 'Anonymous';
const port = config.port ?? 3000;

// Different from ||
const count = 0;
const value1 = count || 10; // 10 (0 is falsy)
const value2 = count ?? 10; // 0 (0 is not nullish)
```

### Object Property Shorthand
```typescript
const name = 'John';
const age = 30;

// Shorthand
const user = { name, age };

// Method shorthand
const obj = {
    getName() {
        return this.name;
    }
};
```

## Classes

### Class Definition
```typescript
class UserService {
    // Private fields (TypeScript)
    private readonly repository: UserRepository;
    private cache: Map<string, User>;

    // Public property
    public isInitialized: boolean = false;

    // Constructor
    constructor(repository: UserRepository) {
        this.repository = repository;
        this.cache = new Map();
    }

    // Public method
    async getUser(id: string): Promise<User> {
        const cached = this.cache.get(id);
        if (cached) return cached;

        const user = await this.repository.findById(id);
        this.cache.set(id, user);
        return user;
    }

    // Private method
    private clearCache(): void {
        this.cache.clear();
    }

    // Static method
    static create(repository: UserRepository): UserService {
        return new UserService(repository);
    }

    // Getter
    get cacheSize(): number {
        return this.cache.size;
    }
}
```

## Configuration Pattern

### Config Object
```typescript
// config.ts
export const CONFIG = {
    api: {
        baseUrl: process.env.API_BASE_URL || 'http://localhost:3000',
        timeout: 5000,
        retries: 3
    },
    output: {
        directory: path.join(__dirname, 'out'),
        screenshotDir: path.join(__dirname, 'out', 'png')
    },
    features: {
        enableCache: true,
        debugMode: process.env.NODE_ENV === 'development'
    }
} as const; // as const for literal types

// Type inference
type Config = typeof CONFIG;
```

## Code Review Checklist

Before completing any task, verify:
- [ ] Naming conventions followed (camelCase, PascalCase, kebab-case)
- [ ] TypeScript types defined for parameters and returns
- [ ] No use of `any` type
- [ ] Async/await used instead of promise chains
- [ ] Error handling with try-catch
- [ ] Imports organized correctly
- [ ] Destructuring used where appropriate
- [ ] Template literals for string interpolation
- [ ] Optional chaining (?.) and nullish coalescing (??)
- [ ] Single responsibility per function/class
- [ ] Outputs go to `out/` directory
