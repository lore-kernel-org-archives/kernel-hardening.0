Date: Sun, 1 Oct 2017 00:00:11 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170930220011.GA19418@openwall.com>
References: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
Subject: Re: [kernel-hardening] [RFC] A method to prevent priviledge escalation
To: "?$BCfB<M:0l / NAKAMURA?$B!$YUUICHI" <yuichi.nakamura.fe@hitachi.com>
Cc: kernel-hardening@lists.openwall.com, "yamauchi@cs.okayama-u.ac.jp" <yamauchi@cs.okayama-u.ac.jp>, Adam Zabrocki <pi3@pi3.com.pl>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Fri, Sep 22, 2017 at 02:49:59AM +0000, ?$BCfB<M:0l / NAKAMURA?$B!$YUUICHI wrote:
> As we said in Linux Security Summit 2017, 
> we would like to post a patch to prevent privilege escalation attack.
> 
> The concept is here:
> http://events.linuxfoundation.org/sites/events/files/slides/nakamura_20170831_1.pdf

We were not aware of your work, but FWIW we happen to have similar
functionality, also in early development/testing stage, in LKRG by Adam
Zabrocki (who is CC'ed on this reply, so he might chime in):

http://openwall.info/wiki/p_lkrg/Main#Exploit-Detection

LKRG is not publicly available yet, but it probably will be soon.

Unlike your implementation, LKRG is a kernel module, not a patch.
LKRG can be built for and loaded on top of a wide range of mainline and
distros' kernels, without needing to patch those.  There are other
implementation differences as well - indeed, hopefully we are not
actually introducing vulnerabilities with our code, although the risk is
always there, so it would need to be justified.  And this brings us to:

Frankly, we're skeptical about the value that this approach provides.
Much of the value could be in diversity - if most systems do not have
this sort of runtime checks, then canned exploits and even some capable
human attackers would not care or know to try and bypass the checks.
However, if this functionality becomes standard, so will the bypasses.
Now, are there cases (such as specific kernel vulnerabilities) where a
bypass is not possible, not practical, not reliable, or would complicate
the exploit so much it becomes less generic and/or less reliable?
Perhaps yes, and this would mean there's some value in this approach
even if it becomes standard.  Another option may be to have a lighter
standard version and a heavier and more extensive limited distribution
version (which could also be a way to receive funding for the project).

Speaking of addressing a sensible threat model, I suggested to Adam that
we add validation of credentials right after the kernel's original
permissions check on the module loading syscalls.  (Or we might
duplicate those permission checks first, since that's easier to do when
we're also a kernel module rather than a patch.)  Then we'll achieve
sensible overall functionality: can't use those unauthorized credentials
for much time, and can't easily backdoor the running kernel through
having exploited a typical kernel vulnerability (due to LKRG's integrity
checking of the rest of the kernel and, with this extra check, not being
able to perform an unauthorized kernel module load by official means,
which LKRG's integrity checking wouldn't otherwise catch).

The credentials checks would need to be extended to cover cap_*, etc. -
there's already a (partial?) list of those other credential-like data
items on the wiki page above.  And they will need to be performed in
more places - I think in particular on open(), as otherwise even a very
brief exposure of the unauthorized credentials would let the attacker
retain an fd e.g. to a block device corresponding to the root filesystem
and then install persistent backdoors in there without hurry (e.g.,
pattern-match a critical system binary and introduce own code in there).

Of course, the action on detected integrity violation (of the kernel
itself or of its critical data) should not be limited to logging a
warning, as we do for testing now.  What exact action is best might be a
non-trivial question.  Panic the kernel?  Lock the kernel from any
further syscalls, log what happened, sync the disks, and then panic?

Attempt to undo the unauthorized change whenever possible - e.g.,
restore the credentials from our shadow copy that couldn't be tampered
with as easily?  But then an alternative would appear to be to protect
the main credentials to the same extent, e.g. keeping them read-only
most of the time or/and encrypted with a per-boot key (trickier to do
when we're a kernel module, though).  This undoing the damage is
probably bad as it'd allow the attack to repeat until all races are won,
unless we combine it e.g. with blacklisting of attack sources such as by
uid when a threshold is reached.  It's also bad in that it requires
exploits to replace just one set of credentials - the more trusted
(and better protected?) one - rather than both, as would be the case if
we choose panic.  For some vulnerabilities, an exploit would probably
only be able to perform one write in a while (e.g., per syscall), so
needing to replace both sets of credentials improves the chances of
detection.

We welcome any other thoughts - be it criticism, feedback, or anything.

Thanks,

Alexander
