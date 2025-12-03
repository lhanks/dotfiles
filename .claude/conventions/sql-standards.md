# SQL Coding Standards

**ALL AGENTS working with SQL MUST FOLLOW THESE CONVENTIONS**

## Naming Conventions

### Tables
- **Style**: `snake_case`, plural nouns
- **Examples**: `users`, `order_items`, `customer_addresses`
- **Pattern**: Descriptive, plural form of entity

### Columns
- **Style**: `snake_case`, singular nouns
- **Examples**: `user_id`, `first_name`, `created_at`, `is_active`
- **Booleans**: Prefix with `is_`, `has_`, `can_`, `should_`
  - Examples: `is_active`, `has_permission`, `can_edit`
- **Timestamps**: Use standard suffixes
  - `created_at`, `updated_at`, `deleted_at`, `published_at`

### Primary Keys
- **Style**: `id` or `{table_name}_id`
- **Examples**: `id`, `user_id`, `order_id`
- **Pattern**: Single column, auto-incrementing integer or UUID

### Foreign Keys
- **Style**: `{referenced_table}_id` (singular)
- **Examples**: `user_id`, `customer_id`, `product_id`
- **Pattern**: References primary key of another table

### Indexes
- **Style**: `idx_{table}_{columns}`
- **Examples**: `idx_users_email`, `idx_orders_customer_id_created_at`
- **Unique indexes**: `uq_{table}_{columns}`
  - Example: `uq_users_email`

### Constraints
- **Primary key**: `pk_{table}`
  - Example: `pk_users`
- **Foreign key**: `fk_{table}_{referenced_table}`
  - Example: `fk_orders_customers`
- **Unique**: `uq_{table}_{column}`
  - Example: `uq_users_email`
- **Check**: `chk_{table}_{column}_constraint`
  - Example: `chk_users_age_positive`

### Views
- **Style**: `v_{descriptive_name}` or `vw_{descriptive_name}`
- **Examples**: `v_active_users`, `v_order_summary`, `vw_customer_totals`

### Stored Procedures
- **Style**: `sp_{verb}_{entity}` or `usp_{verb}_{entity}`
- **Examples**: `sp_get_user`, `sp_create_order`, `usp_update_customer`
- **Prefix**: `sp_` (stored procedure) or `usp_` (user stored procedure)

### Functions
- **Style**: `fn_{verb}_{description}` or `ufn_{verb}_{description}`
- **Examples**: `fn_calculate_total`, `fn_get_user_count`, `ufn_format_phone`

### Triggers
- **Style**: `tr_{table}_{event}_{timing}`
- **Examples**: `tr_users_after_insert`, `tr_orders_before_update`
- **Pattern**: Table name + event (insert/update/delete) + timing (before/after)

## SQL Formatting

### Keywords
- **Style**: UPPERCASE
- **Examples**: `SELECT`, `FROM`, `WHERE`, `JOIN`, `ORDER BY`

### Identifiers
- **Style**: lowercase (table names, column names, aliases)
- **Examples**: `users`, `first_name`, `u`, `oi`

### Indentation
- **Style**: 2 or 4 spaces (be consistent)
- **Align keywords** for readability

### Basic Query Structure
```sql
-- Simple SELECT
SELECT
    user_id,
    first_name,
    last_name,
    email,
    created_at
FROM users
WHERE is_active = TRUE
ORDER BY last_name, first_name;

-- With JOIN
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_amount
FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2024-01-01'
    AND o.status = 'completed'
GROUP BY
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > 100
ORDER BY o.order_date DESC;
```

### Complex Queries
```sql
-- CTE (Common Table Expression) - preferred over subqueries
WITH active_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        email
    FROM customers
    WHERE is_active = TRUE
        AND created_at >= DATEADD(YEAR, -1, GETDATE())
),
customer_orders AS (
    SELECT
        ac.customer_id,
        COUNT(o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spent
    FROM active_customers ac
        LEFT JOIN orders o ON ac.customer_id = o.customer_id
    GROUP BY ac.customer_id
)
SELECT
    ac.customer_id,
    ac.first_name,
    ac.last_name,
    ac.email,
    COALESCE(co.order_count, 0) AS order_count,
    COALESCE(co.total_spent, 0) AS total_spent
FROM active_customers ac
    LEFT JOIN customer_orders co ON ac.customer_id = co.customer_id
WHERE COALESCE(co.order_count, 0) > 0
ORDER BY co.total_spent DESC;
```

## Table Design

### Primary Keys
```sql
-- Auto-increment integer (for most tables)
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    -- or in PostgreSQL/MySQL:
    -- user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- UUID (for distributed systems)
CREATE TABLE sessions (
    session_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    -- or in PostgreSQL:
    -- session_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
```

### Foreign Keys
```sql
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

### Indexes
```sql
-- Single column index
CREATE INDEX idx_users_email ON users(email);

-- Multi-column index (order matters!)
CREATE INDEX idx_orders_customer_date
    ON orders(customer_id, order_date DESC);

-- Unique index
CREATE UNIQUE INDEX uq_users_username ON users(username);

-- Filtered index (SQL Server)
CREATE INDEX idx_active_users
    ON users(last_name, first_name)
    WHERE is_active = 1;

-- Covering index (include columns)
CREATE INDEX idx_orders_customer_covering
    ON orders(customer_id)
    INCLUDE (order_date, status, total_amount);
```

### Constraints
```sql
CREATE TABLE products (
    product_id INT IDENTITY(1,1),
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),

    -- Primary key
    CONSTRAINT pk_products PRIMARY KEY (product_id),

    -- Unique constraint
    CONSTRAINT uq_products_name UNIQUE (product_name),

    -- Check constraints
    CONSTRAINT chk_products_price_positive CHECK (price >= 0),
    CONSTRAINT chk_products_stock_nonnegative CHECK (stock_quantity >= 0)
);
```

### Standard Columns (Audit Fields)
```sql
-- Include these in most tables
CREATE TABLE example_table (
    id INT IDENTITY(1,1) PRIMARY KEY,

    -- Your data columns here

    -- Audit columns (always include)
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NULL, -- FK to users table
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_by INT NULL, -- FK to users table

    -- Soft delete (optional but recommended)
    deleted_at DATETIME NULL,
    deleted_by INT NULL,
    is_deleted BIT NOT NULL DEFAULT 0
);
```

## Common Patterns

### Pagination
```sql
-- SQL Server (OFFSET-FETCH)
SELECT
    user_id,
    username,
    email
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC
OFFSET @PageSize * (@PageNumber - 1) ROWS
FETCH NEXT @PageSize ROWS ONLY;

-- PostgreSQL/MySQL (LIMIT-OFFSET)
SELECT
    user_id,
    username,
    email
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC
LIMIT @PageSize
OFFSET @PageSize * (@PageNumber - 1);
```

### Soft Delete
```sql
-- Mark as deleted instead of DELETE
UPDATE users
SET
    is_deleted = TRUE,
    deleted_at = GETDATE(),
    deleted_by = @CurrentUserId
WHERE user_id = @UserId;

-- Query excluding soft-deleted records
SELECT
    user_id,
    username,
    email
FROM users
WHERE is_deleted = FALSE
    OR is_deleted IS NULL; -- Handle NULL case if column is nullable
```

### Upsert (Insert or Update)
```sql
-- SQL Server (MERGE)
MERGE INTO users AS target
USING (SELECT @UserId AS user_id) AS source
ON target.user_id = source.user_id
WHEN MATCHED THEN
    UPDATE SET
        username = @Username,
        email = @Email,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (username, email, created_at, updated_at)
    VALUES (@Username, @Email, GETDATE(), GETDATE());

-- PostgreSQL (ON CONFLICT)
INSERT INTO users (user_id, username, email, created_at)
VALUES (@UserId, @Username, @Email, NOW())
ON CONFLICT (user_id)
DO UPDATE SET
    username = EXCLUDED.username,
    email = EXCLUDED.email,
    updated_at = NOW();

-- MySQL (ON DUPLICATE KEY)
INSERT INTO users (user_id, username, email, created_at)
VALUES (@UserId, @Username, @Email, NOW())
ON DUPLICATE KEY UPDATE
    username = VALUES(username),
    email = VALUES(email),
    updated_at = NOW();
```

### Conditional Aggregation
```sql
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) AS pending_orders,
    SUM(CASE WHEN status = 'completed' THEN total_amount ELSE 0 END) AS total_revenue
FROM orders
GROUP BY customer_id;
```

### Window Functions
```sql
-- Row number, ranking
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS order_number,
    RANK() OVER (ORDER BY total_amount DESC) AS amount_rank,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
    LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
FROM orders;

-- Running totals
SELECT
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;
```

## Stored Procedures

### Basic Structure
```sql
CREATE PROCEDURE sp_get_user
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        user_id,
        username,
        email,
        first_name,
        last_name,
        is_active,
        created_at
    FROM users
    WHERE user_id = @UserId
        AND (is_deleted = 0 OR is_deleted IS NULL);
END;
```

### With Error Handling
```sql
CREATE PROCEDURE sp_create_order
    @CustomerId INT,
    @OrderItems NVARCHAR(MAX), -- JSON array of items
    @OrderId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate customer exists
        IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @CustomerId)
        BEGIN
            THROW 50001, 'Customer not found', 1;
        END;

        -- Insert order
        INSERT INTO orders (customer_id, order_date, status)
        VALUES (@CustomerId, GETDATE(), 'pending');

        SET @OrderId = SCOPE_IDENTITY();

        -- Insert order items (parsing JSON)
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        SELECT
            @OrderId,
            product_id,
            quantity,
            unit_price
        FROM OPENJSON(@OrderItems)
        WITH (
            product_id INT '$.productId',
            quantity INT '$.quantity',
            unit_price DECIMAL(10,2) '$.unitPrice'
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
```

## Views

### Simple View
```sql
CREATE VIEW v_active_users AS
SELECT
    user_id,
    username,
    email,
    first_name,
    last_name,
    created_at
FROM users
WHERE is_active = TRUE
    AND (is_deleted = FALSE OR is_deleted IS NULL);
```

### Complex View with Joins
```sql
CREATE VIEW v_customer_order_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    MAX(o.order_date) AS last_order_date,
    MIN(o.order_date) AS first_order_date
FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
        AND o.status = 'completed'
WHERE c.is_active = TRUE
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
```

## Performance Best Practices

### DO's
```sql
-- Use appropriate indexes
-- Query with index on email
SELECT user_id, username
FROM users
WHERE email = 'user@example.com';

-- Use EXISTS instead of IN for large subqueries
SELECT customer_id, first_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
        AND o.order_date >= '2024-01-01'
);

-- Use specific columns instead of SELECT *
SELECT user_id, username, email
FROM users;

-- Filter early in CTEs
WITH recent_orders AS (
    SELECT order_id, customer_id, total_amount
    FROM orders
    WHERE order_date >= DATEADD(DAY, -30, GETDATE()) -- Filter here
)
SELECT *
FROM recent_orders;
```

### DON'Ts
```sql
-- Avoid SELECT *
-- Bad
SELECT * FROM users;

-- Avoid functions on indexed columns
-- Bad - index on created_at won't be used
SELECT user_id
FROM users
WHERE YEAR(created_at) = 2024;

-- Good - index can be used
SELECT user_id
FROM users
WHERE created_at >= '2024-01-01'
    AND created_at < '2025-01-01';

-- Avoid leading wildcards in LIKE
-- Bad - can't use index
SELECT user_id
FROM users
WHERE email LIKE '%@example.com';

-- Good - can use index
SELECT user_id
FROM users
WHERE email LIKE 'user@%';
```

## Transactions

### Basic Transaction
```sql
BEGIN TRANSACTION;

BEGIN TRY
    UPDATE accounts
    SET balance = balance - @Amount
    WHERE account_id = @FromAccount;

    UPDATE accounts
    SET balance = balance + @Amount
    WHERE account_id = @ToAccount;

    INSERT INTO transactions (from_account, to_account, amount, transaction_date)
    VALUES (@FromAccount, @ToAccount, @Amount, GETDATE());

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

## Comments

### Single-line Comments
```sql
-- This is a single-line comment
SELECT user_id, username
FROM users
WHERE is_active = TRUE; -- Filter active users only
```

### Multi-line Comments
```sql
/*
 * Get customer order summary for the last 12 months
 * Includes total orders, total spent, and average order value
 */
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE order_date >= DATEADD(MONTH, -12, GETDATE())
GROUP BY customer_id;
```

## Code Review Checklist

Before completing any task, verify:
- [ ] All naming conventions followed (snake_case, prefixes)
- [ ] SQL keywords in UPPERCASE
- [ ] Proper indentation and formatting
- [ ] Indexes on foreign keys and frequently queried columns
- [ ] Constraints defined (PK, FK, unique, check)
- [ ] Audit columns included (created_at, updated_at)
- [ ] Error handling in stored procedures
- [ ] No SELECT * (use specific columns)
- [ ] No functions on indexed columns in WHERE
- [ ] Transactions used for multi-step operations
- [ ] Comments for complex logic
