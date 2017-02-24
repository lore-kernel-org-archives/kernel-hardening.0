MIME-Version: 1.0
In-Reply-To: <CACi5LpMdoo4xFCO4w+FAF=UQMDF_Lx95UoN-B4UrtCX_27B8wg@mail.gmail.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <1486014168-1279-2-git-send-email-bhsharma@redhat.com> <87mve4c2my.fsf@concordia.ellerman.id.au>
 <CACi5LpOkkSFOJm07BGZFOmFpZpx7qsQiNywEmAjCEmcQG6kGEg@mail.gmail.com>
 <87mvduz4wi.fsf@concordia.ellerman.id.au> <CACi5LpOddY6WOz7S-fNEwSDLOoYFga-NKUOkCHtNLJ0puiNMOQ@mail.gmail.com>
 <CACi5LpMdoo4xFCO4w+FAF=UQMDF_Lx95UoN-B4UrtCX_27B8wg@mail.gmail.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Fri, 24 Feb 2017 13:02:13 +0530
Message-ID: <CACi5LpM1ZjLgPUFaYy5xnC+Or-ENNzGSMaAqMo9rE3zVEy0PkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Daniel Cashman <dcashman@google.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Michael,

On Thu, Feb 16, 2017 at 10:19 AM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> Hi Michael,
>
> On Fri, Feb 10, 2017 at 4:41 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
>> On Fri, Feb 10, 2017 at 4:31 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> Bhupesh Sharma <bhsharma@redhat.com> writes:
>>>
>>>> HI Michael,
>>>>
>>>> On Thu, Feb 2, 2017 at 3:53 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>>>> Bhupesh Sharma <bhsharma@redhat.com> writes:
>>>>>
>>>>>> powerpc: arch_mmap_rnd() uses hard-coded values, (23-PAGE_SHIFT) for
>>>>>> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
>>>>>> for the mmap base address.
>>>>>>
>>>>>> This value represents a compromise between increased
>>>>>> ASLR effectiveness and avoiding address-space fragmentation.
>>>>>> Replace it with a Kconfig option, which is sensibly bounded, so that
>>>>>> platform developers may choose where to place this compromise.
>>>>>> Keep default values as new minimums.
>>>>>>
>>>>>> This patch makes sure that now powerpc mmap arch_mmap_rnd() approach
>>>>>> is similar to other ARCHs like x86, arm64 and arm.
>>>>>
>>>>> Thanks for looking at this, it's been on my TODO for a while.
>>>>>
>>>>> I have a half completed version locally, but never got around to testing
>>>>> it thoroughly.
>>>>
>>>> Sure :)
>>>>
>>>>>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>>>>>> index a8ee573fe610..b4a843f68705 100644
>>>>>> --- a/arch/powerpc/Kconfig
>>>>>> +++ b/arch/powerpc/Kconfig
>>>>>> @@ -22,6 +22,38 @@ config MMU
>>>>>>       bool
>>>>>>       default y
>>>>>>
>>>>>> +config ARCH_MMAP_RND_BITS_MIN
>>>>>> +       default 5 if PPC_256K_PAGES && 32BIT
>>>>>> +       default 12 if PPC_256K_PAGES && 64BIT
>>>>>> +       default 7 if PPC_64K_PAGES && 32BIT
>>>>>> +       default 14 if PPC_64K_PAGES && 64BIT
>>>>>> +       default 9 if PPC_16K_PAGES && 32BIT
>>>>>> +       default 16 if PPC_16K_PAGES && 64BIT
>>>>>> +       default 11 if PPC_4K_PAGES && 32BIT
>>>>>> +       default 18 if PPC_4K_PAGES && 64BIT
>>>>>> +
>>>>>> +# max bits determined by the following formula:
>>>>>> +#  VA_BITS - PAGE_SHIFT - 4
>>>>>> +#  for e.g for 64K page and 64BIT = 48 - 16 - 4 = 28
>>>>>> +config ARCH_MMAP_RND_BITS_MAX
>>>>>> +       default 10 if PPC_256K_PAGES && 32BIT
>>>>>> +       default 26 if PPC_256K_PAGES && 64BIT
>>>>>> +       default 12 if PPC_64K_PAGES && 32BIT
>>>>>> +       default 28 if PPC_64K_PAGES && 64BIT
>>>>>> +       default 14 if PPC_16K_PAGES && 32BIT
>>>>>> +       default 30 if PPC_16K_PAGES && 64BIT
>>>>>> +       default 16 if PPC_4K_PAGES && 32BIT
>>>>>> +       default 32 if PPC_4K_PAGES && 64BIT
>>>>>> +
>>>>>> +config ARCH_MMAP_RND_COMPAT_BITS_MIN
>>>>>> +       default 5 if PPC_256K_PAGES
>>>>>> +       default 7 if PPC_64K_PAGES
>>>>>> +       default 9 if PPC_16K_PAGES
>>>>>> +       default 11
>>>>>> +
>>>>>> +config ARCH_MMAP_RND_COMPAT_BITS_MAX
>>>>>> +       default 16
>>>>>> +
>>>>>
>>>>> This is what I have below, which is a bit neater I think because each
>>>>> value is only there once (by defaulting to the COMPAT value).
>>>>>
>>>>> My max values are different to yours, I don't really remember why I
>>>>> chose those values, so we can argue about which is right.
>>>>
>>>> I am not sure how you derived these values, but I am not sure there
>>>> should be differences between 64-BIT x86/ARM64 and PPC values for the
>>>> MAX values.
>>>
>>> But your values *are* different to x86 and arm64.
>>>
>>> And why would they be the same anyway? x86 has a 47 bit address space,
>>> 64-bit powerpc is 46 bits, and arm64 is configurable from 36 to 48 bits.
>>>
>>> So your calculations above using VA_BITS = 48 should be using 46 bits.
>>>
>>> But if you fixed that, your formula basically gives 1/16th of the
>>> address space as the maximum range. Why is that the right amount?
>>>
>>> x86 uses 1/8th, and arm64 uses a mixture of 1/8th and 1/32nd (though
>>> those might be bugs).
>>>
>>> My values were more liberal, giving up to half the address space for 32
>>> & 64-bit. Maybe that's too generous, but my rationale was it's up to the
>>> sysadmin to tweak the values and they get to keep the pieces if it
>>> breaks.
>>
>> I am not sure why would one want to use more than the practical limits
>> of 1/8th used by x86 - this causes additional burden of address space
>> fragmentation.
>>
>> So we need to balance between the randomness increase and the address
>> space fragmentation.
>>
>>>>> +config ARCH_MMAP_RND_BITS_MAX
>>>>> +       # On 64-bit up to 32T of address space (2^45)
>>>>> +       default 27 if 64BIT && PPC_256K_PAGES   # 256K (2^18), = 45 - 18 = 27
>>>>> +       default 29 if 64BIT && PPC_64K_PAGES    # 64K  (2^16), = 45 - 16 = 29
>>>>> +       default 31 if 64BIT && PPC_16K_PAGES    # 16K  (2^14), = 45 - 14 = 31
>>>>> +       default 33 if 64BIT                     # 4K   (2^12), = 45 - 12 = 33
>>>>> +       default ARCH_MMAP_RND_COMPAT_BITS_MAX
>>>
>>> I played with my values a bit and allowing 32T is a little bit nuts. It
>>> means you can actually end up with the adjusted ET_DYN_BASE *above* 32T,
>>> followed by the heap growing up, and the mmap base *below* 32T, growing
>>> down. Which is kinda fun, but definitely breaks a lot of assumptions.
>>>
>>> So limiting it to a max of 16T is probably more sensible.
>>>
>>> Anyway late here, will think about it some more over the weekend.
>>
>> A user is always free to tweak the maximum values via specific Kconfig
>> + defconfig combinations for their platforms, but why have such large
>> max values as default for say a embedded PPC64 board which only
>> supports say 16GB of DDR.
>>
>> A default max of 33bits for such platforms might be an overkill, while
>> it might be fine for servers which might have greater DDR
>> availability.
>
> Ping.
>

Any updates on this?

Regards,
Bhupesh
