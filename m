Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524BAF92.1090705@zytor.com>
Date: Tue, 01 Oct 2013 22:30:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <20131002050714.GA27982@gmail.com> <fcdac020-6b9a-4d36-b424-290597669cb0@email.android.com> <20131002052531.GA31122@gmail.com>
In-Reply-To: <20131002052531.GA31122@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/7] Kernel base address randomization
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/01/2013 10:25 PM, Ingo Molnar wrote:
> 
> I mean, for example in an oops message we print data in words: the RIP, 
> other registers and stack contents. If any of these values lies within the 
> randomization range then we could de-randomize it.
> 
> So instead of exposing randomized values, we could expose de-randomized 
> values.
> 
> ( This isn't fool-proof: if some data value happens to lie within the 
>   random range spuriously then we'll incorrectly transform it. In the 
>   context of oops messages this should not be a big practical problem 
>   though. )
> 

I don't agree that this isn't a big practical problem.  I often find it
necessary to pick out "things that look like pointers".  Overall,
derandomization would make it possible to get really confused when you
have things like half a pointer overwritten.

	-hpa
