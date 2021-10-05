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

Qtile may be useful, as it's a tiling window manager written and configured in Python. Not sure how it would be useful, though. Actually, maybe it won't be useful, as I'd like people to be able to move windows around the screen when docked, so maybe I'll just use Kwin or something Qt-based until I can figure out something better or write something myself. Here's the link, anyway:
https://github.com/qtile/qtile

Python has a library that's used for reading INI files, so I'll probably be able to just use that if Python.NET doesn't end up supporting Python 3.9 and/or I decide that trying to get both it and  .NET installed and running on phones just isn't worth it. I'll have to limit allowed comment characters and delimiters to be the same as what the desktop entry spec requires. It'll be a good idea to have this code be written in a way that's easy to reuse for other projects, as a library.
https://docs.python.org/3/library/configparser.html

I'm trying to use multiple .py file for each .qml file like .NET's code behinds, and even though this question and answer involves PyQt5, it may help:
https://stackoverflow.com/questions/37974446/how-to-architect-a-pyqt5-project-using-qml-with-multiple-python-files
