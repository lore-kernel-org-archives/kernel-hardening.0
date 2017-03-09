MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170309024229.GA6638@hopstrocity>
References: <CAL_7pOJU751gDD9xHqP4Vs=BCBoa9xqLHUrTZEWxF4nkDra86Q@mail.gmail.com>
 <CAGXu5jKNhZtoP-8DxG+_NsTVCMo-ZLV8E1xPMWgEn=71kTJ4rw@mail.gmail.com> <20170309024229.GA6638@hopstrocity>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Mar 2017 22:01:38 -0800
Message-ID: <CAGXu5jKGQ+UDu8LZDou1FfOs_ExuRKTo1M86mEA9EV33QNDEtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Ahoy!
To: Tycho Andersen <tycho@docker.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 8, 2017 at 6:42 PM, Tycho Andersen <tycho@docker.com> wrote:
> Hey Kees,
>
> On Wed, Mar 08, 2017 at 03:17:55PM -0800, Kees Cook wrote:
>> On Tue, Mar 7, 2017 at 3:37 PM, Tycho Andersen <tycho@docker.com> wrote:
>> > I'm a new engineer at Docker, and I've been given some time to work on
>> > kernel security, so I figured I'd introduce myself here. I'm currently
>> > trying to figure out what a good first small-ish project that matches up
>> > with the company's interests (containers, infrastructure that is used for
>> > security primitives like eBPF).
>> >
>> > Thoughts about areas to poke at are much appreciated!
>>
>> Hi! Welcome to the fun!
>>
>> As I understand it (for our earlier chat), Docker is mainly x86, which
>> somewhat limits choices from the existing KSPP TODO list which has a
>> lot of arm and arm64 stuff on it. :)
>
> Yes, unfortunately :(.
>
>> So, here's one that isn't protection exactly, but rather a requested
>> arrangement of Kconfig logic: it would be nice if HARDENED_USERCOPY
>> depended on !DEVKMEM and STRICT_DEVMEM=y, but this isn't quite trivial
>> since STRICT_DEVMEM doesn't exist for all architectures, but maybe it
>> should be looking at ARCH_HAS_DEVMEM_IS_ALLOWED... (it seems Dan
>> Williams cleaned this up a lot already in commit 21266be9ed542)
>>
>> Regardless, no one has snagged this to make sure that hardened
>> usercopy isn't bypassed by things like DEVKMEM or DEVMEM and the lack
>> of STRICT_DEVMEM. I'd like to have that off the list, and mostly I
>> think it just requires staring at the Kconfigs for a bit to figure out
>> the right combination so that people wanting hardened usercopy don't
>> accidentally undermine themselves.
>
> Yeah, I think it is fairly simple. Does the attached patch look like
> what you had in mind? I can send out a real version to the right
> people if it looks reasonable.

Ah, I found the original thread.. https://lkml.org/lkml/2016/9/7/589

Can you add the !MMU case, and then I think it'll be good.

>> So, that's the first thing that pops out at me. What do you think? :)
>
> I was curious about PAX_MEMORY_STACKLEAK, actually. I noticed in the
> initial KSPP announcement email you mentioned it, and it's not clear
> to me that anything actually got merged for it.

That was an example of one of the many plugins in grsecurity, but no
one has looked at upstreaming it yet. Since we've got the gcc
infrastructure in place now, yeah, please take a look; I'd love to add
it.

> I understand in principle what needs to happen, but I'm not sure I
> understand why a gcc plugin is required.

IIUC, the plugin is used to instrument the call depth so that it's an
efficient clearing.

> Anyway, it seems like a
> small-ish change (that could be hid behind a sysctl or a compiler
> flag) that is reasonable enough to start with. Thoughts?

Nothing is ever simple. :) See the #ifdef CONFIG_PAX_MEMORY_STACKLEAK
sections in the x86 entry code, fs/exec.c, etc. And it looks like
additional changes (that lack the config ifdef in processor.h) for
adding the new field to track depth, etc.

(It'd be nice to expand this feature beyond x86 too, but that can be
the next step.)

As far as how to enable id, I would follow the existing Kconfig style
(see how the structleak plugin was added for upstream).

I think it'd be a great addition!

-Kees

-- 
Kees Cook
Pixel Security
