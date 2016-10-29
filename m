Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 29 Oct 2016 14:04:50 -0700
Message-ID: <CAGXu5j+soho2i80-28D3OkSTJfTgtyFRKkQzCFcAaXFe2NtGxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH 0/5] Expand HARDENED_ATOMIC overflow protection
To: David Windsor <dwindsor@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 29, 2016 at 9:19 AM, David Windsor <dwindsor@gmail.com> wrote:
> Expand HARDENED_ATOMIC overflow protection to cover more kernel reference
> counters.
>
> The original HARDENED_ATOMIC series adds overflow protection to existing kernel
> users of atomic_t.  This series creates 8 new users of atomic_t:
>
>  * struct fs_struct.users
>  * struct tty_port.count
>  * struct tty_ldisc_ops.refcount
>  * struct pipe_inode_info.{readers|writers|files|waiting_writers}
>  * struct kmem_cache.refcount
>
> This series changes the type of these variables to atomic_t, thus affording them
> the overflow protection provided by HARDENED_ATOMIC.

Very cool! This will be a nice addition. :)

-Kees

>
> This is based upon work done by the PaX Team [1].
>
> [1] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
>
> David Windsor (5):
>   fs: add overflow protection to struct fs_struct.users
>   tty: add overflow protection to struct tty_port.count
>   tty: add overflow protection to struct tty_ldisc_ops.refcount
>   fs: add overflow protection to struct
>     pipe_inode_info.{readers|writers|files|waiting_writers}
>   mm: add overflow protection to struct kmem_cache.refcount
>
>  arch/um/drivers/line.c                 |  2 +-
>  drivers/char/pcmcia/synclink_cs.c      | 16 ++++-----
>  drivers/isdn/gigaset/interface.c       |  8 ++---
>  drivers/isdn/i4l/isdn_tty.c            | 22 ++++++-------
>  drivers/net/usb/hso.c                  | 22 ++++++-------
>  drivers/s390/char/tty3270.c            |  2 +-
>  drivers/staging/gdm724x/gdm_tty.c      |  2 +-
>  drivers/tty/amiserial.c                |  4 +--
>  drivers/tty/bfin_jtag_comm.c           |  4 +--
>  drivers/tty/cyclades.c                 |  8 ++---
>  drivers/tty/hvc/hvc_console.c          | 14 ++++----
>  drivers/tty/hvc/hvcs.c                 | 20 ++++++------
>  drivers/tty/hvc/hvsi.c                 | 10 +++---
>  drivers/tty/ipwireless/tty.c           | 26 +++++++--------
>  drivers/tty/moxa.c                     |  2 +-
>  drivers/tty/n_gsm.c                    |  2 +-
>  drivers/tty/n_tty.c                    |  3 +-
>  drivers/tty/rocket.c                   |  8 ++---
>  drivers/tty/serial/crisv10.c           | 34 ++++++++++----------
>  drivers/tty/serial/serial_core.c       |  4 +--
>  drivers/tty/synclink.c                 | 32 +++++++++---------
>  drivers/tty/synclink_gt.c              | 28 ++++++++--------
>  drivers/tty/synclinkmp.c               | 34 ++++++++++----------
>  drivers/tty/tty_ldisc.c                |  8 ++---
>  drivers/tty/tty_port.c                 | 22 ++++++-------
>  drivers/usb/gadget/function/u_serial.c | 22 ++++++-------
>  drivers/usb/serial/console.c           |  6 ++--
>  fs/coredump.c                          | 10 +++---
>  fs/exec.c                              |  2 +-
>  fs/fs_struct.c                         |  8 ++---
>  fs/namespace.c                         |  2 +-
>  fs/pipe.c                              | 59 +++++++++++++++++-----------------
>  fs/proc/task_nommu.c                   |  2 +-
>  fs/splice.c                            | 36 ++++++++++-----------
>  include/linux/fs_struct.h              |  2 +-
>  include/linux/pipe_fs_i.h              |  8 ++---
>  include/linux/slab_def.h               |  2 +-
>  include/linux/slub_def.h               |  2 +-
>  include/linux/tty.h                    |  4 +--
>  include/linux/tty_ldisc.h              |  2 +-
>  kernel/fork.c                          |  6 ++--
>  kernel/user_namespace.c                |  2 +-
>  mm/slab.c                              |  2 +-
>  mm/slab.h                              |  2 +-
>  mm/slab_common.c                       | 12 +++----
>  mm/slub.c                              | 10 +++---
>  net/bluetooth/rfcomm/tty.c             |  4 +--
>  net/irda/ircomm/ircomm_tty.c           | 18 +++++------
>  48 files changed, 281 insertions(+), 279 deletions(-)
>
> --
> 2.7.4
>



-- 
Kees Cook
Nexus Security
