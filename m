Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Aug 2011 00:14:19 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110815201419.GA20296@openwall.com>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110815185114.GA20115@openwall.com> <4E496CAC.3030103@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E496CAC.3030103@zytor.com>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2011 at 11:59:56AM -0700, H. Peter Anvin wrote:
> There is really no bloody difference between i386 vs x86-64 and, say,
> sys_oldstat versus sys_stat, or anything else along those lines.

There is a difference from a sysadmin standpoint: a sysadmin knows that
certain containers have Linux distro userlands for i386 and certain
others for x86-64, so he/she can configure things accordingly.  Even if
a customer using one of those containers installs extra software
packages, this extra software will work just fine as long as it's for
the same ABI.  The same doesn't hold true for sys_oldstat versus
sys_stat, etc.

> Putting in a bunch of ad hoc facilities because of semi-plausible
> performance wins rather than building a sane filtering facility which
> can be optimized as a single path is ridiculous.

I don't mind having a general filtering facility if it gets accepted
into the kernel (somehow Will's patch is not applied yet), and I don't
mind optimizing it to the point where it's not any slower for the "all
syscalls permitted but not all ABIs are" case.  I suspect that the
result of such optimizations will be similar to having these things
implemented separately, though - but I could be wrong.

So how do we proceed from here?  Start by getting Will's patch applied?

Alexander
