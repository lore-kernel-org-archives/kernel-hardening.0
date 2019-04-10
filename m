Date: Tue, 9 Apr 2019 21:17:56 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only post
 init
Message-ID: <20190410011756.GA78239@google.com>
References: <20190410011418.76408-1-joel@joelfernandes.org>
 <20190410011418.76408-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410011418.76408-2-joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, keescook@chromium.org, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, mathieu.desnoyers@efficios.com, rcu@vger.kernel.org, rostedt@goodmis.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 09, 2019 at 09:14:18PM -0400, Joel Fernandes (Google) wrote:
> Since commit title ("srcu: Allocate per-CPU data for DEFINE_SRCU() in
> modules"), modules that call DEFINE_{STATIC,}SRCU will have a new array
> of srcu_struct pointers which is used by srcu code to initialize and
> clean up these structures.
> 
> There is no reason for this array of pointers to be writable, and can
> cause security or other hidden bugs. Mark these are read-only after the
> module init has completed.
> 
> Suggested-by: paulmck@linux.vnet.ibm.com
> Suggested-by: keescook@chromium.org
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Just wanted to mention, that I tested that the srcu_struct_ptrs array is not
writeable any more after init, but doing the following after
module_enable_ro() :

@@ -3513,6 +3523,14 @@ static noinline int do_init_module(struct module *mod)
        rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
        module_enable_ro(mod, true);
+
+       if (mod->srcu_struct_ptrs) {
+               // Check if SRCU Access is possible
+               char x = *(char *)mod->srcu_struct_ptrs;
+               *(char *)mod->srcu_struct_ptrs = 0;
+               *(char *)mod->srcu_struct_ptrs = x;
+       }
+
        mod_tree_remove_init(mod);
        disable_ro_nx(&mod->init_layout);
        module_arch_freeing_init(mod);


thanks,

 - Joel

> 
> ---
>  kernel/module.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index f9221381d076..ed1f2612aebc 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3301,7 +3301,7 @@ static bool blacklisted(const char *module_name)
>  core_param(module_blacklist, module_blacklist, charp, 0400);
>  
>  /*
> - * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> + * These are section names marked with SHF_RO_AFTER_INIT so that
>   * layout_sections() can put it in the right place.
>   * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
>   */
> @@ -3314,6 +3314,13 @@ static char *ro_after_init_sections[] = {
>  	 * annotated as such at module load time.
>  	 */
>  	"__jump_table",
> +
> +	/*
> +	 * Used for SRCU structures which need to be initialized/cleaned up
> +	 * by the SRCU notifiers
> +	 */
> +	"___srcu_struct_ptrs",
> +
>  	NULL
>  };
>  
> -- 
> 2.21.0.392.gf8f6787159e-goog
> 
