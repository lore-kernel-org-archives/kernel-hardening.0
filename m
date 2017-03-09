Date: Wed, 8 Mar 2017 18:42:29 -0800
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170309024229.GA6638@hopstrocity>
References: <CAL_7pOJU751gDD9xHqP4Vs=BCBoa9xqLHUrTZEWxF4nkDra86Q@mail.gmail.com>
 <CAGXu5jKNhZtoP-8DxG+_NsTVCMo-ZLV8E1xPMWgEn=71kTJ4rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNhZtoP-8DxG+_NsTVCMo-ZLV8E1xPMWgEn=71kTJ4rw@mail.gmail.com>
Subject: Re: [kernel-hardening] Ahoy!
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Kees,

On Wed, Mar 08, 2017 at 03:17:55PM -0800, Kees Cook wrote:
> On Tue, Mar 7, 2017 at 3:37 PM, Tycho Andersen <tycho@docker.com> wrote:
> > I'm a new engineer at Docker, and I've been given some time to work on
> > kernel security, so I figured I'd introduce myself here. I'm currently
> > trying to figure out what a good first small-ish project that matches up
> > with the company's interests (containers, infrastructure that is used for
> > security primitives like eBPF).
> >
> > Thoughts about areas to poke at are much appreciated!
> 
> Hi! Welcome to the fun!
> 
> As I understand it (for our earlier chat), Docker is mainly x86, which
> somewhat limits choices from the existing KSPP TODO list which has a
> lot of arm and arm64 stuff on it. :)

Yes, unfortunately :(.

> So, here's one that isn't protection exactly, but rather a requested
> arrangement of Kconfig logic: it would be nice if HARDENED_USERCOPY
> depended on !DEVKMEM and STRICT_DEVMEM=y, but this isn't quite trivial
> since STRICT_DEVMEM doesn't exist for all architectures, but maybe it
> should be looking at ARCH_HAS_DEVMEM_IS_ALLOWED... (it seems Dan
> Williams cleaned this up a lot already in commit 21266be9ed542)
> 
> Regardless, no one has snagged this to make sure that hardened
> usercopy isn't bypassed by things like DEVKMEM or DEVMEM and the lack
> of STRICT_DEVMEM. I'd like to have that off the list, and mostly I
> think it just requires staring at the Kconfigs for a bit to figure out
> the right combination so that people wanting hardened usercopy don't
> accidentally undermine themselves.

Yeah, I think it is fairly simple. Does the attached patch look like
what you had in mind? I can send out a real version to the right
people if it looks reasonable.

> So, that's the first thing that pops out at me. What do you think? :)

I was curious about PAX_MEMORY_STACKLEAK, actually. I noticed in the
initial KSPP announcement email you mentioned it, and it's not clear
to me that anything actually got merged for it.

I understand in principle what needs to happen, but I'm not sure I
understand why a gcc plugin is required. Anyway, it seems like a
small-ish change (that could be hid behind a sysctl or a compiler
flag) that is reasonable enough to start with. Thoughts?

Thanks,

Tycho

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-security-Kconfig-further-restrict-HARDENED_USERCOPY.patch"

>From 96f0e3764bb3c764cd103b2829ab10176cf5b8c7 Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@docker.com>
Date: Wed, 8 Mar 2017 16:19:26 -0800
Subject: [PATCH] security/Kconfig: further restrict HARDENED_USERCOPY

It doesn't make sense to have HARDENED_USERCOPY when either /dev/kmem is
enabled or /dev/mem can be used to read kernel memory.

Signed-off-by: Tycho Andersen <tycho@docker.com>
---
 security/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/Kconfig b/security/Kconfig
index d900f47..8ff32d3 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -137,6 +137,7 @@ config HARDENED_USERCOPY
 	bool "Harden memory copies between kernel and userspace"
 	depends on HAVE_ARCH_HARDENED_USERCOPY
 	depends on HAVE_HARDENED_USERCOPY_ALLOCATOR
+	depends on !DEVKMEM && (!ARCH_HAS_DEVMEM_IS_ALLOWED || STRICT_DEVMEM)
 	select BUG
 	help
 	  This option checks for obviously wrong memory regions when
-- 
2.7.4


--Qxx1br4bt0+wmkIi--
