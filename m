Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 26 Nov 2015 08:51:30 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151126075130.GB18742@gmail.com>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
 <1448494286-16029-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1448494286-16029-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 1/4] init: create cmdline param to disable readonly
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> It may be useful to debug writes to the readonly sections of memory,
> so provide a cmdline "rodata=off" to allow for this.
> 
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/kernel-parameters.txt |  4 ++++
>  init/main.c                         | 31 +++++++++++++++++++++++++++----
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 742f69d18fc8..21cf76dbba90 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3409,6 +3409,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	ro		[KNL] Mount root device read-only on boot
>  
> +	rodata=		[KNL]
> +		on	Mark read-only kernel memory as read-only (default).
> +		off	Leave read-only kernel memory writable for debugging.
> +
>  	root=		[KNL] Root filesystem
>  			See name_to_dev_t comment in init/do_mounts.c.
>  
> diff --git a/init/main.c b/init/main.c
> index 9e64d7097f1a..06200d2fbf08 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -93,9 +93,6 @@ static int kernel_init(void *);
>  extern void init_IRQ(void);
>  extern void fork_init(void);
>  extern void radix_tree_init(void);
> -#ifndef CONFIG_DEBUG_RODATA
> -static inline void mark_rodata_ro(void) { }
> -#endif
>  
>  /*
>   * Debug helper: via this flag we know that we are in 'early bootup code'
> @@ -929,6 +926,32 @@ static int try_to_run_init_process(const char *init_filename)
>  
>  static noinline void __init kernel_init_freeable(void);
>  
> +#ifdef CONFIG_DEBUG_RODATA

Btw., could you please remove the Kconfig option altogether in an additional patch 
and make read-only sections an always-on feature? It has been default-y for years 
and all distros have it enabled.

The 'debug rodata' naming is purely historic: this started out as a simple 
debugging feature, but meanwhile it has spread and has become an essential kernel 
robustness feature.

The boot option you added can be used if anyone needs to disable it. (Never heard 
of such a case though.)

Thanks,

	Ingo
