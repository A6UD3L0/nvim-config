# Refactor Plan: Neovim Modular Config

## Immediate Actions
1. **Remove/Archive** `backend-essentials.lua` (done).
2. **Audit** all plugin and config modules for duplicate plugin specs and setup logic.
3. **Centralize** all plugin setup/config in appropriate `config/*.lua` files.
4. **Deduplicate** keymaps, ensuring only one source of truth.

## Next Steps
- Review each `config/*.lua` for overlapping logic.
- Refactor any remaining setup code out of plugin spec files.
- Document UV and Neovim workflows in `README.md`/`INSTALL.md`.
- Add a summary of actions and architecture in the docs.

## Long-Term
- Regularly audit for plugin/config drift.
- Stay up to date with upstream plugin changes.
- Encourage MECE structure for all new modules.
