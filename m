References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
Date: Thu, 8 Jun 2017 23:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/08/2017 10:38 PM, Kees Cook wrote:
> On Wed, Jun 7, 2017 at 8:43 PM, Matt Brown <matt@nmatt.com> wrote:
>> This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
>> feature. It also adds features and config options that were found in Corey
>> Henderson's tpe-lkm project.
>>
>> Modifications from Brad Spengler's implementation of TPE were made to
>> turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
>> Also, a new denial logging function was used to simplify printing messages
>> to the kernel log. Additionally, mmap and mprotect restrictions were
>> taken from Corey Henderson's tpe-lkm project and implemented using the
>> LSM hooks mmap_file and file_mprotect.
>>
>> Trusted Path Execution is not a new idea:
>>
>> http://phrack.org/issues/52/6.html#article
>>
>> | A trusted path is one that is inside a root owned directory that
>> | is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
>> | (under normal circumstances) considered trusted.  Any non-root
>> | users home directory is not trusted, nor is /tmp.
>>
>> To be clear, Trusted Path Execution is no replacement for a MAC system
>> like SELinux, SMACK, or AppArmor. This LSM is designed to be good enough
>> without requiring a userland utility to configure policies. The fact
>> that TPE only requires the user to turn on a few sysctl options lowers
>> the barrier to implementing a security framework substantially.
>>
>> Threat Models:
>>
>> 1. Attacker on system executing exploit on system vulnerability
>>
>> *  If attacker uses a binary as a part of their system exploit, TPE can
>>    frustrate their efforts
>>
>> *  This protection can be more effective when an attacker does not yet
>>    have an interactive shell on a system
>>
>> *  Issues:
>>    *  Can be bypassed by interpreted languages such as python. You can run
>>       malicious code by doing: python -c 'evil code'
>
> What's the recommendation for people interested in using TPE but
> having interpreters installed?
>

If you don't need a given interpreter installed, uninstall it. While
this is common sense system hardening it especially would make a
difference under the TPE threat model.

I don't have a knock down answer for this. Interpreters are a hard
problem for TPE.

>>
>> 2. Attacker on system replaces binary used by a privileged user with a
>>    malicious one
>>
>> *  This situation arises when the administrator of a system leaves a
>>    binary as world writable.
>>
>> *  TPE is very effective against this threat model
>>
>> This Trusted Path Execution implementation introduces the following
>> Kconfig options and sysctls. The Kconfig text and sysctl options are
>> taken heavily from Brad Spengler's implementation. Some extra sysctl
>> options were taken from Corey Henderson's implementation.
>>
>> CONFIG_SECURITY_TPE (sysctl=kernel.tpe.enabled)
>>
>> default: n
>>
>> This option enables Trusted Path Execution. TPE blocks *untrusted*
>> users from executing files that meet the following conditions:
>>
>> * file is not in a root-owned directory
>> * file is writable by a user other than root
>>
>> NOTE: By default root is not restricted by TPE.
>>
>> CONFIG_SECURITY_TPE_GID (sysctl=kernel.tpe.gid)
>>
>> default: 0
>>
>> This option defines a group id that, by default, is the trusted group.
>> If a user is not trusted then it has the checks described in
>> CONFIG_SECURITY_TPE applied. Otherwise, the user is trusted and the
>> checks are not applied. You can disable the trusted gid option by
>> setting it to 0. This makes all non-root users untrusted.
>>
>> CONFIG_SECURITY_TPE_STRICT (sysctl=kernel.tpe.strict)
>>
>> default: n
>>
>> This option applies another set of restrictions to all non-root users
>> even if they are trusted. This only allows execution under the
>> following conditions:
>>
>> * file is in a directory owned by the user that is not group or
>>   world-writable
>> * file is in a directory owned by root and writable only by root
>>
>> CONFIG_SECURITY_TPE_RESTRICT_ROOT (sysctl=kernel.tpe.restrict_root)
>>
>> default: n
>>
>> This option applies all enabled TPE restrictions to root.
>>
>> CONFIG_SECURITY_TPE_INVERT_GID (sysctl=kernel.tpe.invert_gid)
>>
>> default: n
>>
>> This option reverses the trust logic of the gid option and makes
>> kernel.tpe.gid into the untrusted group. This means that all other groups
>> become trusted. This sysctl is helpful when you want TPE restrictions
>> to be limited to a small subset of users.
>>
>> Signed-off-by: Matt Brown <matt@nmatt.com>
>> ---
>>  Documentation/security/tpe.txt |  59 +++++++++++
>>  MAINTAINERS                    |   5 +
>>  include/linux/lsm_hooks.h      |   5 +
>>  security/Kconfig               |   1 +
>>  security/Makefile              |   2 +
>>  security/security.c            |   1 +
>>  security/tpe/Kconfig           |  64 ++++++++++++
>>  security/tpe/Makefile          |   3 +
>>  security/tpe/tpe_lsm.c         | 218 +++++++++++++++++++++++++++++++++++++++++
>>  9 files changed, 358 insertions(+)
>>  create mode 100644 Documentation/security/tpe.txt
>>  create mode 100644 security/tpe/Kconfig
>>  create mode 100644 security/tpe/Makefile
>>  create mode 100644 security/tpe/tpe_lsm.c
>>
>> diff --git a/Documentation/security/tpe.txt b/Documentation/security/tpe.txt
>> new file mode 100644
>> index 0000000..226afcc
>> --- /dev/null
>> +++ b/Documentation/security/tpe.txt
>> @@ -0,0 +1,59 @@
>> [...]
>
> Yes, docs! I love it. :) One suggestion, though, all of the per-LSM
> docs were moved in -next from .txt to .rst files, and had index
> entries added, etc:
> https://patchwork.kernel.org/patch/9725165/
>
> Namely, move to Documentation/admin-guide/LSM/, add an entry to
> index.rst and format it using ReST:
> https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html#writing-documentation
>

Will do :)

>> diff --git a/security/tpe/Kconfig b/security/tpe/Kconfig
>> new file mode 100644
>> index 0000000..a1b8f17
>> --- /dev/null
>> +++ b/security/tpe/Kconfig
>> @@ -0,0 +1,64 @@
>> +config SECURITY_TPE
>> +       bool "Trusted Path Execution (TPE)"
>> +       default n
>> +       help
>> +         If you say Y here, you will be able to choose a gid to add to the
>> +         supplementary groups of users you want to mark as "trusted."
>> +         Untrusted users will not be able to execute any files that are not in
>> +         root-owned directories writable only by root.  If the sysctl option
>> +         is enabled, a sysctl option with name "tpe.enabled" is created.
>> +
>> +config SECURITY_TPE_GID
>> +       int
>> +       default SECURITY_TPE_TRUSTED_GID if (SECURITY_TPE && !SECURITY_TPE_INVERT_GID)
>> +       default SECURITY_TPE_UNTRUSTED_GID if (SECURITY_TPE && SECURITY_TPE_INVERT_GID)
>
> I think this should have "depends on SECURITY_TPE" (like all the others).
>
>> [...]
>> diff --git a/security/tpe/tpe_lsm.c b/security/tpe/tpe_lsm.c
>> new file mode 100644
>> index 0000000..fda811a
>> --- /dev/null
>> +++ b/security/tpe/tpe_lsm.c
>> @@ -0,0 +1,218 @@
>> +/*
>> + * Trusted Path Execution Security Module
>> + *
>> + * Copyright (C) 2017 Matt Brown
>> + * Copyright (C) 2001-2014 Bradley Spengler, Open Source Security, Inc.
>> + * http://www.grsecurity.net spender@grsecurity.net
>> + * Copyright (C) 2011 Corey Henderson
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version 2
>> + * as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/uidgid.h>
>> +#include <linux/ratelimit.h>
>> +#include <linux/limits.h>
>> +#include <linux/cred.h>
>> +#include <linux/slab.h>
>> +#include <linux/lsm_hooks.h>
>> +#include <linux/sysctl.h>
>> +#include <linux/binfmts.h>
>> +#include <linux/string_helpers.h>
>> +#include <linux/dcache.h>
>> +#include <uapi/asm-generic/mman-common.h>
>> +
>> +#define global_root(x) uid_eq((x), GLOBAL_ROOT_UID)
>> +#define global_nonroot(x) (!uid_eq((x), GLOBAL_ROOT_UID))
>> +#define global_root_gid(x) (gid_eq((x), GLOBAL_ROOT_GID))
>> +#define global_nonroot_gid(x) (!gid_eq((x), GLOBAL_ROOT_GID))
>> +
>> +static int tpe_enabled __read_mostly = IS_ENABLED(CONFIG_SECURITY_TPE);
>> +static kgid_t tpe_gid __read_mostly = KGIDT_INIT(CONFIG_SECURITY_TPE_GID);
>> +static int tpe_invert_gid __read_mostly =
>> +       IS_ENABLED(CONFIG_SECURITY_TPE_INVERT_GID);
>> +static int tpe_strict __read_mostly = IS_ENABLED(CONFIG_SECURITY_TPE_STRICT);
>> +static int tpe_restrict_root __read_mostly =
>> +       IS_ENABLED(CONFIG_SECURITY_TPE_RESTRICT_ROOT);
>> +
>> +int print_tpe_error(struct file *file, char *reason1, char *reason2,
>> +       char *method)
>
> I think these char * can all be const char *.
>
>> +{
>> +       char *filepath;
>> +
>> +       filepath = kstrdup_quotable_file(file, GFP_KERNEL);
>> +
>> +       if (!filepath)
>> +               return -ENOMEM;
>> +
>> +       pr_warn_ratelimited("TPE: Denied %s of %s Reason: %s%s%s\n", method,
>> +               (IS_ERR(filepath) ? "failed fetching file path" : filepath),
>> +               reason1, reason2 ? " and " : "", reason2 ?: "");
>> +       kfree(filepath);
>> +       return -EPERM;
>> +}
>> +
>> +static int tpe_check(struct file *file, char *method)
>
> This char * can be const char *.
>
>> +{
>> +       struct inode *inode;
>> +       struct inode *file_inode;
>> +       struct dentry *dir;
>> +       const struct cred *cred = current_cred();
>> +       char *reason1 = NULL;
>> +       char *reason2 = NULL;
>
> Perhaps check file argument for NULL here instead of each caller?
>
>> +
>> +       dir = dget_parent(file->f_path.dentry);
>> +       inode = d_backing_inode(dir);
>> +       file_inode = d_backing_inode(file->f_path.dentry);
>> +
>> +       if (!tpe_enabled)
>> +               return 0;
>> +
>> +       /* never restrict root unless restrict_root sysctl is 1*/
>> +       if (global_root(cred->uid) && !tpe_restrict_root)
>> +               return 0;
>> +
>> +       if (!tpe_strict)
>> +               goto general_tpe_check;
>
> This kind of use of goto tells me the code sections need to be
> separate functions. i.e. tpe_check_strict() for the bit below before
> general_tpe_check:
>
>> +
>> +       /* TPE_STRICT: restrictions enforced even if the gid is trusted */
>> +       if (global_nonroot(inode->i_uid) && !uid_eq(inode->i_uid, cred->uid))
>> +               reason1 = "directory not owned by user";
>> +       else if (inode->i_mode & 0002)
>> +               reason1 = "file in world-writable directory";
>> +       else if ((inode->i_mode & 0020) && global_nonroot_gid(inode->i_gid))
>> +               reason1 = "file in group-writable directory";
>> +       else if (file_inode->i_mode & 0002)
>> +               reason1 = "file is world-writable";
>> +
>> +       if (reason1)
>> +               goto end;
>
> struct tpe_rationale {
>     const char *reason1;
>     const char *reason2;
> };
>
> bool tpe_check_strict(...)
> {
>     if (!tpe_strict);
>         return false;
>     ...
>     return rationale->reason1 != NULL;
> }
>
> static int tpe_check(...)
> {
>     ...
>     struct tpe_rationale rationale= { };
>
>     if (tpe_check_strict(inode, cred, &rationale))
>         goto end;
> ...
>
>> +general_tpe_check:
>> +       /* determine if group is trusted */
>> +       if (global_root_gid(tpe_gid))
>> +               goto next_check;
>> +       if (!tpe_invert_gid && !in_group_p(tpe_gid))
>> +               reason2 = "not in trusted group";
>> +       else if (tpe_invert_gid && in_group_p(tpe_gid))
>> +               reason2 = "in untrusted group";
>> +       else
>> +               return 0;
>
> (This return 0 currently leaks the dget that is put at the end label.
> Ah, yes, already pointed out I see now in later reply in thread.)
>
>     if (tpe_check_general(inode, cred, &rationale))
>         goto end;
>
> bool tpe_check_general(...)
> {
>     if (!global_root_gid(tpe_gid)) {
>          rationale->reason1 = NULL;
>          return true;
>     }
>     ...
> }
>
>> +
>> +next_check:
>> +       /* main TPE checks */
>> +       if (global_nonroot(inode->i_uid))
>> +               reason1 = "file in non-root-owned directory";
>> +       else if (inode->i_mode & 0002)
>> +               reason1 = "file in world-writable directory";
>> +       else if ((inode->i_mode & 0020) && global_nonroot_gid(inode->i_gid))
>> +               reason1 = "file in group-writable directory";
>> +       else if (file_inode->i_mode & 0002)
>> +               reason1 = "file is world-writable";
>
>     tpe_check_main(inode, cred, &rationale);
>
>> +
>> +end:
>> +       dput(dir);
>> +       if (reason1)
>> +               return print_tpe_error(file, reason1, reason2, method);
>> +       else
>> +               return 0;
>
> And the end part above stays.
>
>> +}
>> +
>> +int tpe_mmap_file(struct file *file, unsigned long reqprot,
>> +       unsigned long prot, unsigned long flags)
>> +{
>> +       if (!file || !(prot & PROT_EXEC))
>> +               return 0;
>> +
>> +       return tpe_check(file, "mmap");
>> +}
>> +
>> +int tpe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
>> +       unsigned long prot)
>> +{
>> +       if (!vma->vm_file)
>
> No examination of reqprot vs prot here?
>

opps you're right. Would I just need to check (reqprot & PROT_EXEC) or
do I need to check (prot & PROT_EXEC) as well? Would the kernel ever
try to set PROT_EXEC if the application didn't ask for it?

>> +               return 0;
>> +       return tpe_check(vma->vm_file, "mprotect");
>> +}
>> +
>> +static int tpe_bprm_set_creds(struct linux_binprm *bprm)
>> +{
>> +       if (!bprm->file)
>> +               return 0;
>> +       return tpe_check(bprm->file, "exec");
>> +
>> +}
>> +
>> +static struct security_hook_list tpe_hooks[] = {
>> +       LSM_HOOK_INIT(mmap_file, tpe_mmap_file),
>> +       LSM_HOOK_INIT(file_mprotect, tpe_file_mprotect),
>> +       LSM_HOOK_INIT(bprm_set_creds, tpe_bprm_set_creds),
>> +};
>> +
>> +#ifdef CONFIG_SYSCTL
>> +struct ctl_path tpe_sysctl_path[] = {
>> +       { .procname = "kernel", },
>> +       { .procname = "tpe", },
>> +       { }
>> +};
>> +
>> +static struct ctl_table tpe_sysctl_table[] = {
>> +       {
>> +               .procname       = "enabled",
>> +               .data           = &tpe_enabled,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       {
>> +               .procname       = "gid",
>> +               .data           = &tpe_gid,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       {
>> +               .procname       = "invert_gid",
>> +               .data           = &tpe_invert_gid,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       {
>> +               .procname       = "strict",
>> +               .data           = &tpe_strict,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       {
>> +               .procname       = "restrict_root",
>> +               .data           = &tpe_restrict_root,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0600,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       { }
>> +};
>> +static void __init tpe_init_sysctl(void)
>> +{
>> +       if (!register_sysctl_paths(tpe_sysctl_path, tpe_sysctl_table))
>> +               panic("TPE: sysctl registration failed.\n");
>> +}
>> +#else
>> +static inline void tpe_init_sysctl(void) { }
>> +#endif /* CONFIG_SYSCTL */
>> +
>> +void __init tpe_add_hooks(void)
>> +{
>> +       pr_info("TPE: securing systems like it's 1998\n");
>
> :)
>
>> +       security_add_hooks(tpe_hooks, ARRAY_SIZE(tpe_hooks), "tpe");
>> +       tpe_init_sysctl();
>> +}
>> --
>> 2.10.2
>>
>
> -Kees
>

I agree with all the suggested changes above and will have them soon in
v3.

Thanks for the review,
Matt
