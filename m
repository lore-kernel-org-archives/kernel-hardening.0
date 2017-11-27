References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-2-git-send-email-tixxdz@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d3ad5499-02d4-28f0-569a-e28960301097@infradead.org>
Date: Mon, 27 Nov 2017 10:48:35 -0800
MIME-Version: 1.0
In-Reply-To: <1511803118-2552-2-git-send-email-tixxdz@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: Djalal Harouni <tixxdz@gmail.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Mostly typos/spellos...


On 11/27/2017 09:18 AM, Djalal Harouni wrote:
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  include/linux/kmod.h      | 65 ++++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/lsm_hooks.h |  6 ++++-
>  include/linux/security.h  |  7 +++--
>  kernel/kmod.c             | 29 ++++++++++++++++-----
>  security/security.c       |  6 +++--
>  security/selinux/hooks.c  |  3 ++-
>  6 files changed, 97 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 40c89ad..ccd6a1c 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -33,16 +33,67 @@

> +/**
> + * request_module  Try to load a kernel module
> + *
> + * Automatically loads the request module.
> + *
> + * @mod...: The module name
> + */

what are the "..." for?  what do they do here?

> +#define request_module(mod...) __request_module(true, -1, NULL, mod)
> +
> +#define request_module_nowait(mod...) __request_module(false, -1, NULL, mod)
> +
> +/**
> + * request_module_cap  Load kernel module only if the required capability is set
> + *
> + * Automatically load a module if the required capability is set and it
> + * corresponds to the appropriate subsystem that is indicated by prefix.
> + *
> + * This allows to load aliased modules like 'netdev-%s' with CAP_NET_ADMIN.
> + *
> + * ex:
> + *	request_module_cap(CAP_NET_ADMIN, "netdev", "%s", mod);
> + *
> + * @required_cap: Required capability to load the module
> + * @prefix: The module prefix if any, otherwise NULL
> + * @fmt: printf style format string for the name of the module with its
> + *       arguments if any
> + *
> + * If '@required_cap' is positive, the security subsystem will check if
> + * '@prefix' is set and if caller has the required capability then the
> + * operation is allowed.
> + * The security subsystem can not make assumption about the boundaries
> + * of other subsystems, it is their responsability to make a call with

                                       responsibility

> + * the right capability and module alias.
> + *
> + * If '@required_cap' is positive and '@prefix' is NULL then we assume
> + * that the '@required_cap' is CAP_SYS_MODULE.
> + *
> + * If '@required_cap' is negative then there are no permission checks, this
> + * is the equivalent to request_module() function.
> + *
> + * This function trust callers to pass the right capability with the

                    trusts

> + * appropriate prefix.
> + *
> + * Note: the permission checks may still fail, even if the required
> + * capability is negative, this is due to module loading restrictions

                    negative; this

> + * that are controlled by the enduser.
> + */
> +#define request_module_cap(required_cap, prefix, fmt...) \
> +	__request_module(true, required_cap, prefix, fmt)
> +
>  #endif /* __LINUX_KMOD_H__ */
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 7161d8e..d898bd0 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -571,6 +571,9 @@
>   *	Ability to trigger the kernel to automatically upcall to userspace for
>   *	userspace to load a kernel module with the given name.
>   *	@kmod_name name of the module requested by the kernel
> + *	@required_cap If positive, the required capability to automatically load
> + *	the correspondig kernel module.

            corresponding

> + *	@prefix The prefix of the module if any. Can be NULL.
>   *	Return 0 if successful.
>   * @kernel_read_file:
>   *	Read a file specified by userspace.

> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index bc6addd..679d401 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -109,6 +109,8 @@ static int call_modprobe(char *module_name, int wait)
>  /**
>   * __request_module - try to load a kernel module
>   * @wait: wait (or not) for the operation to complete
> + * @required_cap: required capability to load the module
> + * @prefix: module prefix if any otherwise NULL
>   * @fmt: printf style format string for the name of the module
>   * @...: arguments as specified in the format string
>   *
> @@ -119,14 +121,20 @@ static int call_modprobe(char *module_name, int wait)
>   * must check that the service they requested is now available not blindly
>   * invoke it.
>   *
> - * If module auto-loading support is disabled then this function
> - * becomes a no-operation.
> + * If "required_cap" is positive, The security subsystem will trust the caller

                                     the

> + * that if it has "required_cap" then it may allow to load some modules that
> + * have a specific alias.
> + *
> + * If module auto-loading support is disabled by clearing the modprobe path
> + * then this function becomes a no-operation.
>   */
> -int __request_module(bool wait, const char *fmt, ...)
> +int __request_module(bool wait, int required_cap,
> +		     const char *prefix, const char *fmt, ...)
>  {
>  	va_list args;
>  	char module_name[MODULE_NAME_LEN];
>  	int ret;
> +	int len = 0;
>  
>  	/*
>  	 * We don't allow synchronous module loading from async.  Module
> @@ -139,13 +147,22 @@ int __request_module(bool wait, const char *fmt, ...)
>  	if (!modprobe_path[0])
>  		return 0;
>  
> +	/*
> +	 * Lets attach the prefix to the module name

Let's
but better:
	 * Attach the prefix to the module name

> +	 */
> +	if (prefix != NULL && *prefix != '\0') {
> +		len += snprintf(module_name, MODULE_NAME_LEN, "%s-", prefix);
> +		if (len >= MODULE_NAME_LEN)
> +			return -ENAMETOOLONG;
> +	}
> +
>  	va_start(args, fmt);
> -	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
> +	ret = vsnprintf(module_name + len, MODULE_NAME_LEN - len, fmt, args);
>  	va_end(args);
> -	if (ret >= MODULE_NAME_LEN)
> +	if (ret >= MODULE_NAME_LEN - len)
>  		return -ENAMETOOLONG;
>  
> -	ret = security_kernel_module_request(module_name);
> +	ret = security_kernel_module_request(module_name, required_cap, prefix);
>  	if (ret)
>  		return ret;
>  


-- 
~Randy
