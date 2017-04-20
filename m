From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5jKAoukvBtH7i0K17MywkLEpizECCfMGJ+XKWWfPQHdQBw@mail.gmail.com>
References: <1492612181-8484-1-git-send-email-mpe@ellerman.id.au> <CAGXu5jKAoukvBtH7i0K17MywkLEpizECCfMGJ+XKWWfPQHdQBw@mail.gmail.com>
Date: Thu, 20 Apr 2017 21:22:22 +1000
Message-ID: <87bmrr493l.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] powerpc/mm: Add support for runtime configuration of ASLR limits
To: Kees Cook <keescook@chromium.org>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, Bhupesh Sharma <bhsharma@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Wed, Apr 19, 2017 at 7:29 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Add powerpc support for mmap_rnd_bits and mmap_rnd_compat_bits, which are two
>> sysctls that allow a user to configure the number of bits of randomness used for
>> ASLR.
>>
>> Because of the way the Kconfig for ARCH_MMAP_RND_BITS is defined, we have to
>> construct at least the MIN value in Kconfig, vs in a header which would be more
>> natural. Given that we just go ahead and do it all in Kconfig.
>>
>> At least according to the code (the documentation makes no mention of it), the
>> value is defined as the number of bits of randomisation *of the page*, not the
>> address. This makes some sense, with larger page sizes more of the low bits are
>> forced to zero, which would reduce the randomisation if we didn't take the
>> PAGE_SIZE into account. However it does mean the min/max values have to change
>> depending on the PAGE_SIZE in order to actually limit the amount of address
>> space consumed by the randomisation.
>>
>> The result of that is that we have to define the default values based on both
>> 32-bit vs 64-bit, but also the configured PAGE_SIZE. Furthermore now that we
>> have 128TB address space support on Book3S, we also have to take that into
>> account.
>>
>> Finally we can wire up the value in arch_mmap_rnd().
>>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>
> Maybe add a Suggested-by: for the earlier patches?

Sure.

>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 97a8bc8a095c..608ee0b7b79f 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -22,6 +22,48 @@ config MMU
>>         bool
>>         default y
>>
>> +config ARCH_MMAP_RND_BITS_MAX
>> +       # On Book3S 64, the default virtual address space for 64-bit processes
>> +       # is 2^47 (128TB). As a maximum, allow randomisation to consume up to
>> +       # 32T of address space (2^45), which should ensure a reasonable gap
>> +       # between bottom-up and top-down allocations for applications that
>> +       # consume "normal" amounts of address space. Book3S 64 only supports 64K
>> +       # and 4K page sizes.
>> +       default 29 if PPC_BOOK3S_64 && PPC_64K_PAGES # 29 = 45 (32T) - 16 (64K)
>> +       default 33 if PPC_BOOK3S_64                  # 33 = 45 (32T) - 12 (4K)
>> +       #
>> +       # On all other 64-bit platforms (currently only Book3E), the virtual
>> +       # address space is 2^46 (64TB). Allow randomisation to consume up to 16T
>> +       # of address space (2^44). Only 4K page sizes are supported.
>> +       default 32 if 64BIT     # 32 = 44 (16T) - 12 (4K)
>> +       #
>> +       # For 32-bit, use the compat values, as they're the same.
>> +       default ARCH_MMAP_RND_COMPAT_BITS_MIN
>
> Shouldn't the default case be ..._MAX?

Yes, ooops! Thanks for the review.

> Yay! Ever closer to being able to extract arch_mmap_rnd() out of arch/ ;)

Hah, you are an optimist :)

cheers
