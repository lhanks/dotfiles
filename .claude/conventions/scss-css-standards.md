# SCSS/CSS Coding Standards

**ALL AGENTS working with SCSS/CSS MUST FOLLOW THESE CONVENTIONS**

## Naming Conventions

### Classes
- **Style**: `kebab-case`
- **Examples**: `.nav-item`, `.button-primary`, `.card-header`
- **Pattern**: Descriptive, reusable

### IDs
- **Style**: `kebab-case`
- **Examples**: `#main-nav`, `#hero-section`
- **Usage**: Avoid using for styling (use for JS hooks only)

### BEM Methodology (Recommended for Components)
- **Block**: `.block-name`
- **Element**: `.block-name__element-name`
- **Modifier**: `.block-name--modifier-name`

```scss
// Block
.card { }

// Elements
.card__header { }
.card__body { }
.card__footer { }

// Modifiers
.card--featured { }
.card--large { }

// Element with modifier
.card__header--sticky { }
```

### SCSS Variables
- **Style**: `$kebab-case` or `$snake_case`
- **Prefer**: `$kebab-case` for consistency with CSS
- **Examples**: `$primary-color`, `$font-size-large`, `$breakpoint-md`

```scss
// Colors
$primary-color: #007bff;
$secondary-color: #6c757d;
$success-color: #28a745;
$error-color: #dc3545;

// Spacing
$spacing-unit: 8px;
$spacing-small: $spacing-unit;
$spacing-medium: $spacing-unit * 2;
$spacing-large: $spacing-unit * 3;

// Typography
$font-family-base: 'Helvetica Neue', Arial, sans-serif;
$font-size-base: 16px;
$font-size-large: 20px;
$font-weight-normal: 400;
$font-weight-bold: 700;

// Breakpoints
$breakpoint-sm: 576px;
$breakpoint-md: 768px;
$breakpoint-lg: 992px;
$breakpoint-xl: 1200px;
```

### SCSS Mixins and Functions
- **Style**: `kebab-case` or `camelCase`
- **Prefer**: `kebab-case` for consistency

```scss
// Mixins
@mixin flex-center { }
@mixin button-variant($color) { }
@mixin media-breakpoint-up($breakpoint) { }

// Functions
@function calculate-rem($pixels) { }
@function get-color($name) { }
```

### CSS Custom Properties (Variables)
- **Style**: `--kebab-case`
- **Examples**: `--primary-color`, `--spacing-unit`

```css
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --font-size-base: 16px;
  --spacing-unit: 8px;
}
```

### Files
- **Style**: `kebab-case.scss` or `_kebab-case.scss` (partials)
- **Examples**: `styles.scss`, `_variables.scss`, `_mixins.scss`, `_buttons.scss`
- **Partials**: Prefix with underscore `_`

## File Organization

### Structure
```
styles/
├── abstracts/
│   ├── _variables.scss      # Variables
│   ├── _mixins.scss          # Mixins
│   ├── _functions.scss       # Functions
│   └── _placeholders.scss    # Placeholder selectors
├── base/
│   ├── _reset.scss           # Reset/normalize
│   ├── _typography.scss      # Typography rules
│   └── _base.scss            # Base styles
├── components/
│   ├── _buttons.scss         # Button styles
│   ├── _cards.scss           # Card styles
│   ├── _forms.scss           # Form styles
│   └── _modals.scss          # Modal styles
├── layout/
│   ├── _header.scss          # Header
│   ├── _footer.scss          # Footer
│   ├── _sidebar.scss         # Sidebar
│   └── _grid.scss            # Grid system
├── pages/
│   ├── _home.scss            # Home page specific
│   └── _about.scss           # About page specific
├── themes/
│   ├── _dark.scss            # Dark theme
│   └── _light.scss           # Light theme
├── vendors/
│   └── _bootstrap.scss       # Third-party overrides
└── main.scss                 # Main file that imports all
```

### Main SCSS File
```scss
// main.scss

// 1. Abstracts
@import 'abstracts/variables';
@import 'abstracts/functions';
@import 'abstracts/mixins';
@import 'abstracts/placeholders';

// 2. Vendors
@import 'vendors/bootstrap';

// 3. Base
@import 'base/reset';
@import 'base/typography';
@import 'base/base';

// 4. Layout
@import 'layout/header';
@import 'layout/footer';
@import 'layout/sidebar';
@import 'layout/grid';

// 5. Components
@import 'components/buttons';
@import 'components/cards';
@import 'components/forms';
@import 'components/modals';

// 6. Pages
@import 'pages/home';
@import 'pages/about';

// 7. Themes
@import 'themes/light';
@import 'themes/dark';
```

## Formatting

### Indentation and Spacing
- **Indentation**: 1 tab
- **Space after selector**: One space before opening brace
- **Space after property colon**: One space
- **Blank line between rules**: One line

```scss
// Good
.selector {
	property: value;
	another-property: value;
}

.another-selector {
  property: value;
}

// Bad
.selector{
  property:value;
  another-property:value;}
.another-selector{property:value;}
```

### Declaration Order
Group properties logically:
1. Positioning
2. Box model
3. Typography
4. Visual
5. Misc

```scss
.element {
  // Positioning
  position: absolute;
  top: 0;
  right: 0;
  z-index: 10;

  // Box model
  display: flex;
  width: 100%;
  height: 100px;
  margin: 10px;
  padding: 10px;
  border: 1px solid #ccc;

  // Typography
  font-family: Arial, sans-serif;
  font-size: 16px;
  line-height: 1.5;
  text-align: center;

  // Visual
  background-color: #fff;
  color: #333;
  opacity: 1;

  // Misc
  cursor: pointer;
  transition: all 0.3s ease;
}
```

### Nesting (SCSS)
- **Max depth**: 3 levels
- **Use nesting**: For pseudo-classes, pseudo-elements, and child selectors
- **Avoid deep nesting**: Flattens specificity

```scss
// Good
.nav {
  display: flex;

  &__item {
    padding: 10px;

    &:hover {
      background-color: #f0f0f0;
    }

    &--active {
      font-weight: bold;
    }
  }
}

// Bad - too deep
.nav {
  .nav-list {
    .nav-item {
      .nav-link {
        .nav-icon {
          // Too nested!
        }
      }
    }
  }
}
```

### Quotes
- **Style**: Single quotes `'` (or double quotes, be consistent)
- **URLs**: Quote URLs
- **Font families**: Quote multi-word font names

```scss
// Good
.element {
  background-image: url('images/bg.jpg');
  font-family: 'Helvetica Neue', Arial, sans-serif;
  content: 'Hello';
}
```

### Colors
- **Lowercase**: Use lowercase for hex colors
- **Shorthand**: Use 3-character hex when possible
- **Variables**: Use variables for colors

```scss
// Good
$primary-color: #007bff;
$white: #fff;
$black: #000;

.element {
  color: $primary-color;
  background-color: $white;
  border-color: rgba(0, 0, 0, 0.1);
}

// Bad
.element {
  color: #007BFF; // Not lowercase
  background-color: #ffffff; // Not shorthand
}
```

## SCSS Features

### Variables
```scss
// Define variables
$primary-color: #007bff;
$spacing-unit: 8px;

// Use variables
.button {
  background-color: $primary-color;
  padding: $spacing-unit;
}

// Variable interpolation
$property: margin;

.element {
  #{$property}-top: 10px;
}
```

### Nesting with Parent Selector
```scss
.button {
  background-color: $primary-color;

  // Pseudo-classes
  &:hover {
    background-color: darken($primary-color, 10%);
  }

  &:focus {
    outline: 2px solid $primary-color;
  }

  // Modifiers
  &--large {
    font-size: 20px;
    padding: 15px 30px;
  }

  &--disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  // Elements
  &__icon {
    margin-right: 8px;
  }
}
```

### Mixins
```scss
// Define mixin
@mixin flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

// Mixin with parameters
@mixin button-variant($bg-color, $text-color) {
  background-color: $bg-color;
  color: $text-color;
  border: 1px solid darken($bg-color, 10%);

  &:hover {
    background-color: darken($bg-color, 10%);
  }
}

// Use mixins
.centered-container {
  @include flex-center;
}

.button-primary {
  @include button-variant($primary-color, #fff);
}

// Mixin with default parameters
@mixin box-shadow($x: 0, $y: 2px, $blur: 4px, $color: rgba(0, 0, 0, 0.1)) {
  box-shadow: $x $y $blur $color;
}

.card {
  @include box-shadow; // Uses defaults
}
```

### Functions
```scss
// Define function
@function calculate-rem($pixels) {
  @return #{$pixels / 16}rem;
}

@function get-spacing($multiplier) {
  @return $spacing-unit * $multiplier;
}

// Use functions
.element {
  font-size: calculate-rem(18); // 1.125rem
  margin: get-spacing(2); // 16px if $spacing-unit is 8px
}
```

### Placeholder Selectors
```scss
// Define placeholder
%button-base {
  display: inline-block;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
}

// Extend placeholder
.button-primary {
  @extend %button-base;
  background-color: $primary-color;
  color: #fff;
}

.button-secondary {
  @extend %button-base;
  background-color: $secondary-color;
  color: #fff;
}
```

### Control Directives
```scss
// @if
@mixin heading-style($level) {
  @if $level == 1 {
    font-size: 32px;
    font-weight: bold;
  } @else if $level == 2 {
    font-size: 24px;
    font-weight: bold;
  } @else {
    font-size: 18px;
    font-weight: normal;
  }
}

// @for
@for $i from 1 through 4 {
  .heading-#{$i} {
    @include heading-style($i);
  }
}

// @each
$colors: (primary: #007bff, secondary: #6c757d, success: #28a745);

@each $name, $color in $colors {
  .button-#{$name} {
    background-color: $color;
  }
}

// @while (use sparingly)
$i: 1;
@while $i <= 3 {
  .item-#{$i} {
    width: 100px * $i;
  }
  $i: $i + 1;
}
```

## Responsive Design

### Mobile-First Approach
```scss
// Base styles (mobile)
.element {
  font-size: 14px;
  padding: 10px;
}

// Tablet and up
@media (min-width: 768px) {
  .element {
    font-size: 16px;
    padding: 15px;
  }
}

// Desktop and up
@media (min-width: 992px) {
  .element {
    font-size: 18px;
    padding: 20px;
  }
}
```

### Breakpoint Mixins
```scss
// Define breakpoints
$breakpoints: (
  sm: 576px,
  md: 768px,
  lg: 992px,
  xl: 1200px,
  xxl: 1400px
);

// Mixin for min-width
@mixin media-up($breakpoint) {
  @media (min-width: map-get($breakpoints, $breakpoint)) {
    @content;
  }
}

// Mixin for max-width
@mixin media-down($breakpoint) {
  @media (max-width: map-get($breakpoints, $breakpoint) - 1px) {
    @content;
  }
}

// Usage
.element {
  font-size: 14px;

  @include media-up(md) {
    font-size: 16px;
  }

  @include media-up(lg) {
    font-size: 18px;
  }
}
```

### Container Queries (Modern CSS)
```scss
.card-container {
  container-type: inline-size;
  container-name: card;
}

.card {
  padding: 1rem;

  @container card (min-width: 400px) {
    padding: 2rem;
    display: flex;
  }
}
```

## Modern CSS Features

### CSS Grid
```scss
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.grid-complex {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    'header header header'
    'sidebar main aside'
    'footer footer footer';
  gap: 20px;
}

.header {
  grid-area: header;
}
```

### Flexbox
```scss
.flex-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
}

.flex-item {
  flex: 1 1 auto;
}
```

### CSS Custom Properties (CSS Variables)
```scss
:root {
  --primary-color: #007bff;
  --spacing-unit: 8px;
  --border-radius: 4px;
}

.element {
  background-color: var(--primary-color);
  padding: calc(var(--spacing-unit) * 2);
  border-radius: var(--border-radius);
}

// Dark theme
[data-theme='dark'] {
  --primary-color: #0056b3;
  --background-color: #1a1a1a;
  --text-color: #ffffff;
}
```

### Logical Properties
```scss
// Instead of left/right
.element {
  margin-inline-start: 10px; // margin-left in LTR, margin-right in RTL
  margin-inline-end: 10px;
  padding-inline: 15px; // padding-left and padding-right
}

// Instead of top/bottom
.element {
  margin-block-start: 10px; // margin-top
  margin-block-end: 10px; // margin-bottom
  padding-block: 15px; // padding-top and padding-bottom
}
```

## Best Practices

### Avoid !important
```scss
// Bad
.element {
  color: red !important;
}

// Good - increase specificity or restructure
.component .element {
  color: red;
}
```

### Use Shorthand Properties
```scss
// Good
.element {
  margin: 10px 20px;
  padding: 15px;
  background: #fff url('bg.jpg') no-repeat center;
}

// Avoid when unclear
.element {
  margin: 10px 15px 20px 25px; // Not obvious which side is which
}

// Better
.element {
  margin-top: 10px;
  margin-right: 15px;
  margin-bottom: 20px;
  margin-left: 25px;
}
```

### Zero Units
```scss
// Good - no unit for 0
.element {
  margin: 0;
  padding: 0;
}

// Bad
.element {
  margin: 0px;
}
```

### Vendor Prefixes
```scss
// Let autoprefixer handle it, but if manual:
.element {
  -webkit-transform: rotate(45deg);
  -ms-transform: rotate(45deg);
  transform: rotate(45deg);
}

// Use mixins
@mixin transform($value) {
  -webkit-transform: $value;
  -ms-transform: $value;
  transform: $value;
}

.element {
  @include transform(rotate(45deg));
}
```

## Performance

### Minimize Reflows/Repaints
```scss
// Expensive properties (trigger layout)
// width, height, margin, padding, border, top, left, etc.

// Cheap properties (composite only)
// transform, opacity

// Good for animations
.element {
  transition: transform 0.3s ease, opacity 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    opacity: 0.8;
  }
}

// Avoid
.element {
  transition: margin 0.3s ease; // Triggers layout

  &:hover {
    margin-top: -5px;
  }
}
```

### Use `will-change` Sparingly
```scss
.animated-element {
  will-change: transform, opacity; // Only for elements that will animate

  &:hover {
    transform: scale(1.1);
  }
}
```

## Comments

### Section Comments
```scss
/* ==========================================================================
   Components / Buttons
   ========================================================================== */

.button {
  // Implementation
}

/* Sub-section
   ========================================================================== */
```

### Inline Comments
```scss
.element {
  // This is a single-line comment
  color: red;

  /*
   * This is a multi-line comment
   * explaining complex logic
   */
  margin: 10px;
}

// TODO: Refactor this when design is finalized
// FIXME: This breaks on IE11
// HACK: Temporary workaround for Safari bug
```

## Code Review Checklist

Before completing any task, verify:
- [ ] All naming conventions followed (kebab-case, BEM)
- [ ] Proper file organization and imports
- [ ] Indentation consistent (2 spaces)
- [ ] No more than 3 levels of nesting
- [ ] Variables used for colors, spacing, breakpoints
- [ ] Mixins used for repeated patterns
- [ ] Mobile-first responsive design
- [ ] No !important (unless absolutely necessary)
- [ ] Shorthand properties used appropriately
- [ ] No vendor prefixes (use autoprefixer)
- [ ] Zero values have no units
- [ ] Comments explain complex logic
- [ ] Performance considerations (transforms vs layout properties)
