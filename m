MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 27 May 2017 18:04:14 -0700
Message-ID: <CAGXu5jJ045iaDfoW+2dXU+U-KhfnNH1WX5ngUW9dHyS5Yn3EGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of
 struct list_head
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, Igor Stoppa <igor.stoppa@huawei.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 27, 2017 at 4:17 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Commit 3dfc9b02864b19f4 ("LSM: Initialize security_hook_heads upon
> registration.") treats "struct security_hook_heads" as an implicit array
> of "struct list_head" so that we can eliminate code for static
> initialization. Although we haven't encountered compilers which do not
> treat sizeof(security_hook_heads) != sizeof(struct list_head) *
> (sizeof(security_hook_heads) / sizeof(struct list_head)), Casey does not
> like the assumption that a structure of N elements can be assumed to be
> the same as an array of N elements.
>
> Now that Kees found that randstruct complains such casting
>
>   security/security.c: In function 'security_init':
>   security/security.c:59:20: note: found mismatched op0 struct pointer types: 'struct list_head' and 'struct security_hook_heads'
>
>     struct list_head *list = (struct list_head *) &security_hook_heads;
>
> and Christoph thinks that we should fix it rather than make randstruct
> whitelist it, this patch fixes it.
>
> It would be possible to revert commit 3dfc9b02864b19f4, but this patch
> converts security_hook_heads into an explicit array of struct list_head
> by introducing an enum, due to reasons explained below.

Like Casey, I had confused this patch with the other(?) that resulted
in dropped type checking. This just switches from named list_heads to
indexed list_heads, which is fine now that the BUG_ON exists to
sanity-check the index being used.

> In MM subsystem, a sealable memory allocator patch was proposed, and
> the LSM hooks ("struct security_hook_heads security_hook_heads" and
> "struct security_hook_list ...[]") will benefit from this allocator via
> protection using set_memory_ro()/set_memory_rw(), and that allocator
> will remove CONFIG_SECURITY_WRITABLE_HOOKS config option. Thus, we will
> likely be moving to that direction.

It's unlikely that smalloc will allow unsealing after initialization,
so the SELinux disabling case will remain, IIUC.

> This means that these structures will be allocated at run time using
> this allocator, and therefore the address of these structures will be
> determined at run time rather than compile time.
>
> But currently, LSM_HOOK_INIT() macro depends on the address of
> security_hook_heads being known at compile time. If we use an enum
> so that LSM_HOOK_INIT() macro does not need to know absolute address of
> security_hook_heads, it will help us to use that allocator for LSM hooks.
>
> As a result of introducing an enum, security_hook_heads becomes a local
> variable, making it easier to allocate security_hook_heads at run time.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Igor Stoppa <igor.stoppa@huawei.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  include/linux/lsm_hooks.h | 412 +++++++++++++++++++++++-----------------------
>  security/security.c       |  38 +++--
>  2 files changed, 229 insertions(+), 221 deletions(-)
>
> diff --git a/security/security.c b/security/security.c
> index 38316bb..bd3c07e 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -179,7 +182,8 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
>         do {                                                    \
>                 struct security_hook_list *P;                   \
>                                                                 \
> -               list_for_each_entry(P, &security_hook_heads.FUNC, list) \
> +               list_for_each_entry(P, &security_hook_heads     \
> +                                   [LSM_##FUNC], list)         \

Can this be unsplit so the [...] remains next to security_hook_heads?

>                         P->hook.FUNC(__VA_ARGS__);              \
>         } while (0)
>
> @@ -188,7 +192,8 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
>         do {                                                    \
>                 struct security_hook_list *P;                   \
>                                                                 \
> -               list_for_each_entry(P, &security_hook_heads.FUNC, list) { \
> +               list_for_each_entry(P, &security_hook_heads     \
> +                                   [LSM_##FUNC], list) {       \

Same

>                         RC = P->hook.FUNC(__VA_ARGS__);         \
>                         if (RC != 0)                            \
>                                 break;                          \
> @@ -1587,8 +1595,8 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
>          * For speed optimization, we explicitly break the loop rather than
>          * using the macro
>          */
> -       list_for_each_entry(hp, &security_hook_heads.xfrm_state_pol_flow_match,
> -                               list) {
> +       list_for_each_entry(hp, &security_hook_heads
> +                           [LSM_xfrm_state_pol_flow_match], list) {

Same

>                 rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl);
>                 break;
>         }
> --
> 1.8.3.1
>

Otherwise, yeah, I can be convinced to take this. :) Thanks for
persisting with this, I think it makes sense now.

-Kees

-- 
Kees Cook
Pixel Security
