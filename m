Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Mar 2016 14:29:00 -0700
Message-ID: <CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 12:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
> Sigreturn-oriented programming is a new attack vector in userland
> where an attacker crafts a fake signal frame on the stack and calls
> sigreturn. The kernel will extract the fake signal frame, which
> contains attacker controlled "saved" registers. The kernel will then
> transfer control to the attacker controlled userland instruction pointer.
>
> To prevent SROP attacks the kernel needs to know or be able to dervive
> whether a sigreturn it is processing is in response to a legitimate
> signal the kernel previously delivered.
>
> Further information and test code can be found in Documentation/security
> and this excellent article:
> http://lwn.net/Articles/676803/
>
> These patches implement the necessary changes to generate a cookie
> which will be placed above signal frame upon signal delivery to userland.
> The cookie is generated using a per-process random value xor'd with
> the address where the cookie will be stored on the stack.
>
> Upon a sigreturn the kernel will extract the cookie from userland,
> recalculate what the original cookie should be and verify that the two
> do not differ. If the two differ the kernel will terminate the process
> with a SIGSEGV.
>
> This prevents SROP by adding a value that the attacker cannot guess,
> but the kernel can verify. Therefore an attacker cannot use sigreturn as
> a method to control the flow of a process.
>

Has anyone verified that this doesn't break CRIU cross-machine (or
cross-boot) migration and that this doesn't break dosemu?  You're
changing the ABI here.

--Andy

>
> Version changes:
>
> v3->v4
>         Removed ambiguous __user annotation, added Documentation
>         and test code.
>
> v2->v3
>         Changed cookie calculation from using restored regs->sp to
>         using frame pointer from before restoration.
>
> v1->v2
>         Miscellaneous nits and code cleanup.
>
> Scott Bauer (4):
>       SROP Mitigation: Architecture independent code for signal cookies
>       x86: SROP Mitigation: Implement Signal Cookies
>       Sysctl: SROP Mitigation: Add Sysctl argument to disable SROP.
>       Documentation: SROP Mitigation: Add documentation for SROP cookies
>
>
>  Documentation/security/srop-cookies.txt | 203 ++++++++++++++++++++++++++++++++
>  arch/x86/ia32/ia32_signal.c             |  65 +++++++++-
>  arch/x86/include/asm/fpu/signal.h       |   2 +
>  arch/x86/kernel/fpu/signal.c            |  10 ++
>  arch/x86/kernel/signal.c                |  83 +++++++++++--
>  fs/exec.c                               |   3 +
>  include/linux/sched.h                   |   7 ++
>  include/linux/signal.h                  |   3 +
>  kernel/signal.c                         |  49 ++++++++
>  kernel/sysctl.c                         |   8 ++
>  10 files changed, 418 insertions(+), 15 deletions(-)
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
