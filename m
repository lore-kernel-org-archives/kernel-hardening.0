Reply-To: kernel-hardening@lists.openwall.com
From: Will Drewry <wad@chromium.org>
Date: Thu, 24 May 2012 11:07:58 -0500
Message-Id: <1337875681-20717-1-git-send-email-wad@chromium.org>
In-Reply-To: <20120522173942.GJ11775@ZenIV.linux.org.uk>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
Subject: [kernel-hardening] [RFC PATCH 0/3] move the secure_computing call
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is an RFC based on the comments from Al Viro and Eric Paris
regarding ptrace()rs being able to change the system call the kernel
sees after the seccomp enforcement has occurred (for mode 1 or 2).

With this series applied, a (p)tracer of a process with seccomp enabled
will be unable to change the tracee's system call number after the
secure computing check has been performed.

The x86 change is tested, as is the seccomp.c change.  For other arches,
it is not (RFC :).  Given that there are other inconsistencies in this
code across architectures, I'm not sure if it makes sense to attempt to
fix them all at once or to roll through as I attempt to add seccomp
filter support.

As is, the biggest benefit of this change is just setting consistent
expectations in what the ptrace/seccomp interactions should be.  The
current ability for ptrace to "bypass" secure computing (by remapping
allowed system calls) is not necessarily a problem, but it is not
necessarily intuitive behavior.

Thoughts, comments, flames will be appreciated!


Will Drewry (3):
  seccomp: Don't allow tracers to abuse RET_TRACE
  arch/x86: move secure_computing after ptrace
  arch/*: move secure_computing after trace

 arch/arm/kernel/entry-common.S  |    7 +------
 arch/arm/kernel/ptrace.c        |   42 +++++++++++++++++++--------------------
 arch/microblaze/kernel/ptrace.c |    4 ++--
 arch/mips/kernel/ptrace.c       |   16 ++++++---------
 arch/powerpc/kernel/ptrace.c    |    5 +++--
 arch/s390/kernel/ptrace.c       |    6 +++---
 arch/sh/kernel/ptrace_32.c      |    5 +++--
 arch/sh/kernel/ptrace_64.c      |    5 +++--
 arch/sparc/kernel/ptrace_64.c   |    7 ++++---
 arch/x86/kernel/ptrace.c        |   13 ++++++------
 kernel/seccomp.c                |    4 ++++
 11 files changed, 56 insertions(+), 58 deletions(-)

-- 
1.7.9.5
