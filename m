MIME-Version: 1.0
In-Reply-To: <8f805a19-19d1-3c97-c85b-510664d22dad@arm.com>
References: <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej> <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej> <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
 <20170714103258.GA16128@leverpostej> <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
 <CAKv+Gu96YHXDta7=YdYO4=wtR3mGVdkzAkG6tSzS-vo7toiPXA@mail.gmail.com>
 <20170714140605.GB16687@leverpostej> <188731af-269c-4197-1c55-78e485e7af46@arm.com>
 <8f805a19-19d1-3c97-c85b-510664d22dad@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 14 Jul 2017 16:15:37 +0100
Message-ID: <CAKv+Gu-46jyOjHfR5NEca6rYx8eSwOOcwJ3wg1dSa0-U8kze1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Robin Murphy <robin.murphy@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morse <james.morse@arm.com>, Takahiro Akashi <akashi.takahiro@linaro.org>, Dave Martin <dave.martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 July 2017 at 16:03, Robin Murphy <robin.murphy@arm.com> wrote:
> On 14/07/17 15:39, Robin Murphy wrote:
>> On 14/07/17 15:06, Mark Rutland wrote:
>>> On Fri, Jul 14, 2017 at 01:27:14PM +0100, Ard Biesheuvel wrote:
>>>> On 14 July 2017 at 11:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>>> On 14 July 2017 at 11:32, Mark Rutland <mark.rutland@arm.com> wrote:
>>>>>> On Thu, Jul 13, 2017 at 07:28:48PM +0100, Ard Biesheuvel wrote:
>>>
>>>>>>> OK, so here's a crazy idea: what if we
>>>>>>> a) carve out a dedicated range in the VMALLOC area for stacks
>>>>>>> b) for each stack, allocate a naturally aligned window of 2x the stack
>>>>>>> size, and map the stack inside it, leaving the remaining space
>>>>>>> unmapped
>>>
>>>>>> The logical ops (TST) and conditional branches (TB(N)Z, CB(N)Z) operate
>>>>>> on XZR rather than SP, so to do this we need to get the SP value into a
>>>>>> GPR.
>>>>>>
>>>>>> Previously, I assumed this meant we needed to corrupt a GPR (and hence
>>>>>> stash that GPR in a sysreg), so I started writing code to free sysregs.
>>>>>>
>>>>>> However, I now realise I was being thick, since we can stash the GPR
>>>>>> in the SP:
>>>>>>
>>>>>>         sub     sp, sp, x0      // sp = orig_sp - x0
>>>>>>         add     x0, sp, x0      // x0 = x0 - (orig_sp - x0) == orig_sp
>>>
>>> That comment is off, and should say     x0 = x0 + (orig_sp - x0) == orig_sp
>>>
>>>>>>         sub     x0, x0, #S_FRAME_SIZE
>>>>>>         tb(nz)  x0, #THREAD_SHIFT, overflow
>>>>>>         add     x0, x0, #S_FRAME_SIZE
>>>>>>         sub     x0, sp, x0
>>>>
>>>> You need a neg x0, x0 here I think
>>>
>>> Oh, whoops. I'd mis-simplified things.
>>>
>>> We can avoid that by storing orig_sp + orig_x0 in sp:
>>>
>>>      add     sp, sp, x0      // sp = orig_sp + orig_x0
>>>      sub     x0, sp, x0      // x0 = orig_sp
>>>      < check >
>>>      sub     x0, sp, x0      // x0 = orig_x0
>>
>> Haven't you now forcibly cleared the top bit of x0 thanks to overflow?
>
> ...or maybe not. I still can't quite see it, but I suppose it must
> cancel out somewhere, since Mr. Helpful C Program[1] has apparently
> proven me mistaken :(
>
> I guess that means I approve!
>
> Robin.
>
> [1]:
> #include <assert.h>
> #include <stdint.h>
>
> int main(void) {
>         for (int i = 0; i < 256; i++) {
>                 for (int j = 0; j < 256; j++) {
>                         uint8_t x = i;
>                         uint8_t y = j;
>                         y = y + x;
>                         x = y - x;
>                         x = y - x;
>                         y = y - x;
>                         assert(x == i && y == j);
>                 }
>         }
> }
>

Yeah, I think the carry out in the first instruction can be ignored,
given that we don't care about the magnitude of the result, only about
the lower 64-bits. The subtraction that inverts it will be off by
exactly 2^64
