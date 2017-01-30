MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+KhAHZgtTQz+ig=_G+YvasKFw6RjfMj=6EYF8sd6vs5eL1bKg@mail.gmail.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com> <CA+KhAHY-2+nWBYwgBvu0v_yVBb8sizkYyGOPiW3DxX+EJi7sBg@mail.gmail.com>
 <CAGXu5j+ZFDJgHnWpYcaXupLh8KS=9pMsWY-LydrjavEv4w27SQ@mail.gmail.com> <CA+KhAHZgtTQz+ig=_G+YvasKFw6RjfMj=6EYF8sd6vs5eL1bKg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Jan 2017 14:15:43 -0800
Message-ID: <CAGXu5jJ=G05X0GBv82GrcWdVp2o5fdAqhGL3ypCL_=is=K3BLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack frame object validation
To: Keun-O Park <kpark3469@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 30, 2017 at 3:26 AM, Keun-O Park <kpark3469@gmail.com> wrote:
> Hello Kees,
>
> Thanks for the suggestion about lkdtm. Yes, it worked correctly.
> provoke-crash# echo USERCOPY_STACK_FRAME_TO > DIRECT
> [11388.369172] lkdtm: Performing direct entry USERCOPY_STACK_FRAME_TO
> [11388.369259] lkdtm: attempting good copy_to_user of local stack
> [11388.369366] lkdtm: attempting bad copy_to_user of distant stack
> [11388.369453] usercopy: kernel memory exposure attempt detected from
> ffffffc87985fd60 (<process stack>) (32 bytes)
>
> provoke-crash# echo USERCOPY_STACK_FRAME_FROM > DIRECT
> [12687.156830] lkdtm: Performing direct entry USERCOPY_STACK_FRAME_FROM
> [12687.156918] lkdtm: attempting good copy_from_user of local stack
> [12687.156995] lkdtm: attempting bad copy_from_user of distant stack
> [12687.157082] usercopy: kernel memory overwrite attempt detected to
> ffffffc87985fd60 (<process stack>) (32 bytes)
>
> One thing I want to ask is..
> Does USERCOPY_HEAP_FLAG_FROM/TO work correctly in latest kernel?

No, this protection (the whitelisting flag) isn't implemented yet in
upstream. (You're more than welcome to dig into it, if you want!)

> Both on Pixel(v3.18) and on emulator(v4.10-rc5)
> In these two cases the bad attempt passed. I guess the code for this
> test might not be ready. Am I right?

Correct.

-Kees

-- 
Kees Cook
Pixel Security
