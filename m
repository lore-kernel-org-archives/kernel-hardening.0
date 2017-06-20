Date: Mon, 19 Jun 2017 21:29:36 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170620042936.GD610@zzz.localdomain>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <1497915397-93805-24-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497915397-93805-24-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH 23/23] mm: Allow slab_nomerge to be
 set at build time
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 04:36:37PM -0700, Kees Cook wrote:
> Some hardened environments want to build kernels with slab_nomerge
> already set (so that they do not depend on remembering to set the kernel
> command line option). This is desired to reduce the risk of kernel heap
> overflows being able to overwrite objects from merged caches, increasing
> the difficulty of these attacks. By keeping caches unmerged, these kinds
> of exploits can usually only damage objects in the same cache (though the
> risk to metadata exploitation is unchanged).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  mm/slab_common.c |  5 ++---
>  security/Kconfig | 13 +++++++++++++
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 6c14d765379f..17a4c4b33283 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -47,13 +47,12 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
>  
>  /*
>   * Merge control. If this is set then no merging of slab caches will occur.
> - * (Could be removed. This was introduced to pacify the merge skeptics.)
>   */
> -static int slab_nomerge;
> +static bool slab_nomerge = !IS_ENABLED(CONFIG_SLAB_MERGE_DEFAULT);
>  
>  static int __init setup_slab_nomerge(char *str)
>  {
> -	slab_nomerge = 1;
> +	slab_nomerge = true;
>  	return 1;
>  }
>  
> diff --git a/security/Kconfig b/security/Kconfig
> index 0c181cebdb8a..e40bd2a260f8 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -166,6 +166,19 @@ config HARDENED_USERCOPY_SPLIT_KMALLOC
>  	  confined to a separate cache, attackers must find other ways
>  	  to prepare heap attacks that will be near their desired target.
>  
> +config SLAB_MERGE_DEFAULT
> +	bool "Allow slab caches to be merged"
> +	default y
> +	help
> +	  For reduced kernel memory fragmentation, slab caches can be
> +	  merged when they share the same size and other characteristics.
> +	  This carries a small risk of kernel heap overflows being able
> +	  to overwrite objects from merged caches, which reduces the
> +	  difficulty of such heap attacks. By keeping caches unmerged,
> +	  these kinds of exploits can usually only damage objects in the
> +	  same cache. To disable merging at runtime, "slab_nomerge" can be
> +	  passed on the kernel command line.
> +

It's good to at least have this option, but again it's logically separate and
shouldn't just be hidden in patch 23/23.  And again, is it really just about
heap overflows?

Please also fix the documentation for slab_nomerge in
Documentation/admin-guide/kernel-parameters.txt.

- Eric
