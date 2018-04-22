Message-Id: <20180422162512.458372618@linutronix.de>
Date: Sun, 22 Apr 2018 18:23:47 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 02/10] dm/verity_fec: Use GFP aware reed solomon init
References: <20180422162345.004292133@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline;
 filename=dm-verity_fec--Use-GFP-aware-reed-solomon-init.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Neil Brown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

Allocations from the rs_pool can invoke init_rs() from the mempool
allocation callback. This is problematic in fec_alloc_bufs() which invokes
mempool_alloc() with GFP_NOIO to prevent a swap deadlock because init_rs()
uses GFP_KERNEL allocations.

Switch it to init_rs_gfp() and invoke it with the gfp_t flags which are
handed in from the allocator.

Note: This is not a problem today because the rs control struct is shared
between the instances and its created when the mempool is initialized. But
the upcoming changes which switch to a rs_control struct per instance to
embed decoder buffers will trigger the swap vs. GFP_KERNEL issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Neil Brown <neilb@suse.com>
---
 drivers/md/dm-verity-fec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -570,7 +570,7 @@ static void *fec_rs_alloc(gfp_t gfp_mask
 {
 	struct dm_verity *v = (struct dm_verity *)pool_data;
 
-	return init_rs(8, 0x11d, 0, 1, v->fec->roots);
+	return init_rs_gfp(8, 0x11d, 0, 1, v->fec->roots, gfp_mask);
 }
 
 static void fec_rs_free(void *element, void *pool_data)
