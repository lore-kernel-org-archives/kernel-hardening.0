Date: Thu, 16 May 2019 09:19:56 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905160907.92FAC880@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-2-glider@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> Slowdown for the new features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)

I wonder if the patch series should be reorganized to introduce
__GFP_NO_AUTOINIT first, so that when the commit with benchmarks appears,
we get the "final" numbers...

> Linux build with -j12, init_on_free=1:  +8.38% wall time (st.err 0.39%)
> Linux build with -j12, init_on_free=1:  +24.42% sys time (st.err 0.52%)
> Linux build with -j12, init_on_alloc=1: -0.13% wall time (st.err 0.42%)
> Linux build with -j12, init_on_alloc=1: +0.57% sys time (st.err 0.40%)

I'm working on reproducing these benchmarks. I'd really like to narrow
down the +24% number here. But it does 

> The slowdown for init_on_free=0, init_on_alloc=0 compared to the
> baseline is within the standard error.

I think the use of static keys here is really great: this is available
by default for anyone that wants to turn it on.

I'm thinking, given the configuable nature of this, it'd be worth adding
a little more detail at boot time. I think maybe a separate patch could
be added to describe the kernel's memory auto-initialization features,
and add something like this to mm_init():

+void __init report_meminit(void)
+{
+	const char *stack;
+
+	if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
+		stack = "all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
+		stack = "byref_all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
+		stack = "byref";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
+		stack = "__user";
+	else
+		stack = "off";
+
+	/* Report memory auto-initialization states for this boot. */
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
+		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
+		want_init_on_free() ? "on" : "off");
+}

To get a boot line like:

	mem auto-init: stack:off, heap alloc:off, heap free:on

And one other thought I had was that in the init_on_free=1 case, there is
a large pause at boot while memory is being cleared. I think it'd be handy
to include a comment about that, just to keep people from being surprised:

diff --git a/init/main.c b/init/main.c
index cf0c3948ce0e..aea278392338 100644
--- a/init/main.c
+++ b/init/main.c
@@ -529,6 +529,8 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	if (want_init_on_free())
+		pr_info("Clearing system memory ...\n");
 	mem_init();
 	kmem_cache_init();
 	pgtable_init();

Beyond these thoughts, I think this series is in good shape.

Andrew (or anyone else) do you have any concerns about this?

-- 
Kees Cook
