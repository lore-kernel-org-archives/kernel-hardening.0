MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAL_7pOJU751gDD9xHqP4Vs=BCBoa9xqLHUrTZEWxF4nkDra86Q@mail.gmail.com>
References: <CAL_7pOJU751gDD9xHqP4Vs=BCBoa9xqLHUrTZEWxF4nkDra86Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Mar 2017 15:17:55 -0800
Message-ID: <CAGXu5jKNhZtoP-8DxG+_NsTVCMo-ZLV8E1xPMWgEn=71kTJ4rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Ahoy!
To: Tycho Andersen <tycho@docker.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 7, 2017 at 3:37 PM, Tycho Andersen <tycho@docker.com> wrote:
> I'm a new engineer at Docker, and I've been given some time to work on
> kernel security, so I figured I'd introduce myself here. I'm currently
> trying to figure out what a good first small-ish project that matches up
> with the company's interests (containers, infrastructure that is used for
> security primitives like eBPF).
>
> Thoughts about areas to poke at are much appreciated!

Hi! Welcome to the fun!

As I understand it (for our earlier chat), Docker is mainly x86, which
somewhat limits choices from the existing KSPP TODO list which has a
lot of arm and arm64 stuff on it. :)

So, here's one that isn't protection exactly, but rather a requested
arrangement of Kconfig logic: it would be nice if HARDENED_USERCOPY
depended on !DEVKMEM and STRICT_DEVMEM=y, but this isn't quite trivial
since STRICT_DEVMEM doesn't exist for all architectures, but maybe it
should be looking at ARCH_HAS_DEVMEM_IS_ALLOWED... (it seems Dan
Williams cleaned this up a lot already in commit 21266be9ed542)

Regardless, no one has snagged this to make sure that hardened
usercopy isn't bypassed by things like DEVKMEM or DEVMEM and the lack
of STRICT_DEVMEM. I'd like to have that off the list, and mostly I
think it just requires staring at the Kconfigs for a bit to figure out
the right combination so that people wanting hardened usercopy don't
accidentally undermine themselves.

So, that's the first thing that pops out at me. What do you think? :)

-Kees

-- 
Kees Cook
Pixel Security
