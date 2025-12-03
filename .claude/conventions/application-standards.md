# Application Standards

**ALL AGENTS working with applications MUST FOLLOW THESE CONVENTIONS**

## General Conventions

-   Follow Martin Fowler's "Refactoring" principles
-   Use methods instead of comments to explain code (self-documenting code)
-   Include comments ONLY when necessary to understand the code
-   Move reusable methods to utility classes where appropriate

## Technology Stack Knowledge

-   **Frontend**: Angular 14, TypeScript, Akita state management
-   **UI Libraries**: Angular Material
-   **State Management**: @datorama/akita (stores, queries, services)
-   **Key Modules**:
    -   \_core/: Core services, actions, effects, utilities
    -   projects/: Project management
    -   subjects/: Subject/patient data
    -   conversations/: Messaging system
    -   dynamic-forms/: Dynamic form generation
    -   reports/: Report generation

### Class Organization (MUST FOLLOW EXACTLY)

-   Access modifiers in order: static → public → protected → private
-   Group by: properties → constructors → methods
-   Method order within each access level:
    1. constructors
    2. ngOnInit
    3. ngOnChanges
    4. ngOnDestroy
    5. ngAfterViewInit
    6. ngAfterViewChecked
    7. ngAfterContentInit
    8. ngAfterContentChecked
    9. onParam (only if needed for parameter initialization)
    10. public methods (alphabetically)
    11. protected methods (alphabetically)
    12. private methods (alphabetically)
-   Within each grouping, organize items alphabetically by name
-   Place decorators on their own line
-   Do NOT implement OnXXX interfaces if they are optional
-   Only include onParam method if needed for initialization when parameters are ready
-   Methods within each access level are alphabetically ordered

## SCSS Styles

-   Use the global styles defined in the `styles.scss` file:
    -   Buttons: buttons.scss
    -   Colors: colors.scss
    -   Dialogs: dialogs.scss
    -   Layout: layout.scss
    -   Sections: section.scss
    -   Typography: typography.scss

## UI Components

### Dialogs

-   Always use routing to navigate to the dialog
-   Use ModalDialog2 component to navigate to the dialog
-   Use `<section>` tag with appropriate dialog classes.
-

### Pages

-   Types
    -   General:
        -   Components:
            -   SideBar
            -   Toolbar
    -   Lists:
        -   SearchBox (search-box.component.ts and search-box.component.html)
        -   New Button (new-button.component.ts and new-button.component.html): Uses + icon button.
        -   List (list.component.ts and list.component.html)

## Checklist

-   [ ] Do not hard code styles in XXX.component.scss files. Use the global styles defined in the `styles.scss` file.
-   [ ] Follow established layout patterns
-   [ ] NEVER run builds yourself - an external process handles builds
