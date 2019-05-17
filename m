Date: Thu, 16 May 2019 17:26:09 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905161714.A53D472D9@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
 <201905160923.BD3E530EFC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905160923.BD3E530EFC@keescook>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 16, 2019 at 09:53:01AM -0700, Kees Cook wrote:
> On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> > Add sock_alloc_send_pskb_noinit(), which is similar to
> > sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> > This helps reduce the slowdown on hackbench in the init_on_alloc mode
> > from 6.84% to 3.45%.
> 
> Out of curiosity, why the creation of the new function over adding a
> gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
> are only 6 callers, and this change already updates 2 of those.)
> 
> > Slowdown for the initialization features compared to init_on_free=0,
> > init_on_alloc=0:
> > 
> > hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> > hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

So I've run some of my own wall-clock timings of kernel builds (which
should be an pretty big "worst case" situation, and I see much smaller
performance changes:

everything off
	Run times: 289.18 288.61 289.66 287.71 287.67
	Min: 287.67 Max: 289.66 Mean: 288.57 Std Dev: 0.79
		baseline

init_on_alloc=1
	Run times: 289.72 286.95 287.87 287.34 287.35
	Min: 286.95 Max: 289.72 Mean: 287.85 Std Dev: 0.98
		0.25% faster (within the std dev noise)

init_on_free=1
	Run times: 303.26 301.44 301.19 301.55 301.39
	Min: 301.19 Max: 303.26 Mean: 301.77 Std Dev: 0.75
		4.57% slower

init_on_free=1 with the PAX_MEMORY_SANITIZE slabs excluded:
	Run times: 299.19 299.85 298.95 298.23 298.64
	Min: 298.23 Max: 299.85 Mean: 298.97 Std Dev: 0.55
		3.60% slower

So the tuning certainly improved things by 1%. My perf numbers don't
show the 24% hit you were seeing at all, though.

> In the commit log it might be worth mentioning that this is only
> changing the init_on_alloc case (in case it's not already obvious to
> folks). Perhaps there needs to be a split of __GFP_NO_AUTOINIT into
> __GFP_NO_AUTO_ALLOC_INIT and __GFP_NO_AUTO_FREE_INIT? Right now
> __GFP_NO_AUTOINIT is only checked for init_on_alloc:

I was obviously crazy here. :) GFP isn't present for free(), but a SLAB
flag works (as was done in PAX_MEMORY_SANITIZE). I'll send the patch I
used for the above timing test.

-- 
Kees Cook
