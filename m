Date: Wed, 10 Apr 2019 15:11:20 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v2 1/3] module: Prepare for addition of new ro_after_init
 sections
Message-ID: <20190410191120.GA109588@google.com>
References: <20190410190823.109172-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410190823.109172-1-joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 03:08:21PM -0400, Joel Fernandes (Google) wrote:
> For the purposes of hardening modules by adding sections to
> ro_after_init sections, prepare for addition of new ro_after_init
> entries which we do in future patches. Create a table to which new
> entries could be added later. This makes it less error prone and reduce
> code duplication.
> 
> Cc: paulmck@linux.vnet.ibm.com
> Cc: rostedt@goodmis.org
> Cc: mathieu.desnoyers@efficios.com
> Cc: rcu@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> Cc: kernel-team@android.com
> Suggested-by: keescook@chromium.org
> Reviewed-by: keescook@chromium.org
> Acked-by: rostedt@goodmis.org
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> ---
>  kernel/module.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 524da609c884..1acddb93282a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3300,11 +3300,27 @@ static bool blacklisted(const char *module_name)
>  }
>  core_param(module_blacklist, module_blacklist, charp, 0400);
>  
> +/*
> + * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> + * layout_sections() can put it in the right place.
> + * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
> + */
> +static char *ro_after_init_sections[] = {
> +	".data..ro_after_init",
> +
> +	/*
> +	 * __jump_table structures are never modified, with the exception of
> +	 * entries that refer to code in the __init section, which are
> +	 * annotated as such at module load time.
> +	 */
> +	"__jump_table",
> +};
> +
>  static struct module *layout_and_allocate(struct load_info *info, int flags)
>  {
>  	struct module *mod;
>  	unsigned int ndx;
> -	int err;
> +	int err, i;
>  
>  	err = check_modinfo(info->mod, info, flags);
>  	if (err)
> @@ -3319,23 +3335,12 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>  	/* We will do a special allocation for per-cpu sections later. */
>  	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>  
> -	/*
> -	 * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> -	 * layout_sections() can put it in the right place.
> -	 * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
> -	 */
> -	ndx = find_sec(info, ".data..ro_after_init");
> -	if (ndx)
> -		info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
> -	/*
> -	 * Mark the __jump_table section as ro_after_init as well: these data
> -	 * structures are never modified, with the exception of entries that
> -	 * refer to code in the __init section, which are annotated as such
> -	 * at module load time.
> -	 */
> -	ndx = find_sec(info, "__jump_table");
> -	if (ndx)
> -		info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
> +	/* Set sh_flags for read-only after init sections */
> +	for (i = 0; ro_after_init_sections[i]; i++) {

Seems the fixup for this based on Kees suggestion of using NULL got squashed
into 2/3, so allow me to send a v3 to fix this ;-) Sorry! I am doing that
now.

The patches applied together are still code-correct thought.

thanks,

 - Joel
