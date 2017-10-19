Date: Thu, 19 Oct 2017 21:38:08 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Message-ID: <20171019193808.GI17331@wotan.suse.de>
References: <20171011203027.11248-1-thgarnie@google.com>
 <20171011203027.11248-16-thgarnie@google.com>
 <20171012200201.GW11645@wotan.suse.de>
 <CAJcbSZEJ-kjcRQD3uHm0QZuOvbHpg9FV=wn7v4-RweDG7J3uqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZEJ-kjcRQD3uHm0QZuOvbHpg9FV=wn7v4-RweDG7J3uqg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v1 15/27] compiler: Option to default to hidden symbols
To: Thomas Garnier <thgarnie@google.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Nicholas Piggin <npiggin@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Jan H =?iso-8859-1?Q?=2E_Sch=F6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 04:15:10PM -0700, Thomas Garnier wrote:
> On Thu, Oct 12, 2017 at 1:02 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Wed, Oct 11, 2017 at 01:30:15PM -0700, Thomas Garnier wrote:
> >> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> >> index e95a2631e545..6997716f73bf 100644
> >> --- a/include/linux/compiler.h
> >> +++ b/include/linux/compiler.h
> >> @@ -78,6 +78,14 @@ extern void __chk_io_ptr(const volatile void __iomem *);
> >>  #include <linux/compiler-clang.h>
> >>  #endif
> >>
> >> +/* Useful for Position Independent Code to reduce global references */
> >> +#ifdef CONFIG_DEFAULT_HIDDEN
> >> +#pragma GCC visibility push(hidden)
> >> +#define __default_visibility  __attribute__((visibility ("default")))
> >
> > Does this still work with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION ?
> 
> I cannot make it work with or without this change. How is it supposed
> to be used?

Sadly I don't think much documentation was really added as part of the Nick's
commits about feature, even though commit b67067f1176 ("kbuild: allow archs to
select link dead code/data elimination") *does* say this was documented.

Side rant: the whole CONFIG_LTO removal was merged in the same commit without
this having gone in as a separate atomic patch.

Nick can you provide a bit more guidance about how to get this feature going or
tested on an architecture? Or are you just sticking to assuming folks using the
linker / compiler flags will know what to do? *Some* guidance could help.

> For me with, it crashes with a bad consdev at:
> http://elixir.free-electrons.com/linux/latest/source/drivers/tty/tty_io.c#L3194

>From my reading of the commit log he only had tested it with with powerpc64le,
each other architecture would have to do work to get as far as even booting.

It would require someone then testing Nick's patches against a working
powerpc setup to ensure we don't regress there.

> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index ccb1d8daf241..b640201fcff7 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -1649,6 +1649,13 @@ config PROFILING
> >>  config TRACEPOINTS
> >>       bool
> >>
> >> +#
> >> +# Default to hidden visibility for all symbols.
> >> +# Useful for Position Independent Code to reduce global references.
> >> +#
> >> +config DEFAULT_HIDDEN
> >> +     bool
> >
> > Note it is default.
> >
> > Has 0-day ran through this git tree? It should be easy to get it added for
> > testing. Also, even though most changes are x86 based there are some generic
> > changes and I'd love a warm fuzzy this won't break odd / random builds.
> > Although 0-day does cover a lot of test cases, it only has limited run time
> > tests. There are some other test beds which also cover some more obscure
> > architectures. Having a test pass on Guenter's test bed would be nice to
> > see. For that please coordinate with Guenter if he's willing to run this
> > a test for you.
> 
> Not yet, plan to give a v1.5 to Kees Cook to keep in one of his tree
> for couple weeks. I expect it will identify interesting issues.

I bet :)

  Luis
