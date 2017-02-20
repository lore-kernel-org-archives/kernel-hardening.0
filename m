Date: Mon, 20 Feb 2017 10:30:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170220103008.GC9003@leverpostej>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com>
Subject: Re: [kernel-hardening] [RFC 3/7] module: modify memory attrs for
 __ro_mostly_after_init during module_init/exit
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 19, 2017 at 07:04:06PM +0900, Hoeun Ryu wrote:
>  `__ro_mostly_after_init` is almost like `__ro_after_init`. The section is
> read-only as same as `__ro_after_init` after kernel init. This patch makes
> `__ro_mostly_after_init` section read-write temporarily only during
> module_init/module_exit.
> 
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
> ---
>  kernel/module.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 7eba6de..3b25e0e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -987,8 +987,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  
>  	mutex_unlock(&module_mutex);
>  	/* Final destruction now no one is using it. */
> -	if (mod->exit != NULL)
> +	if (mod->exit != NULL) {
> +		set_ro_mostly_after_init_rw();
>  		mod->exit();
> +		set_ro_mostly_after_init_ro();
> +	}
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);
>  	klp_module_going(mod);
> @@ -3396,8 +3399,11 @@ static noinline int do_init_module(struct module *mod)
>  
>  	do_mod_ctors(mod);
>  	/* Start the module */
> -	if (mod->init != NULL)
> +	if (mod->init != NULL) {
> +		set_ro_mostly_after_init_rw();
>  		ret = do_one_initcall(mod->init);
> +		set_ro_mostly_after_init_ro();
> +	}

This looks very much like the pax_{open,close}_kernel() approach for
write-rarely data.

I think it would be better to implement a first class write-rarely
mechanism rather than trying to extend __ro_after_init to cover this
case.

As mentioned previously, I *think* we can have a generic implementation
that uses an mm to temporarily map a (thread/cpu-local) RW alias of the
data in question in what would otherwise be the user half of the address
space. Regardless, we can have a generic interface [1] that can cater
for that style of approach and/or something like ARM's domains or x86's
pkeys.

Thanks,
Mark.

[1] http://www.openwall.com/lists/kernel-hardening/2016/11/18/3
