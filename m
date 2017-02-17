MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170216182917.19637-1-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 16 Feb 2017 16:54:21 -0800
Message-ID: <CAGXu5jJ9xis_X9qd-GxCM=oDDoynMrW=GZbfeOKKt_FpAuK83Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/3] arm64: usercopy: Implement stack frame object validation
To: James Morse <james.morse@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 10:29 AM, James Morse <james.morse@arm.com> wrote:
> Hi all,
>
> This version of Sahara's arch_within_stack_frames() series replaces the
> open-coded stack walker with a call to arm64's existing walker.
>
> Patch 2 can be tested independently with this change[0].
>
> lkdtm's use of unallocated stack regions is a separate problem, patch 3
> tries to address this.
>
> Sahara, it would be good to get your review of this!
> I'm afraid I omitted your patch-3 as it stopped the lkdtm test from working,
> I suspect its not tricking the compiler, but I haven't investigated.
>
>
> Thanks,
>
> James
>
> [0] Change to lkdtm to generate accesses that overlap stack frames.
> --------------%<--------------
> diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
> index 1dd611423d8b..fcbba3a14387 100644
> --- a/drivers/misc/lkdtm_usercopy.c
> +++ b/drivers/misc/lkdtm_usercopy.c
> @@ -57,7 +57,8 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
>
>         /* This is a pointer to outside our current stack frame. */
>         if (bad_frame) {
> -               bad_stack = do_usercopy_stack_callee((uintptr_t)&bad_stack);
> +               bad_stack = __builtin_frame_address(0);
> +               bad_stack -= sizeof(good_stack)/2;

Ah, sneaky, yeah, that'll work nicely.

(Though it should likely get wrapped in a CONFIG_STACK_GROWSUP/DOWN test...)

-Kees

-- 
Kees Cook
Pixel Security
