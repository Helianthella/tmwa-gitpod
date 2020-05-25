# Gitpod env for The Mana World **Legacy** &nbsp; [![Open in Gitpod](https://img.shields.io/badge/Gitpod-ready-blue?logo=gitpod)](https://gitpod.io/#https://github.com/Helianthella/evol-gitpod)

Creates a new Gitpod instance pre-configured for The Mana World Legacy.

> ⚠️ **This is a Work in Progress**: This dev environment is not quite ready for prime time yet.
  This repo will be moved to the TMW namespace once it is considered stable and suitably tested.

## Components
- TMW Legacy [server-data](https://github.com/themanaworld/tmwa-server-data), [client-data](https://github.com/themanaworld/tmwa-client-data), and [tools](https://github.com/themanaworld/tmw-tools)
- [tmwAthena](https://github.com/themanaworld/tmwa), [attoconf](https://github.com/o11c/attoconf)
- [ManaPlus](https://gitlab.com/manaplus/manaplus)
- [seppuku](https://github.com/Helianthella/seppuku) (zsh prompt)
- noVNC (to run ManaPlus)

## Configuration
Environment variables may be set in the Gitpod account settings to configure the environment.

- `GITHUB_NAME`: your GitHub username
- `GITLAB_NAME`: your GitLab username
- `GIT_AUTHOR_NAME`: the author name to use whit git
- `GIT_AUTHOR_EMAIL`: the author email to use whit git
- `CUSTOM_MODS`: the repo URL containing your custom mods

## Custom modifications
The `CUSTOM_MODS` variable can be set to a git repository that contains custom modifications.
The repository must contain a Makefile, which will be called with `make` (default target) after the workspace starts up.
