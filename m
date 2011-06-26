Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Jun 2011 22:33:21 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110626183321.GA3867@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a quick overview of PaX features from the upstream inclusion
point of view.


PaXTeam said there is almost nothing I can do with userspace NX.
Currently it is implemented as a "stack can be X unless GNU_STACK is
enabled" instead of secure by default policy.  It's impossible to fix it
not breaking the compatibility with old apps.  So, I'm skipping NOEXEC
options.


PAX_MPROTECT

As said in pax documentation [4]:

   The restrictions prevent
   - creating executable anonymous mappings
   - creating executable/writable file mappings
   - making an executable/read-only file mapping writable except for
     performing relocations on an ET_DYN ELF file (non-PIC shared library)
   - making a non-executable mapping executable

In Pax' terminology, it protects against one type of malforming code
execution flaw: introducing new code and executing it without
interaction with external files, (1) part 2 in [5].

Assuming no new executable vm mappings can be added (e.g.  via mmaping
a file with precreated shellcode), there is no WX areas, and no writable
areas can be turned into executable, ret2libc is the only attacker's
choise.

It definitely makes things harder for the attacker if the process is
seccomp'ed.  If execve()/fork() cannot be done (which is the seccomp's case)
arbitrary code execution becomes impossible, leaving the attacker only
using the already existing code.

I think it can be done via kernel.mprotect_rigid per pid namespace
(different containers might have different policies or one may have such
dummy app that doesn't work with PAX_MPROTECT).


PAX_KERNEXEC

As PaXTeam said, there are problems with DEBUG_RODATA in the upstream
kernel, not everything that can be made RO is actually made RO [1].

Constification - a significant portion of constification patches is not
yet applied.  One should patiently try to push it, listen to
maintainers' complains, re-divide the patch, and so forth ;-)

Verify what's done for NX, what's missing, what's wrong with large page
mappings.

Identify what structs may be RO or be RO for almost all the time (it is
implemented as pax_open()/pax_close() in PaX).


PAX_ASLR

Dan Rosenberg has started to work on it [0], I see no reason for
duplication the work (at least now).


PAX_RANDKSTACK

It randomizes the kernel stack by subtracting random value 0x0-0x100
from SP gotten from rdtsc.  Technically it is simple, but there are 2 issues:

1) it might slowdown the border case (very fast syscalls).

2) it makes kernel stack overflow situation worse, at least potentially.

However, it worth trying to propose.


PAX_RANDUSTACK
PAX_RANDMMAP

Looks like these 2 are actually implemented in the upstream kernel.


PAX_MEMORY_SANITIZE

It zeroes a memory page when it is freed.  IMO if it is worth including,
it also should be expanded by kernel caches zeroing.  Some sensitive
information might be stored not only in buffer/cache pages, but also in
kmalloc'ed areas or cryptography related structs like in
security/keys/trusted.h.  As it has some performance drawbacks, it
should be done sysctl'able (but not per namespace, sinse it is global to
the kernel).


PAX_MEMORY_STACKLEAK

Zeroes kernel stack memory on every syscall.

Good feature, but (a) it is very young (it might mature and have even
smaller performance penalty) and (b) has rather big performance penalty
in the border case anyway.


PAX_MEMORY_UDEREF

Unlikely to be applied because it rather significantly interferes in the
very core architecture code.  However, the feature is very interesting.


PAX_REFCOUNT

Technically it is very simple - if the resulted refcount value is too
large (2 times less than the overflow value) then redo atomic_inc/dec
and exec "int 4h".  It adds 3 asm commands to all atomic operations, it
shouldn't be performance visible.  I'd only change "int 4h" to
pr_emerg(), SIGKILL and maybe oops.

On the other hand atomic_t is used not only as a reference counter, but
also as a statistics storage, and even a bitmask [2].  Obviously, panic on
statistics counter overflow doesn't makes sense.  More correct naming
scheme would use refcount_t that checks overflows, but use atomic_t as
unmanaged type, and changing already implemented atomic_t refcounter to
refcount_t.  It is complicated by the fact that atomic_t usage as a
reference counter 99,9% all over the code with very small number other
applications.

So, if implement separate refcount_t and sequentially adapt atomic_t to
refcount_t, it would take too much time ("find -name '*.c' -o -name
'*.h' | wc" shows 2.5K lines including comments) and might end like
constification patch series, but it will be transparent to developers
and shouldn't cause much protest.  If change existing atomic_t
implementation, it should be done in one step not to break existing
statistics, bitmasks, etc., it would greatly annoy maintainers, but if
succeed would be perfect ;-)

As it is arch-dependent I'll implement it for ia32/amd64, leaving other
architectures with unmanaged atomic_t.


PAX_USERCOPY

This is a great overflow protection, it checks objects' size when the
size is checkable:

1) if it is on the stack, check whether it is fully packed in a single
stack frame.

2) if it is on the heap, check whether it is fully packed in an
allocated area.

If upstream is worried by the slowdown, it can be made sysctl'able or
CONFIG'urable.


In summa, I'd expect to try to push MPROTECT, review/fix KERNEXEC,
REFCOUNT, USERCOPY, KSTACK and maybe MEMORY_SANITIZE if there is some
time for it.  I'm afraid about one fundamental thing - upstream is
unlikely to favour anti-exploitation security features if they have some
significant slowdown.


[0] - http://lkml.org/lkml/2011/5/24/520
[1] - http://www.grsecurity.net/~paxguy1/kmaps.c
[2] - http://forums.grsecurity.net/viewtopic.php?f=1&t=2639
[3] - https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening
[4] - http://pax.grsecurity.net/docs/mprotect.txt
[5] - http://pax.grsecurity.net/docs/pax.txt

-- 
Vasiliy
