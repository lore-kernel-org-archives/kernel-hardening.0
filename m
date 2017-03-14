MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170313211422.cxtmes35ozkwaisu@docker>
References: <20170313211422.cxtmes35ozkwaisu@docker>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 14 Mar 2017 15:43:53 -0600
Message-ID: <CAGXu5j+T65E6AybgH=B2Fcu-kSdybUfNC+Px32txZqEVzZivtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: stackleak plugin port to upstream kernel
To: Tycho Andersen <tycho@docker.com>
Cc: PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Yay more plugins! :)

In the future please include patches in-line... it's hard to comment
on them if they're attachments. More comments below...

On Mon, Mar 13, 2017 at 3:14 PM, Tycho Andersen <tycho@docker.com> wrote:
> The problem seems to be in the erase_kstack routine in
> arch/x86/entry/entry_64.S, it seems to be looking for a series of 0xBEEFs,
> which aren't found. I'm struggling to figure out where these 0xBEEFs come from:
> are they part of the mainline kernel stack initialization and something has
> gone totally haywire, or is this some PaX thing that I've overlooked?

It looks like the Kconfig renaming wasn't complete, and your build
isn't building/running the plugin at all:

> +config GCC_PLUGIN_STACKLEAK
> +       bool "Zero the kernel stack after syscalls"
> [...]
> +  gcc-plugin-$(CONFIG_PAX_MEMORY_STACKLEAK)            += stackleak_plugin.so$
> +  gcc-plugin-cflags-$(CONFIG_PAX_MEMORY_STACKLEAK)     += -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-lowest-sp=100$

(CONFIG_GCC_PLUGIN_STACKLEAK vs CONFIG_PAX_MEMORY_STACKLEAK)

Also, becareful of #ifdef CONFIG_GCC_PLUGIN_STACKLEAK vs #ifdef
STACKLEAK_PLUGIN. That has gotten confused with some other plugin
ports too.

Otherwise, this looks good for an initial extraction. For the next
version there should probably be more comments on the new functions
for what they do, and detailing for the ARCH_HAS Kconfig for what an
architecture needs to do to correctly implement it (see examples for
seccomp, hardened usercopy, etc), and an attempt made to reduce the
number of #ifdef blocks. For example, instead of:

#ifdef THE_THING
     do_the_thing();
#endif

Build the definition of do_the_thing() with the #ifdef in one place.
In C, this would be:

#ifdef THE_THING
void do_the_thing();
#else
static inline void do_the_thing() { }
#endif

Then do_the_thing() can be included everywhere without the #ifdef
block. (I haven't spent much time looking at what's needed in .S files
to make this happen, but I'm sure there is a similar pattern.)

Oh, and we should probably build a test for this, though lkdtm doesn't
seem like the right place since it's expecting a Bug-style protection.
Maybe something more like lib/test_user_copy.c that just exercises
stuff to see if it's correctly behaving?

Thanks for working on this and sending this for people to look at!

-Kees

-- 
Kees Cook
Pixel Security
