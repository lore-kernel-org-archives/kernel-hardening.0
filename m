Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2011 22:51:14 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110815185114.GA20115@openwall.com>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 14, 2011 at 07:48:51AM -0700, H. Peter Anvin wrote:
> i386 vs x86-64 vs x32 is just one of many axes along which syscalls can be restricted (and for that matter, one axis if backward compatibility), and it does not make sense to burden the code with ad hoc filters.  Designing a general filter facility which can be used to restrict any container to the subset of system calls it actually needs would make more sense, no?

I agree with you that i386 vs x86-64 vs x32 is one axis and syscall
number is another axis.  I'd like to be able to setup restrictions on
both.  So I support both Vasiliy's patch (a future revision of it; his
RFC posting was just to get the discussion started) and Will's seccomp
patch (maybe with further changes for inheritance on fork and execve).

On specific systems I (co-)administer, I have immediate need for the 32-
vs. 64-bit restrictions.  These are easy to put to use, with changes
only to the kernel (Vasiliy's patch) and to the vzctl program (read a
setting from a per-container config file, make the right prctl() call).

Per-syscall restrictions are also useful, but primarily at a different
level - I'd expect them to be used in specific programs, such as Chrome
and vsftpd.  Those programs may also want to limit themselves to a
certain type of syscalls (that is, on the i386 vs x86-64 vs x32 axis),
thereby making use of both features at once.  Or they might even have to
do that, depending on how we implement the syscall restrictions.

Per your suggestion, if I understand correctly, any task that wants to
restrict itself on the i386 vs x86-64 vs x32 axis will have TIF_SECCOMP
set and will incur calls into __secure_computing().  This is unnecessary
overhead for the case when we have a restriction over this axis only,
without per-syscall restrictions.  Vasiliy's patch avoids such overhead.

Alexander
