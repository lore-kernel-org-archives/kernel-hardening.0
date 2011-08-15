Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E496CAC.3030103@zytor.com>
Date: Mon, 15 Aug 2011 11:59:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110815185114.GA20115@openwall.com>
In-Reply-To: <20110815185114.GA20115@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Solar Designer <solar@openwall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 08/15/2011 11:51 AM, Solar Designer wrote:
> I agree with you that i386 vs x86-64 vs x32 is one axis and syscall
> number is another axis.

They are not.  ABI is ONE SUBSET OF SYSCALL NUMBERS.

> Per-syscall restrictions are also useful, but primarily at a different
> level - I'd expect them to be used in specific programs, such as Chrome
> and vsftpd.  Those programs may also want to limit themselves to a
> certain type of syscalls (that is, on the i386 vs x86-64 vs x32 axis),
> thereby making use of both features at once.  Or they might even have to
> do that, depending on how we implement the syscall restrictions.
> 
> Per your suggestion, if I understand correctly, any task that wants to
> restrict itself on the i386 vs x86-64 vs x32 axis will have TIF_SECCOMP
> set and will incur calls into __secure_computing().  This is unnecessary
> overhead for the case when we have a restriction over this axis only,
> without per-syscall restrictions.  Vasiliy's patch avoids such overhead.

There is really no bloody difference between i386 vs x86-64 and, say,
sys_oldstat versus sys_stat, or anything else along those lines.
Putting in a bunch of ad hoc facilities because of semi-plausible
performance wins rather than building a sane filtering facility which
can be optimized as a single path is ridiculous.

	-hpa
