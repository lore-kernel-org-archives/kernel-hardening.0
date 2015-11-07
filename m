Reply-To: kernel-hardening@lists.openwall.com
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Date: Sat, 7 Nov 2015 09:52:29 +0000 (UTC)
Message-ID: <n1khkt$lc7$1@ger.gmane.org>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <n1iirh$q7o$1@ger.gmane.org>
 <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2015-11-06, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Nov 6, 2015 at 8:00 AM, Quentin Casasnovas
><quentin.casasnovas@oracle.com> wrote:
>>>
>>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>>> gcc plugin, which will also get us the gcc plugin infrastructure.
>>> Other people, please speak up on what you'd like to tackle.
>>>
>>
>> Not that it's complex but I already have a branch with the gcc plugin
>> infrastructure split up if you're interested and you reckon that can save
>> you some time.
>
> Sure, what's the URL?
> 

I've pushed the three of them onto:

  https://github.com/casasnovas/linux/commits/quentin-spk-gcc-plugin

It lacks Documentation for now, but you can have a look at the branch
quentin-fuzz-gccplugin which adds an instrumentation plugin (converted from
the gcc patch[1] Dmitry Vyukov wrote for syzkaller[2]).

Adding a plugin should be simple, add its name to $(HOSTLIBS)-y, and use
the regular kbuild system way to specify from which source files it is
built, CFLAGS, etc.

  $(HOSTLIBS)-y = foo.so
  foo-objs = foo.c bar.c

And then to have some compilations units be compiled using foo.so, they
just need the following in their CFLAGS:

 -fplugin=$(objtree)/path/to/foo.so


  [1] https://codereview.appspot.com/267910043
  [2] https://github.com/google/syzkaller

All of this is taken from the grsecurity/PaX Team patchset.

>
> I actually think that just splitting out features might be a good
> first step all around. Most folks aren't very familiar with the
> PaX/Grsec patches, and they, in their monolithic nature, can be hard
> to understand. Many depend on each other, but some are separable.
>

Agreed, that should be a required step before people can review.

> I'm also hoping Emese Revfy[1] might be interested in driving
> PAX_SIZE_OVERFLOW too, which would be terrific, since she's way more
> qualified than me to do it. /me awaits emails. :)
>
> -Kees
>
> [1] https://github.com/ephox-gcc-plugins/size_overflow
>

Quentin
