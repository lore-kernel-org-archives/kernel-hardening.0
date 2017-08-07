MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu9QPnSwOqtBkg9kPq2_UONRfOOJusw0_U59BWLW2=YbUw@mail.gmail.com>
References: <20170807203948.GA22298@beast> <CAKv+Gu-DUk9xqzpWt_FNBzpbLhdi9Cc5vU5J-tZZ4b8wD87UTQ@mail.gmail.com>
 <CAGXu5jL27FsZLi_L-mJnySe3H_3LiyFr2Odav+Xm=xhOHc25uw@mail.gmail.com> <CAKv+Gu9QPnSwOqtBkg9kPq2_UONRfOOJusw0_U59BWLW2=YbUw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Aug 2017 14:47:08 -0700
Message-ID: <CAGXu5jLtJYQAdJWM_bAsEOEOLCQMmNM1CrHhuvbNZzTvx=O1tA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] lkdtm: Test VMAP_STACK allocates
 leading/trailing guard pages
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 7, 2017 at 2:46 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 7 August 2017 at 22:44, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Aug 7, 2017 at 2:27 PM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> On 7 August 2017 at 21:39, Kees Cook <keescook@chromium.org> wrote:
>>>> Two new tests STACK_GUARD_PAGE_LEADING and STACK_GUARD_PAGE_TRAILING
>>>> attempt to read the byte before and after, respectively, of the current
>>>> stack frame, which should fault under VMAP_STACK.
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>> Do these tests both trip with the new arm64 VMAP_STACK code?
>>>
>>> Probably not. On arm64, the registers are stacked by software at
>>> exception entry,  and so we decrement the sp first by the size of the
>>> register file, and if the resulting value overflows the stack, the
>>> situation is handled as if the exception was caused by a faulting
>>> stack access while it may be caused by something else in reality.
>>> Since the act of handling the exception is guaranteed to overflow the
>>> stack anyway, this does not really make a huge difference, and it
>>> prevents the recursive fault from wiping the context that we need to
>>> produce the diagnostics.
>>>
>>> This means an illegal access right above the stack will go undetected.
>>
>> I thought vmap entries provided guard pages around allocations?
>> Shouldn't that catch it?
>>
>
> Ah yes, so we will fault. We should probably double check whether we
> will not misidentify the fault because of the subtraction we do first,
> but that should be trivial to add.

Okay, cool. I'd be curious to see what the lkdtm tests show for you.

-Kees

-- 
Kees Cook
Pixel Security
