Date: Tue, 13 Mar 2018 14:10:12 -0700
From: =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
Subject: [PATCH] btree: avoid variable-length allocations
Message-ID: <20180313211012.GB29976@cork>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <tobin@apporbit.com>, "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

I agree that the code is garbage.  In my defense, creating generic
iterator-type functions for multiple data types appears to be one of the
hardest problems in CS with many bad examples of what not to do.

Patch below should fix it.  We have tcm_qla2xxx systems, so I will stick
it into our test system as well.

Jörn

--
It is a cliché that most clichés are true, but then, like most clichés,
that cliché is untrue.
-- Stephen Fry

>From 0077d19b11ec27c3287787d2413b26fc4cf0b3ca Mon Sep 17 00:00:00 2001
From: Joern Engel <joern@purestorage.com>
Date: Tue, 13 Mar 2018 11:36:49 -0700
Subject: [PATCH] btree: avoid variable-length allocations

geo->keylen cannot be larger than 4.  So we might as well make
fixed-size allocations.

Given the one remaining user, geo->keylen cannot even be larger than 1.
Logfs used to have 64bit and 128bit keys, tcm_qla2xxx only has 32bit
keys.  But let's not break the code if we don't have to.

Signed-off-by: Joern Engel <joern@purestorage.com>
---
 lib/btree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/btree.c b/lib/btree.c
index f93a945274af..590facba2c50 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2007-2008 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2007-2008 Joern Engel <joern@purestorage.com>
  * Bits and pieces stolen from Peter Zijlstra's code, which is
  * Copyright 2007, Red Hat Inc. Peter Zijlstra
  * GPLv2
@@ -76,6 +76,8 @@ struct btree_geo btree_geo128 = {
 };
 EXPORT_SYMBOL_GPL(btree_geo128);
 
+#define MAX_KEYLEN	(2 * LONG_PER_U64)
+
 static struct kmem_cache *btree_cachep;
 
 void *btree_alloc(gfp_t gfp_mask, void *pool_data)
@@ -313,7 +315,7 @@ void *btree_get_prev(struct btree_head *head, struct btree_geo *geo,
 {
 	int i, height;
 	unsigned long *node, *oldnode;
-	unsigned long *retry_key = NULL, key[geo->keylen];
+	unsigned long *retry_key = NULL, key[MAX_KEYLEN];
 
 	if (keyzero(geo, __key))
 		return NULL;
@@ -639,8 +641,8 @@ EXPORT_SYMBOL_GPL(btree_remove);
 int btree_merge(struct btree_head *target, struct btree_head *victim,
 		struct btree_geo *geo, gfp_t gfp)
 {
-	unsigned long key[geo->keylen];
-	unsigned long dup[geo->keylen];
+	unsigned long key[MAX_KEYLEN];
+	unsigned long dup[MAX_KEYLEN];
 	void *val;
 	int err;
 
-- 
2.15.1
