MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170724090710.o66r5r2pwxgwor7t@gmail.com>
References: <1500855620-73004-1-git-send-email-keescook@chromium.org>
 <1500855620-73004-4-git-send-email-keescook@chromium.org> <20170724090710.o66r5r2pwxgwor7t@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jul 2017 11:25:13 -0700
Message-ID: <CAGXu5jKYnLu8B4Js-F4s5WPu0c3vDfhOnxV2qjd_WDdf6KucEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v7 3/3] x86/refcount: Implement fast refcount overflow protection
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 2:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> +config ARCH_HAS_REFCOUNT
>> +     bool
>> +     help
>> +       An architecture selects this when it has implemented refcount_t
>> +       using primitizes that provide a faster runtime at the expense
>> +       of some full refcount state checks. The refcount overflow condition,
>> +       however, must be retained. Catching overflows is the primary
>> +       security concern for protecting against bugs in reference counts.
>
> s/primitizes/primitives

And, as an aside for anyone curious, I've just added this to my .vimrc:

" Enable spell checking in Kconfig files
autocmd BufEnter Kconfig* set spell
" Enable spell checking in git commit edits
autocmd BufEnter COMMIT_EDITMSG set spell

I'm always forgetting to double-check the spellchecker mode, and in
those files, it should just be enabled by default. :P

> also, the 'faster runtime' and the whole explanation reads a bit weird to me,
> how about something like:
>
>        An architecture selects this when it has implemented refcount_t
>        using open coded assembly primitives that provide an optimized
>        refcount_t implementation, possibly at the expense of some full
>        refcount state checks of CONFIG_REFCOUNT_FULL=y.
>
>        The refcount overflow check behavior, however, must be retained.
>        Catching overflows is the primary security concern for protecting
>        against bugs in reference counts.

Yeah, this is much clearer, thanks! I've replaced this for v8.

>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -55,6 +55,7 @@ config X86
>>       select ARCH_HAS_KCOV                    if X86_64
>>       select ARCH_HAS_MMIO_FLUSH
>>       select ARCH_HAS_PMEM_API                if X86_64
>> +     select ARCH_HAS_REFCOUNT
>>       select ARCH_HAS_UACCESS_FLUSHCACHE      if X86_64
>>       select ARCH_HAS_SET_MEMORY
>>       select ARCH_HAS_SG_CHAIN
>
> Just wonderin, how was the 32-bit kernel tested?

I've got a qemu image for 32-bit too. Behavior and timing are
similarly matched. I've got updates to LKDTM that provide test
coverage of the refcount API. (I was going to send that via the
drivers tree, with some other LKDTM updates.) If you want to see it, a
not-quite-final version is here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/fast-refcount/ud/v6&id=5ebc36fd39a3c58bca770b81030626cf779103ee

>> +/*
>> + * Body of refcount error handling: in .text.unlikely, saved into CX the
>> + * address of the refcount that has entered a bad state, and trigger an
>> + * exception. Fixup address is back in regular execution flow in .text.
>
> I had to read this 4 times to parse it (and even now I'm unsure whether I parsed
> it correctly) - could this explanation be transformed to simpler, more
> straightforward English?

I've rewritten this now; hopefully it will be easier to parse.

>
>> + */
>> +#define _REFCOUNT_EXCEPTION                          \
>> +     ".pushsection .text.unlikely\n"                 \
>> +     "111:\tlea %[counter], %%" _ASM_CX "\n"         \
>> +     "112:\t" ASM_UD0 "\n"                           \
>> +     ASM_UNREACHABLE                                 \
>> +     ".popsection\n"                                 \
>> +     "113:\n"                                        \
>> +     _ASM_EXTABLE_REFCOUNT(112b, 113b)
>
> Would it be technically possible to use named labels instead of these random
> numbered labels?

My understanding was that using numbered labels allows us to have
repeated labels in the same function. (i.e. NUMb and NUMf can't, I
think, be done with text labels.)

>> +     /*
>> +      * This function has been called because either a negative refcount
>> +      * value was seen by any of the refcount functions, or a zero
>> +      * refcount value was seen by refcount_dec().
>> +      *
>> +      * If we crossed from INT_MAX to INT_MIN, the OF flag (result
>> +      * wrapped around) will be set. Additionally, seeing the refcount
>> +      * reach 0 will set the ZF flag. In each of these cases we want a
>> +      * report, since it's a boundary condition.
>
> Small nit: 'ZF' stands for 'zero flag' - so we should either write 'zero flag' or
> 'ZF' - 'ZF flag' is kind of redundant.

True! I'll fix this (and the "OF flag" usage above there).

>> +#else
>> +static inline void refcount_error_report(struct pt_regs *regs,
>> +                                      const char *msg) { }
>
> By now you should know that for x86 code you should not break lines in such an
> ugly fashion, right? :-)

Yes, I agonized over this because I hated the look of each variation I
tried here. I'll try again. :)

Thanks for the review!

-Kees

-- 
Kees Cook
Pixel Security
