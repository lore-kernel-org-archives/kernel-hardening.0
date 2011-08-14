Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2011 09:29:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <4E47EB99.1020909@zytor.com>
Message-ID: <alpine.LRH.2.00.1108150927210.31525@tundra.namei.org>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
 <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110814152729.GU5782@one.firstfloor.org> <4E47EB99.1020909@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 14 Aug 2011, H. Peter Anvin wrote:

> Last I looked seccomp still had a hardcoded list of system calls, but
> perhaps I've been looking in the wrong place.  However, since that's
> exactly what seccomp is -- a system call filter -- this can, and should,
> be unified that way.

Yes, we should definitely look at incorporating this into seccomp v2, 
which is still under discussion (and a topic at KS).


- James
-- 
James Morris
<jmorris@namei.org>
