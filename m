Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 10:32:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104093236.GB31677@kroah.com>
References: <20170103225831.GA113525@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103225831.GA113525@beast>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@coreos.com>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 03, 2017 at 02:58:31PM -0800, Kees Cook wrote:
> From: Matthew Garrett <mjg59@coreos.com>
> 
> Various attacks are made possible due to the large attack surface of
> kernel drivers and the easy availability of hotpluggable hardware that can
> be programmed to mimic arbitrary devices. This allows attackers to find a
> single vulnerable driver and then produce a device that can exploit it by
> plugging into a hotpluggable bus (such as PCI or USB). This violates user
> assumptions about unattended systems being secure as long as the screen
> is locked.
> 
> The kernel already has support for deferring driver binding in order
> to avoid problems over suspend/resume. By exposing this to userspace we
> can disable probing when the screen is locked and simply reenable it on
> unlock.
> 
> This is not a complete solution - since this still permits device
> creation and simply blocks driver binding, it won't stop userspace
> drivers from attaching to devices and it won't protect against any kernel
> vulnerabilities in the core bus code. However, it should be sufficient to
> block attacks like Poisontap (https://samy.pl/poisontap/).
> 
> Signed-off-by: Matthew Garrett <mjg59@coreos.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  .../ABI/testing/sysfs-kernel-disable-device-probe  | 10 ++++++++
>  drivers/base/base.h                                |  2 --
>  drivers/base/dd.c                                  | 10 ++++++++
>  drivers/base/power/main.c                          | 16 ++++++++++---
>  include/linux/device.h                             |  4 ++++
>  kernel/ksysfs.c                                    | 28 ++++++++++++++++++++++
>  6 files changed, 65 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-disable-device-probe
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-disable-device-probe b/Documentation/ABI/testing/sysfs-kernel-disable-device-probe
> new file mode 100644
> index 000000000000..1ca6c2d11d8b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-disable-device-probe
> @@ -0,0 +1,10 @@
> +What:		/sys/kernel/disable_device_probe
> +Date:		December 2016
> +KernelVersion:	4.11
> +Contact:	Matthew Garrett <mjg59@srcf.ucam.org>
> +Description
> +		Disables automatic driver probing of any newly added devices.
> +		If "1", driver probing is disabled - any newly added devices
> +		will not have a driver bound to them. If "0", newly added
> +		devices will be probed, along with any devices connected while
> +		"1" was set.
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index ada9dce34e6d..7bee2e4e38ce 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -134,8 +134,6 @@ extern void device_remove_groups(struct device *dev,
>  extern char *make_class_name(const char *name, struct kobject *kobj);
>  
>  extern int devres_release_all(struct device *dev);
> -extern void device_block_probing(void);
> -extern void device_unblock_probing(void);
>  
>  /* /sys/devices directory */
>  extern struct kset *devices_kset;
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index a8b258e5407b..4d70fa41132c 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -191,6 +191,16 @@ static void driver_deferred_probe_trigger(void)
>  }
>  
>  /**
> + * device_probing_deferred() - Get the current state of device probing
> + *
> + *	Returns whether or not device probing is currently deferred
> + */
> +bool device_probing_deferred(void)
> +{
> +	return defer_all_probes;
> +}
> +
> +/**
>   * device_block_probing() - Block/defere device's probes
>   *
>   *	It will disable probing of devices and defer their probes instead.
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 249e0304597f..b566e7a6140c 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -59,6 +59,8 @@ struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
>  
> +static bool probing_deferred;
> +
>  static int async_error;
>  
>  static char *pm_verb(int event)
> @@ -1024,8 +1026,12 @@ void dpm_complete(pm_message_t state)
>  	list_splice(&list, &dpm_list);
>  	mutex_unlock(&dpm_list_mtx);
>  
> -	/* Allow device probing and trigger re-probing of deferred devices */
> -	device_unblock_probing();
> +	/*
> +	 * Allow device probing and trigger re-probing of deferred devices
> +	 * unless userspace has explicitly disabled probing
> +	 */
> +	if (!probing_deferred)
> +		device_unblock_probing();

Ick, hiding this in the power management code?  That's messy, and
complex, as Rafael pointed out.

Turning on and off at random times "new devices can not be bound, wait,
now they can!" is ripe for loads of issues and is going to be a pain to
properly maintain over time.

What's wrong with the facility that the USB layer provides today to
allow only "authenticated" devices to be enabled?  That has been used
for a few years now to prevent these "don't allow random devices that
are plugged into the computer to be enabled" type attacks.  Doing much
the same thing, in a different manner, is ripe for problems (how do the
two interact now?)

If you are worried about PCI devices, why not just implement what USB
did for PCI?  Or better yet, move the USB functionality into the driver
core, adding that type of authentication ability to any bus that wishes
to have it (and not break existing working systems that are using the
USB solution today.)

thanks,

greg k-h
