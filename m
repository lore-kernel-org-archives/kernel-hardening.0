MIME-Version: 1.0
In-Reply-To: <CAGXu5jKidijcESX2vguQ=m4Fx1S7eKOKXrLTEb3Of1FN9jQbbg@mail.gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <1519899591-29761-2-git-send-email-kpark3469@gmail.com> <1519899591-29761-3-git-send-email-kpark3469@gmail.com>
 <CAGXu5jKidijcESX2vguQ=m4Fx1S7eKOKXrLTEb3Of1FN9jQbbg@mail.gmail.com>
From: Keun-O Park <kpark3469@gmail.com>
Date: Sun, 8 Apr 2018 10:39:24 +0400
Message-ID: <CA+KhAHZB2tDpd-EY8har78PWyf=SCN4cNSjLHLpRqZoJgB2TiQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] arm64: usercopy: implement arch_within_stack_frames
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, keun-o.park@darkmatter.ae, Sodagudi Prasad <psodagud@codeaurora.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Thu, Apr 5, 2018 at 2:55 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 1, 2018 at 2:19 AM,  <kpark3469@gmail.com> wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> This implements arch_within_stack_frames() for arm64 that should
>> validate if a given object is contained by a kernel stack frame.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Reviewed-by: Sahara <keun-o.park@darkmatter.ae>
>
> Looks good to me. Does this end up passing the LKDTM
> USERCOPY_STACK_FRAME_TO and USERCOPY_STACK_FRAME_FROM tests?

Yes, this passes those two LKDTM tests.
Thanks.

BR
Sahara
