Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1465420302-23754-3-git-send-email-keescook@chromium.org>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <1465420302-23754-3-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Jun 2016 14:09:49 -0700
Message-ID: <CAGXu5j+d1nWs=HjMudPx9P=rbE5dSs3on3Gex=UeBcBNB7pEgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/4] usercopy: avoid direct copying to userspace
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 8, 2016 at 2:11 PM, Kees Cook <keescook@chromium.org> wrote:
> Some non-whitelisted heap memory has small areas that need to be copied
> to userspace. For these cases, explicitly copy the needed contents out
> to stack first before sending to userspace. This lets their respective
> caches remain un-whitelisted (i.e. no SLAB_USERCOPY), since the bulk of
> their contents should not be exposed to userspace.

I've spent some time thinking about these kinds of
non-whitelisted-slab-workaround changes, and I would like to see if we
can design a better solution. So, to that end, here's what I see:

- HARDENED_USERCOPY verifies object addresses and sizes
- whitelisted caches (via HARDENED_USERCOPY_WHITELIST's SLAB_USERCOPY)
are intentionally rare
- Some code uses small parts of non-whitelisted cache memory for
userspace work (I think the auxv ("mm_struct") and signal frames
("task_struct") are good examples of this: neither cache should be
entirely exposed to userspace, yet tiny pieces are sent to userspace.)
- non-whitelist-workarounds are open-coded
- non-whitelist-workarounds require a double-copy
- non-whitelist-workarounds have explicit size maximums (e.g.
AT_VECTOR_SIZE, sizeof(sigset_t))
- non-whitelist-workarounds _bypass_ HARDENED_USERCOPY object address checking

So, while the workarounds do have a max-size sanity-check, they
actually lack the object address checking that would normally happen
with the usercopy checks. I think to solve the open-coding and
double-copy problems without compromising on the whitelisting or the
explicit size checking, we could also gain back the address checking
if we created something like:

copy_to_user_n(user, kernel, dynamic-size, const-max-size);

If "const-max-size" isn't detected as a builtin_constant it could fail
to build. When run, it would a) verify dynamic-size wasn't larger that
const-max-size, and b) perform the regular usercopy checks (without
the SLAB_USERCOPY check).

So, for the auxv example, instead of the new stack variable, the
memcpy, etc, it could just be a one-line change replacing the existing
copy_to_user() call:

copy_to_user_n(sp, elf_info, ei_index * sizeof(elf_addr_t), AT_VECTOR_SIZE);

(Bike-shedding: copy_to_user_bounded(), ..._limited(), ..._whitelist_hole(), ?)

What do people think?

>
> These changes, based on code by Brad Spengler and PaX Team, were extracted
> from grsecurity/PaX on a case-by-case basis as I ran into errors during
> testing of CONFIG_HARDENED_USERCOPY_WHITELIST:
>
> Changed exec to use copy of auxv instead of copying from "mm_struct" cache.
>
> Changed signal handling to use an on-stack copy of signal frames instead
> of direct copying from "task_struct" cache.
>
> Changed name_to_handle to use put_user (which operates on fixed sizes)
> instead of copy_to_user from "mnt_cache" cache.
>
> Changed readlink to use stack for in-struct names to avoid copying from
> filesystem cache (e.g. "ext4_inode_cache")
>
> Changed sg ioctl to bounce commands through stack instead of directly
> copying to/from "blkdev_requests" cache.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/kernel/signal.c |  6 +++---
>  block/scsi_ioctl.c       | 27 +++++++++++++++++++++++++--
>  fs/binfmt_elf.c          |  8 +++++++-
>  fs/fhandle.c             |  3 +--
>  fs/namei.c               | 11 ++++++++++-
>  5 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 22cc2f9f8aec..479fb2b9afcd 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -680,8 +680,8 @@ static int
>  setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
>  {
>         int usig = ksig->sig;
> -       sigset_t *set = sigmask_to_save();
> -       compat_sigset_t *cset = (compat_sigset_t *) set;
> +       sigset_t sigcopy = *sigmask_to_save();
> +       compat_sigset_t *cset = (compat_sigset_t *)&sigcopy;
>
>         /* Set up the stack frame */
>         if (is_ia32_frame()) {
> @@ -692,7 +692,7 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
>         } else if (is_x32_frame()) {
>                 return x32_setup_rt_frame(ksig, cset, regs);
>         } else {
> -               return __setup_rt_frame(ksig->sig, ksig, set, regs);
> +               return __setup_rt_frame(ksig->sig, ksig, &sigcopy, regs);
>         }
>  }
>
> [...]
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index e158b22ef32f..84edd23d7fcc 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -167,6 +167,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>         int ei_index = 0;
>         const struct cred *cred = current_cred();
>         struct vm_area_struct *vma;
> +       unsigned long saved_auxv[AT_VECTOR_SIZE];
> +       size_t saved_auxv_size;
>
>         /*
>          * In some cases (e.g. Hyper-Threading), we want to avoid L1
> @@ -324,9 +326,13 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>                 return -EFAULT;
>         current->mm->env_end = p;
>
> +       saved_auxv_size = ei_index * sizeof(elf_addr_t);
> +       BUG_ON(saved_auxv_size > sizeof(saved_auxv));
> +       memcpy(saved_auxv, elf_info, saved_auxv_size);
> +
>         /* Put the elf_info on the stack in the right place.  */
>         sp = (elf_addr_t __user *)envp + 1;
> -       if (copy_to_user(sp, elf_info, ei_index * sizeof(elf_addr_t)))
> +       if (copy_to_user(sp, saved_auxv, saved_auxv_size))
>                 return -EFAULT;
>         return 0;
>  }
> [...]

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
