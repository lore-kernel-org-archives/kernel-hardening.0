Message-Id: <20180422162512.363154748@linutronix.de>
Date: Sun, 22 Apr 2018 18:23:46 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 01/10] rslib: Add GFP aware init function
References: <20180422162345.004292133@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=rslib--Add-GFP-aware-init-function.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Neil Brown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

The rslib usage in dm/verity_fec is broken because init_rs() can nest in
GFP_NOIO mempool allocations as init_rs() is invoked from the mempool alloc
callback.

Provide a variant which takes gfp_t flags as argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Neil Brown <neilb@suse.com>
---
 include/linux/rslib.h           |   26 +++++++++++++++++++++++---
 lib/reed_solomon/reed_solomon.c |   36 ++++++++++++++++++++----------------
 2 files changed, 43 insertions(+), 19 deletions(-)

--- a/include/linux/rslib.h
+++ b/include/linux/rslib.h
@@ -77,10 +77,30 @@ int decode_rs16(struct rs_control *rs, u
 #endif
 
 /* Create or get a matching rs control structure */
-struct rs_control *init_rs(int symsize, int gfpoly, int fcr, int prim,
-			   int nroots);
+struct rs_control *init_rs_gfp(int symsize, int gfpoly, int fcr, int prim,
+			       int nroots, gfp_t gfp);
+
+/**
+ * init_rs - Create a RS control struct and initialize it
+ *  @symsize:	the symbol size (number of bits)
+ *  @gfpoly:	the extended Galois field generator polynomial coefficients,
+ *		with the 0th coefficient in the low order bit. The polynomial
+ *		must be primitive;
+ *  @fcr:	the first consecutive root of the rs code generator polynomial
+ *		in index form
+ *  @prim:	primitive element to generate polynomial roots
+ *  @nroots:	RS code generator polynomial degree (number of roots)
+ *
+ * Allocations use GFP_KERNEL.
+ */
+static inline struct rs_control *init_rs(int symsize, int gfpoly, int fcr,
+					 int prim, int nroots)
+{
+	return init_rs_gfp(symsize, gfpoly, fcr, prim, nroots, GFP_KERNEL);
+}
+
 struct rs_control *init_rs_non_canonical(int symsize, int (*func)(int),
-                                         int fcr, int prim, int nroots);
+					 int fcr, int prim, int nroots);
 
 /* Release a rs control structure */
 void free_rs(struct rs_control *rs);
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -59,19 +59,20 @@ static DEFINE_MUTEX(rslistlock);
  * @fcr:	first root of RS code generator polynomial, index form
  * @prim:	primitive element to generate polynomial roots
  * @nroots:	RS code generator polynomial degree (number of roots)
+ * @gfp:	GFP_ flags for allocations
  *
  * Allocate a control structure and the polynom arrays for faster
  * en/decoding. Fill the arrays according to the given parameters.
  */
 static struct rs_control *rs_init(int symsize, int gfpoly, int (*gffunc)(int),
-                                  int fcr, int prim, int nroots)
+				  int fcr, int prim, int nroots, gfp_t gfp)
 {
 	struct rs_control *rs;
 	int i, j, sr, root, iprim;
 
 	/* Allocate the control structure */
-	rs = kmalloc(sizeof (struct rs_control), GFP_KERNEL);
-	if (rs == NULL)
+	rs = kmalloc(sizeof(*rs), gfp);
+	if (!rs)
 		return NULL;
 
 	INIT_LIST_HEAD(&rs->list);
@@ -85,15 +86,15 @@ static struct rs_control *rs_init(int sy
 	rs->gffunc = gffunc;
 
 	/* Allocate the arrays */
-	rs->alpha_to = kmalloc(sizeof(uint16_t) * (rs->nn + 1), GFP_KERNEL);
+	rs->alpha_to = kmalloc(sizeof(uint16_t) * (rs->nn + 1), gfp);
 	if (rs->alpha_to == NULL)
 		goto errrs;
 
-	rs->index_of = kmalloc(sizeof(uint16_t) * (rs->nn + 1), GFP_KERNEL);
+	rs->index_of = kmalloc(sizeof(uint16_t) * (rs->nn + 1), gfp);
 	if (rs->index_of == NULL)
 		goto erralp;
 
-	rs->genpoly = kmalloc(sizeof(uint16_t) * (rs->nroots + 1), GFP_KERNEL);
+	rs->genpoly = kmalloc(sizeof(uint16_t) * (rs->nroots + 1), gfp);
 	if(rs->genpoly == NULL)
 		goto erridx;
 
@@ -195,13 +196,14 @@ void free_rs(struct rs_control *rs)
  *		in index form
  *  @prim:	primitive element to generate polynomial roots
  *  @nroots:	RS code generator polynomial degree (number of roots)
+ *  @gfp:	GFP_ flags for allocations
  */
 static struct rs_control *init_rs_internal(int symsize, int gfpoly,
-                                           int (*gffunc)(int), int fcr,
-                                           int prim, int nroots)
+					   int (*gffunc)(int), int fcr,
+					   int prim, int nroots, gfp_t gfp)
 {
-	struct list_head	*tmp;
-	struct rs_control	*rs;
+	struct list_head *tmp;
+	struct rs_control *rs;
 
 	/* Sanity checks */
 	if (symsize < 1)
@@ -236,7 +238,7 @@ static struct rs_control *init_rs_intern
 	}
 
 	/* Create a new one */
-	rs = rs_init(symsize, gfpoly, gffunc, fcr, prim, nroots);
+	rs = rs_init(symsize, gfpoly, gffunc, fcr, prim, nroots, gfp);
 	if (rs) {
 		rs->users = 1;
 		list_add(&rs->list, &rslist);
@@ -247,7 +249,7 @@ static struct rs_control *init_rs_intern
 }
 
 /**
- * init_rs - Find a matching or allocate a new rs control structure
+ * init_rs_gfp - Find a matching or allocate a new rs control structure
  *  @symsize:	the symbol size (number of bits)
  *  @gfpoly:	the extended Galois field generator polynomial coefficients,
  *		with the 0th coefficient in the low order bit. The polynomial
@@ -256,11 +258,12 @@ static struct rs_control *init_rs_intern
  *		in index form
  *  @prim:	primitive element to generate polynomial roots
  *  @nroots:	RS code generator polynomial degree (number of roots)
+ *  @gfp:	GFP_ flags for allocations
  */
-struct rs_control *init_rs(int symsize, int gfpoly, int fcr, int prim,
-                           int nroots)
+struct rs_control *init_rs_gfp(int symsize, int gfpoly, int fcr, int prim,
+			       int nroots, gfp_t gfp)
 {
-	return init_rs_internal(symsize, gfpoly, NULL, fcr, prim, nroots);
+	return init_rs_internal(symsize, gfpoly, NULL, fcr, prim, nroots, gfp);
 }
 
 /**
@@ -279,7 +282,8 @@ struct rs_control *init_rs(int symsize,
 struct rs_control *init_rs_non_canonical(int symsize, int (*gffunc)(int),
                                          int fcr, int prim, int nroots)
 {
-	return init_rs_internal(symsize, 0, gffunc, fcr, prim, nroots);
+	return init_rs_internal(symsize, 0, gffunc, fcr, prim, nroots,
+				GFP_KERNEL);
 }
 
 #ifdef CONFIG_REED_SOLOMON_ENC8
