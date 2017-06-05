References: <20170605192216.21596-1-igor.stoppa@huawei.com>
 <20170605192216.21596-5-igor.stoppa@huawei.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <71e91de0-7d91-79f4-67f0-be0afb33583c@schaufler-ca.com>
Date: Mon, 5 Jun 2017 12:53:06 -0700
MIME-Version: 1.0
In-Reply-To: <20170605192216.21596-5-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/5] Make LSM Writable Hooks a command line option
To: Igor Stoppa <igor.stoppa@huawei.com>, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, paul@paul-moore.com, sds@tycho.nsa.gov, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/5/2017 12:22 PM, Igor Stoppa wrote:
> This patch shows how it is possible to take advantage of pmalloc:
> instead of using the build-time option __lsm_ro_after_init, to decide if
> it is possible to keep the hooks modifiable, now this becomes a
> boot-time decision, based on the kernel command line.
>
> This patch relies on:
>
> "Convert security_hook_heads into explicit array of struct list_head"
> Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> to break free from the static constraint imposed by the previous
> hardening model, based on __ro_after_init.
>
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  init/main.c         |  2 ++
>  security/security.c | 29 ++++++++++++++++++++++++++---
>  2 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index f866510..7850887 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -485,6 +485,7 @@ static void __init mm_init(void)
>  	ioremap_huge_init();
>  }
>  
> +extern int __init pmalloc_init(void);
>  asmlinkage __visible void __init start_kernel(void)
>  {
>  	char *command_line;
> @@ -653,6 +654,7 @@ asmlinkage __visible void __init start_kernel(void)
>  	proc_caches_init();
>  	buffer_init();
>  	key_init();
> +	pmalloc_init();
>  	security_init();
>  	dbg_late_init();
>  	vfs_caches_init();
> diff --git a/security/security.c b/security/security.c
> index c492f68..4285545 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -26,6 +26,7 @@
>  #include <linux/personality.h>
>  #include <linux/backing-dev.h>
>  #include <linux/string.h>
> +#include <linux/pmalloc.h>
>  #include <net/flow.h>
>  
>  #define MAX_LSM_EVM_XATTR	2
> @@ -33,8 +34,17 @@
>  /* Maximum number of letters for an LSM name string */
>  #define SECURITY_NAME_MAX	10
>  
> -static struct list_head hook_heads[LSM_MAX_HOOK_INDEX]
> -	__lsm_ro_after_init;
> +static int security_debug;
> +
> +static __init int set_security_debug(char *str)
> +{
> +	get_option(&str, &security_debug);
> +	return 0;
> +}
> +early_param("security_debug", set_security_debug);

I don't care for calling this "security debug". Making
the lists writable after init isn't about development,
it's about (Tetsuo's desire for) dynamic module loading.
I would prefer "dynamic_module_lists" our something else
more descriptive.

> +
> +static struct list_head *hook_heads;
> +static struct pmalloc_pool *sec_pool;
>  char *lsm_names;
>  /* Boot-time LSM user choice */
>  static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
> @@ -59,6 +69,13 @@ int __init security_init(void)
>  {
>  	enum security_hook_index i;
>  
> +	sec_pool = pmalloc_create_pool("security");
> +	if (!sec_pool)
> +		goto error_pool;

Excessive gotoing - return -ENOMEM instead.

> +	hook_heads = pmalloc(sizeof(struct list_head) * LSM_MAX_HOOK_INDEX,
> +			     sec_pool);
> +	if (!hook_heads)
> +		goto error_heads;

This is the only case where you'd destroy the pool, so
the goto is unnecessary. Put the
	pmalloc_destroy_pool(sec_pool);
	return -ENOMEM;

under the if here.
 

>  	for (i = 0; i < LSM_MAX_HOOK_INDEX; i++)
>  		INIT_LIST_HEAD(&hook_heads[i]);
>  	pr_info("Security Framework initialized\n");
> @@ -74,8 +91,14 @@ int __init security_init(void)
>  	 * Load all the remaining security modules.
>  	 */
>  	do_security_initcalls();
> -
> +	if (!security_debug)
> +		pmalloc_protect_pool(sec_pool);
>  	return 0;
> +
> +error_heads:
> +	pmalloc_destroy_pool(sec_pool);
> +error_pool:
> +	return -ENOMEM;
>  }
>  
>  /* Save user chosen LSM */
