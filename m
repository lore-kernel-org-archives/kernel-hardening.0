From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702150016220.32759@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702150016220.32759@namei.org>
Message-Id: <201702142324.IFB95862.MOSJLOVFQFtFHO@I-love.SAKURA.ne.jp>
Date: Tue, 14 Feb 2017 23:24:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
To: jmorris@namei.org, linux-security-module@vger.kernel.org
Cc: selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> > Loadable kernel modules used by antivirus software temporarily modify syscall tables
> > ( http://stackoverflow.com/questions/13876369/system-call-interception-in-linux-kernel-module-kernel-3-5 )
> > in order to register hooks for execve()/open()/close(). It is very frustrating for
> > many users if you enforce CONFIG_MODULES=n or forbid post-__init registration of hooks.
> 
> We don't cater to out of tree code.
> 
> Additionally, I'd also seriously question whether the security benefits of 
> kernel AV outweigh its security risks.

Are you aware that loadable kernel modules used by antivirus software are used for
relaying events to userspace daemons? Such modules don't do scanning inside kernel.
Why such modules are considered as security risks?

Are you aware that SELinux (or AppArmor or whatever so-called MAC) is not always
enabled in all enterprise systems? Are you aware that there are systems where
administrators cannot afford using rule based access restriction mechanisms?
In such systems, the security benefits of loadable security modules (provided by
AV or alike) can outweigh read only LSM hooks.

> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..f6f90c4 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -31,6 +31,11 @@ config SECURITY
>  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECURITY_WRITABLE_HOOKS
> +	depends on SECURITY
> +	bool
> +	default n
> +

This configuration option must not be set to N without big fat explanation
about implications of setting this option to N.

Honestly, I still don't like this option, regardless of whether SELinux
needs this option or not.
