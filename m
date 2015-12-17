Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Dec 2015 09:16:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151217171645.GA7495@kroah.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
 <1450364270-12687-2-git-send-email-dave@progbits.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450364270-12687-2-git-send-email-dave@progbits.org>
Subject: Re: [kernel-hardening][RFC PATCH v2 01/12] x86: add PAX_REFCOUNT
 support
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 09:57:39AM -0500, David Windsor wrote:
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -749,6 +749,17 @@ struct signal_struct {
>  #ifdef CONFIG_TASKSTATS
>  	struct taskstats *stats;
>  #endif
> +
> +#ifdef CONFIG_GRKERNSEC
> +	u32 curr_ip;
> +	u32 saved_ip;
> +	u32 gr_saddr;
> +	u32 gr_daddr;
> +	u16 gr_sport;
> +	u16 gr_dport;
> +	u8 used_accept:1;
> +#endif
> +

Why is this here in this patch?

thanks,

greg k-h
