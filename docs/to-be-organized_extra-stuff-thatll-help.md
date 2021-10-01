Microsoft has a SystemD integration package that I'll have to use to make a service for Retiled to start up and show the login screen and stuff, though at first it'll probably just be a terminal window:
https://devblogs.microsoft.com/dotnet/net-core-and-systemd/
<br>Actually, maybe instead of a terminal window, it could be a basic window with buttons that go 0-9, an Enter key, and a Backspace key. Those buttons would put text into a password textbox, which is then sent to whatever program unlocks the phone. Preferably it would just use the terminal and a real software keyboard temporarily, though.

That's required for switching the UI as detailed here:
https://wiki.mobian-project.org/doku.php?id=desktopenvironments

Not sure how to handle non-SystemD distros yet, but there may be a way and I'll have to have a non-SystemD version of Retiled.

Also not sure how to start X11 or Wayland from the service so that the UI is shown. Will have to look into that. Edit: this presentation may help out a bit, not sure:
https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf

This page of the QML docs may be useful as a way to implement long-pressing buttons and opening context menus:
https://doc.qt.io/qt-6/qml-qtquick-taphandler.html
