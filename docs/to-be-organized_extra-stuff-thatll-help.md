Microsoft has a SystemD integration package that I'll have to use to make a service for Retiled to start up and show the login screen and stuff, though at first it'll probably just be a terminal window:
https://devblogs.microsoft.com/dotnet/net-core-and-systemd/

That's required for switching the UI as detailed here:
https://wiki.mobian-project.org/doku.php?id=desktopenvironments

Not sure how to handle non-SystemD distros yet, but there may be a way and I'll have to have a non-SystemD version of Retiled.

Also not sure how to start X11 or Wayland from the service so that the UI is shown. Will have to look into that. Edit: this presentation may help out a bit, not sure:
https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
