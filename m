Date: Tue, 11 Sep 2018 10:41:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
Message-ID: <20180911084148.GA23570@kroah.com>
References: <20180910191002.350195-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180910191002.350195-1-kristen@linux.intel.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 10, 2018 at 12:10:02PM -0700, Kristen Carlson Accardi wrote:
> This patch aims to make it harder to perform cache timing attacks on data
> left behind by system calls. If we have an error returned from a syscall,
> flush the L1 cache.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/Kconfig        |  8 ++++++++
>  arch/x86/entry/common.c | 20 ++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c5ff296bc5d1..8a67642ff9fe 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -445,6 +445,14 @@ config RETPOLINE
>  	  code are eliminated. Since this includes the syscall entry path,
>  	  it is not entirely pointless.
>  
> +config SYSCALL_FLUSH
> +	bool "Clear L1 Cache on syscall errors"
> +	default y

"y" normally is only for "your machine will not boot without this
option", and I don't think that's the case here :)

> +	help
> +	  Select to allow the L1 cache to be cleared upon return of
> +	  an error code from a syscall. This will reduce the likelyhood of
> +	  speculative execution style attacks on syscalls.

Shouldn't this help text refer to the fact that this needs CPU support
for this type of functionality?

I like the idea, as a "gadget" normally only is used when an
out-of-bands check happens, which implies someone could be trying to do
something "bad", nice job.

thanks,

greg k-h
