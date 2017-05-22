From: Daniel Axtens <dja@axtens.net>
Date: Mon, 22 May 2017 11:32:31 +1000
Message-Id: <20170522013233.21780-1-dja@axtens.net>
Subject: [kernel-hardening] [PATCH 0/2] powerpc: fortify support
To: kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Cc: Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

This series provides arch-specific support for Daniel Micay's
fortified string functions on powerpc.

Fortified string functions provied some compile and run time bounds
checking on commonly used string functions.

It's cool - currently it picks up a lot of random things so it will
require some more work across the tree, but hopefully it will
eventually hit mainline. These patches make powerpc ready for when it
does.

They've been tested on pseries.

I think patch 1 should probably go through Kees to line up with the
fortify patch itself, but patch 2 can apply to powerpc as is. But up
to you, mpe.

Regards,
Daniel

Daniel Axtens (2):
  powerpc: Don't fortify prom_init
  powerpc: Make feature-fixup tests fortify-safe

 arch/powerpc/kernel/prom_init.c   |   3 +
 arch/powerpc/lib/feature-fixups.c | 180 +++++++++++++++++++-------------------
 2 files changed, 93 insertions(+), 90 deletions(-)

-- 
2.11.0
