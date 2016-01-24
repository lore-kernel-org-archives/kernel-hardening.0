Reply-To: kernel-hardening@lists.openwall.com
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56A48779.3000005@eng.utah.edu>
Date: Sun, 24 Jan 2016 01:12:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [RFC PATCH 0/2] SROP Mitigation
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Erik Bosman previously attempted to upstream some patches which mitigate SROP
exploits in userland. Unfortunately he never pursued it further and they never
got upstreamed.

The previous patches can be seen here:
https://lkml.org/lkml/2014/5/15/660
https://lkml.org/lkml/2014/5/15/661
https://lkml.org/lkml/2014/5/15/657
https://lkml.org/lkml/2014/5/15/858

In the discussion for those patches Andy Lutomirski and Andi Kleen had a few
suggestions which are implemented in my patch series.

Andy Lutomirski suggested that the per-process secret be xord and with the location
on the stack where the cookie will reside, then hashed. I've taken this approach but
have concerns about the safety and collision properties of the hash function I've used.

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
