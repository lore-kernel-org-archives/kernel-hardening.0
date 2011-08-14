Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Aug 2011 13:09:00 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110814090900.GA14293@openwall.com>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <20110813163252.GA18458@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813163252.GA18458@albatros>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, x86@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 13, 2011 at 08:32:52PM +0400, Vasiliy Kulikov wrote:
> I didn't say all IA-32 compatibility layer of x86 is a crap, surely no.
> But there is some code, which is poorly tested exactly because it is
> compatibility code.  One relatively recent example:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3e645d6b485446c54c6745c5e2cf5c528fe4deec

Here's another one:

http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-3081
https://bugzilla.redhat.com/show_bug.cgi?id=634457
https://access.redhat.com/kb/docs/DOC-40265

"The compat_alloc_user_space functions in include/asm/compat.h files in
the Linux kernel before 2.6.36-rc4-git2 on 64-bit platforms do not
properly allocate the userspace memory required for the 32-bit
compatibility layer, which allows local users to gain privileges by
leveraging the ability of the compat_mc_getsockopt function (aka the
MCAST_MSFILTER getsockopt support) to control a certain length value,
related to a "stack pointer underflow" issue, as exploited in the wild
in September 2010."

It would have been nice if this one were not exploitable from 64-bit
OpenVZ containers at the time, which, if I understand correctly, would
be the case with Vasiliy's patch (and the corresponding change to vzctl
to make use of the feature, which we're planning to make).

Similarly, it would be nice if 32-bit compat issues like this would not
be triggerable from privsep child processes of vsftpd, sshd, etc. -
those programs would need to set a flag via prctl(), which we'll add
support for.

> I'll move the check to the tracesys branch, which is not a hot path, in
> the next RFC version, so this should not be a problem.

Vasiliy is going to reuse a check (of multiple flags at once) that is
already in the code, so the change will have no performance impact for
permitted and non-traced syscalls (the case where we care about
performance).

Alexander
