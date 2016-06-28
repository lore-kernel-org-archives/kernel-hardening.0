Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1467139734.24287.45.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jun 2016 11:48:54 -0700
In-Reply-To: <1467131708.24287.29.camel@perches.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	 <1467131708.24287.29.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-06-28 at 09:35 -0700, Joe Perches wrote:
> (adding Mathias Krause who did something similar via macros in 2014)
> 
> https://lkml.org/lkml/2014/6/22/149
> 
> On Tue, 2016-06-28 at 13:34 +0200, Emese Revfy wrote:
> > 
> > I would like to introduce the initify gcc plugin. The kernel already
> > has
> > a mechanism to free up code and data memory that is only used during
> > kernel
> > or module initialization.
> > This plugin will teach the compiler to find more such code and data
> > that
> > can be freed after initialization. It reduces memory usage.
> > The initify gcc plugin can be useful for embedded systems.
> What happens to string deduplication when one string
> is in an init function and the same string is also used
> in a non-init function in the same compilation unit?
> 
> foo.c
> 
> __init void initfunc(void)
> {
> 	pr_info("%s: I'm here\n", __func__);
> }
> 
> void runtimefunc(void)
> {
> 	pr_info("I'm here: %s\n", __func__);
> }
> 
> In what section does the string "I'm here: %s\n" get placed
> or does it get placed into multiple sections?

Sorry, Joe can't type.
That was meant to be the identical string in both functions.
