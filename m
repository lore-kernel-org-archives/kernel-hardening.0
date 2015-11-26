Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 25 Nov 2015 16:44:02 -0800
From: Greg KH <greg@kroah.com>
Message-ID: <20151126004402.GA30235@kroah.com>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
 <1448494286-16029-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1448494286-16029-2-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH v2 1/4] init: create cmdline param to
 disable readonly
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 25, 2015 at 03:31:23PM -0800, Kees Cook wrote:
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
> +bool disable_mark_readonly;
> +static int __init set_debug_rodata(char *str)
> +{
> +	if (!str)
> +		return -EINVAL;
> +	if (!strncmp(str, "on", 2))
> +		disable_mark_readonly = false;
> +	else if (!strncmp(str, "off", 3))
> +		disable_mark_readonly = true;

strtobool()?
