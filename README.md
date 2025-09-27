Oftentimes, when Debian users try to install the Minecraft.deb file from minecraft.net,
they encounter the error "Dependency is not satisfiable: libgdk-pixbuf2.0-0 (>=2.22.0).
This is caused by a missing hyphen between "pixbuf" and "2." I repackaged the .deb file
with the proper dependency name, tested it on hardware, and it installs without any errors.
Apart from this, all credit goes to the maintainer Petr Mrázek at petr@mojang.com, and to
Mojang and Microsoft in terms of the Minecraft ecosystem. I hope this helps a lot of you,
particularly new and longtime Debian users.
