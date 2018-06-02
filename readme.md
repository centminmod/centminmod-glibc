# glibc 2.2.7 custom RPM build

For CentOS 7.x 64bit based Centmin Mod LEMP stacks - build custom glibc 2.2.7 RPM which installs side by side with system default glibc 2.1.7. Custom glibc 2.2.7 RPM is saved to `/svr-setup/glibc-custom-2.2.7-1.el7.x86_64.rpm`

Note: these custom glibc RPMs are experimental and untested as yet. Only install on test CentOS 7 64bit systems.

## custom glibc 2.2.7

```
yum info glibc-custom -q
Installed Packages
Name        : glibc-custom
Arch        : x86_64
Version     : 2.2.7
Release     : 1.el7
Size        : 145 M
Repo        : installed
Summary     : glibc-custom-2.2.7 for centminmod.com LEMP stack installs
URL         : https://centminmod.com
License     : unknown
Description : glibc-custom-2.2.7 for centminmod.com LEMP stacks
```

```
/opt/glibc/usr/bin/ldd --version
ldd (GNU libc) 2.27.9000
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
```

## system glibc

```
ldd --version
ldd (GNU libc) 2.17
Copyright (C) 2012 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
```