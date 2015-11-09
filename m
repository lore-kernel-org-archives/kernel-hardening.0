Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org> <87h9kvze0o.fsf@rasmusvillemoes.dk>
	<20151109103315.GB19735@chrystal.uk.oracle.com>
Date: Mon, 09 Nov 2015 20:24:31 +0100
In-Reply-To: <20151109103315.GB19735@chrystal.uk.oracle.com> (Quentin
	Casasnovas's message of "Mon, 9 Nov 2015 11:33:15 +0100")
Message-ID: <87bnb3ou1c.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09 2015, Quentin Casasnovas <quentin.casasnovas@oracle.com> wrote:

>> >
>> > Adding a plugin should be simple, add its name to $(HOSTLIBS)-y, and use
>> > the regular kbuild system way to specify from which source files it is
>> > built, CFLAGS, etc.
>> >
>> >   $(HOSTLIBS)-y = foo.so
>> >   foo-objs = foo.c bar.c
>> >
>> > And then to have some compilations units be compiled using foo.so, they
>> > just need the following in their CFLAGS:
>> >
>> >  -fplugin=$(objtree)/path/to/foo.so
>> 
>> Nice, thanks. But wouldn't it be even more userfriendly to have these
>> things driven by Kconfig? So let (use of) each plugin depend on a
>> CONFIG_GCCPLUGIN_XYZ variable, which will automatically turn itself off
>> (with a warning) if that plugin can't be used for whatever
>> reason. That'll also give a natural place to say a little about the
>> plugin (though I also think Documentation/gccplugins/* should be
>> created). We could hide these behind CONFIG_USE_GCCPLUGINS to make it
>> easy for people to turn off.
>> 
>
> Ah agreed, this was just so people could get started quickly.  The way to
> do this is to include your plugin flags inside the Makefile variable
> GCC_PLUGIN_CFLAGS, which is exported and stuffed to the KBUILD_CFLAGS.
>
> So if you have plugin foo.so that you want to be used for all of the
> compilation units (and which depends on CONFIG_FOO), then it should be as
> simple as doing this in the top-level Makefile:
>
> ifeq ($(CONFIG_FOO),y)
>  GCC_PLUGIN_CFLAGS += -fplugin=$(objtree)/path/to/foo.so
> endif
>
> The grsecurity/PaX patchset already deals with gcc version and
> GCC_PLUGIN_CFLAGS will only be exported if your gcc version supports
> plugins, otherwise it'll dump a warning and carry on compiling your kernel.
>
> Hope that clarifies things :)

It does.

It would be nice if the plugin infrastructure was as self-contained as
possible, and to get whatever is decided acked by the kbuild maintainers
and Linus well before 4.5.

Is it possible to make a scheme where existing files are touched as
little as possible? E.g. putting all the makefile magic in
e.g. scripts/Makefile.plugins, the Kconfig symbols in
lib/Kconfig.plugins, and the source of the plugins are in lib/plugins/
(at first just in that single directory, which will also make sharing
code between the plugins slightly easier).

Rasmus
