Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161214185110.GD4939@kroah.com>
References: <20161214185000.GA3930@kroah.com> <20161214185110.GD4939@kroah.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 14 Dec 2016 12:31:34 -0800
Message-ID: <CAGXu5jK-k=Mbk5RxiYk0r3xAQHkMvVZvYiX9mmHGpK1=hsCvtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 4/4] Introduce CONFIG_READONLY_USERMODEHELPER
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 14, 2016 at 10:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> If you can write to kernel memory, an "easy" way to get the kernel to
> run any application is to change the pointer of one of the usermode
> helper program names.  To try to mitigate this, create a new config
> option, CONFIG_READONLY_USERMODEHELPER.
>
> This option only allows "predefined" binaries to be called.  A number of
> drivers and subsystems allow for the name of the binary to be changed,
> and this config option disables that capability, so be aware of that.
>
> Note:  Still a proof-of-concept at this point in time, doesn't cover all
> of the call_usermodehelper() calls just yet, including the "fun" of
> coredumps, it's still a work in progress.
>
> Not-Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++++----
>  drivers/block/drbd/drbd_int.h    |  6 +++++-
>  drivers/block/drbd/drbd_main.c   |  5 +++++
>  drivers/video/fbdev/uvesafb.c    | 19 ++++++++++++++-----
>  fs/nfs/cache_lib.c               | 12 ++++++++++--
>  include/linux/reboot.h           |  2 ++
>  kernel/ksysfs.c                  |  6 +++++-
>  kernel/reboot.c                  |  3 +++
>  kernel/sysctl.c                  |  4 ++++
>  lib/kobject_uevent.c             |  3 +++
>  security/Kconfig                 | 17 +++++++++++++++++
>  11 files changed, 76 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 00ef43233e03..92a2ef8ffe3e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2337,15 +2337,16 @@ static ssize_t set_bank(struct device *s, struct device_attribute *attr,
>  }
>
>  static ssize_t
> -show_trigger(struct device *s, struct device_attribute *attr, char *buf)
> +trigger_show(struct device *s, struct device_attribute *attr, char *buf)
>  {
>         strcpy(buf, mce_helper);
>         strcat(buf, "\n");
>         return strlen(mce_helper) + 1;

The +1 is wrong, AFAICT. Also, is speed really needed here?

    return scnprintf(buf, PAGE_SIZE, "%s\n", mce_helper);

is more readable...

> -static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
> -                               const char *buf, size_t siz)
> +#ifndef CONFIG_READONLY_USERMODEHELPER
> +static ssize_t trigger_store(struct device *s, struct device_attribute *attr,
> +                            const char *buf, size_t siz)
>  {
>         char *p;
>
> @@ -2358,6 +2359,10 @@ static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
>
>         return strlen(mce_helper) + !!p;
>  }
> +static DEVICE_ATTR_RW(trigger);
> +#else
> +static DEVICE_ATTR_RO(trigger);
> +#endif
>
>  static ssize_t set_ignore_ce(struct device *s,
>                              struct device_attribute *attr,
> @@ -2415,7 +2420,6 @@ static ssize_t store_int_with_restart(struct device *s,
>         return ret;
>  }
>
> -static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
>  static DEVICE_INT_ATTR(tolerant, 0644, mca_cfg.tolerant);
>  static DEVICE_INT_ATTR(monarch_timeout, 0644, mca_cfg.monarch_timeout);
>  static DEVICE_BOOL_ATTR(dont_log_ce, 0644, mca_cfg.dont_log_ce);
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index a139a34f1f1e..e21ab2bcc482 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -75,7 +75,11 @@ extern int fault_rate;
>  extern int fault_devs;
>  #endif
>
> -extern char drbd_usermode_helper[];
> +extern
> +#ifdef CONFIG_READONLY_USERMODEHELPER
> +       const
> +#endif
> +             char drbd_usermode_helper[];

This #ifdef; const; #endif is repeated a few times. Perhaps better to
create a separate macro:

#ifdef CONFIG_READONLY_USERMODEHELPER
# define __ro_umh const
#else
# define __ro_umh /**/
#endif

...

extern __ro_umh char drbd_usermode_helper[];



-Kees

-- 
Kees Cook
Nexus Security
