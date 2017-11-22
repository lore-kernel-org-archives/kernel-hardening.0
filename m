MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171122005432.4974-1-mjg59@google.com>
References: <20171122005432.4974-1-mjg59@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Nov 2017 17:29:29 -0800
Message-ID: <CAGXu5jLk6NzoBf-Z_sFX3dsgks=_MaSTON4i9QnPrJ+gEi+uOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] usercopy: Allow runtime disabling of usercopy fallback
To: Matthew Garrett <mjg59@google.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 21, 2017 at 4:54 PM, Matthew Garrett <mjg59@google.com> wrote:
> Distributions are likely to build with
> CONFIG_HARDENED_USERCOPY_FALLBACK, but individual sites may wish to
> disable that functionality. Add a sysctl that allows the fallback to be
> disabled and then forbids any attempt to re-enable it.

Is it likely that distros will select FALLBACK? I figured by the time
a kernel with this feature got to the distros it'd already gotten a
fair bit of testing, so they'd just leave FALLBACK disabled.

I'll consider this, though I have to refactor the series a bit to move
this patch earlier, etc.

Thanks for looking at it!

-Kees

>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> ---
>  Documentation/sysctl/vm.txt |  9 +++++++++
>  include/linux/mm.h          |  7 +++++++
>  kernel/sysctl.c             | 11 +++++++++++
>  mm/memory.c                 | 17 +++++++++++++++++
>  mm/slab.c                   |  4 +---
>  mm/slub.c                   |  4 +---
>  6 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 9baf66a9ef4e..b494b292fd93 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -60,6 +60,7 @@ Currently, these files are in /proc/sys/vm:
>  - stat_refresh
>  - swappiness
>  - user_reserve_kbytes
> +- usercopy_fallback
>  - vfs_cache_pressure
>  - watermark_scale_factor
>  - zone_reclaim_mode
> @@ -822,6 +823,14 @@ Changing this takes effect whenever an application requests memory.
>
>  ==============================================================
>
> +usercopy_fallback
> +
> +If 1, attempts to copy data from userland will generate a kernel warning
> +if the target has not been whitelisted, but will still be permitted. If 0,
> +this will result in a kernel BUG(). This may be set from 1 to 0 at runtime,
> +but may not be modified if 0.
> +
> +==============================================================
>  vfs_cache_pressure
>  ------------------
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f8c10d336e42..511237addbf9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2456,6 +2456,8 @@ int drop_caches_sysctl_handler(struct ctl_table *, int,
>  void drop_slab(void);
>  void drop_slab_node(int nid);
>
> +extern bool usercopy_fallback;
> +
>  #ifndef CONFIG_MMU
>  #define randomize_va_space 0
>  #else
> @@ -2602,5 +2604,10 @@ void __init setup_nr_node_ids(void);
>  static inline void setup_nr_node_ids(void) {}
>  #endif
>
> +#ifdef CONFIG_HARDENED_USERCOPY
> +int usercopy_fallback_handler(struct ctl_table *table, int write,
> +                           void __user *buffer, size_t *length, loff_t *ppos);
> +#endif
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 423554ad3610..ba3366335b40 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1663,6 +1663,17 @@ static struct ctl_table vm_table[] = {
>                 .extra1         = (void *)&mmap_rnd_compat_bits_min,
>                 .extra2         = (void *)&mmap_rnd_compat_bits_max,
>         },
> +#endif
> +#ifdef CONFIG_HARDENED_USERCOPY
> +       {
> +               .procname       = "usercopy_fallback",
> +               .data           = &usercopy_fallback,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0600,
> +               .proc_handler   = usercopy_fallback_handler,
> +               .extra1         = &zero,
> +               .extra2         = &one,
> +       },
>  #endif
>         { }
>  };
> diff --git a/mm/memory.c b/mm/memory.c
> index ec4e15494901..29ed21083a8d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -104,6 +104,11 @@ EXPORT_SYMBOL(mem_map);
>  void *high_memory;
>  EXPORT_SYMBOL(high_memory);
>
> +#ifdef CONFIG_HARDENED_USERCOPY
> +/* Permit non-whitelisted usercopy targets */
> +bool usercopy_fallback = IS_ENABLED(CONFIG_HARDENED_USERCOPY_FALLBACK);
> +#endif
> +
>  /*
>   * Randomize the address space (stacks, mmaps, brk, etc.).
>   *
> @@ -4668,3 +4673,15 @@ void ptlock_free(struct page *page)
>         kmem_cache_free(page_ptl_cachep, page->ptl);
>  }
>  #endif
> +
> +#ifdef CONFIG_HARDENED_USERCOPY
> +int usercopy_fallback_handler(struct ctl_table *table, int write,
> +                           void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +       /* Don't allow re-enabling fallback if it's been disabled */
> +       if (write && !usercopy_fallback)
> +               return -EINVAL;
> +
> +       return proc_dointvec_minmax(table, write, buffer, length, ppos);
> +}
> +#endif
> diff --git a/mm/slab.c b/mm/slab.c
> index 23c53dc46cd6..6afcac1d8b97 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4435,21 +4435,19 @@ const char *__check_heap_object(const void *ptr, unsigned long n,
>         if (offset < cachep->useroffset ||
>             offset - cachep->useroffset > cachep->usersize ||
>             n > cachep->useroffset - offset + cachep->usersize) {
> -#ifdef CONFIG_HARDENED_USERCOPY_FALLBACK
>                 /*
>                  * If no whitelist exists, and FALLBACK is set, produce
>                  * a warning instead of rejecting the copy. This is intended
>                  * to be a temporary method to find any missing usercopy
>                  * whitelists.
>                  */
> -               if (cachep->usersize == 0 &&
> +               if (usercopy_fallback && cachep->usersize == 0 &&
>                     offset <= cachep->object_size &&
>                     n <= cachep->object_size - offset) {
>                         WARN_ONCE(1, "unexpected usercopy without slab whitelist from %s offset %lu size %lu",
>                                   cachep->name, offset, n);
>                         return NULL;
>                 }
> -#endif
>                 return cachep->name;
>         }
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 82e7f15162a8..e664c6e715e6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3867,7 +3867,6 @@ const char *__check_heap_object(const void *ptr, unsigned long n,
>         if (offset < s->useroffset ||
>             offset - s->useroffset > s->usersize ||
>             n > s->useroffset - offset + s->usersize) {
> -#ifdef CONFIG_HARDENED_USERCOPY_FALLBACK
>                 size_t object_size;
>
>                 object_size = slab_ksize(s);
> @@ -3878,13 +3877,12 @@ const char *__check_heap_object(const void *ptr, unsigned long n,
>                  * to be a temporary method to find any missing usercopy
>                  * whitelists.
>                  */
> -               if (s->usersize == 0 &&
> +               if (usercopy_fallback && s->usersize == 0 &&
>                     (offset <= object_size && n <= object_size - offset)) {
>                         WARN_ONCE(1, "unexpected usercopy without slab whitelist from %s offset %lu size %lu",
>                                   s->name, offset, n);
>                         return NULL;
>                 }
> -#endif
>                 return s->name;
>         }
>
> --
> 2.15.0.448.gf294e3d99a-goog
>



-- 
Kees Cook
Pixel Security
