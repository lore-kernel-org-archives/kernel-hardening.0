Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
Date: Thu, 17 Dec 2015 12:34:35 -0800
Message-ID: <CAGXu5jLr_kKagFb=prYcx83UPnh4MK7aLKUdSC6YjJmn7AW7_w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 12/12] lkdtm: add test for
 atomic_t underflow/overflow
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrote:
> dmesg output of running this LKDTM test:
>
> [187095.475573] lkdtm: No crash points registered, enable through debugfs
> [187118.020257] lkdtm: Performing direct entry WRAP_ATOMIC
> [187118.030045] lkdtm: attempting atomic underflow
> [187118.030929] PAX: refcount overflow detected in: bash:1790, uid/euid: 0/0
> [187118.071667] PAX: refcount overflow occured at: lkdtm_do_action+0x19e/0x400 [lkdtm]
> [187118.081423] CPU: 3 PID: 1790 Comm: bash Not tainted 4.2.6-pax-refcount-split+ #2
> [187118.083403] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [187118.102596] task: ffff8800da8de040 ti: ffff8800da8e4000 task.ti: ffff8800da8e4000
> [187118.111321] RIP: 0010:[<ffffffffc00fc2fe>]  [<ffffffffc00fc2fe>] lkdtm_do_action+0x19e/0x400 [lkdtm]
> ...
> [187118.128074] lkdtm: attempting atomic overflow
> [187118.128080] PAX: refcount overflow detected in: bash:1790, uid/euid: 0/0
> [187118.128082] PAX: refcount overflow occured at: lkdtm_do_action+0x1b6/0x400 [lkdtm]
> [187118.128085] CPU: 3 PID: 1790 Comm: bash Not tainted 4.2.6-pax-refcount-split+ #2
> [187118.128086] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [187118.128088] task: ffff8800da8de040 ti: ffff8800da8e4000 task.ti: ffff8800da8e4000
> [187118.128092] RIP: 0010:[<ffffffffc00fc316>]  [<ffffffffc00fc316>] lkdtm_do_action+0x1b6/0x400 [lkdtm]
>
> Signed-off-by: David Windsor <dave@progbits.org>

Yay tests! :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/misc/lkdtm.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index b5abe34..5002747 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -104,6 +104,7 @@ enum ctype {
>         CT_ACCESS_USERSPACE,
>         CT_WRITE_RO,
>         CT_WRITE_KERN,
> +    CT_WRAP_ATOMIC
>  };
>
>  static char* cp_name[] = {
> @@ -141,6 +142,7 @@ static char* cp_type[] = {
>         "ACCESS_USERSPACE",
>         "WRITE_RO",
>         "WRITE_KERN",
> +    "WRAP_ATOMIC"
>  };
>
>  static struct jprobe lkdtm;
> @@ -522,6 +524,17 @@ static void lkdtm_do_action(enum ctype which)
>                 do_overwritten();
>                 break;
>         }
> +    case CT_WRAP_ATOMIC: {
> +        atomic_t under = ATOMIC_INIT(INT_MIN);
> +        atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +        pr_info("attempting atomic underflow\n");
> +        atomic_dec(&under);
> +        pr_info("attempting atomic overflow\n");
> +        atomic_inc(&over);
> +
> +        return;
> +    }
>         case CT_NONE:
>         default:
>                 break;
> --
> 2.5.0
>
>



-- 
Kees Cook
Chrome OS & Brillo Security
