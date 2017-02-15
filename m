Date: Wed, 15 Feb 2017 10:45:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170215104503.GA31733@leverpostej>
References: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com>
 <CAGXu5j+ogVnxxu1VuUep6ObAdyJbvxMyN25J+PF+exOJqk2VVg@mail.gmail.com>
 <CAGXu5jLfpq=vn0V_41NbLPyxkPQzGVwvo33tnErkmtcx8TOf4g@mail.gmail.com>
 <2C0135CD-ACCF-462F-B7C6-E8554C6C99BF@gmail.com>
 <CAGXu5jLhqFx5gZWB7GFdz_zfphJbnUgwrjHNSxHEFBt8ujtPPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAGXu5jLhqFx5gZWB7GFdz_zfphJbnUgwrjHNSxHEFBt8ujtPPg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] usercopy: add testcases to check zeroing on failure of
 usercopy
To: Kees Cook <keescook@chromium.org>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 12:36:48PM -0800, Kees Cook wrote:
> On Mon, Feb 13, 2017 at 5:44 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> >> On Feb 14, 2017, at 4:24 AM, Kees Cook <keescook@chromium.org> wrote:
> >>> On Mon, Feb 13, 2017 at 10:33 AM, Kees Cook <keescook@chromium.org> wrote:
> >>>> On Sat, Feb 11, 2017 at 10:13 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:

> >>>> @@ -69,25 +76,35 @@ static int __init test_user_copy_init(void)
> >>>>                    "legitimate put_user failed");
> >>>>
> >>>>        /* Invalid usage: none of these should succeed. */
> >>>> +       memset(kmem, 0x5A, PAGE_SIZE);
> >>>>        ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
> >>>>                                    PAGE_SIZE),
> >>>>                    "illegal all-kernel copy_from_user passed");
> >>>> +       ret |= test(memcmp(zerokmem, kmem, PAGE_SIZE),
> >>>> +                   "zeroing failure for illegal all-kernel copy_from_user");
> >>>> +       memset(bad_usermem, 0x5A, PAGE_SIZE);
> >>>
> >>> Oh, actually, ha-ha: this isn't legal: it's a direct copy from kernel
> >>> to userspace. :) This needs a copy_to_user()... (and same for the
> >>> memcmp...)
> >
> > I just came up with that usercopy doesn't check the buffer is valid
> > when zeroing happens. I mean if the buffer is wrong address pointing
> > other kernel objects or user space address, is it possible for
> > zeroing to overwrite the address ?
> 
> The overwrite happening even when the address is "wrong" seems like a
> bug to me, but it's sort of already too late (a bad kernel address
> would have already been a target for a userspace copy), but if
> something has gone really wrong (i.e. attacker doesn't have control
> over the source buffer) this does give a "write 0" primitive.
> 
> Mark Rutland noticed some order-of-operations issues here too, and his
> solution is pretty straight forward: move the checks outside the
> failure path. If the kernel target is demonstrably bad, then the
> process will be killed before the write 0 happens. (In the non-const
> case at least...)
> 
> (Oh, btw, I just noticed that x86's copy_from_user() already does the
> check before _copy_from_user() can do the memset, so x86 is already
> "ok" in this regard.)

FWIW, the patch making arm64 do the check first is queued [1], and
should be in v4.11.

Doing the same for other architectures would be good.

Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/commit/?h=for-next/core&id=76624175dcae6f7a808d345c0592908a15ca6975
