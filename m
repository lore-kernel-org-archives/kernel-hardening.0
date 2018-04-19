Message-Id: <20180419100935.340306831@linutronix.de>
Date: Thu, 19 Apr 2018 12:04:48 +0200
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 7/8] dm verity fec: Check result of init_rs()
References: <20180419100441.548834519@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline;
 filename=dm_verity_fec--Check_result_of_init_rs--.patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Gleixner <tglx@linutronix.de>

The allocation of the reed solomon control structure can fail, but
fec_alloc_bufs() ignores that and subsequent operations in dm verity use
the potential NULL pointer unconditionally.

Add a proper check and abort if init_rs() fails.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>

---
 drivers/md/dm-verity-fec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -308,8 +308,13 @@ static int fec_alloc_bufs(struct dm_veri
 {
 	unsigned n;
 
-	if (!fio->rs)
+	if (!fio->rs) {
 		fio->rs = mempool_alloc(v->fec->rs_pool, GFP_NOIO);
+		if (!fio->rs) {
+			DMERR("failed to allocate RS control structure");
+			return -ENOMEM;
+		}
+	}
 
 	fec_for_each_prealloc_buffer(n) {
 		if (fio->bufs[n])
