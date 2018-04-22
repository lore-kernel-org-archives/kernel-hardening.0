Message-Id: <20180422162512.915544167@linutronix.de>
Date: Sun, 22 Apr 2018 18:23:52 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 07/10] rslib: Simplify error path
References: <20180422162345.004292133@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=rslib--Simplify-error-path.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

The four error path labels in rs_init() can be reduced to one by allocating
the struct with kzalloc so the pointers in the struct are NULL and can be
unconditionally handed in to kfree() because they either point to an
allocation or are NULL.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/reed_solomon/reed_solomon.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -60,8 +60,7 @@ static struct rs_control *rs_init(int sy
 	struct rs_control *rs;
 	int i, j, sr, root, iprim;
 
-	/* Allocate the control structure */
-	rs = kmalloc(sizeof(*rs), gfp);
+	rs = kzalloc(sizeof(*rs), gfp);
 	if (!rs)
 		return NULL;
 
@@ -78,15 +77,15 @@ static struct rs_control *rs_init(int sy
 	/* Allocate the arrays */
 	rs->alpha_to = kmalloc(sizeof(uint16_t) * (rs->nn + 1), gfp);
 	if (rs->alpha_to == NULL)
-		goto errrs;
+		goto err;
 
 	rs->index_of = kmalloc(sizeof(uint16_t) * (rs->nn + 1), gfp);
 	if (rs->index_of == NULL)
-		goto erralp;
+		goto err;
 
 	rs->genpoly = kmalloc(sizeof(uint16_t) * (rs->nroots + 1), gfp);
 	if(rs->genpoly == NULL)
-		goto erridx;
+		goto err;
 
 	/* Generate Galois field lookup tables */
 	rs->index_of[0] = rs->nn;	/* log(zero) = -inf */
@@ -111,7 +110,7 @@ static struct rs_control *rs_init(int sy
 	}
 	/* If it's not primitive, exit */
 	if(sr != rs->alpha_to[0])
-		goto errpol;
+		goto err;
 
 	/* Find prim-th root of 1, used in decoding */
 	for(iprim = 1; (iprim % prim) != 0; iprim += rs->nn);
@@ -141,14 +140,10 @@ static struct rs_control *rs_init(int sy
 		rs->genpoly[i] = rs->index_of[rs->genpoly[i]];
 	return rs;
 
-	/* Error exit */
-errpol:
+err:
 	kfree(rs->genpoly);
-erridx:
 	kfree(rs->index_of);
-erralp:
 	kfree(rs->alpha_to);
-errrs:
 	kfree(rs);
 	return NULL;
 }
