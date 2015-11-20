Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <564EF64F.1060903@redhat.com>
Date: Fri, 20 Nov 2015 11:30:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Not sure if this in scope for this list.  If not, please say so.

Currently, the system call interface to user space expects the system
call number in a register (on i386 and x86_64, and probably most other
architectures).  This means that once you have a system call instruction
in the process image, it can be theoretically used to run *any* system
call, including ones that are not actually referenced in the binary.  As
a result, you need seccomp or a Linux security module to interdict
certain system calls.

This would have to be an opt-in feature, obviously, and applications
would have to opt in explicitly via some ELF flag (similar to what we
did for non-executable stacks).

Do you think it would be feasible to encode the system call number in
the instruction stream instead, next to the instruction?  I think this
would have to set the system call MSR (LSTAR) on some context switches
at least (to avoid a conditional branch in the system call handler,
depending on whether the process has opted in to the new interface), and
add a few instructions (two loads and an add, so that the system call
number can be encoded in multiple ways, to avoid creating otherwise
useful bit patterns).  On the other hand, it would avoid the need to
load the sixth argument from the stack on i386.

Florian
