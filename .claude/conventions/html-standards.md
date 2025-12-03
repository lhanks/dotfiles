# HTML Coding Standards

**ALL AGENTS working with HTML MUST FOLLOW THESE CONVENTIONS**

## General Rules

### Document Structure
- **DOCTYPE**: Always use HTML5 doctype
- **Language**: Specify language attribute
- **Character encoding**: UTF-8
- **Viewport**: Include for responsive design

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Page description for SEO">
    <title>Page Title</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Content here -->
    <script src="script.js"></script>
</body>
</html>
```

### Naming Conventions

#### IDs
- **Style**: `kebab-case`
- **Examples**: `main-nav`, `hero-section`, `user-profile`
- **Usage**: Unique, use sparingly (prefer classes)
- **Purpose**: JavaScript hooks, anchor links

#### Classes
- **Style**: `kebab-case`
- **Examples**: `nav-item`, `button-primary`, `card-header`
- **Pattern**: Descriptive, reusable
- **BEM notation**: Consider for complex components (see CSS standards)

#### Custom Data Attributes
- **Style**: `data-kebab-case`
- **Examples**: `data-user-id`, `data-product-name`, `data-toggle-target`

#### File Names
- **Style**: `kebab-case.html`
- **Examples**: `index.html`, `about-us.html`, `user-profile.html`

## Formatting

### Indentation
- **Style**: 2 spaces (consistent with CSS/JS)
- **Nest properly**: Indent child elements

```html
<!-- Good -->
<div class="container">
  <header class="header">
    <h1 class="title">Welcome</h1>
  </header>
</div>

<!-- Bad -->
<div class="container">
<header class="header">
<h1 class="title">Welcome</h1>
</header>
</div>
```

### Quotes
- **Style**: Double quotes `"` for attributes
- **Always quote**: Even for single-word values

```html
<!-- Good -->
<img src="image.jpg" alt="Description" class="responsive-img">

<!-- Bad -->
<img src=image.jpg alt='Description' class=responsive-img>
```

### Attributes Order
Standard order for readability:
1. `class`
2. `id`, `name`
3. `data-*` attributes
4. `src`, `for`, `type`, `href`, `value`
5. `title`, `alt`
6. `role`, `aria-*`
7. Event handlers (avoid inline)

```html
<a class="btn btn-primary"
   id="submit-button"
   data-user-id="123"
   href="/submit"
   title="Submit form"
   role="button"
   aria-label="Submit the registration form">
  Submit
</a>
```

### Self-Closing Tags
- **Void elements**: No closing slash needed in HTML5
- **Examples**: `<img>`, `<br>`, `<hr>`, `<input>`, `<meta>`, `<link>`

```html
<!-- HTML5 (preferred) -->
<img src="image.jpg" alt="Description">
<br>
<input type="text" name="username">

<!-- XHTML style (optional but not required) -->
<img src="image.jpg" alt="Description" />
<br />
```

## Semantic HTML

### Use Semantic Elements
```html
<!-- Good - Semantic -->
<header>
  <nav>
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h1>Article Title</h1>
    <p>Article content...</p>
  </article>

  <aside>
    <h2>Related Content</h2>
    <p>Sidebar content...</p>
  </aside>
</main>

<footer>
  <p>&copy; 2024 Company Name</p>
</footer>

<!-- Bad - Non-semantic -->
<div class="header">
  <div class="nav">
    <div class="nav-list">
      <div class="nav-item"><a href="/">Home</a></div>
    </div>
  </div>
</div>
```

### Semantic Elements Reference
- `<header>` - Page or section header
- `<nav>` - Navigation links
- `<main>` - Main content (one per page)
- `<article>` - Self-contained content
- `<section>` - Thematic grouping
- `<aside>` - Tangential content
- `<footer>` - Page or section footer
- `<figure>` / `<figcaption>` - Images with captions
- `<time>` - Date/time
- `<mark>` - Highlighted text
- `<details>` / `<summary>` - Disclosure widget

## Headings

### Hierarchy
- **Use proper order**: h1 → h2 → h3 (don't skip levels)
- **One h1**: Per page (usually page title)
- **Describe content**: Don't choose based on appearance

```html
<!-- Good -->
<h1>Main Page Title</h1>
<section>
  <h2>Section Title</h2>
  <h3>Subsection Title</h3>
  <h3>Another Subsection</h3>
</section>
<section>
  <h2>Another Section</h2>
</section>

<!-- Bad - skipping levels -->
<h1>Main Title</h1>
<h4>Some Content</h4>
```

## Forms

### Structure
```html
<form action="/submit" method="post" class="registration-form">
  <fieldset>
    <legend>Personal Information</legend>

    <div class="form-group">
      <label for="first-name">First Name</label>
      <input
        type="text"
        id="first-name"
        name="firstName"
        class="form-control"
        required
        aria-required="true"
        autocomplete="given-name">
    </div>

    <div class="form-group">
      <label for="email">Email Address</label>
      <input
        type="email"
        id="email"
        name="email"
        class="form-control"
        required
        aria-required="true"
        aria-describedby="email-help"
        autocomplete="email">
      <small id="email-help" class="form-text">
        We'll never share your email.
      </small>
    </div>

    <div class="form-group">
      <label for="country">Country</label>
      <select id="country" name="country" class="form-control" required>
        <option value="">Select a country</option>
        <option value="us">United States</option>
        <option value="ca">Canada</option>
        <option value="uk">United Kingdom</option>
      </select>
    </div>

    <div class="form-group">
      <fieldset>
        <legend>Newsletter Preferences</legend>
        <div class="form-check">
          <input
            type="checkbox"
            id="newsletter-weekly"
            name="newsletter[]"
            value="weekly"
            class="form-check-input">
          <label for="newsletter-weekly" class="form-check-label">
            Weekly Updates
          </label>
        </div>
        <div class="form-check">
          <input
            type="checkbox"
            id="newsletter-monthly"
            name="newsletter[]"
            value="monthly"
            class="form-check-input">
          <label for="newsletter-monthly" class="form-check-label">
            Monthly Newsletter
          </label>
        </div>
      </fieldset>
    </div>
  </fieldset>

  <button type="submit" class="btn btn-primary">Submit</button>
  <button type="reset" class="btn btn-secondary">Reset</button>
</form>
```

### Form Best Practices
- **Always use labels**: Associate with `for` attribute
- **Use appropriate input types**: email, tel, date, number, etc.
- **Include autocomplete**: For better UX
- **Group related fields**: Use `<fieldset>` and `<legend>`
- **Provide validation**: Use HTML5 validation attributes
- **Add help text**: Use `aria-describedby`

## Links and Buttons

### Links vs Buttons
```html
<!-- Links - for navigation -->
<a href="/about" class="nav-link">About Us</a>
<a href="#section-2" class="anchor-link">Jump to Section 2</a>

<!-- Buttons - for actions -->
<button type="button" class="btn" onclick="handleClick()">
  Click Me
</button>
<button type="submit" class="btn btn-primary">Submit Form</button>

<!-- Don't do this -->
<a href="#" onclick="handleClick()">Click Me</a> <!-- Use button instead -->
<button type="button" onclick="location.href='/about'">About</button> <!-- Use link instead -->
```

### Link Attributes
```html
<!-- External links -->
<a href="https://example.com"
   target="_blank"
   rel="noopener noreferrer">
  External Site
</a>

<!-- Download links -->
<a href="/files/document.pdf" download="document.pdf">
  Download PDF
</a>

<!-- Email links -->
<a href="mailto:user@example.com">Contact Us</a>

<!-- Phone links -->
<a href="tel:+1234567890">Call Us</a>
```

## Images

### Basic Image
```html
<img
  src="images/logo.png"
  alt="Company Logo"
  width="200"
  height="100"
  loading="lazy">
```

### Responsive Images
```html
<!-- srcset for different resolutions -->
<img
  src="images/photo.jpg"
  srcset="images/photo-320w.jpg 320w,
          images/photo-640w.jpg 640w,
          images/photo-1280w.jpg 1280w"
  sizes="(max-width: 320px) 280px,
         (max-width: 640px) 600px,
         1200px"
  alt="Descriptive text"
  loading="lazy">

<!-- Picture element for art direction -->
<picture>
  <source media="(min-width: 800px)" srcset="images/hero-large.jpg">
  <source media="(min-width: 400px)" srcset="images/hero-medium.jpg">
  <img src="images/hero-small.jpg" alt="Hero image">
</picture>
```

### Figure with Caption
```html
<figure>
  <img src="images/chart.png" alt="Sales chart for Q4 2024">
  <figcaption>
    Figure 1: Sales performance in Q4 2024 showing 25% growth
  </figcaption>
</figure>
```

### Image Best Practices
- **Always include alt**: Describe image content
- **Empty alt for decorative**: `alt=""` (not missing)
- **Use appropriate formats**: JPEG (photos), PNG (graphics), SVG (icons), WebP (modern)
- **Lazy loading**: Add `loading="lazy"` for below-fold images
- **Specify dimensions**: Prevent layout shift

## Tables

### Proper Table Structure
```html
<table class="data-table">
  <caption>Employee Roster 2024</caption>
  <thead>
    <tr>
      <th scope="col">Employee ID</th>
      <th scope="col">Name</th>
      <th scope="col">Department</th>
      <th scope="col">Start Date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>001</td>
      <td>John Doe</td>
      <td>Engineering</td>
      <td>2024-01-15</td>
    </tr>
    <tr>
      <td>002</td>
      <td>Jane Smith</td>
      <td>Marketing</td>
      <td>2024-02-01</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td colspan="4">Total Employees: 2</td>
    </tr>
  </tfoot>
</table>
```

### Table Best Practices
- **Use tables for data**: Not for layout
- **Include caption**: Describe table purpose
- **Use thead/tbody/tfoot**: For structure
- **Scope attributes**: `scope="col"` or `scope="row"` for headers
- **Responsive tables**: Use CSS for mobile

## Accessibility (a11y)

### ARIA Attributes
```html
<!-- Landmark roles (when semantic HTML isn't enough) -->
<div role="navigation" aria-label="Main navigation">...</div>
<div role="search" aria-label="Site search">...</div>

<!-- Live regions -->
<div role="alert" aria-live="assertive">
  Form submitted successfully!
</div>

<!-- Hidden content -->
<button aria-expanded="false" aria-controls="menu">
  Menu
</button>
<nav id="menu" aria-hidden="true">...</nav>

<!-- Form controls -->
<input
  type="text"
  aria-label="Search"
  aria-required="true"
  aria-describedby="search-help">
<span id="search-help">Enter keywords to search</span>

<!-- Current page in navigation -->
<nav>
  <a href="/" aria-current="page">Home</a>
  <a href="/about">About</a>
</nav>
```

### Accessibility Checklist
- [ ] All images have meaningful alt text
- [ ] Form inputs have associated labels
- [ ] Landmark roles or semantic HTML used
- [ ] Color is not the only indicator
- [ ] Links have descriptive text (not "click here")
- [ ] Heading hierarchy is logical
- [ ] Tables have proper structure
- [ ] Keyboard navigation works
- [ ] ARIA attributes used appropriately

## Comments

- Always use ALL CAPS for section comments.

### When to Comment
```html
<!-- MAIN NAVIGATION -->
<nav class="main-nav">
  <!-- ... -->
</nav>

<!-- TODO: Replace with dynamic content from API -->
<div class="placeholder">Static content</div>

<!-- Temporary fix for IE11 compatibility - remove after IE11 EOL -->
<div class="ie-hack">...</div>

<!-- USER PROFILE: START -->
<section class="user-profile">
	<!-- EDIT USER PROFILE -->
	<a href="/user-profile/edit">Edit User Profile</a>
  <!-- ... -->
</section>
<!-- USER PROFILE: END -->
```

### What Not to Comment
```html
<!-- Bad - obvious comments -->
<!-- This is a div -->
<div>Content</div>

<!-- Header -->
<header>...</header>
```

## Script and Style Tags

### Placement
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Critical CSS inline (optional for performance) -->
  <style>
    /* Critical above-the-fold styles */
  </style>

  <!-- External CSS -->
  <link rel="stylesheet" href="styles.css">

  <!-- Preload important resources -->
  <link rel="preload" href="font.woff2" as="font" type="font/woff2" crossorigin>
</head>
<body>
  <!-- Content -->

  <!-- Scripts at end of body (or use defer/async) -->
  <script src="script.js"></script>

  <!-- Or in head with defer -->
  <!-- <script src="script.js" defer></script> -->
</body>
</html>
```

### Script Loading
```html
<!-- Defer - execute after HTML parsed, in order -->
<script src="app.js" defer></script>

<!-- Async - execute as soon as loaded, order not guaranteed -->
<script src="analytics.js" async></script>

<!-- Module scripts (always deferred) -->
<script type="module" src="main.js"></script>
```

## Meta Tags

### Essential Meta Tags
```html
<head>
  <!-- Character encoding -->
  <meta charset="UTF-8">

  <!-- Viewport for responsive design -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- SEO -->
  <meta name="description" content="Page description (150-160 characters)">
  <meta name="keywords" content="keyword1, keyword2, keyword3">
  <meta name="author" content="Author Name">

  <!-- Open Graph (social media) -->
  <meta property="og:title" content="Page Title">
  <meta property="og:description" content="Page description">
  <meta property="og:image" content="https://example.com/image.jpg">
  <meta property="og:url" content="https://example.com/page">
  <meta property="og:type" content="website">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Page Title">
  <meta name="twitter:description" content="Page description">
  <meta name="twitter:image" content="https://example.com/image.jpg">

  <!-- Favicon -->
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">

  <title>Page Title | Site Name</title>
</head>
```

## Code Review Checklist

Before completing any task, verify:
- [ ] Valid HTML5 (use validator)
- [ ] Semantic HTML elements used
- [ ] All naming conventions followed (kebab-case)
- [ ] Proper indentation (2 spaces)
- [ ] All images have alt text
- [ ] Forms have proper labels and structure
- [ ] Accessibility attributes included
- [ ] Meta tags for SEO and social media
- [ ] Scripts loaded efficiently (defer/async)
- [ ] No inline styles or scripts (except critical CSS)
- [ ] Heading hierarchy is correct (h1 → h2 → h3)
- [ ] Links vs buttons used appropriately
