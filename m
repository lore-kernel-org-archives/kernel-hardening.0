From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:15:52 -0700
Message-Id: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2] Introduce rare_write() infrastructure
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

This is take 2 of an RFC series to demonstrate a possible infrastructure
for the "write rarely" memory storage type in the kernel (patch 1). The
intent is to further reduce the internal attack surface of the kernel
by making more variables read-only while "at rest". This is heavily
based on the "__read_only" portion of the KERNEXEC infrastructure from
PaX/grsecurity, though I tried to adjust it to be more in line with
the upstream discussions around the APIs.

Also included is the PaX/grsecurity constify plugin (patch 10) which will
automatically make all instances of certain structures read-only, to help
demonstrate more complex cases of "write rarely" targets. (The plugin in
this series is altered to only operate on marked structures, rather than
the full automatic constification.)

As part of the series I've included both x86 support (patch 4), exactly
as done in PaX, and ARM support (patches 5-7), similar to what is done in
grsecurity but without support for earlier ARM CPUs. Both are lightly
tested by me, though they need a bit more work, especially ARM as it is
missing the correct domain marking for kernel modules.

I've added an lkdtm test (patch 2), which serves as a stand-alone example
of the new infrastructure.

Included are two example "conversions" to the rare_write()-style of
variable manipulation: a simple one, which switches the inet diag handler
table to write-rarely during register/unregister calls (patch 3), and
a more complex one: cgroup types (patch 11), which is made read-only via
the constify plugin. The latter uses rare-write linked lists (patch 9)
and multi-field updates. Both examples are refactorings of what already
appears in PaX/grsecurity.

The patches are:

	[PATCH 01/11] Introduce rare_write() infrastructure
	[PATCH 02/11] lkdtm: add test for rare_write() infrastructure
	[PATCH 03/11] net: switch sock_diag handlers to rare_write()
	[PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
	[PATCH 05/11] ARM: mm: dump: Add domain to output
	[PATCH 06/11] ARM: domains: Extract common USER domain init
	[PATCH 07/11] ARM: mm: set DOMAIN_WR_RARE for rodata
	[PATCH 08/11] ARM: Implement __arch_rare_write_begin/unmap()
	[PATCH 09/11] list: add rare_write() list helpers
	[PATCH 10/11] gcc-plugins: Add constify plugin
	[PATCH 11/11] cgroups: force all struct cftype const

-Kees
