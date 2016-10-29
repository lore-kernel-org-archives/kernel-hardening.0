Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF9F28@IRSMSX102.ger.corp.intel.com>
References: <CAEXv5_iWUUs-NwzJn7n38cX0R_Mdd2V4+T6E16akwrAMqhsuiA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BF9F28@IRSMSX102.ger.corp.intel.com>
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 03:13:15 -0400
Message-ID: <CAEXv5_jSRz2F=JrVo-EFUSftvNbFSumDeZcypvFRpXsVyrskjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Expanding HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 29, 2016 at 2:57 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> Hi David,
>
> Thank you for letting us know! The most up-to-date branch now is hardened_atomic_next since it contains most recent fixes and it is rebased on top of latest Linux-next stable.
> I will probably terminate hardened_atomic_on_next branch after I cherry-pick your documentation change.
>
> I would propose that we send the existing rfc this weekend without your new additions and then we can include them into new rfcv4 or it might be also new patch set all together since this one is already so big.
> What do you think?
>

I tend to agree: I will recreate the hardened_atomic_on_next_expanded
branch on top of hardened_atomic_next and call it
hardened_atomic_next_expanded.  I will post patches as soon as it
compiles.

> Best Regards,
> Elena.
>
>> I've created a branch on Elena's github repo called hardened_atomic_on_next_expanded
> (https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next_expanded)
> which incorporates the PAX_REFCOUNT changes to extend atomic_t coverage to kernel reference counters that were originally integer types.  Our work to this point only addresses existing atomic_t users:
> this patch is a first attempt to convert non-atomic_t reference counter users to use atomic_t, and thus get overflow protection.
>
> The users addressed in this branch are:
>   * struct fs_struct.users
>   * struct tty_port.count
>   * struct tty_ldisc_ops.refcount
>   * struct pipe_inode_info.{readers|writers|files|waiting_writers}
>   * struct kmem_cache.refcount
>
> This branch currently does not compile, as I am in the process of cherrypicking the necessary changes from PAX_REFCOUNT.
>
> I wanted to let Elena/Hans know about this now, as they are preparing the next RFC.  I don't know if we want to actually expand kernel coverage in this round of RFC's, but there shouldn't be much more work left to get this working.
>
> Thanks,
> David
