Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 13 Aug 2011 20:32:52 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110813163252.GA18458@albatros>
References: <20110812150304.GC16880@albatros>
 <4E45884B.8030303@zytor.com>
 <20110813062246.GC3851@albatros>
 <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
Subject: Re: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to
 32 or 64 bit syscalls
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, x86@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 13, 2011 at 10:41 -0500, H. Peter Anvin wrote:
> IA64 is totally different.

I didn't say all IA-32 compatibility layer of x86 is a crap, surely no.
But there is some code, which is poorly tested exactly because it is
compatibility code.  One relatively recent example:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3e645d6b485446c54c6745c5e2cf5c528fe4deec

>  I'm extremely sceptical to this patch;
> it feels like putting code in a super-hot path to paper over a problem that has to be fixed anyway.

I'll move the check to the tracesys branch, which is not a hot path, in
the next RFC version, so this should not be a problem.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
