Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2016 16:03:30 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160701160330.1ce5a95e8c64c89af49155bb@gmail.com>
In-Reply-To: <1467245565.24287.115.camel@perches.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
	<1467132211.24287.31.camel@perches.com>
	<20160628224043.c543b2b01e776e7757bbb3f4@gmail.com>
	<1467147657.24287.59.camel@perches.com>
	<20160629204204.859692ea2b7f570260ed18a0@gmail.com>
	<1467245565.24287.115.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Jun 2016 17:12:45 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2016-06-29 at 20:42 +0200, Emese Revfy wrote:
> > On Tue, 28 Jun 2016 14:00:57 -0700 Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2016-06-28 at 22:40 +0200, Emese Revfy wrote:
> > > > On Tue, 28 Jun 2016 09:43:31 -0700 Joe Perches <joe@perches.com> wrote:
> > > > > On Tue, 2016-06-28 at 13:36 +0200, Emese Revfy wrote:
> > > > > > The nocapture gcc attribute can be on functions only.
> > > > > > The attribute takes one or more unsigned integer constants as parameters
> > > > > > that specify the function argument(s) of const char* type to initify.
> > > > > Perhaps this should be const <void>*
> > > > For me function arguments are the values passed to a function call so
> > > > the const char* type is good because this is the only one that the plugin handles
> > > > (for now at least).
> > > OK, but this function prototype specified takes a const void *
> > > 
> > > +extern void * memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
> > What matters for the plugin is the type of the passed arguments (which can be const char*
> > in the current implementation), not that of the parameters.
> 
> And how does this work when the prototype requires the compiler to
> implicit cast to const void * before calling the function?


The plugin searches for the nocapture attribute that does not depend on the type.
If the function argument is not a string constant just a pointer then
the plugin walks the data flow (use-def chain) and tries to find a string constant.
If there is a cast to void * then the use-def chain will walk across it.

-- 
Emese
