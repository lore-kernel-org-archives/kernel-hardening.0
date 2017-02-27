From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 12:42:58 -0800
Message-Id: <1488228186-110679-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC] Introduce rare_write() infrastructure
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is an RFC series to demonstrate a possible infrastructure for the
"write rarely" memory storage type in the kernel (patch 1). The intent
is to further reduce the internal attack surface of the kernel by making
more variables read-only while "at rest". This is strongly based on the
"__read_only" portion of the KERNEXEC infrastructure from PaX/grsecurity,
though I tried to adjust it to be more in line with ideas Mark Rutland had
about how it might work upstream.

Also included is the PaX/grsecurity constify plugin (patch 7) which will
automatically make all instances of certain structures read-only, to help
demonstrate more complex cases of "write rarely" targets. (The plugin in
this series is altered to only operate on marked structures, rather than
the full automatic constification.)

As part of the series I've included both x86 support (patch 4), exactly
as done in PaX, and ARM support (patch 5), similar to what is done in
grsecurity but without support for earlier ARM CPUs. Both are lightly
tested by me, but have lived through 0-day build testing over the weekend.

I've added an lkdtm test (patch 2), though it needs to be reorganized
since its failure case is inverted from what would normally be expected
for lkdtm. It does, however, serve as a stand-alone example of the new
infrastructure.

Included are two example "conversions" to the rare_write()-style of
variable manipulation: a simple one, which switches the inet diag handler
table to write-rarely during register/unregister calls (patch 3), and
a more complex one: cgroup types (patch 8), which is made read-only via
the constify plugin. The latter uses rare-write linked lists (patch 6)
and multi-field updates. Both examples are refactorings of what already
appears in PaX/grsecurity.

It may make sense to also return to PaX's original interface (using
assignments instead of a function-like macro), to avoid false positives
from coccinelle[1], and to allow for assignment operators instead of
longer-form assignments ("rare_write(thing->field, thing->field | FLAG)"
is ugly compared to "const_cast(thing->field) |= FLAG").

The patches are:

	[PATCH 1/8] Introduce rare_write() infrastructure
	[PATCH 2/8] lkdtm: add test for rare_write() infrastructure
	[PATCH 3/8] net: switch sock_diag handlers to rare_write()
	[PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
	[PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
	[PATCH 6/8] list: add rare_write() list helpers
	[PATCH 7/8] gcc-plugins: Add constify plugin
	[PATCH 8/8] cgroups: force all struct cftype const

Let's hammer out the issues...

-Kees

[1] https://lists.01.org/pipermail/kbuild-all/2017-February/031316.html
