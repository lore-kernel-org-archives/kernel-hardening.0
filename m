Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 11:33:15 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151109103315.GB19735@chrystal.uk.oracle.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <n1iirh$q7o$1@ger.gmane.org>
 <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
 <n1khkt$lc7$1@ger.gmane.org>
 <87h9kvze0o.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h9kvze0o.fsf@rasmusvillemoes.dk>
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09, 2015 at 11:02:47AM +0100, Rasmus Villemoes wrote:
> On Sat, Nov 07 2015, Quentin Casasnovas <quentin.casasnovas@oracle.com> wrote:
> 
> > On 2015-11-06, Kees Cook <keescook@chromium.org> wrote:
> >> On Fri, Nov 6, 2015 at 8:00 AM, Quentin Casasnovas
> >><quentin.casasnovas@oracle.com> wrote:
> >>>>
> >>>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
> >>>> gcc plugin, which will also get us the gcc plugin infrastructure.
> >>>> Other people, please speak up on what you'd like to tackle.
> >>>>
> >>>
> >>> Not that it's complex but I already have a branch with the gcc plugin
> >>> infrastructure split up if you're interested and you reckon that can save
> >>> you some time.
> >>
> >> Sure, what's the URL?
> >> 
> >
> > I've pushed the three of them onto:
> >
> >   https://github.com/casasnovas/linux/commits/quentin-spk-gcc-plugin
> >
> > It lacks Documentation for now, but you can have a look at the branch
> > quentin-fuzz-gccplugin which adds an instrumentation plugin (converted from
> > the gcc patch[1] Dmitry Vyukov wrote for syzkaller[2]).
> >
> > Adding a plugin should be simple, add its name to $(HOSTLIBS)-y, and use
> > the regular kbuild system way to specify from which source files it is
> > built, CFLAGS, etc.
> >
> >   $(HOSTLIBS)-y = foo.so
> >   foo-objs = foo.c bar.c
> >
> > And then to have some compilations units be compiled using foo.so, they
> > just need the following in their CFLAGS:
> >
> >  -fplugin=$(objtree)/path/to/foo.so
> 
> Nice, thanks. But wouldn't it be even more userfriendly to have these
> things driven by Kconfig? So let (use of) each plugin depend on a
> CONFIG_GCCPLUGIN_XYZ variable, which will automatically turn itself off
> (with a warning) if that plugin can't be used for whatever
> reason. That'll also give a natural place to say a little about the
> plugin (though I also think Documentation/gccplugins/* should be
> created). We could hide these behind CONFIG_USE_GCCPLUGINS to make it
> easy for people to turn off.
> 

Ah agreed, this was just so people could get started quickly.  The way to
do this is to include your plugin flags inside the Makefile variable
GCC_PLUGIN_CFLAGS, which is exported and stuffed to the KBUILD_CFLAGS.

So if you have plugin foo.so that you want to be used for all of the
compilation units (and which depends on CONFIG_FOO), then it should be as
simple as doing this in the top-level Makefile:

ifeq ($(CONFIG_FOO),y)
 GCC_PLUGIN_CFLAGS += -fplugin=$(objtree)/path/to/foo.so
endif

The grsecurity/PaX patchset already deals with gcc version and
GCC_PLUGIN_CFLAGS will only be exported if your gcc version supports
plugins, otherwise it'll dump a warning and carry on compiling your kernel.

Hope that clarifies things :)

> 
> I suppose some plugins are really all-or-nothing (e.g. when randomizing
> structs, the various TUs better agree on what shuffling has been done),
> so for them it doesn't make sense to apply to individual C files.

It was probably a bad example on my side, you'll probably indeed compile
your plugins for the whole kernel as opposed to per-file (it's just that
I'm using the instrumentation plugin from syzkaller on just a few files at
the moment.. so it's the first example that came to my mind).

> Is something done to ensure that, and if not, can it be done with some
> linker magic? (Something like putting a hash of the used random seed in
> each object file and make the linker complain if there are distinct
> definitions of that magic symbol.)
>

I believe/hope the kernel would have trouble booting if there was such a
disreptancy here, though this check sounds like a sensible thing to add to
be notified early of such unexpected cases!

Quentin
