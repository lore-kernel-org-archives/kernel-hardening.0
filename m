References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <8219df49-321d-d032-48b5-cf1cd5a46664@schaufler-ca.com>
Date: Mon, 12 Jun 2017 14:31:30 -0700
MIME-Version: 1.0
In-Reply-To: <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/12/2017 9:56 AM, Salvatore Mesoraca wrote:
> Creation of a new LSM hook that can be used to authorize or deauthorize
> new USB devices via the usb authorization interface.
> The same hook can also prevent the authorization of a USB device via
> "/sys/bus/usb/devices/DEVICE/authorized".
> Using this hook an LSM could provide an higher level of granularity
> than the current authorization interface.
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/core/hub.c    | 4 ++++
>  drivers/usb/core/sysfs.c  | 6 +++++-
>  include/linux/lsm_hooks.h | 6 ++++++
>  include/linux/security.h  | 7 +++++++
>  security/security.c       | 5 +++++
>  5 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index b8bb20d..58be4f0 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -28,6 +28,7 @@
>  #include <linux/mutex.h>
>  #include <linux/random.h>
>  #include <linux/pm_qos.h>
> +#include <linux/security.h>
>  
>  #include <linux/uaccess.h>
>  #include <asm/byteorder.h>
> @@ -4831,6 +4832,9 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  		if (udev->quirks & USB_QUIRK_DELAY_INIT)
>  			msleep(1000);
>  
> +		if (security_usb_device_auth(udev))
> +			usb_deauthorize_device(udev);
> +
>  		/* consecutive bus-powered hubs aren't reliable; they can
>  		 * violate the voltage drop budget.  if the new child has
>  		 * a "powered" LED, users should notice we didn't enable it
> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> index dfc68ed..fce9d39 100644
> --- a/drivers/usb/core/sysfs.c
> +++ b/drivers/usb/core/sysfs.c
> @@ -17,6 +17,7 @@
>  #include <linux/usb.h>
>  #include <linux/usb/quirks.h>
>  #include <linux/of.h>
> +#include <linux/security.h>
>  #include "usb.h"
>  
>  /* Active configuration fields */
> @@ -742,8 +743,11 @@ static ssize_t authorized_store(struct device *dev,
>  		result = -EINVAL;
>  	else if (val == 0)
>  		result = usb_deauthorize_device(usb_dev);
> -	else
> +	else {
> +		if (security_usb_device_auth(usb_dev))
> +			return -EPERM;

Return the error reported by the hook rather than -EPERM.

>  		result = usb_authorize_device(usb_dev);
> +	}
>  	return result < 0 ? result : size;
>  }
>  static DEVICE_ATTR_IGNORE_LOCKDEP(authorized, S_IRUGO | S_IWUSR,
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index bd274db..cc0937e 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1189,6 +1189,10 @@
>   *	to the @parent process for tracing.
>   *	@parent contains the task_struct structure for debugger process.
>   *	Return 0 if permission is granted.
> + * @usb_device_auth:
> + *	Check if @udev device should be authorized or not.
> + *	@udev contains the usb_device structure for the USB device.
> + *	Return 0 if the device is allowed.
>   * @capget:
>   *	Get the @effective, @inheritable, and @permitted capability sets for
>   *	the @target process.  The hook may also perform permission checking to
> @@ -1352,6 +1356,7 @@
>  	int (*ptrace_access_check)(struct task_struct *child,
>  					unsigned int mode);
>  	int (*ptrace_traceme)(struct task_struct *parent);
> +	int (*usb_device_auth)(const struct usb_device *udev);
>  	int (*capget)(struct task_struct *target, kernel_cap_t *effective,
>  			kernel_cap_t *inheritable, kernel_cap_t *permitted);
>  	int (*capset)(struct cred *new, const struct cred *old,
> @@ -1670,6 +1675,7 @@ struct security_hook_heads {
>  	struct list_head binder_transfer_file;
>  	struct list_head ptrace_access_check;
>  	struct list_head ptrace_traceme;
> +	struct list_head usb_device_auth;
>  	struct list_head capget;
>  	struct list_head capset;
>  	struct list_head capable;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index af675b5..19bc364 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -30,6 +30,7 @@
>  #include <linux/string.h>
>  #include <linux/mm.h>
>  #include <linux/fs.h>
> +#include <linux/usb.h>
>  
>  struct linux_binprm;
>  struct cred;
> @@ -196,6 +197,7 @@ int security_binder_transfer_file(struct task_struct *from,
>  				  struct task_struct *to, struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>  int security_ptrace_traceme(struct task_struct *parent);
> +int security_usb_device_auth(const struct usb_device *udev);
>  int security_capget(struct task_struct *target,
>  		    kernel_cap_t *effective,
>  		    kernel_cap_t *inheritable,
> @@ -434,6 +436,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
>  	return cap_ptrace_traceme(parent);
>  }
>  
> +static inline int security_usb_device_auth(const struct usb_device *udev)
> +{
> +	return 0;
> +}
> +
>  static inline int security_capget(struct task_struct *target,
>  				   kernel_cap_t *effective,
>  				   kernel_cap_t *inheritable,
> diff --git a/security/security.c b/security/security.c
> index 42c8028..e390f99 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -214,6 +214,11 @@ int security_ptrace_traceme(struct task_struct *parent)
>  	return call_int_hook(ptrace_traceme, 0, parent);
>  }
>  
> +int security_usb_device_auth(const struct usb_device *udev)
> +{
> +	return call_int_hook(usb_device_auth, 0, udev);
> +}
> +
>  int security_capget(struct task_struct *target,
>  		     kernel_cap_t *effective,
>  		     kernel_cap_t *inheritable,
