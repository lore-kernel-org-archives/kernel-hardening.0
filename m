From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] x86/xen: Remove use of VLAs
Date: Fri, 13 Apr 2018 15:11:46 -0700
Message-Id: <20180413221146.28476-1-labbott@redhat.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
Cc: Laura Abbott <labbott@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. The few VLAs in use have an upper bound based on a size
of 64K. This doesn't produce an excessively large stack so just switch
the upper bound.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 arch/x86/xen/enlighten_pv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index c36d23aa6c35..d96a5a535cbb 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -421,8 +421,7 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 {
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
-	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
-	unsigned long frames[pages];
+	unsigned long frames[DIV_ROUND_UP(SZ_64K, PAGE_SIZE)];
 	int f;
 
 	/*
@@ -470,8 +469,7 @@ static void __init xen_load_gdt_boot(const struct desc_ptr *dtr)
 {
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
-	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
-	unsigned long frames[pages];
+	unsigned long frames[DIV_ROUND_UP(SZ_64K, PAGE_SIZE)];
 	int f;
 
 	/*
-- 
2.14.3
