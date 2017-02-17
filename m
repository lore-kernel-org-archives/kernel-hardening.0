Message-ID: <1487345427.13790.3.camel@tycho.nsa.gov>
From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Fri, 17 Feb 2017 10:30:27 -0500
In-Reply-To: <alpine.LRH.2.20.1702150016220.32759@namei.org>
References: <alpine.LRH.2.20.1702150016220.32759@namei.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce
 CONFIG_SECURITY_WRITABLE_HOOKS
To: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
Cc: selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-02-15 at 00:17 +1100, James Morris wrote:
> Subsequent patches will add RO hardening to LSM hooks, however,
> SELinux
> still needs to be able to perform runtime disablement after init to
> handle
> architectures where init-time disablement via boot parameters is not
> feasible.
> 
> Introduce a new kernel configuration parameter
> CONFIG_SECURITY_WRITABLE_HOOKS,
> and a helper macro __lsm_ro_after_init, to handle this case.
> 
> Signed-off-by: James Morris <james.l.morris@oracle.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  include/linux/lsm_hooks.h |    7 +++++++
>  security/Kconfig          |    5 +++++
>  security/selinux/Kconfig  |    6 ++++++
>  3 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index e29d4c6..c4b149f 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1908,6 +1908,13 @@ static inline void
> security_delete_hooks(struct security_hook_list *hooks,
>  }
>  #endif /* CONFIG_SECURITY_SELINUX_DISABLE */
>  
> +/* Currently required to handle SELinux runtime hook disable. */
> +#ifdef CONFIG_SECURITY_WRITABLE_HOOKS
> +#define __lsm_ro_after_init
> +#else
> +#define __lsm_ro_after_init	__ro_after_init
> +#endif /* CONFIG_SECURITY_WRITABLE_HOOKS */
> +
>  extern int __init security_module_enable(const char *module);
>  extern void __init capability_add_hooks(void);
>  #ifdef CONFIG_SECURITY_YAMA
> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..f6f90c4 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -31,6 +31,11 @@ config SECURITY
>  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECURITY_WRITABLE_HOOKS
> +	depends on SECURITY
> +	bool
> +	default n
> +
>  config SECURITYFS
>  	bool "Enable the securityfs filesystem"
>  	help
> diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
> index ea7e3ef..8af7a69 100644
> --- a/security/selinux/Kconfig
> +++ b/security/selinux/Kconfig
> @@ -40,6 +40,7 @@ config SECURITY_SELINUX_BOOTPARAM_VALUE
>  config SECURITY_SELINUX_DISABLE
>  	bool "NSA SELinux runtime disable"
>  	depends on SECURITY_SELINUX
> +	select SECURITY_WRITABLE_HOOKS
>  	default n
>  	help
>  	  This option enables writing to a selinuxfs node 'disable',
> which
> @@ -50,6 +51,11 @@ config SECURITY_SELINUX_DISABLE
>  	  portability across platforms where boot parameters are
> difficult
>  	  to employ.
>  
> +	  NOTE: selecting this option will disable the
> '__ro_after_init'
> +	  kernel hardening feature for security hooks.   Please
> consider
> +	  using the selinux=0 boot parameter instead of enabling
> this
> +	  option.
> +
>  	  If you are unsure how to answer this question, answer N.
>  
>  config SECURITY_SELINUX_DEVELOP
