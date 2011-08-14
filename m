Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 14 Aug 2011 20:08:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110814160848.GA4333@albatros>
References: <20110812150304.GC16880@albatros>
 <4E45884B.8030303@zytor.com>
 <20110813062246.GC3851@albatros>
 <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
 <m2ei0olnua.fsf@firstfloor.org>
 <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
 <20110814092028.GB14293@openwall.com>
 <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
 <20110814152729.GU5782@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814152729.GU5782@one.firstfloor.org>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Solar Designer <solar@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>, containers@lists.linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

(CC'ed Will Drewry, the author of new seccomp version, and 
containers list)

On Sun, Aug 14, 2011 at 17:27 +0200, Andi Kleen wrote:
> > i386 vs x86-64 vs x32 is just one of many axes along which syscalls can be restricted (and for that matter, one axis if backward compatibility), and it does not make sense to burden the code with ad hoc filters.  Designing a general filter facility which can be used to restrict any container to the subset of system calls it actually needs would make more sense, no?
> 
> I believe this is already in the newer versions of seccomp.

The "newer versions of seccomp" are NAK'ed by Ingo.  AFAIU, Ingo wants
more generic filters to filter much more than syscalls.  But it
contradicts the security by simplicity, which we're trying to achieve
with this patch.

Compatibility syscalls are much more error prone than common syscalls
as they lack good testing or sometimes lack it at all, unfortunately.
The link I've posted is about a crazy bug - a completely uninitialized
structure was used in copy_from_user() function.  The function was not
tested _at all_.  I doubt any non-compatibility syscall (ioctl()
handler, etc.) can be completely untested.

Also we already have CONFIG_IA32_EMULATION, this patch only moves the
configuration mechanism from the compilation stage to the runtime stage,
it doesn't draw the new line.  It grants the permissions to use the
feature to some containers, but denies to other containers, which is an
rather expected property of containers separation.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
