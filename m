Date: Thu, 16 May 2019 10:03:11 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905160953.903FD364BC@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
 <201905160907.92FAC880@keescook>
 <CAG_fn=VsJmyuEUYy16R_M5Hu2CX-PJkz9Kw4rdy9XUCAYHwV5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=VsJmyuEUYy16R_M5Hu2CX-PJkz9Kw4rdy9XUCAYHwV5g@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 16, 2019 at 06:42:37PM +0200, Alexander Potapenko wrote:
> I suspect the slowdown of init_on_free is bigger than that of
> PAX_SANITIZE_MEMORY, as we've set the goal to have fully zeroed memory
> at alloc time.
> If we want a mode that only wipes the user data upon free() but
> doesn't eliminate all uninit memory, then we can make it faster.

Yeah, I sent a separate email that discusses this a bit more.

I think the goals of init_on_alloc and init_on_free are likely a bit
different. Given init_on_alloc's much more cache-friendly performance,
I think that it's likely the right way forward for getting to fully zeroed
memory at alloc time. (Though I note that it already includes exclusions:
such tradeoffs won't be unique to init_on_free.)

init_on_free appears to give us similar coverage (but also reduces the
lifetime of unused data), but isn't cache-friendly so it looks to need
a lot more tuning/trade-offs. (Not that we shouldn't include it! It'll
just need a bit more care to be reasonable.)

> > +void __init report_meminit(void)
> > +{
> > +       const char *stack;
> > +
> > +       if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
> > +               stack = "all";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
> > +               stack = "byref_all";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
> > +               stack = "byref";
> > +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
> > +               stack = "__user";
> > +       else
> > +               stack = "off";
> > +
> > +       /* Report memory auto-initialization states for this boot. */
> > +       pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
> > +               stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
> > +               want_init_on_free() ? "on" : "off");
> > +}
> >
> > To get a boot line like:
> >
> >         mem auto-init: stack:off, heap alloc:off, heap free:on
> For stack there's no binary on/off, as you can potentially build half
> of the kernel with stack instrumentation and another half without it.
> We could make the instrumentation insert a static global flag into
> each translation unit, but this won't give us any interesting info.

Well, yes, that's technically true, but I think reporting the kernel
config here would make sense. If someone intentionally bypasses the
stack auto-init for portions of the kernel, we can't meaningfully report
it here. There will be exceptions for stack auto-init and heap auto-init.

-- 
Kees Cook
