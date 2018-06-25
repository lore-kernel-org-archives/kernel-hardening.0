Subject: Re: [PATCH v5 15/27] compiler: Option to default to hidden symbols
References: <20180625224014.134829-1-thgarnie@google.com>
 <20180625224014.134829-16-thgarnie@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8486eb8b-e233-4e2f-e976-da7b4cefc673@infradead.org>
Date: Mon, 25 Jun 2018 16:25:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180625224014.134829-16-thgarnie@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>, kernel-hardening@lists.openwall.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Kate Stewart <kstewart@linuxfoundation.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Philippe Ombredanne <pombredanne@nexb.com>, Lukas Wunner <lukas@wunner.de>, Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/25/18 15:39, Thomas Garnier wrote:
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
> ---

> diff --git a/init/Kconfig b/init/Kconfig
> index 24b60536e26b..d4f90cc38ede 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1718,6 +1718,13 @@ config PROFILING
>  config TRACEPOINTS
>  	bool
>  
> +#
> +# Default to hidden visibility for all symbols.
> +# Useful for Position Independent Code to reduce global references.
> +#
> +config DEFAULT_HIDDEN
> +	bool
> +

I certainly would appreciate a better/more descriptive kconfig symbol name
here.

>  source "arch/Kconfig"
>  
>  endmenu		# General setup


thanks,
-- 
~Randy
