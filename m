References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <CAGXu5jJ045iaDfoW+2dXU+U-KhfnNH1WX5ngUW9dHyS5Yn3EGg@mail.gmail.com>
 <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <bdeb7de0-bd8d-f1f5-3287-a48a37da974f@schaufler-ca.com>
Date: Sun, 28 May 2017 10:57:38 -0700
MIME-Version: 1.0
In-Reply-To: <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of
 struct list_head
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

On 5/27/2017 6:26 PM, Tetsuo Handa wrote:
> Kees Cook wrote:
>> On Sat, May 27, 2017 at 4:17 AM, Tetsuo Handa
>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>> Commit 3dfc9b02864b19f4 ("LSM: Initialize security_hook_heads upon
>>> registration.") treats "struct security_hook_heads" as an implicit array
>>> of "struct list_head" so that we can eliminate code for static
>>> initialization. Although we haven't encountered compilers which do not
>>> treat sizeof(security_hook_heads) != sizeof(struct list_head) *
>>> (sizeof(security_hook_heads) / sizeof(struct list_head)), Casey does not
>>> like the assumption that a structure of N elements can be assumed to be
>>> the same as an array of N elements.
>>>
>>> Now that Kees found that randstruct complains such casting
>>>
>>>   security/security.c: In function 'security_init':
>>>   security/security.c:59:20: note: found mismatched op0 struct pointer types: 'struct list_head' and 'struct security_hook_heads'
>>>
>>>     struct list_head *list = (struct list_head *) &security_hook_heads;
>>>
>>> and Christoph thinks that we should fix it rather than make randstruct
>>> whitelist it, this patch fixes it.
>>>
>>> It would be possible to revert commit 3dfc9b02864b19f4, but this patch
>>> converts security_hook_heads into an explicit array of struct list_head
>>> by introducing an enum, due to reasons explained below.
>> Like Casey, I had confused this patch with the other(?) that resulted
>> in dropped type checking. This just switches from named list_heads to
>> indexed list_heads, which is fine now that the BUG_ON exists to
>> sanity-check the index being used.
> Casey, are you just confused as well?

I am indeed "just confused". I still don't like it, I liked
it the way I had it, but I don't see it worth fighting over.


>>> In MM subsystem, a sealable memory allocator patch was proposed, and
>>> the LSM hooks ("struct security_hook_heads security_hook_heads" and
>>> "struct security_hook_list ...[]") will benefit from this allocator via
>>> protection using set_memory_ro()/set_memory_rw(), and that allocator
>>> will remove CONFIG_SECURITY_WRITABLE_HOOKS config option. Thus, we will
>>> likely be moving to that direction.
>> It's unlikely that smalloc will allow unsealing after initialization,
>> so the SELinux disabling case will remain, IIUC.
> LKM-based LSM modules will need it. Look at the result of a recent poll at
> https://distrowatch.com/weekly.php?pollnumber=102&myaction=SeeVote&issue=20170522#poll .
> We are still failing to provide users "a security module that individual user
> can afford enabling". And we know that we cannot merge all security modules
> into mainline. Thus, allowing LKM-based LSM modules is inevitable.
>
>>> @@ -179,7 +182,8 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
>>>         do {                                                    \
>>>                 struct security_hook_list *P;                   \
>>>                                                                 \
>>> -               list_for_each_entry(P, &security_hook_heads.FUNC, list) \
>>> +               list_for_each_entry(P, &security_hook_heads     \
>>> +                                   [LSM_##FUNC], list)         \
>> Can this be unsplit so the [...] remains next to security_hook_heads?
> These are needed for passing 80 columns check by scripts/checkpatch.pl .
> Should we ignore that warning or rename security_hook_heads to e.g. SHH ?

No! I spend way too much of my life battling with checkpatch.pl.
OK, you could rename it since it's static. hook_heads gets my vote.

>
>> Otherwise, yeah, I can be convinced to take this. :) Thanks for
>> persisting with this, I think it makes sense now.
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
