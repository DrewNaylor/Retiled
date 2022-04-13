Running the custom compositor currently involves these commands:
1. Switch to a new TTY
2. Delete the Wayland lock file from `/run/user/1002/wayland-0.lock` so Kwin doesn't interfere
3. CD into the folder with the compositor's files and run `python main.py -platform eglfs`

These are copied from my demo video on the compositor here:
https://youtube.com/shorts/jURqf86CS0I

The last command is very important, because using `QT_QPA_PLATFORM=eglfs` before the command makes things break.
