Date: Wed, 21 Feb 2018 22:39:46 +0100
From: Ulf Magnusson <ulfalizer@gmail.com>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Message-ID: <20180221213946.w4v6ywy7fbiy6oyc@huvuddator>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
 <20180218221352.GA6651@ravnborg.org>
 <CAFkk2KT1krKuDkWt0eHcasfC61fTVQNf-1kqw7icLP9OYGYkXQ@mail.gmail.com>
 <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com>
 <CAK8P3a2BOQt5Y0B4271WqaJvvWqfxHxD3S6r1i1xONvb+CJ5Dg@mail.gmail.com>
 <CAK7LNARtZcW1v53ridFJK1MULmj8tQT4s+DoRhKj9PrbMri5rQ@mail.gmail.com>
 <CAK8P3a1DrhxWXaEs6E85W5HEhvFr23E-GDsu=0X-sG0pX+PLag@mail.gmail.com>
 <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>, Linux-sh list <linux-sh@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Jeff Dike <jdike@addtoit.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, user-mode-linux-user@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 09:57:03PM +0900, Masahiro Yamada wrote:
> 2018-02-21 19:52 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> > On Wed, Feb 21, 2018 at 11:20 AM, Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> >> 2018-02-21 18:56 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> >>> On Wed, Feb 21, 2018 at 8:38 AM, Masahiro Yamada
> >>> <yamada.masahiro@socionext.com> wrote:
> >>>> 2018-02-20 0:18 GMT+09:00 Ulf Magnusson <ulfalizer@gmail.com>:
> >>
> >> Let me clarify my concern.
> >>
> >> When we test the compiler flag, is there a case
> >> where a particular flag depends on -m{32,64} ?
> >>
> >> For example, is there a compiler that supports -fstack-protector
> >> for 64bit mode, but unsupports it for 32bit mode?
> >>
> >>   $(cc-option -m32)                     ->  y
> >>   $(cc-option -m64)                     ->  y
> >>   $(cc-option -fstack-protector)        ->  y
> >>   $(cc-option -m32 -fstack-protector)   ->  n
> >>   $(cc-option -m64 -fstack-protector)   ->  y
> >>
> >> I guess this is unlikely to happen,
> >> but I am not whether it is zero possibility.
> >>
> >> If this could happen,
> >> $(cc-option ) must be evaluated together with
> >> correct bi-arch option (either -m32 or -m64).
> >>
> >>
> >> Currently, -m32/-m64 is specified in Makefile,
> >> but we are moving compiler tests to Kconfig
> >> and, CONFIG_64BIT can be dynamically toggled in Kconfig.
> >
> > I don't think it can happen for this particular combination (stack protector
> > and word size), but I'm sure we'll eventually run into options that
> > need to be tested in combination. For the current CFLAGS_KERNEL
> > setting, we definitely have the case of needing the variables to be
> > evaluated in a specific order.
> >
> 
> 
> 
> 
> I was thinking of how we can handle complex cases
> in the current approach.
> 
> 
> 
> (Case 1)
> 
> Compiler flag -foo and -bar interacts, so
> we also need to check the combination of the two.
> 
> 
> config CC_HAS_FOO
>         def_bool $(cc-option -foo)
> 
> config CC_HAS_BAR
>         def_bool $(cc-option -bar)
> 
> config CC_HAS_FOO_WITH_BAR
>         def_bool $(cc-option -foo -bar)
> 
> 
> 
> (Case 2)
> Compiler flag -foo is sensitive to word-size.
> So, we need to test this option together with -m32/-m64.
> User can toggle CONFIG_64BIT, like i386/x86_64.
> 
> 
> config CC_NEEDS_M64
>           def_bool $(cc-option -m64) && 64BIT
> 
> config CC_NEEDS_M32
>           def_bool $(cc-option -m32) && !64BIT
> 
> config CC_HAS_FOO
>          bool
>          default $(cc-option -m64 -foo) if CC_NEEDS_M64
>          default $(cc-option -m32 -foo) if CC_NEEDS_M32
>          default $(cc-option -foo)
> 
> 
> 
> (Case 3)
> Compiler flag -foo is sensitive to endian-ness.
> 
> 
> config CC_NEEDS_BIG_ENDIAN
>           def_bool $(cc-option -mbig-endian) && CPU_BIG_ENDIAN
> 
> config CC_NEEDS_LITTLE_ENDIAN
>           def_bool $(cc-option -mlittle-endian) && CPU_LITTLE_ENDIAN
> 
> config CC_HAS_FOO
>          bool
>          default $(cc-option -mbig-endian -foo) if CC_NEEDS_BIG_ENDIAN
>          default $(cc-option -mlittle-endian -foo) if CC_NEEDS_LITTLE_ENDIAN
>          default $(cc-option -foo)
> 
> 
> 
> 
> Hmm, I think I can implement those somehow.
> But, I hope we do not have many instances like this...
> 
> 
> If you know more naive cases, please share your knowledge.
> 
> Thanks!
> 
> 
> -- 
> Best Regards
> Masahiro Yamada

Would get pretty bad if a test needs to consider multiple symbols.
Exponential explosion there...


I thought some more about the implementation of dynamic (post-parsing)
functions to see how bad it would get with the current implementation.

Some background on how things work now:

  1. All expression operands in Kconfig are symbols.

  2. Returning '$ENV' or '$(fn foo)' as a T_WORD during parsing gets
     you symbols with those strings as names and S_UNKNOWN type (because
     they act like references to undefined symbols).

  3. For "foo-$(fn foo)", you also get a symbol with that string as its
     name and S_UNKNOWN type (stored among the SYMBOL_CONST symbols)

  4. Symbols with S_UNKNOWN type get their name as their string value,
     and the tristate value n.

So, if you do string expansion on the names of symbols with S_UNKNOWN
type in sym_calc_value(), you're almost there with the current
implementation, except for the tristate case.

Maybe you could set the tristate value of S_UNKNOWN symbols depending on
the string value you end up with. Things are getting pretty confusing at
that point.

Could have something like S_DYNAMIC as well. More Kconfig complexity...

Then there's other complications:

  1. SYMBOL_CONST is no longer constant.

  2. Dependency loop detection needs to consider symbol references
     within strings.

  3. Dependency loop detection relies on static knowledge of what
     symbols a symbol depends on. That might get messy for certain
     expansions, though it might be things you wouldn't do in practice.

  4. Symbols still need to be properly invalidated. It looks like at
     least menuconfig just does a dumb invalidate-everything whenever
     the value of a symbol is changed though, so it might not require
     extra work. (Bit messier in Kconfiglib, which does minimal
     invalidation to keep scripts fast, but just need to extract a few
     extra deps there.)


It looks like dynamic functions could get quite messy, but might be
doable if absolutely required. There's probably more devils in the
details though.

I don't think the static function model precludes switching models later
btw, when people have more experience.

Cheers,
Ulf
