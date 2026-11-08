
# lilac-hyprland
<img width="1920" height="1078" alt="2026-11-07-200042_hyprshot" src="https://github.com/user-attachments/assets/9116487f-1257-4b87-8f49-edb50f569b53" />
Lilac is modern and sleek with a few tricks up it's sleeve to make it actually useful. 
It uses hyprland, noctalia shell, quickshell, and tlp and is laptop friendly.

### Showcase:
https://www.youtube.com/watch?v=aB3Av5daA0c

# Gallery

<img width="1920" height="1080" alt="2026-11-07-203946_hyprshot" src="https://github.com/user-attachments/assets/f1390665-e733-4e51-96e1-f749abe2e95d" />

<img width="1920" height="1080" alt="2026-11-07-200153_hyprshot" src="https://github.com/user-attachments/assets/6513fa22-4c66-41d1-a6e0-b616574cba6c" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/343373cb-b5bb-4574-802b-882136e30820" />
<img width="1920" height="1080" alt="2026-11-07-204034_hyprshot" src="https://github.com/user-attachments/assets/ea91c0a7-5306-476c-8115-48e3e3a4d3ee" />


### Since I'm equipped with a brain I didn't use AI for any of this project, or any of my other projects unless specified in the readme.

# Can I use it?
Yes? Kinda? The installer works, but there is only an arch installer right now im still working on the other ones. 
### The installer does not care about your config folder and it will overwrite it! If you are installing on a real computer and you have dotfiles installed already, BACK UP YOUR CONFIG!!!!!!

## Backing up your config
Backing up is simple. Go to the config folder in this repository and then look at your ~/.config folder. The installer only overwrites the folders in this repository's config, so you only need to back up the ones you see there. Now you are ready to install

# Installation
## Arch
Run this command to download and run the installer:
```bash
curl https://raw.githubusercontent.com/Cammy43/lilac-dots/refs/heads/main/install.sh | sh
```
Once it finishes, you can run ``` start-hyprland```. If the installer fails, good luck!
If you are using sddm or lightdm, hyprland should already be selected as the window manager, so you can sign in as usual. If not, click on the window manager dropdown and select hyprland.
