Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 23 Jul 2011 15:40:38 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110723114038.GA3281@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] securelevel'ish restrictions in Linux
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar, all -

Before starting to think about porting grsecurity features restricting
root, I'd want to discuss the global problem here.

There are 3 options restricting root in grsecurity:

- GRKERNSEC_KMEM further restricts /dev/mem by white listing allowed
regions below 1MB. /dev/kmem and /dev/port are disabled.

- GRKERNSEC_IO disables iopl(2) and ioperm(2).

- GRKERNSEC_PROC_ADD introduces many restrictions including /proc/kcore
disabling.

There are some restrictions in the mainline kernel:

- kernel.modules_disabled disables inserting/deletion of kernel modules.

- STRICT_DEVMEM restricts /dev/mem to non-ram regions.

- DEVKMEM=n disables /dev/kmem.

- (implicitly) HIBERNATION=n disabled reading the kernel image, changing
  it and loading it back as if the hibernation+restore was processed.

All of them try to restrict root to backdoor the kernel (either
CAP_SYS_ADMIN or CAP_SYS_RAW_IO) when root account is compromised.

(However, they might be useful as is in cases of partial privilege
escalation when an attacker may do "insmod %s" or may write to
"./%s/mem", but without arbitrary code execution.)


To do anti backdooring consistent way 2 problems should be solved:

1) there should be neither explicit nor implicit ways to do arbitrary
kernel read/writes by root.  It means all interfaces should not allow
root to do arbitrary r/w.

2) the scheme of restricted root should be supported by kernel developers
because:

 (a) almost everybody think root is a god and can do everything he
wants.  If an interface allows to do bad things, then well, he's his own
master.  Such "leaks" are not explicitly documented as it is not a
threat with nonrestricted root.

 (b) while writing kernel code that has an input supplied by root, a
developer doesn't expect it to be malformed, but trusted: if the input
is incorrect, then it is a fault of userspace root too (but not a
vulnerability).


While (1) is somehow reviewable - the kernel interfaces number is big,
but finite and it doesn't increase very fast - (2) reduces to the code
review of half of all kernel code, which is almost impossible with
current development speed.

Now assume (1) and even (2) are accomplished.  What do we have?  In the
classic UNIX model we have a compromised root that may not do arbitrary
things in the kernel, but may freely mix userspace by ptracing alien
tasks (even dumpable flag is set), infect binaries, MIM network
connections, etc. etc. - a genuine root.  The only case where it does
*something* is a container root - it may not access processes and files
outside of the container and cannot mix "global" kernel variables that
influences other containers.  But the latter is closely connected to
dropping capabilities, so root restriction probably makes not too much
here.

In OpenVZ container root restriction is implemented by introducing new
capability (actually, multiple capabilities) which allows to do some
things, but on the white list bases.  So, the ways of potential kernel
abuse is significantly less than via CAP_SYS_ADMIN and all of them are
expected to be thoroughly reviewed.  I don't see any movement to such
capability in the mainline kernel yet, but introducing it would
significantly simplify the review work and changed blacklisting way of
root restriction to whitelisting one => would make the threat model
clear.

I'm hesitating to claim that common root restriction doesn't makes
sense, but it seems to me that the work in the area of containers is
much more productive.

As usual, comments are hell welcome.

Thanks,

--
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
