Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Sat,  6 Feb 2016 16:39:22 -0700
Message-Id: <1454801964-50385-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCHv2  0/2] SROP Mitigation: Signal cookies
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de
List-ID: <kernel-hardening.lists.openwall.com>

Erik Bosman previously attempted to upstream some patches which mitigate SROP
exploits in userland. Unfortunately he never pursued it further and they never
got merged in.

The previous patches can be seen here:
https://lkml.org/lkml/2014/5/15/660
https://lkml.org/lkml/2014/5/15/661
https://lkml.org/lkml/2014/5/15/657
https://lkml.org/lkml/2014/5/15/858

In the discussion for those patches Andy Lutomirski and Andi Kleen had a few
suggestions which are implemented in my patch series.

Andy Lutomirski suggested that the per-process secret be xord and with the location
on the stack where the cookie will reside, then hashed. I've taken this approach but
have not found a suitable secure hashing algorithm that is in-kernel and will work.
There is SipHash, which is perfect for this scenario, but there is no upstreamed
implementation. Once it has been upstreamed I will submit patches to use it.

Second, Andi Kleen was concerned that the previous patches broke the ABI. He suggested
placing the cookie above the FP state. The code I'm submitting does that by placing the
cookie in the padding above the FP state, or if no FP state is available above the
padding for the sigframe.

Below is an explanation of SROP stolen and slightly modified by me from Erik's patches.

These patches are meant to make Sigreturn Oriented Programming (SROP) a much
less attractive exploitation path.  In Sigreturn Oriented Programming, an
attacker causes a user-space program to call the sigreturn system call in order
to get complete control control over the entire userspace context in one go.

Previously attackers would have to search for ROP gadgets to get values into registers
then call mprotect or mmap. If the ROP gadgets didnt exist well then they'd be in trouble.
With SROP however one wouldn't have to search for ROP gadgets to get values into regs.
The attacker would simply lay out the ucontext on the stack as they choose then
SROP into the mprotect or mmap call.

( see: http://www.cs.vu.nl/~herbertb/papers/srop_sp14.pdf )

While mitigating SROP will probably not stop determined attackers from
exploiting a program, as there's always the much more well-known Return
Oriented Programming, we still think SROP's relative ease warrants mitigation,
especially since the mitigation is so cheap.
