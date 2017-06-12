From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 12 Jun 2017 18:56:49 +0200
Message-Id: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

S.A.R.A. (S.A.R.A. is Another Recursive Acronym) is a stacked Linux
Security Module that aims to collect heterogeneous security measures,
providing a common interface to manage them.
It can be useful to allow minor security features to use advanced
management options, like user-space configuration files and tools, without
too much overhead.
Some submodules that use this framework are also introduced.
The code is quite long, I apologize for this. Thank you in advance to
anyone who will take the time to review this patchset.

S.A.R.A. is meant to be stacked but it needs cred blobs and the procattr
interface, so I temporarily implemented those parts in a way that won't
be acceptable for upstream, but it works for now. I know that there
is some ongoing work to make cred blobs and procattr stackable, as soon
as the new interfaces will be available I'll reimplement the involved
parts.
At the moment I've been able to test it only on x86.

S.A.R.A. submodules introduced in this patchset are: USB Filtering and
WX Protection.

The kernel-space part is complemented by its user-space counterpart:
saractl [1].
A test suite for WX Protection, called sara-test [2], is also available.

USB Filtering aims to provide a mechanism to decide which USB devices
should be authorized to connect to the system and which shouldn't. The main
goal is to narrow the attack surface for custom USB devices designed to
exploit vulnerabilities found in some USB device drivers.
Via configuration it's possible to allow or to deny authorization, based
on one or more of: Vendor ID, Product ID, bus name and port number. There
is also limited support for wildcards.
Depending on the configuration, it can work both as a white list or as a
black list.
With the help of "saractl" it's also possible to completely disable new
USB devices when the screen is "locked".
The original idea is inspired by the Grsecurity "Deny USB" feature.

WX Protection aims to improve user-space programs security by applying:
- W^X enforcement: program can't have a page of memory that is marked, at
		   the same time, writable and executable.
- W!->X restriction: any page that could have been marked as writable in
		     the past won't ever be allowed to be marked as
		     executable.
- Executable MMAP prevention: prevents the creation of new executable mmaps
			      after the dynamic libraries have been loaded.
All of the above features can be enabled or disabled both system wide
or on a per executable basis through the use of configuration files managed
by "saractl".
It is important to note that some programs may have issues working with
WX Protection. In particular:
- W^X enforcement will cause problems to any programs that needs
  memory pages mapped both as writable and executable at the same time e.g.
  programs with executable stack markings in the PT_GNU_STACK segment.
- W!->X restriction will cause problems to any program that
  needs to generate executable code at run time or to modify executable
  pages e.g. programs with a JIT compiler built-in or linked against a
  non-PIC library.
- Executable MMAP prevention can work only with programs that have at least
  partial RELRO support. It's disabled automatically for programs that
  lack this feature. It will cause problems to any program that uses dlopen
  or tries to do an executable mmap. Unfortunately this feature is the one
  that could create most problems and should be enabled only after careful
  evaluation.
To extend the scope of the above features, despite the issues that they may
cause, they are complemented by:
- procattr interface: can be used by a program to discover which WX
		      Protection features are enabled and/or to tighten
		      them.
- Trampoline emulation: emulates the execution of well-known "trampolines"
			even when they are placed in non-executable memory.
Parts of WX Protection are inspired by some of the features available in
PaX.

More information can be found in the documentation introduced in the first
patch and in the "commit message" of the following emails.

[1] https://github.com/smeso/saractl
[2] https://github.com/smeso/sara-test

Salvatore Mesoraca (11):
  S.A.R.A. Documentation
  S.A.R.A. framework creation
  Creation of "usb_device_auth" LSM hook
  S.A.R.A. USB Filtering
  Creation of "check_vmflags" LSM hook
  S.A.R.A. cred blob management
  S.A.R.A. WX Protection
  Creation of "pagefault_handler_x86" LSM hook
  Trampoline emulation
  Allowing for stacking procattr support in S.A.R.A.
  S.A.R.A. WX Protection procattr interface

 Documentation/admin-guide/kernel-parameters.txt |  40 ++
 Documentation/security/00-INDEX                 |   2 +
 Documentation/security/SARA.rst                 | 192 +++++
 arch/x86/mm/fault.c                             |   6 +
 drivers/usb/core/hub.c                          |   4 +
 drivers/usb/core/sysfs.c                        |   6 +-
 fs/proc/base.c                                  |  38 +
 include/linux/cred.h                            |   3 +
 include/linux/lsm_hooks.h                       |  26 +
 include/linux/security.h                        |  24 +
 mm/mmap.c                                       |   9 +
 security/Kconfig                                |   1 +
 security/Makefile                               |   2 +
 security/sara/Kconfig                           | 175 +++++
 security/sara/Makefile                          |   5 +
 security/sara/include/sara.h                    |  29 +
 security/sara/include/sara_data.h               |  47 ++
 security/sara/include/securityfs.h              |  59 ++
 security/sara/include/trampolines.h             | 171 +++++
 security/sara/include/usb_filtering.h           |  27 +
 security/sara/include/utils.h                   |  69 ++
 security/sara/include/wxprot.h                  |  27 +
 security/sara/main.c                            | 113 +++
 security/sara/sara_data.c                       |  79 +++
 security/sara/securityfs.c                      | 558 +++++++++++++++
 security/sara/usb_filtering.c                   | 410 +++++++++++
 security/sara/utils.c                           | 151 ++++
 security/sara/wxprot.c                          | 902 ++++++++++++++++++++++++
 security/security.c                             |  42 +-
 29 files changed, 3214 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/security/SARA.rst
 create mode 100644 security/sara/Kconfig
 create mode 100644 security/sara/Makefile
 create mode 100644 security/sara/include/sara.h
 create mode 100644 security/sara/include/sara_data.h
 create mode 100644 security/sara/include/securityfs.h
 create mode 100644 security/sara/include/trampolines.h
 create mode 100644 security/sara/include/usb_filtering.h
 create mode 100644 security/sara/include/utils.h
 create mode 100644 security/sara/include/wxprot.h
 create mode 100644 security/sara/main.c
 create mode 100644 security/sara/sara_data.c
 create mode 100644 security/sara/securityfs.c
 create mode 100644 security/sara/usb_filtering.c
 create mode 100644 security/sara/utils.c
 create mode 100644 security/sara/wxprot.c

-- 
1.9.1
