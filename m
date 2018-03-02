Date: Fri, 2 Mar 2018 10:12:01 +0100
From: Ulf Magnusson <ulfalizer@gmail.com>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Message-ID: <20180302091201.veyw5iv2uwvlvs2h@huvuddator>
References: <20180218221352.GA6651@ravnborg.org>
 <CAFkk2KT1krKuDkWt0eHcasfC61fTVQNf-1kqw7icLP9OYGYkXQ@mail.gmail.com>
 <CAK7LNAQH0WD3A3T97gce0xmZpMy0zWxTO2StfNWaDbiqjQg8gg@mail.gmail.com>
 <CAK8P3a2BOQt5Y0B4271WqaJvvWqfxHxD3S6r1i1xONvb+CJ5Dg@mail.gmail.com>
 <CAK7LNARtZcW1v53ridFJK1MULmj8tQT4s+DoRhKj9PrbMri5rQ@mail.gmail.com>
 <CAK8P3a1DrhxWXaEs6E85W5HEhvFr23E-GDsu=0X-sG0pX+PLag@mail.gmail.com>
 <CAK7LNAR3OMh9Q9ZfaBq=FpSJ-+DT5-RH_20ohV-iu34pX9hFKw@mail.gmail.com>
 <20180221213946.w4v6ywy7fbiy6oyc@huvuddator>
 <CAK7LNARd-9KNRTHT3jrNganqLisheAWbDQMGi_ujp+1GpYzSOg@mail.gmail.com>
 <20180302090326.h55wontzv3traxnn@huvuddator>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180302090326.h55wontzv3traxnn@huvuddator>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>, Linux-sh list <linux-sh@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Jeff Dike <jdike@addtoit.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, user-mode-linux-user@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, Michal Marek <michal.lkml@markovi.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 02, 2018 at 10:03:26AM +0100, Ulf Magnusson wrote:
> On Fri, Mar 02, 2018 at 02:50:39PM +0900, Masahiro Yamada wrote:
> > 2018-02-22 6:39 GMT+09:00 Ulf Magnusson <ulfalizer@gmail.com>:
> > > On Wed, Feb 21, 2018 at 09:57:03PM +0900, Masahiro Yamada wrote:
> > >> 2018-02-21 19:52 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> > >> > On Wed, Feb 21, 2018 at 11:20 AM, Masahiro Yamada
> > >> > <yamada.masahiro@socionext.com> wrote:
> > >> >> 2018-02-21 18:56 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> > >> >>> On Wed, Feb 21, 2018 at 8:38 AM, Masahiro Yamada
> > >> >>> <yamada.masahiro@socionext.com> wrote:
> > >> >>>> 2018-02-20 0:18 GMT+09:00 Ulf Magnusson <ulfalizer@gmail.com>:
> > >> >>
> > >> >> Let me clarify my concern.
> > >> >>
> > >> >> When we test the compiler flag, is there a case
> > >> >> where a particular flag depends on -m{32,64} ?
> > >> >>
> > >> >> For example, is there a compiler that supports -fstack-protector
> > >> >> for 64bit mode, but unsupports it for 32bit mode?
> > >> >>
> > >> >>   $(cc-option -m32)                     ->  y
> > >> >>   $(cc-option -m64)                     ->  y
> > >> >>   $(cc-option -fstack-protector)        ->  y
> > >> >>   $(cc-option -m32 -fstack-protector)   ->  n
> > >> >>   $(cc-option -m64 -fstack-protector)   ->  y
> > >> >>
> > >> >> I guess this is unlikely to happen,
> > >> >> but I am not whether it is zero possibility.
> > >> >>
> > >> >> If this could happen,
> > >> >> $(cc-option ) must be evaluated together with
> > >> >> correct bi-arch option (either -m32 or -m64).
> > >> >>
> > >> >>
> > >> >> Currently, -m32/-m64 is specified in Makefile,
> > >> >> but we are moving compiler tests to Kconfig
> > >> >> and, CONFIG_64BIT can be dynamically toggled in Kconfig.
> > >> >
> > >> > I don't think it can happen for this particular combination (stack protector
> > >> > and word size), but I'm sure we'll eventually run into options that
> > >> > need to be tested in combination. For the current CFLAGS_KERNEL
> > >> > setting, we definitely have the case of needing the variables to be
> > >> > evaluated in a specific order.
> > >> >
> > >>
> > >>
> > >>
> > >>
> > >> I was thinking of how we can handle complex cases
> > >> in the current approach.
> > >>
> > >>
> > >>
> > >> (Case 1)
> > >>
> > >> Compiler flag -foo and -bar interacts, so
> > >> we also need to check the combination of the two.
> > >>
> > >>
> > >> config CC_HAS_FOO
> > >>         def_bool $(cc-option -foo)
> > >>
> > >> config CC_HAS_BAR
> > >>         def_bool $(cc-option -bar)
> > >>
> > >> config CC_HAS_FOO_WITH_BAR
> > >>         def_bool $(cc-option -foo -bar)
> > >>
> > >>
> > >>
> > >> (Case 2)
> > >> Compiler flag -foo is sensitive to word-size.
> > >> So, we need to test this option together with -m32/-m64.
> > >> User can toggle CONFIG_64BIT, like i386/x86_64.
> > >>
> > >>
> > >> config CC_NEEDS_M64
> > >>           def_bool $(cc-option -m64) && 64BIT
> > >>
> > >> config CC_NEEDS_M32
> > >>           def_bool $(cc-option -m32) && !64BIT
> > >>
> > >> config CC_HAS_FOO
> > >>          bool
> > >>          default $(cc-option -m64 -foo) if CC_NEEDS_M64
> > >>          default $(cc-option -m32 -foo) if CC_NEEDS_M32
> > >>          default $(cc-option -foo)
> > >>
> > >>
> > >>
> > >> (Case 3)
> > >> Compiler flag -foo is sensitive to endian-ness.
> > >>
> > >>
> > >> config CC_NEEDS_BIG_ENDIAN
> > >>           def_bool $(cc-option -mbig-endian) && CPU_BIG_ENDIAN
> > >>
> > >> config CC_NEEDS_LITTLE_ENDIAN
> > >>           def_bool $(cc-option -mlittle-endian) && CPU_LITTLE_ENDIAN
> > >>
> > >> config CC_HAS_FOO
> > >>          bool
> > >>          default $(cc-option -mbig-endian -foo) if CC_NEEDS_BIG_ENDIAN
> > >>          default $(cc-option -mlittle-endian -foo) if CC_NEEDS_LITTLE_ENDIAN
> > >>          default $(cc-option -foo)
> > >>
> > >>
> > >>
> > >>
> > >> Hmm, I think I can implement those somehow.
> > >> But, I hope we do not have many instances like this...
> > >>
> > >>
> > >> If you know more naive cases, please share your knowledge.
> > >>
> > >> Thanks!
> > >>
> > >>
> > >> --
> > >> Best Regards
> > >> Masahiro Yamada
> > >
> > > Would get pretty bad if a test needs to consider multiple symbols.
> > > Exponential explosion there...
> > >
> > >
> > > I thought some more about the implementation of dynamic (post-parsing)
> > > functions to see how bad it would get with the current implementation.
> > >
> > > Some background on how things work now:
> > >
> > >   1. All expression operands in Kconfig are symbols.
> > >
> > >   2. Returning '$ENV' or '$(fn foo)' as a T_WORD during parsing gets
> > >      you symbols with those strings as names and S_UNKNOWN type (because
> > >      they act like references to undefined symbols).
> > >
> > >   3. For "foo-$(fn foo)", you also get a symbol with that string as its
> > >      name and S_UNKNOWN type (stored among the SYMBOL_CONST symbols)
> > >
> > >   4. Symbols with S_UNKNOWN type get their name as their string value,
> > >      and the tristate value n.
> > >
> > > So, if you do string expansion on the names of symbols with S_UNKNOWN
> > > type in sym_calc_value(), you're almost there with the current
> > > implementation, except for the tristate case.
> > >
> > > Maybe you could set the tristate value of S_UNKNOWN symbols depending on
> > > the string value you end up with. Things are getting pretty confusing at
> > > that point.
> > >
> > > Could have something like S_DYNAMIC as well. More Kconfig complexity...
> > >
> > > Then there's other complications:
> > >
> > >   1. SYMBOL_CONST is no longer constant.
> > >
> > >   2. Dependency loop detection needs to consider symbol references
> > >      within strings.
> > >
> > >   3. Dependency loop detection relies on static knowledge of what
> > >      symbols a symbol depends on. That might get messy for certain
> > >      expansions, though it might be things you wouldn't do in practice.
> > >
> > >   4. Symbols still need to be properly invalidated. It looks like at
> > >      least menuconfig just does a dumb invalidate-everything whenever
> > >      the value of a symbol is changed though, so it might not require
> > >      extra work. (Bit messier in Kconfiglib, which does minimal
> > >      invalidation to keep scripts fast, but just need to extract a few
> > >      extra deps there.)
> > >
> > >
> > > It looks like dynamic functions could get quite messy, but might be
> > > doable if absolutely required. There's probably more devils in the
> > > details though.
> > >
> > > I don't think the static function model precludes switching models later
> > > btw, when people have more experience.
> > 
> > 
> > 
> > I really want to start with the static function model
> > and see if we need the dynamic function implementation.
> 
> Yeah, let's start with static functions, IMO.
> 
> Either we'll learn that they're powerful enough in practice, and save
> ourselves some work, or we'll gain experience for later. Converting from
> static to dynamic functions should be painless, if needed.
> 
> My plan would be something like:
> 
>   1. Implement static functions
> 
>   2. Convert as many simple cases over to them as possible
> 
>   3. See how bad the bad cases get. If they get really bad, then decide
>      what to do next (extend Kconfig, handle them in the Makefiles,
>      etc.)
> 
> > 
> > Here is an idea for the migration path in case
> > we need to do that in the future.
> > 
> > 
> > 
> > Currently, every time user input is given,
> > sym_clear_all_valid() is called.
> > 
> > It is not efficient to blindly re-evaluate expensive $(shell ...)
> 
> I think menuconfig only reevalutes the symbols in the menu that's
> currently shown in the interface (along with their dependencies).
> 
> Maybe that'd be bad enough though.
> 
> > 
> > 
> > So, have a list of symbols the function depends on
> > in its arguments.
> > 
> > For example,
> > 
> > config CC_HAS_SANE_STACKPROTECTOR
> >         def_bool $(shell $srctree/scripts/gcc-has-stack-protector.sh
> > $CC $(1), CFLAGS_BASE)
> > 
> > 
> > Here the first argument
> >   $srctree/scripts/gcc-x86-has-stack-protector.sh $CC $(1)
> > 
> > is the shell command.
> > $(1), $(2), ... will be replaced with the values of symbols (or expressions)
> > that follow when running the shell command.
> > 
> > 
> > The second argument
> > CFLAGS_BASE
> > is the dependency symbol (or expression).
> > 
> > 
> > CFLAGS_BASE can be dynamically changed like
> > 
> > config CFLAGS_BASE
> >         string
> >         default "-m64" if 64BIT
> >         default "-m32"
> > 
> > 
> > When and only when CFLAGS_BASE is updated, the function should be re-calculated.
> > (This will require efforts to minimize the amount of re-evaluation.)
> > 
> > 
> > 
> > 
> > cc-option will be implemented like follows:
> > 
> > macro cc-option $(shell $CC -Werror $$(1) $(1) -c -x c /dev/null -o
> > /dev/null, CFLAGS_BASE)
> > 
> > 
> > 
> > Please notice the difference between $$(1) and $(1).
> > 
> > $(1) is immediately expanded by cc-option macro.
> > 
> > $$(1) is escaped since we want to expand it by $(shell ...), not by
> > $(cc-option ...)
> > 
> > 
> > 
> > For example,
> > 
> >   $(cc-option -fstack-protector)
> > 
> > will be expanded to
> > 
> >   $(shell gcc -Werror $(1) -fstack-protector -c -x c /dev/null -o
> > /dev/null, CFLAGS_BASE)
> > 
> > Since macros are just textual shorthand, so this expansion happens
> > during the parse phase.
> > 
> > 
> > 
> > Then, the evaluation phase does the following every time CFLAGS_BASE is updated.
> > 
> > gcc -Werror [value of CFLAGS_BASE] -fstack-protector -c -x c /dev/null
> > -o /dev/null
> > 
> > 
> > This is a new form of expression, so it will be managed in AST tree
> > with a flag E_SHELL (or E_FUNC) etc.
> > 
> > 
> > Not implemented at all.  Just a rough sketch.
> 
> A simpler syntax like
> 
> 	$(shell $CC -Werror {CFLAGS_BASE} -c -x c /dev/null -o /dev/null)

	*$(shell $CC -Werror {CFLAGS_BASE} -fstack-protector -c -x c /dev/null -o /dev/null)
