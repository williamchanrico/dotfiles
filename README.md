# Dotfiles :shipit:

Config files for archlinux running i3 window manager
and picom (fork of compton) compositor, integrated into ~~GNOME~~ environment.

## YADM Setup (dotfiles manager)

https://github.com/TheLocehiliosan/yadm

```
# Set up YADM :+1:
yay -S --noconfirm yadm-git

# Create a temporary Bitbucket app password (read-only on repository)
# https://support.atlassian.com/bitbucket-cloud/docs/create-an-app-password/

# Clone (skip shell history)
 yadm clone https://williamchanrico@gmail.com:<BITBUCKET_TEMPORARY_APP_PASSWORD>@bitbucket.org/williamchanrico/dotfiles

# Decrypt yadm encrypt archive
yadm decrypt

# Replace yadm remote origin HTTPS with SSH
yadm remote origin -v
yadm remote remove origin
yadm remote add origin git@bitbucket.org:williamchanrico/dotfiles.git

# Delete the temporary Bitbucket app password
```

## Screenshot(s) Preview

### Empty Desktop

![screenshot-desktop](screenshots/screenshot01.png?raw=true "Screenshot desktop")

### Tiling Example (urxvt, ranger, vim, tpal, screenfetch, mpv)

Showing many running programs in tiling mode in one workspace

<details>
  <summary>Click to preview!</summary>

![screenshot-tiling](screenshots/screenshot02.png?raw=true "Screenshot tiles")
</details>

### Ranger (files viewer with contents preview)

Ranger preview support includes code with highlights, images, file meta-data, etc.

<details>
  <summary>Click to preview!</summary>

![screenshot-ranger](screenshots/screenshot03.png?raw=true "Screenshot ranger")
</details>
