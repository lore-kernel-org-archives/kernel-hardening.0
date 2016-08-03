Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Wed,  3 Aug 2016 14:59:31 +1000
Message-Id: <1470200371-31565-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [PATCH] lkdtm: Mark lkdtm_rodata_do_nothing() notrace
To: Kees Cook <keescook@chromium.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Greg Kroah-Hartman <greg@kroah.com>, kernel-hardening@lists.openwall.com, Anton Blanchard <anton@samba.org>, amodra@gmail.com, Nick Piggin <npiggin@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

lkdtm_rodata_do_nothing() is an empty function which is generated in
order to test the non-executability of rodata.

Currently if function tracing is enabled then an mcount callsite will be
generated for lkdtm_rodata_do_nothing(), and it will appear in the list
of available functions for function tracing (available_filter_functions).

Given it's purpose purely as a test function, it seems preferable for
lkdtm_rodata_do_nothing() to be marked notrace, so it doesn't appear as
traceable.

This also avoids triggering a linker bug on powerpc:

  https://sourceware.org/bugzilla/show_bug.cgi?id=20428

When the linker sees code that needs to generate a call stub, eg. a
branch to mcount(), it assumes the section is executable and
dereferences a NULL pointer leading to a linker segfault. Marking
lkdtm_rodata_do_nothing() notrace avoids triggering the bug because the
function contains no other function calls.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/misc/lkdtm_rodata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm_rodata.c b/drivers/misc/lkdtm_rodata.c
index 166b1db3969f..3564477b8c2d 100644
--- a/drivers/misc/lkdtm_rodata.c
+++ b/drivers/misc/lkdtm_rodata.c
@@ -4,7 +4,7 @@
  */
 #include "lkdtm.h"
 
-void lkdtm_rodata_do_nothing(void)
+void notrace lkdtm_rodata_do_nothing(void)
 {
 	/* Does nothing. We just want an architecture agnostic "return". */
 }
-- 
2.7.4
