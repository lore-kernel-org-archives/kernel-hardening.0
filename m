Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E56483F.3070701@gentoo.org>
Date: Thu, 25 Aug 2011 09:03:59 -0400
From: "Anthony G. Basile" <blueness@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Trying to get PaX RANDMMAP into the mainstream kernel
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi everyone,

I had a brief conversation yesterday with solardiz on
freenode/#openwall.  The topic turned to what other hardening code could
go upstream besides the stuff you guys have already been pushing.  It
would be nice if we could get PaX RANDMMAP in.  It gives better
randomization on mmap addresses, but unfortunately breaks packages which
use pre-compiled headers. [1]

I wrote a little POC program to demonstrate this. [2]  Try running it on
vanilla ubuntu, opensuse and gentoo.  Then try running it on the same
with a hardened kernel with RANDMMAP enabled.

We came across this issue in a hardened gentoo bug. In one of the
comments, pipacs <pageexec@freemail.hu> gives a very complete
explanation of the situation. [3]  I won't repeat it here.

If RANDMMAP does get in, then this would be incentive to the gcc people
to address the limitations of their gch code.  However, the logic works
the other way, so this is also the barrier to getting RANDMMAP upstream.
solardiz had a good idea: have some sysctl in /proc/sys/kernel either
turn it on or off, or allow you to set the amount of randomization.
This eases the impact in a running kernel, so its not something the user
is stuck with once they configure, compile and reboot.

Also, I don't know if people here are familiar with Hedrick's work.  He
has broken up the grsec 50k line monolithic patch into smaller patches
which address each feature individually.  Critical if you want to get
any of this stuff upstream.

BTW, Vasiliy, kudos on your GSoC work.

Refs:

[1] http://gcc.gnu.org/onlinedocs/gcc/Precompiled-Headers.html
[2] http://opensource.dyc.edu/pub/misc/pch-poc.tgz
[3] https://bugs.gentoo.org/show_bug.cgi?id=301299#c31
[4]
https://www.kernel.org/pub/linux/kernel/people/hedrick/security/README.grsecurity

-- 
Anthony G. Basile, Ph.D.
Gentoo Linux Developer [Hardened]
E-Mail    : blueness@gentoo.org
GnuPG FP  : 8040 5A4D 8709 21B1 1A88  33CE 979C AF40 D045 5535
GnuPG ID  : D0455535
