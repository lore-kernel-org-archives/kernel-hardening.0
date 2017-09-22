MIME-Version: 1.0
In-Reply-To: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
References: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
From: Jann Horn <jannh@google.com>
Date: Fri, 22 Sep 2017 09:57:35 +0200
Message-ID: <CAG48ez0=chbP9WGyT-2-xmh7fkC4fBecsoFjTpVstvV9=pSSrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [RFC] A method to prevent priviledge escalation
To: =?UTF-8?B?5Lit5p2R6ZuE5LiAIC8gTkFLQU1VUkHvvIxZVVVJQ0hJ?= <yuichi.nakamura.fe@hitachi.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "yamauchi@cs.okayama-u.ac.jp" <yamauchi@cs.okayama-u.ac.jp>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 22, 2017 at 4:49 AM, =E4=B8=AD=E6=9D=91=E9=9B=84=E4=B8=80 / NAK=
AMURA=EF=BC=8CYUUICHI
<yuichi.nakamura.fe@hitachi.com> wrote:
> Hi.
>
> As we said in Linux Security Summit 2017,
> we would like to post a patch to prevent privilege escalation attack.
>
> The concept is here:
> http://events.linuxfoundation.org/sites/events/files/slides/nakamura_2017=
0831_1.pdf

I believe that the basic concept behind this patch is flawed for the
following reasons:

You are only protecting a tiny subset of the pieces of data in the
kernel that can be used to gain heightened privileges. The syscall
return frame of a setuid task, userspace code in the directmap area,
the uid_map in the user namespace, the credentials structure of
another task, the owner and mode of pretty much any inode and so on
are all interesting targets for an overwrite.

And yes, "commit_creds(prepare_kernel_cred(0))" is a nice and easy
trick if the attacker already has arbitrary code execution in ring 0,
but at that point, you've already lost anyway.
Look at the exploit you linked to: At the point where your mitigation
tries to stop the attack, the attacker has already turned off SMAP and
SMEP and has executed arbitrary code in ring 0. Anything you try to do
after that point is completely useless.

> This work is still work in progress and feedback is welcomed.
> Below patch works for linux-4.4.0,
> To see that it works (try it in a safe place!),
>  * build vulnerable kernel on Ubuntu 16.04.1
>    source: https://launchpad.net/ubuntu/+source/linux/4.4.0-62.83
>    please enable "CONFIG_AKO" in kernel config.
>  * try a poc code for kernel vulnerability
>    https://github.com/xairy/kernel-exploits/blob/master/CVE-2017-6074/poc=
.c
>  * look at kernel log, you can see a log that it detected attack like bel=
ow:
>  AKO: detected unauthorized change of UID. syscall=3D45 original: uid=3D1=
000, euid=3D1000, fsuid=3D1000, suid=3D1000 attempt: uid=3D0, euid=3D0, fsu=
id=3D0, suid=3D0
>  AKO: detected unauthorized change of gid. syscall=3D45 original: gid=3D1=
000, egid=3D1000, fsgid=3D1000, sgid=3D1000 attempt: gid=3D0, egid=3D0, fsg=
id=3D0, sgid=3D0

Showing that a mitigation stops an exploit does not demonstrate that
it is a good mitigation. After all, an attacker who is attacking a
system with the mitigation applied would probably write the exploit
differently, designed to bypass the mitigation.


Some comments on details of the patch are inline.


> --- linux-4.4.0-62-83.orig/kernel/ako.c 1970-01-01 09:00:00.000000000 +09=
00
> +++ linux-4.4.0/kernel/ako.c    2017-07-03 23:06:54.068000000 +0900
[...]
> +void AKO_save_creds(struct ako_struct * ako_cred, int ako_sysnum)
> +{
> +
> +        /*Save credential information to be observed */
> +        /*UID and GID*/
> +        ako_cred->ako_uid =3D current->cred->uid.val;
> +        ako_cred->ako_euid =3D current->cred->euid.val;
> +        ako_cred->ako_fsuid =3D current->cred->fsuid.val;
> +        ako_cred->ako_suid =3D current->cred->suid.val;
> +        ako_cred->ako_gid =3D current->cred->gid.val;
> +        ako_cred->ako_egid =3D current->cred->egid.val;
> +        ako_cred->ako_fsgid =3D current->cred->fsgid.val;
> +        ako_cred->ako_sgid =3D current->cred->sgid.val;
> +        /*Capability*/
> +        ako_cred->ako_inheritable[0] =3D current->cred->cap_inheritable.=
cap[0];
> +        ako_cred->ako_inheritable[1] =3D current->cred->cap_inheritable.=
cap[1];
> +        ako_cred->ako_permitted[0] =3D current->cred->cap_permitted.cap[=
0];
> +        ako_cred->ako_permitted[1] =3D current->cred->cap_permitted.cap[=
1];
> +        ako_cred->ako_effective[0] =3D current->cred->cap_effective.cap[=
0];
> +        ako_cred->ako_effective[1] =3D current->cred->cap_effective.cap[=
1];
> +        ako_cred->ako_bset[0] =3D current->cred->cap_bset.cap[0];
> +        ako_cred->ako_bset[1] =3D current->cred->cap_bset.cap[1];
> +
> +        return;
> +}
> +
> +/*copy from sys.c*/
> +static int set_user(struct cred *new)
> +{
> +       struct user_struct *new_user;
> +
> +       new_user =3D alloc_uid(new->uid);
> +       if (!new_user)
> +               return -EAGAIN;
> +
> +       /*
> +        * We don't fail in case of NPROC limit excess here because too m=
any
> +        * poorly written programs don't check set*uid() return code, ass=
uming
> +        * it never fails if called by root.  We may still enforce NPROC =
limit
> +        * for programs doing set*uid()+execve() by harmlessly deferring =
the
> +        * failure to the execve() stage.
> +        */
> +       if (atomic_read(&new_user->processes) >=3D rlimit(RLIMIT_NPROC) &=
&
> +                       new_user !=3D INIT_USER)
> +               current->flags |=3D PF_NPROC_EXCEEDED;
> +       else
> +               current->flags &=3D ~PF_NPROC_EXCEEDED;
> +
> +       free_uid(new->user);
> +       new->user =3D new_user;
> +       return 0;
> +}

Can you describe why exactly you need this here?

> +static int AKO_restore_uids(struct ako_struct * ako_cred)
> +{
> +        struct cred *new;
> +        struct user_namespace *ns =3D current_user_ns();
> +        kuid_t uid;
> +        kuid_t suid;
> +        kuid_t euid;
> +        kuid_t fsuid;
> +       kernel_cap_t effective, permitted;
> +
> +       new =3D prepare_creds();
> +        if (!new)
> +                return -ENOMEM;
> +
> +        uid =3D make_kuid(ns, ako_cred->ako_uid);
> +        if (!uid_valid(uid))
> +                return -EINVAL;
> +        suid =3D make_kuid(ns, ako_cred->ako_suid);
> +        if (!uid_valid(suid))
> +                return -EINVAL;
> +        euid =3D make_kuid(ns, ako_cred->ako_euid);
> +        if (!uid_valid(euid))
> +                return -EINVAL;
> +        fsuid =3D make_kuid(ns, ako_cred->ako_fsuid);
> +        if (!uid_valid(fsuid))
> +                return -EINVAL;
> +        new->uid =3D uid;
> +        new->suid =3D suid;
> +        new->euid =3D euid;
> +        new->fsuid =3D fsuid;

This is wrong. AKO_save_creds copies raw kernel UIDs into ako_cred,
but this code passes
those raw kernel UIDs to make_kuid(), which assumes that the input is
a namespaced UID
as seen in userspace.


> --- linux-4.4.0-62-83.orig/arch/x86/entry/entry_64.S    2017-06-18 14:34:=
04.008000000 +0900
> +++ linux-4.4.0/arch/x86/entry/entry_64.S       2017-07-01 23:07:43.82400=
0000 +0900
> @@ -182,9 +182,43 @@
>  #endif
>         ja      1f                              /* return -ENOSYS (alread=
y in pt_regs->ax) */
>         movq    %r10, %rcx
> +/*
> + * Additional Kernel Observer (AKO)
> + * Copyright (c) 2017 Okayama-University
> + *     Yohei Akao, Yamauchi Laboratory, Okayama University
> + */
> +       subq    $6144,%rsp /*Allocate area in stack to save credential in=
formation*/
> +       ALLOC_PT_GPREGS_ON_STACK
> +       SAVE_C_REGS
> +       SAVE_EXTRA_REGS
> +       leaq    15*8(%rsp), %rdi /* size of SAVE_C_REGS and size of SAVE_=
EXTRA_REGS is added to rsp, and start address of allocated area is saved in=
 %rdi*/
> +       movq    %rax, %rsi /* Syscall number(%rax) is saved in %rsi */
> +       call AKO_before /*credential information is saved*/
> +       RESTORE_EXTRA_REGS
> +       RESTORE_C_REGS
> +       REMOVE_PT_GPREGS_FROM_STACK
> +       addq    $6144,%rsp /*Allocate area in stack to save credential in=
formation*/
> +       /*end of AKO*/
>         call    *sys_call_table(, %rax, 8)
> +/*
> + * Additional Kernel Observer (AKO)
> + * Copyright (c) 2017 Okayama-University
> + *     Yohei Akao, Yamauchi Laboratory, Okayama University
> + */
> +       /*Start of AKO*/
> +       subq    $6144,%rsp

What is going on here? You're allocating a stack area that is then
passed to AKO_after(),
which reads from it?
Are you trying to store information at the bottom of the stack in
AKO_before() and then read it back in AKO_after()?

> +       ALLOC_PT_GPREGS_ON_STACK
> +       SAVE_C_REGS
> +       SAVE_EXTRA_REGS
> +       leaq    15*8(%rsp), %rdi
> +       call AKO_after
> +       RESTORE_EXTRA_REGS
> +       RESTORE_C_REGS
> +       REMOVE_PT_GPREGS_FROM_STACK
> +       /*Free area to store credential infomation*/
> +       addq    $6144,%rsp
> +       /*End of AKO*/
>         movq    %rax, RAX(%rsp)
> -1:
>  /*
>   * Syscall return path ending with SYSRET (fast path).
>   * Has incompletely filled pt_regs.

This is the 64-bit syscall entry fastpath. As far as I can tell, this
is the only place where you're calling AKO_before() and AKO_after().
This fastpath is not used if either compat (32-bit) syscalls are used
or the slowpath has to be used, e.g. because a seccomp filter is
active.
So a simple trick to get past this check is probably to do this before
the main attack:

prctl(PR_SET_NO_NEW_PRIVS, 1);
struct sock_filter filter[] =3D {
  BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)
};
struct sock_fprog prog =3D {
  .len =3D (unsigned short)(sizeof(filter)/sizeof(filter[0])),
  .filter =3D filter
};
seccomp(SECCOMP_SET_MODE_FILTER, &prog, 0);
