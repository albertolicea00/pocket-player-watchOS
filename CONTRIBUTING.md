# Contributing to Pocket Player

Thank you for considering contributing! Any improvement is welcome — new features, UI enhancements, bug fixes, or optimizations.

## Language
All contributions must be written in English — issues, PR descriptions, commit messages, code comments, and review discussions.

While the app UI targets a specific user base, all technical communication in this repository must be in English to keep the project accessible to a broader audience and maintain consistent standards. Please also pay close attention to spelling and grammar in your contributions.

## Branches

| Branch | Purpose |
| ------ | ------- |
| `main` | Current stable release. Only receives merges from `beta` when ready to publish. |
| `beta` | Active development. New features, fixes, and experiments go here. |

**Always work from `beta`, never from `main`.**

## How to Contribute

### Reporting a Bug
Open an Issue and include:
- A clear, descriptive title.
- Steps to reproduce the bug.
- What you expected vs. what actually happened.
- Screenshots if applicable.
- iOS/watchOS version and device model.

### Code Contributions
1. Fork the repository.
2. Create a branch from `beta`:
   ```bash
   git checkout beta
   git checkout -b feature/your-feature-name
   ```
   *(For bug fixes, use `fix/your-fix-name`)*
3. Make your changes.
4. Commit with a clear message following conventional commits:
   ```bash
   git commit -m "feat: short description of what it does"
   ```
5. Push your branch and open a Pull Request targeting **`beta`** (not `main`).

### Code Style
- Follow the Swift API Design Guidelines.
- Keep the SwiftUI patterns already used in the project.
- Internal code (variable names, comments, commit messages) must be in English.

## Questions?
Open an Issue to discuss before starting work on something large.
