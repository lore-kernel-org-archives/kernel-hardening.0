Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Mon, 09 Nov 2015 11:02:47 +0100
Message-ID: <87h9kvze0o.fsf@rasmusvillemoes.dk>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 07 2015, Quentin Casasnovas <quentin.casasnovas@oracle.com> wrote:

> On 2015-11-06, Kees Cook <keescook@chromium.org> wrote:
>> On Fri, Nov 6, 2015 at 8:00 AM, Quentin Casasnovas
>><quentin.casasnovas@oracle.com> wrote:
>>>>
>>>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>>>> gcc plugin, which will also get us the gcc plugin infrastructure.
>>>> Other people, please speak up on what you'd like to tackle.
>>>>
>>>
>>> Not that it's complex but I already have a branch with the gcc plugin
>>> infrastructure split up if you're interested and you reckon that can save
>>> you some time.
>>
>> Sure, what's the URL?
>> 
>
> I've pushed the three of them onto:
>
>   https://github.com/casasnovas/linux/commits/quentin-spk-gcc-plugin
>
> It lacks Documentation for now, but you can have a look at the branch
> quentin-fuzz-gccplugin which adds an instrumentation plugin (converted from
> the gcc patch[1] Dmitry Vyukov wrote for syzkaller[2]).
>
> Adding a plugin should be simple, add its name to $(HOSTLIBS)-y, and use
> the regular kbuild system way to specify from which source files it is
> built, CFLAGS, etc.
>
>   $(HOSTLIBS)-y = foo.so
>   foo-objs = foo.c bar.c
>
> And then to have some compilations units be compiled using foo.so, they
> just need the following in their CFLAGS:
>
>  -fplugin=$(objtree)/path/to/foo.so

Nice, thanks. But wouldn't it be even more userfriendly to have these
things driven by Kconfig? So let (use of) each plugin depend on a
CONFIG_GCCPLUGIN_XYZ variable, which will automatically turn itself off
(with a warning) if that plugin can't be used for whatever
reason. That'll also give a natural place to say a little about the
plugin (though I also think Documentation/gccplugins/* should be
created). We could hide these behind CONFIG_USE_GCCPLUGINS to make it
easy for people to turn off.

I suppose some plugins are really all-or-nothing (e.g. when randomizing
structs, the various TUs better agree on what shuffling has been done),
so for them it doesn't make sense to apply to individual C files. Is
something done to ensure that, and if not, can it be done with some
linker magic? (Something like putting a hash of the used random seed in
each object file and make the linker complain if there are distinct
definitions of that magic symbol.)

Rasmus
