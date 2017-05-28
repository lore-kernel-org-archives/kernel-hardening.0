MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1496003387-3184-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <1496003387-3184-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 28 May 2017 14:19:22 -0700
Message-ID: <CAGXu5jK2azpWLOg=EGEOhPySN52_JpMcXoWaSkNSZhxF1_dNFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] LSM: Convert security_hook_heads into explicit array
 of struct list_head
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, Igor Stoppa <igor.stoppa@huawei.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 28, 2017 at 1:29 PM, Tetsuo Handa
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
> Now that Kees found that randstruct complains about such casting
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
>
> Igor proposed a sealable memory allocator, and the LSM hooks
> ("struct security_hook_heads security_hook_heads" and
> "struct security_hook_list ...[]") will benefit from that allocator via
> protection using set_memory_ro()/set_memory_rw(), and that allocator
> will remove CONFIG_SECURITY_WRITABLE_HOOKS config option. Thus, we will
> likely be moving to that direction.
>
> This means that these structures will be allocated at run time using
> that allocator, and therefore the address of these structures will be
> determined at run time rather than compile time.
>
> But currently, LSM_HOOK_INIT() macro depends on the address of
> security_hook_heads being known at compile time. If we use an enum
> so that LSM_HOOK_INIT() macro does not need to know absolute address of
> security_hook_heads, it will help us to use that allocator for LSM hooks.
>
> As a result of introducing an enum, security_hook_heads becomes a local
> variable. In order to pass 80 columns check by scripts/checkpatch.pl ,
> rename security_hook_heads to hook_heads.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Igor Stoppa <igor.stoppa@huawei.com>
> Cc: Christoph Hellwig <hch@infradead.org>

Looks good to me; thanks for persisting! :)

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Pixel Security
