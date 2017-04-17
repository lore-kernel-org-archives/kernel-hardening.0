Date: Mon, 17 Apr 2017 08:53:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170417065345.GC21022@kroah.com>
References: <20170417060706.28674-1-matt@nmatt.com>
 <20170417060706.28674-4-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170417060706.28674-4-matt@nmatt.com>
Subject: [kernel-hardening] Re: [PATCH 3/4] restrict unprivileged TIOCSTI tty ioctl
To: Matt Brown <matt@nmatt.com>
Cc: jmorris@namei.org, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 17, 2017 at 02:07:05AM -0400, Matt Brown wrote:
> this patch depends on patch 1 and 2
> 
> enforces restrictions on unprivileged users injecting commands
> into other processes in the same tty session using the TIOCSTI ioctl
> 
> Signed-off-by: Matt Brown <matt@nmatt.com>
> ---
>  drivers/tty/tty_io.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index e6d1a65..31894e8 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -2296,11 +2296,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
>   *	FIXME: may race normal receive processing
>   */
>  
> +int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
> +
>  static int tiocsti(struct tty_struct *tty, char __user *p)
>  {
>  	char ch, mbz = 0;
>  	struct tty_ldisc *ld;
>  
> +	if (tiocsti_restrict && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;

So, what type of "normal" userspace operations did you just break here?
What type of "not normal" did you break/change?

Why tie this to CAP_SYS_ADMIN as well?  That wasn't listed in your
Kconfig help text.  This seems like an additional capabilities
dependancy that odds are, most people do not want...

>  	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
>  		return -EPERM;

And finally, why doesn't this original check handle what you want to do
already?

I don't understand your "threat model" you wish to address by this
change series, please be a lot more explicit in your patch changelog
descriptions.

thanks,

greg k-h
