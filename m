MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1498066040.27465.7.camel@gmail.com>
References: <20170621055835.GA27467@beast> <1498046876.13083.17.camel@redhat.com>
 <CAGXu5j+LJ7241o9xoXrorc-Wt9Z7YWOvkPjkxSMuGn6TtCFkgQ@mail.gmail.com> <1498066040.27465.7.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 21 Jun 2017 10:28:11 -0700
Message-ID: <CAGXu5jJGD5md4YZXadcFnw2WogoXfKtBSQmMa=Mm+CNe309F6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] [RFC] binfmt_elf: Use ELF_ET_DYN_BASE
 only for PIE
To: Daniel Micay <danielmicay@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 21, 2017 at 10:27 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Wed, 2017-06-21 at 10:23 -0700, Kees Cook wrote:
>> On Wed, Jun 21, 2017 at 5:07 AM, Rik van Riel <riel@redhat.com> wrote:
>> > On Tue, 2017-06-20 at 22:58 -0700, Kees Cook wrote:
>> > > +/* This is the base location for PIE (ET_DYN with INTERP) loads.
>> > > */
>> > > +#define ELF_ET_DYN_BASE              0x400000UL
>> >
>> > This value is good for 32 bit binaries, but for 64
>> > bit binaries you probably want to put ELF_ET_DYN_BASE
>> > at 4GB or higher.
>> >
>> > The latter is necessary because Android uses the
>> > lower 4GB of address space for its JVM runtime,
>> > with 32 bit pointers inside that part of the otherwise
>> > 64 bit address space.
>> >
>> > In other words:
>> >
>> > #define ELF_ET_DYN_BASE (mmap_is_ia32() ? 0x400000UL :
>> > 0x100000000UL)
>>
>> Ah, interesting. Okay, that should be fine. I'll adjust it.
>>
>> > > +++ b/fs/binfmt_elf.c
>> > >
>> > > +                      * Therefore, programs are loaded offset
>> > > from
>> > > +                      * ELF_ET_DYN_BASE and loaders are loaded
>> > > into the
>> > > +                      * independently randomized mmap region (0
>> > > load_bias
>> > > +                      * without MAP_FIXED).
>> > > +                      */
>> > > +                     if (elf_interpreter) {
>> > > +                             load_bias = ELF_ET_DYN_BASE;
>> > > +                             if (current->flags & PF_RANDOMIZE)
>> > > +                                     load_bias +=
>> > > arch_mmap_rnd();
>> > > +                             elf_flags |= MAP_FIXED;
>> > > +                     } else
>> > > +                             load_bias = 0;
>> > > +
>> > > +                     load_bias -= vaddr;
>> >
>> > I like this, and the big comment telling people how it
>> > works :)
>>
>> Thanks! It looks like your patch for commenting load_bias never got
>> picked up, so I've added some more comments for that and some other
>> things too. (Mostly for all the stuff I have to read a few times when
>> I look at this code.)
>>
>> -Kees
>>
>
> The stack rlimit calculation fix for space potentially lost to ASLR is
> probably still needed too, right?

Yes. Was that picked up by akpm already?

-Kees

-- 
Kees Cook
Pixel Security
