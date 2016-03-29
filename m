Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 13:53:23 -0600
Message-Id: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

Sigreturn-oriented programming is a new attack vector in userland
where an attacker crafts a fake signal frame on the stack and calls
sigreturn. The kernel will extract the fake signal frame, which
contains attacker controlled "saved" registers. The kernel will then
transfer control to the attacker controlled userland instruction pointer.

To prevent SROP attacks the kernel needs to know or be able to dervive
whether a sigreturn it is processing is in response to a legitimate
signal the kernel previously delivered. 

Further information and test code can be found in Documentation/security
and this excellent article:
http://lwn.net/Articles/676803/

These patches implement the necessary changes to generate a cookie
which will be placed above signal frame upon signal delivery to userland.
The cookie is generated using a per-process random value xor'd with
the address where the cookie will be stored on the stack.

Upon a sigreturn the kernel will extract the cookie from userland,
recalculate what the original cookie should be and verify that the two
do not differ. If the two differ the kernel will terminate the process
with a SIGSEGV.

This prevents SROP by adding a value that the attacker cannot guess,
but the kernel can verify. Therefore an attacker cannot use sigreturn as
a method to control the flow of a process.


Version	changes:

v3->v4
	Removed	ambiguous __user annotation, added Documentation
	and test code.

v2->v3
	Changed	cookie calculation from	using restored regs->sp	to
	using frame pointer from before	restoration.

v1->v2
	Miscellaneous nits and code cleanup.

Scott Bauer (4):
      SROP Mitigation: Architecture independent code for signal cookies
      x86: SROP Mitigation: Implement Signal Cookies
      Sysctl: SROP Mitigation: Add Sysctl argument to disable SROP.
      Documentation: SROP Mitigation: Add documentation for SROP cookies


 Documentation/security/srop-cookies.txt | 203 ++++++++++++++++++++++++++++++++
 arch/x86/ia32/ia32_signal.c             |  65 +++++++++-
 arch/x86/include/asm/fpu/signal.h       |   2 +
 arch/x86/kernel/fpu/signal.c            |  10 ++
 arch/x86/kernel/signal.c                |  83 +++++++++++--
 fs/exec.c                               |   3 +
 include/linux/sched.h                   |   7 ++
 include/linux/signal.h                  |   3 +
 kernel/signal.c                         |  49 ++++++++
 kernel/sysctl.c                         |   8 ++
 10 files changed, 418 insertions(+), 15 deletions(-)
