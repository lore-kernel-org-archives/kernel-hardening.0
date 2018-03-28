Message-Id: <20180328205554.748930560@linutronix.de>
Date: Wed, 28 Mar 2018 22:51:44 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 6/8] mtd: diskonchip: Allocate rs control per instance
References: <20180328205138.301218351@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline;
 filename=mtd--diskonchip--Allocate-rs-control-per-instance.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

The reed solomon library is moving the on stack decoder buffers into the rs
control structure. That would break the DoC driver because multiple
instances share the same control structure and can operate in parallel. At
least in theory....

Instantiate a rs control instance per DoC device to avoid that. The per
instance buffer is fine as the operation on a single DoC instance is
serialized by the MTD/NAND core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mtd/nand/diskonchip.c |   65 ++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -68,6 +68,7 @@ struct doc_priv {
 	int curchip;
 	int mh0_page;
 	int mh1_page;
+	struct rs_control *rs_decoder;
 	struct mtd_info *nextdoc;
 
 	/* Handle the last stage of initialization (BBT scan, partitioning) */
@@ -125,9 +126,6 @@ MODULE_PARM_DESC(doc_config_location, "P
 /* Number of symbols */
 #define NN 1023
 
-/* the Reed Solomon control structure */
-static struct rs_control *rs_decoder;
-
 /*
  * The HW decoder in the DoC ASIC's provides us a error syndrome,
  * which we must convert to a standard syndrome usable by the generic
@@ -933,7 +931,7 @@ static int doc200x_correct_data(struct m
 				calc_ecc[i] = ReadDOC_(docptr, DoC_ECCSyndrome0 + i);
 		}
 
-		ret = doc_ecc_decode(rs_decoder, dat, calc_ecc);
+		ret = doc_ecc_decode(doc->rs_decoder, dat, calc_ecc);
 		if (ret > 0)
 			printk(KERN_ERR "doc200x_correct_data corrected %d errors\n", ret);
 	}
@@ -1561,8 +1559,25 @@ static int __init doc_probe(unsigned lon
 		goto fail;
 	}
 
+
+	/*
+	 * Allocate a RS codec instance
+	 *
+	 * Symbolsize is 10 (bits)
+	 * Primitve polynomial is x^10+x^3+1
+	 * First consecutive root is 510
+	 * Primitve element to generate roots = 1
+	 * Generator polinomial degree = 4
+	 */
+	doc = (struct doc_priv *) (nand + 1);
+	doc->rs_decoder = init_rs(10, 0x409, FCR, 1, NROOTS);
+	if (!doc->rs_decoder) {
+		pr_err("DiskOnChip: Could not create a RS codec\n");
+		ret = -ENOMEM;
+		goto fail_nand;
+	}
+
 	mtd			= nand_to_mtd(nand);
-	doc			= (struct doc_priv *) (nand + 1);
 	nand->bbt_td		= (struct nand_bbt_descr *) (doc + 1);
 	nand->bbt_md		= nand->bbt_td + 1;
 
@@ -1612,19 +1627,24 @@ static int __init doc_probe(unsigned lon
 		   haven't yet added it.  This is handled without incident by
 		   mtd_device_unregister, as far as I can tell. */
 		nand_release(mtd);
-		kfree(nand);
-		goto fail;
+		goto fail_rs;
 	}
 
 	/* Success! */
 	doclist = mtd;
 	return 0;
 
- notfound:
+fail_rs:
+	free_rs(doc->rs_decoder);
+fail_nand:
+	kfree(nand);
+	goto fail;
+
+notfound:
 	/* Put back the contents of the DOCControl register, in case it's not
 	   actually a DiskOnChip.  */
 	WriteDOC(save_control, virtadr, DOCControl);
- fail:
+fail:
 	iounmap(virtadr);
 
 error_ioremap:
@@ -1647,6 +1667,7 @@ static void release_nanddoc(void)
 		nand_release(mtd);
 		iounmap(doc->virtadr);
 		release_mem_region(doc->physadr, DOC_IOREMAP_LEN);
+		kfree(doc->rs_decoder);
 		kfree(nand);
 	}
 }
@@ -1655,26 +1676,11 @@ static int __init init_nanddoc(void)
 {
 	int i, ret = 0;
 
-	/* We could create the decoder on demand, if memory is a concern.
-	 * This way we have it handy, if an error happens
-	 *
-	 * Symbolsize is 10 (bits)
-	 * Primitve polynomial is x^10+x^3+1
-	 * first consecutive root is 510
-	 * primitve element to generate roots = 1
-	 * generator polinomial degree = 4
-	 */
-	rs_decoder = init_rs(10, 0x409, FCR, 1, NROOTS);
-	if (!rs_decoder) {
-		printk(KERN_ERR "DiskOnChip: Could not create a RS decoder\n");
-		return -ENOMEM;
-	}
-
 	if (doc_config_location) {
 		printk(KERN_INFO "Using configured DiskOnChip probe address 0x%lx\n", doc_config_location);
 		ret = doc_probe(doc_config_location);
 		if (ret < 0)
-			goto outerr;
+			return ret;
 	} else {
 		for (i = 0; (doc_locations[i] != 0xffffffff); i++) {
 			doc_probe(doc_locations[i]);
@@ -1685,23 +1691,14 @@ static int __init init_nanddoc(void)
 	if (!doclist) {
 		printk(KERN_INFO "No valid DiskOnChip devices found\n");
 		ret = -ENODEV;
-		goto outerr;
 	}
 	return 0;
- outerr:
-	free_rs(rs_decoder);
-	return ret;
 }
 
 static void __exit cleanup_nanddoc(void)
 {
 	/* Cleanup the nand/DoC resources */
 	release_nanddoc();
-
-	/* Free the reed solomon resources */
-	if (rs_decoder) {
-		free_rs(rs_decoder);
-	}
 }
 
 module_init(init_nanddoc);
