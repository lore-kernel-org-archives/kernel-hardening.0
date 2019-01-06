From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [PATCH V8 08/11] KVM: X86: Port ROE_MPROTECT_CHUNK to x86
Date: Sun,  6 Jan 2019 21:23:42 +0200
Message-Id: <20190106192345.13578-9-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20190106192345.13578-1-ahmedsoliman@mena.vt.edu>
References: <20190106192345.13578-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Apply d->memslot->partial_roe_bitmap to shadow page table entries
too.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 arch/x86/kvm/roe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/roe.c b/arch/x86/kvm/roe.c
index f787106be8..700f69823b 100644
--- a/arch/x86/kvm/roe.c
+++ b/arch/x86/kvm/roe.c
@@ -25,11 +25,14 @@ static bool __rmap_write_protect_roe(struct kvm *kvm,
 	struct rmap_iterator iter;
 	bool prot;
 	bool flush = false;
+	void *full_bmp =  memslot->roe_bitmap;
+	void *part_bmp = memslot->partial_roe_bitmap;
 
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		int idx = spte_to_gfn(sptep) - memslot->base_gfn;
 
-		prot = !test_bit(idx, memslot->roe_bitmap) && pt_protect;
+		prot = !(test_bit(idx, full_bmp) || test_bit(idx, part_bmp));
+		prot = prot && pt_protect;
 		flush |= spte_write_protect(sptep, prot);
 	}
 	return flush;
-- 
2.19.2
