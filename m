Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 11:11:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214191137.GA6974@kroah.com>
References: <20161214185000.GA3930@kroah.com>
 <20161214185052.GC4939@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185052.GC4939@kroah.com>
Subject: Re: [kernel-hardening] [PATCH 3/4] Make static usermode helper
 binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 14, 2016 at 10:50:52AM -0800, Greg KH wrote:
> 
> There are a number of usermode helper binaries that are "hard coded" in
> the kernel today, so mark them as "const" to make it harder for someone
> to change where the variables point to.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/macintosh/windfarm_core.c          | 2 +-
>  drivers/net/hamradio/baycom_epp.c          | 2 +-
>  drivers/pnp/pnpbios/core.c                 | 5 +++--
>  drivers/staging/greybus/svc_watchdog.c     | 4 ++--
>  drivers/staging/rtl8192e/rtl8192e/rtl_dm.c | 6 +++---
>  fs/nfsd/nfs4layouts.c                      | 6 ++++--
>  security/keys/request_key.c                | 7 ++++---
>  7 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
> index 465d770ab0bb..1b317cbb73cf 100644
> --- a/drivers/macintosh/windfarm_core.c
> +++ b/drivers/macintosh/windfarm_core.c
> @@ -74,7 +74,7 @@ static inline void wf_notify(int event, void *param)
>  
>  static int wf_critical_overtemp(void)
>  {
> -	static char * critical_overtemp_path = "/sbin/critical_overtemp";
> +	static const char * critical_overtemp_path = "/sbin/critical_overtemp";
>  	char *argv[] = { critical_overtemp_path, NULL };
>  	static char *envp[] = { "HOME=/",
>  				"TERM=linux",

Doh, minor compiler warnings for this one, and others in this patch,
I'll fix them up...
