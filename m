Date: Thu, 12 Oct 2017 22:02:01 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Message-ID: <20171012200201.GW11645@wotan.suse.de>
References: <20171011203027.11248-1-thgarnie@google.com>
 <20171011203027.11248-16-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011203027.11248-16-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v1 15/27] compiler: Option to default to hidden symbols
To: Thomas Garnier <thgarnie@google.com>, Guenter Roeck <linux@roeck-us.net>, Nicholas Piggin <npiggin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Jan H =?iso-8859-1?Q?=2E_Sch=F6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 01:30:15PM -0700, Thomas Garnier wrote:
> Provide an option to default visibility to hidden except for key
> symbols. This option is disabled by default and will be used by x86_64
> PIE support to remove errors between compilation units.
> 
> The default visibility is also enabled for external symbols that are
> compared as they maybe equals (start/end of sections). In this case,
> older versions of GCC will remove the comparison if the symbols are
> hidden. This issue exists at least on gcc 4.9 and before.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

<-- snip -->

> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index 86e8f0b2537b..8f021783a929 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -144,8 +144,8 @@ static bool __init check_loader_disabled_bsp(void)
>  	return *res;
>  }
>  
> -extern struct builtin_fw __start_builtin_fw[];
> -extern struct builtin_fw __end_builtin_fw[];
> +extern struct builtin_fw __start_builtin_fw[] __default_visibility;
> +extern struct builtin_fw __end_builtin_fw[] __default_visibility;
>  
>  bool get_builtin_firmware(struct cpio_data *cd, const char *name)
>  {

<-- snip -->

> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
> index e5da44eddd2f..1aa5d6dac9e1 100644
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -30,6 +30,9 @@
>   *	__irqentry_text_start, __irqentry_text_end
>   *	__softirqentry_text_start, __softirqentry_text_end
>   */
> +#ifdef CONFIG_DEFAULT_HIDDEN
> +#pragma GCC visibility push(default)
> +#endif
>  extern char _text[], _stext[], _etext[];
>  extern char _data[], _sdata[], _edata[];
>  extern char __bss_start[], __bss_stop[];
> @@ -46,6 +49,9 @@ extern char __softirqentry_text_start[], __softirqentry_text_end[];
>  
>  /* Start and end of .ctors section - used for constructor calls. */
>  extern char __ctors_start[], __ctors_end[];
> +#ifdef CONFIG_DEFAULT_HIDDEN
> +#pragma GCC visibility pop
> +#endif
>  
>  extern __visible const void __nosave_begin, __nosave_end;
>  
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index e95a2631e545..6997716f73bf 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -78,6 +78,14 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  #include <linux/compiler-clang.h>
>  #endif
>  
> +/* Useful for Position Independent Code to reduce global references */
> +#ifdef CONFIG_DEFAULT_HIDDEN
> +#pragma GCC visibility push(hidden)
> +#define __default_visibility  __attribute__((visibility ("default")))

Does this still work with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION ?

> +#else
> +#define __default_visibility
> +#endif
> +
>  /*
>   * Generic compiler-dependent macros required for kernel
>   * build go below this comment. Actual compiler/compiler version
> diff --git a/init/Kconfig b/init/Kconfig
> index ccb1d8daf241..b640201fcff7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1649,6 +1649,13 @@ config PROFILING
>  config TRACEPOINTS
>  	bool
>  
> +#
> +# Default to hidden visibility for all symbols.
> +# Useful for Position Independent Code to reduce global references.
> +#
> +config DEFAULT_HIDDEN
> +	bool

Note it is default.

Has 0-day ran through this git tree? It should be easy to get it added for
testing. Also, even though most changes are x86 based there are some generic
changes and I'd love a warm fuzzy this won't break odd / random builds.
Although 0-day does cover a lot of test cases, it only has limited run time
tests. There are some other test beds which also cover some more obscure
architectures. Having a test pass on Guenter's test bed would be nice to
see. For that please coordinate with Guenter if he's willing to run this
a test for you.

  Luis
