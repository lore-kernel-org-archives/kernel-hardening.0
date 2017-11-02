From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  2 Nov 2017 17:16:28 +1100
Message-Id: <1509603390-7587-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 0/2] sanitize addresses for non-privileged processes
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

This RFC makes an attempt to reduce the number of leaking kernel addresses to
userspace, in particular to non-privileged processes.

procfs files created using the seq_file interface can benefit from the
kptr_restrict sysctl to limit leaking addresses. This RFC presents an alternate
approach, sanitizing the addresses as they are printed based on whether the
process that opened the proc file had root privileges or not.

We add a boolean flag to the struct seq_file and set it in seq_open() based on
the UID/EUID of the current process. Later, when seq_vprint() is called, we
check the flag before either printing the address (with vsnprintf()) or printing
a sanitized address with [the newly defined] vsnprintf_sanitize().

Patch 1 in the set adds *printf_sanitize() functions to enable patch 2 as just
described. Patch 1 adds a fair bit of code since there are so many *printf()
variations. Of note, we don't handle vbin_printf() (and kvas_printf() is not
touched either).

Is this RFC adding any extra security on top of kptr_restrict==2? I don't
know. Is it adding any security to distributions that default to
kptr_restrict==0, I think so.

Thanks for taking the time to look at this. I had good fun writing it and
learned a bunch, if you don't think it is worth pursuing any further please
don't be shy to say so.

Tobin C. Harding (2):
  printk: add sanitized versions of *printf()
  seq_file: sanitize for non-privileged processes

 fs/seq_file.c            |  13 +-
 include/linux/kernel.h   |  11 ++
 include/linux/seq_file.h |   1 +
 lib/vsprintf.c           | 301 ++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 268 insertions(+), 58 deletions(-)

-- 
2.7.4
