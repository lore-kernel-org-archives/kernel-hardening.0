Date: Fri, 17 May 2019 09:13:14 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905170900.BFA80ED@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
 <201905160923.BD3E530EFC@keescook>
 <201905161714.A53D472D9@keescook>
 <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 10:49:03AM +0200, Alexander Potapenko wrote:
> On Fri, May 17, 2019 at 2:26 AM Kees Cook <keescook@chromium.org> wrote:
> > On Thu, May 16, 2019 at 09:53:01AM -0700, Kees Cook wrote:
> > > On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> > > > Add sock_alloc_send_pskb_noinit(), which is similar to
> > > > sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> > > > This helps reduce the slowdown on hackbench in the init_on_alloc mode
> > > > from 6.84% to 3.45%.
> > >
> > > Out of curiosity, why the creation of the new function over adding a
> > > gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
> > > are only 6 callers, and this change already updates 2 of those.)
> > >
> > > > Slowdown for the initialization features compared to init_on_free=0,
> > > > init_on_alloc=0:
> > > >
> > > > hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> > > > hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)
> >
> > So I've run some of my own wall-clock timings of kernel builds (which
> > should be an pretty big "worst case" situation, and I see much smaller
> > performance changes:
> How many cores were you using? I suspect the numbers may vary a bit
> depending on that.

I was using 4.

> > init_on_alloc=1
> >         Run times: 289.72 286.95 287.87 287.34 287.35
> >         Min: 286.95 Max: 289.72 Mean: 287.85 Std Dev: 0.98
> >                 0.25% faster (within the std dev noise)
> >
> > init_on_free=1
> >         Run times: 303.26 301.44 301.19 301.55 301.39
> >         Min: 301.19 Max: 303.26 Mean: 301.77 Std Dev: 0.75
> >                 4.57% slower
> >
> > init_on_free=1 with the PAX_MEMORY_SANITIZE slabs excluded:
> >         Run times: 299.19 299.85 298.95 298.23 298.64
> >         Min: 298.23 Max: 299.85 Mean: 298.97 Std Dev: 0.55
> >                 3.60% slower
> >
> > So the tuning certainly improved things by 1%. My perf numbers don't
> > show the 24% hit you were seeing at all, though.
> Note that 24% is the _sys_ time slowdown. The wall time slowdown seen
> in this case was 8.34%

Ah! Gotcha. Yeah, seems the impact for init_on_free is pretty
variable. The init_on_alloc appears close to free, though.

-- 
Kees Cook
