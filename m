MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486055094-4532-3-git-send-email-djalal@gmail.com>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com> <1486055094-4532-3-git-send-email-djalal@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Feb 2017 16:33:11 -0800
Message-ID: <CAGXu5jLW16bBhwPvqk=2vMetncvhC1sJqUrj+QTM2uSaNGzpHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC/PATCH 2/3] security: Add the Timgad module
To: Djalal Harouni <tixxdz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 2, 2017 at 9:04 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> From: Djalal Harouni <tixxdz@gmail.com>
>
> This adds the Timgad module. Timgad allows to apply restrictions on
> which task is allowed to load or unload kernel modules. Auto-load module
> feature is also handled. The settings can also be applied globally using
> a sysctl interface, this allows to complete the core kernel interface
> "modules_disable" which has only two modes: allow globally or deny
> globally.

To bikeshed on the name: since this is a module loading restriction
LSM, perhaps something more descriptive: ModAutoRestrict or something
like that? (Yes, Yama is poorly named, but initially it was going to
be more than just ptrace restrictions...)

> The feature is useful for sandboxing, embedded systems and Linux
> containers where only some containers/processes that have the
> right privileges are allowed to load/unload modules. Unprivileged

I'd be explicit here and discuss _auto_loading of modules. (Otherwise
people quickly get confused about this vs CAP_SYS_MODULE.) You mention
auto-load later, but I think mentioning it first make this easier to
understand.

> processes should not be able to load/unload modules nor trigger the
> module auto-load feature. This behaviour was inspired from grsecurity's
> GRKERNSEC_MODHARDEN option.
>
> However I still did not complete the check since this has to be
> discussed first, so any bug here is not from grsecurity, but my bugs and
> on purpose. As this is a preliminary RFC these points are not settled,
> discussion has to happen on what should be the best behaviour and what
> checks should be in place. Currently the settings:
>
> Timgad module can be controled using a global sysctl setting:

typo: controlled

>    /proc/sys/kernel/timgad/module_restrict

If this becomes /proc/sys/kernel/mod_autoload_restrict/ then the flag
can just be "enabled". (e.g. see LoadPin LSM.)

> Or using the prctl() interface:
>    prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)
>
> *) The per-process prctl() settings are:
>     prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)

Excellent, yes, please require the trailing zeros. :)

>     Where value means:
>
> 0 - Classic module load and unload permissions, nothing changes.

"Classic module auto-load permissions ..." Nothing can auto-unload as-is.

> 1 - The current process must have CAP_SYS_MODULE to be able to load and
>     unload modules. CAP_NET_ADMIN should allow the current process to
>     load and unload only netdev aliased modules, not implemented

"... to be able to auto-load modules." Same thing about unloading:
everything needs CAP_SYS_MODULE to unload a module.

> 2 - Current process can not loaded nor unloaded modules.

"... cannot auto-load modules."

>
> *) sysctl interface supports the followin values:
>
> 0 - Classic module load and unload permissions, nothing changes.
>
> 1 - Only privileged processes with CAP_SYS_MODULE should be able to load and
>     unload modules.
>
>     To be added: processes with CAP_NET_ADMIN should be able to
>     load and unload only netdev aliased modules, this is currently not
>     supported. Other checks for real root without CAP_SYS_MODULE ? ...
>
>     (This should be improved)
>
> 2 - Modules can not be loaded nor unloaded. Once set, this sysctl value
>     cannot be changed.
>
> Rules:
> First the prctl() settings are checked, if the access is not denied
> then the global sysctl settings are checked.
>
> As said I will update the permission checks later, this is a preliminary
> RFC.
>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  include/linux/lsm_hooks.h     |   5 +
>  include/uapi/linux/prctl.h    |   5 +
>  security/Kconfig              |   1 +
>  security/Makefile             |   2 +
>  security/security.c           |   1 +
>  security/timgad/Kconfig       |  10 ++
>  security/timgad/Makefile      |   3 +
>  security/timgad/timgad_core.c | 306 +++++++++++++++++++++++++++++++++++++++
>  security/timgad/timgad_core.h |  53 +++++++
>  security/timgad/timgad_lsm.c  | 327 ++++++++++++++++++++++++++++++++++++++++++
>  10 files changed, 713 insertions(+)
>  create mode 100644 security/timgad/Kconfig
>  create mode 100644 security/timgad/Makefile
>  create mode 100644 security/timgad/timgad_core.c
>  create mode 100644 security/timgad/timgad_core.h
>  create mode 100644 security/timgad/timgad_lsm.c
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index b37e35e..6b83aaa 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1935,5 +1935,10 @@ void __init loadpin_add_hooks(void);
>  #else
>  static inline void loadpin_add_hooks(void) { };
>  #endif
> +#ifdef CONFIG_SECURITY_TIMGAD
> +extern void __init timgad_add_hooks(void);
> +#else
> +static inline void __init timgad_add_hooks(void) { }
> +#endif
>
>  #endif /* ! __LINUX_LSM_HOOKS_H */
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..6d80eed 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,9 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER          3
>  # define PR_CAP_AMBIENT_CLEAR_ALL      4
>
> +/* Control Timgad LSM options */
> +#define PR_TIMGAD_OPTS                 48
> +# define PR_TIMGAD_SET_MOD_RESTRICT    1
> +# define PR_TIMGAD_GET_MOD_RESTRICT    2
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..e6d6128 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -164,6 +164,7 @@ source security/tomoyo/Kconfig
>  source security/apparmor/Kconfig
>  source security/loadpin/Kconfig
>  source security/yama/Kconfig
> +source security/timgad/Kconfig
>
>  source security/integrity/Kconfig
>
> diff --git a/security/Makefile b/security/Makefile
> index f2d71cd..6a8127e 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -9,6 +9,7 @@ subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
>  subdir-$(CONFIG_SECURITY_APPARMOR)     += apparmor
>  subdir-$(CONFIG_SECURITY_YAMA)         += yama
>  subdir-$(CONFIG_SECURITY_LOADPIN)      += loadpin
> +subdir-$(CONFIG_SECURITY_TIMGAD)       += timgad
>
>  # always enable default capabilities
>  obj-y                                  += commoncap.o
> @@ -25,6 +26,7 @@ obj-$(CONFIG_SECURITY_APPARMOR)               += apparmor/
>  obj-$(CONFIG_SECURITY_YAMA)            += yama/
>  obj-$(CONFIG_SECURITY_LOADPIN)         += loadpin/
>  obj-$(CONFIG_CGROUP_DEVICE)            += device_cgroup.o
> +obj-$(CONFIG_SECURITY_TIMGAD)          += timgad/
>
>  # Object integrity file lists
>  subdir-$(CONFIG_INTEGRITY)             += integrity
> diff --git a/security/security.c b/security/security.c
> index 5c699c8..c6c9349 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -61,6 +61,7 @@ int __init security_init(void)
>         capability_add_hooks();
>         yama_add_hooks();
>         loadpin_add_hooks();
> +       timgad_add_hooks();
>
>         /*
>          * Load all the remaining security modules.
> diff --git a/security/timgad/Kconfig b/security/timgad/Kconfig
> new file mode 100644
> index 0000000..93ecdb6
> --- /dev/null
> +++ b/security/timgad/Kconfig
> @@ -0,0 +1,10 @@
> +config SECURITY_TIMGAD
> +       bool "TIMGAD support"
> +       depends on SECURITY
> +       default n
> +       help
> +         This selects TIMGAD, which applies restrictions on load and unload
> +          modules operations. Further information can be found in
> +          Documentation/security/Timgad.txt.

I'd select a capitalization and stick with it (timgad, Timgad,
TIMGAD?) modulo its renaming, etc.

> +
> +         If you are unsure how to answer this question, answer N.
> diff --git a/security/timgad/Makefile b/security/timgad/Makefile
> new file mode 100644
> index 0000000..dca0441
> --- /dev/null
> +++ b/security/timgad/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_SECURITY_TIMGAD) := timgad.o
> +
> +timgad-y := timgad_core.o timgad_lsm.o
> diff --git a/security/timgad/timgad_core.c b/security/timgad/timgad_core.c
> new file mode 100644
> index 0000000..fa35965
> --- /dev/null
> +++ b/security/timgad/timgad_core.c
> [...]

In the hopes of reusing the task stacking stuff from Casey, I'm going
to skip reading the above code at least for now. ;)

> diff --git a/security/timgad/timgad_core.h b/security/timgad/timgad_core.h
> new file mode 100644
> index 0000000..4096c39
> --- /dev/null
> +++ b/security/timgad/timgad_core.h
> @@ -0,0 +1,53 @@
> +/*
> + * Timgad Linux Security Module
> + *
> + * Author: Djalal Harouni
> + *
> + * Copyright (c) 2017 Djalal Harouni
> + * Copyright (c) 2017 Endocode AG
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#define TIMGAD_MODULE_OFF      0x00000000
> +#define TIMGAD_MODULE_STRICT   0x00000001
> +#define TIMGAD_MODULE_NO_LOAD  0x00000002
> +
> +struct timgad_task;
> +
> +static inline int timgad_op_to_flag(unsigned long op,
> +                                   unsigned long value,
> +                                   unsigned long *flag)
> +{
> +       if (op != PR_TIMGAD_SET_MOD_RESTRICT || value > TIMGAD_MODULE_NO_LOAD)
> +               return -EINVAL;
> +
> +       *flag = value;
> +       return 0;
> +}
> +
> +unsigned long read_timgad_task_flags(struct timgad_task *timgad_tsk);
> +
> +int timgad_task_set_op_flag(struct timgad_task *timgad_tsk,
> +                           unsigned long op, unsigned long flag,
> +                           unsigned long value);
> +
> +int is_timgad_task_op_set(struct timgad_task *timgad_tsk, unsigned long op,
> +                         unsigned long *flag);
> +
> +struct timgad_task *get_timgad_task(struct task_struct *tsk);
> +void put_timgad_task(struct timgad_task *timgad_tsk, bool *collect);
> +struct timgad_task *lookup_timgad_task(struct task_struct *tsk);
> +
> +void release_timgad_task(struct task_struct *tsk);
> +
> +struct timgad_task *init_timgad_task(struct task_struct *tsk,
> +                                    unsigned long flag);
> +struct timgad_task *give_me_timgad_task(struct task_struct *tsk,
> +                                       unsigned long value);
> +
> +int timgad_tasks_init(void);
> +void timgad_tasks_clean(void);
> diff --git a/security/timgad/timgad_lsm.c b/security/timgad/timgad_lsm.c
> new file mode 100644
> index 0000000..809b7cf
> --- /dev/null
> +++ b/security/timgad/timgad_lsm.c
> @@ -0,0 +1,327 @@
> +/*
> + * Timgad Linux Security Module
> + *
> + * Author: Djalal Harouni
> + *
> + * Copyright (C) 2017 Djalal Harouni
> + * Copyright (C) 2017 Endocode AG.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/lsm_hooks.h>
> +#include <linux/sysctl.h>
> +#include <linux/prctl.h>
> +#include <linux/types.h>
> +
> +#include "timgad_core.h"
> +
> +static int module_restrict;
> +
> +static int zero;
> +static int max_module_restrict_scope = TIMGAD_MODULE_NO_LOAD;
> +
> +/* TODO:
> + *  complete permission check
> + *  inline function logic with the per-process if possible
> + */
> +static int timgad_has_global_sysctl_perm(unsigned long op)
> +{
> +       int ret = -EINVAL;
> +       struct mm_struct *mm = NULL;
> +
> +       if (op != PR_TIMGAD_GET_MOD_RESTRICT)
> +               return ret;
> +
> +       switch (module_restrict) {
> +       case TIMGAD_MODULE_OFF:
> +               ret = 0;
> +               break;
> +       /* TODO: complete this and handle it later per task too */
> +       case TIMGAD_MODULE_STRICT:
> +               /*
> +                * Are we allowed to sleep here ?
> +                * Also improve this check here
> +                */
> +               ret = -EPERM;
> +               mm = get_task_mm(current);
> +               if (mm) {
> +                       if (capable(CAP_SYS_MODULE))
> +                               ret = 0;
> +                       mmput(mm);
> +               }

Why the mm check here?

> +               break;
> +       case TIMGAD_MODULE_NO_LOAD:
> +               ret = -EPERM;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +/* TODO: simplify me and move me to timgad_core.c file */
> +static int module_timgad_task_perm(struct timgad_task *timgad_tsk,
> +                                  char *kmod_name)
> +{
> +       int ret;
> +       unsigned long flag = 0;
> +
> +       ret = is_timgad_task_op_set(timgad_tsk,
> +                                   PR_TIMGAD_SET_MOD_RESTRICT, &flag);
> +       if (ret < 0)
> +               return ret;
> +
> +       /*
> +        * TODO: complete me
> +        *    * Allow net modules only with CAP_NET_ADMIN and other cases...
> +        *    * Other exotic cases when set to STRICT should be denied...
> +        *    * Inline logic
> +        */
> +       switch (flag) {
> +       case TIMGAD_MODULE_OFF:
> +               ret = 0;
> +               break;
> +       case TIMGAD_MODULE_STRICT:
> +               if (!capable(CAP_SYS_MODULE))
> +                       ret = -EPERM;
> +               else
> +                       ret = 0;
> +               break;
> +       case TIMGAD_MODULE_NO_LOAD:
> +               ret = -EPERM;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +/* Set the given option in a timgad task */
> +static int timgad_set_op_value(struct task_struct *tsk,
> +                              unsigned long op, unsigned long value)
> +{
> +       int ret = 0;
> +       struct timgad_task *ttask;
> +       unsigned long flag = 0;
> +
> +       ret = timgad_op_to_flag(op, value, &flag);
> +       if (ret < 0)
> +               return ret;
> +
> +       ttask = get_timgad_task(tsk);
> +       if (!ttask) {
> +               ttask = give_me_timgad_task(tsk, value);
> +               if (IS_ERR(ttask))
> +                       return PTR_ERR(ttask);
> +
> +               return 0;
> +       }
> +
> +       ret = timgad_task_set_op_flag(ttask, op, flag, value);
> +
> +       put_timgad_task(ttask, NULL);
> +       return ret;
> +}
> +
> +/* Get the given option from a timgad task */
> +static int timgad_get_op_value(struct task_struct *tsk, unsigned long op)
> +{
> +       int ret = -EINVAL;
> +       struct timgad_task *ttask;
> +       unsigned long flag = 0;
> +
> +       ttask = get_timgad_task(tsk);
> +       if (!ttask)
> +               return ret;
> +
> +       ret = is_timgad_task_op_set(ttask, op, &flag);
> +       put_timgad_task(ttask, NULL);
> +
> +       return ret < 0 ? ret : flag;
> +}
> +
> +/* Copy Timgad context from parent to child */
> +int timgad_task_copy(struct task_struct *tsk)
> +{
> +       int ret = 0;
> +       struct timgad_task *tparent;
> +       struct timgad_task *ttask;
> +       unsigned long value = 0;
> +
> +       tparent = get_timgad_task(current);
> +
> +       /* Parent does not have a timgad context, nothing to do */
> +       if (tparent == NULL)
> +               return 0;
> +
> +       value = read_timgad_task_flags(tparent);
> +
> +       ttask = give_me_timgad_task(tsk, value);
> +       if (IS_ERR(ttask))
> +               ret = PTR_ERR(ttask);
> +       else
> +               ret = 0;
> +
> +       put_timgad_task(tparent, NULL);
> +       return ret;
> +}
> +
> +/*
> + * Return 0 on success, -error on error.  -EINVAL is returned when Timgad
> + * does not handle the given option.
> + */
> +int timgad_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> +                     unsigned long arg4, unsigned long arg5)
> +{
> +       int ret = -EINVAL;
> +       struct task_struct *myself = current;
> +
> +       if (option != PR_TIMGAD_OPTS)
> +               return 0;
> +

Actually enforce that arg4 and arg5 == 0 here, and -EINVAL if they
don't. This will let you expand in the future if you need to.

> +       get_task_struct(myself);
> +
> +       switch (arg2) {
> +       case PR_TIMGAD_SET_MOD_RESTRICT:
> +               ret = timgad_set_op_value(myself,
> +                                         PR_TIMGAD_SET_MOD_RESTRICT,
> +                                         arg3);
> +               break;
> +       case PR_TIMGAD_GET_MOD_RESTRICT:
> +               ret = timgad_get_op_value(myself,
> +                                         PR_TIMGAD_SET_MOD_RESTRICT);
> +               break;
> +       }
> +
> +       put_task_struct(myself);
> +       return ret;
> +}
> +
> +/*
> + * Free the specific task attached resources
> + * task_free() can be called from interrupt context
> + */
> +void timgad_task_free(struct task_struct *tsk)
> +{
> +       release_timgad_task(tsk);
> +}
> +
> +static int timgad_kernel_module_file(struct file *file)
> +{
> +       int ret = 0;
> +       struct timgad_task *ttask;
> +       struct task_struct *myself = current;
> +
> +       /* First check if the task allows that */
> +       ttask = get_timgad_task(myself);
> +       if (ttask != NULL) {
> +               ret = module_timgad_task_perm(ttask, NULL);
> +               put_timgad_task(ttask, NULL);
> +       }
> +
> +       if (ret < 0)
> +               return ret;
> +
> +       return timgad_has_global_sysctl_perm(PR_TIMGAD_GET_MOD_RESTRICT);
> +}

This is the kernel_module_file hook, which is an explicit load of a
module by the current process. Is your intention to block
CAP_SYS_MODULE-capable processes from direct kernel module loading? If
so, I misunderstood part of the design here. I'd explicitly call it
out in the commit text, since direct loading and auto loading are
quite different, though I'd argue that you don't want to touch direct
loading privileges because that's already entirely covered by
CAP_SYS_MODULE....

> +static int timgad_kernel_module_request(char *kmod_name)
> +{
> +       int ret = 0;
> +       struct timgad_task *ttask;
> +       struct task_struct *myself = current;
> +
> +       /* First check if the task allows that */
> +       ttask = get_timgad_task(myself);
> +       if (ttask != NULL) {
> +               ret = module_timgad_task_perm(ttask, kmod_name);
> +               put_timgad_task(ttask, NULL);
> +       }
> +
> +       if (ret < 0)
> +               return ret;
> +
> +       return timgad_has_global_sysctl_perm(PR_TIMGAD_GET_MOD_RESTRICT);
> +}

This is the heart of the auto-loading check...

> +static int timgad_kernel_read_file(struct file *file,
> +                                  enum kernel_read_file_id id)
> +{
> +       int ret = 0;
> +
> +       switch (id) {
> +       case READING_MODULE:
> +               ret = timgad_kernel_module_file(file);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static struct security_hook_list timgad_hooks[] = {
> +       LSM_HOOK_INIT(kernel_module_request, timgad_kernel_module_request),
> +       LSM_HOOK_INIT(kernel_read_file, timgad_kernel_read_file),
> +       LSM_HOOK_INIT(task_copy, timgad_task_copy),
> +       LSM_HOOK_INIT(task_prctl, timgad_task_prctl),
> +       LSM_HOOK_INIT(task_free, timgad_task_free),
> +};
> +
> +#ifdef CONFIG_SYSCTL
> +static int timgad_mod_dointvec_minmax(struct ctl_table *table, int write,
> +                                     void __user *buffer, size_t *lenp,
> +                                     loff_t *ppos)
> +{
> +       struct ctl_table table_copy;
> +
> +       if (write && !capable(CAP_SYS_MODULE))
> +               return -EPERM;
> +
> +       table_copy = *table;
> +       if (*(int *)table_copy.data == *(int *)table_copy.extra2)
> +               table_copy.extra1 = table_copy.extra2;

Are you intentionally pinning to the highest setting (like Yama)? This
isn't mentioned in the commit message, and it doesn't seem like
something that matters here?

> +
> +       return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
> +}
> +
> +struct ctl_path timgad_sysctl_path[] = {
> +       { .procname = "kernel", },
> +       { .procname = "timgad", },
> +       { }
> +};
> +
> +static struct ctl_table timgad_sysctl_table[] = {
> +       {
> +               .procname       = "module_restrict",
> +               .data           = &module_restrict,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = timgad_mod_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &max_module_restrict_scope,
> +       },
> +       { }
> +};
> +
> +static void __init timgad_init_sysctl(void)
> +{
> +       if (!register_sysctl_paths(timgad_sysctl_path, timgad_sysctl_table))
> +               panic("Timgad: sysctl registration failed.\n");
> +}
> +#else
> +static inline void timgad_init_sysctl(void) { }
> +#endif /* CONFIG_SYSCTL */
> +
> +void __init timgad_add_hooks(void)
> +{
> +       pr_info("Timgad: becoming mindful.\n");

That's Yama's catch-phrase. ;) Your LSM should say something else. :)

> +       security_add_hooks(timgad_hooks, ARRAY_SIZE(timgad_hooks));
> +       timgad_init_sysctl();
> +
> +       if (timgad_tasks_init())
> +               panic("Timgad: tasks initialization failed.\n");
> +}
> --
> 2.5.5
>

Sorry for the delay in review! It's been a busy week. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
