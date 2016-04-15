Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 15 Apr 2016 15:03:11 -0700
Message-Id: <1460757793-59020-3-git-send-email-thgarnie@google.com>
In-Reply-To: <1460757793-59020-1-git-send-email-thgarnie@google.com>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v1 2/4] x86, boot: PUD VA support for physical mapping (x86_64)
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Minor change that allows early boot physical mapping of PUD level virtual
addresses. This change prepares usage of different virtual addresses for
KASLR memory randomization. It has no impact on default usage.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160413
---
 arch/x86/mm/init_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 89d9747..6adfbce 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -526,10 +526,10 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 {
 	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
-	int i = pud_index(addr);
+	int i = pud_index((unsigned long)__va(addr));
 
 	for (; i < PTRS_PER_PUD; i++, addr = next) {
-		pud_t *pud = pud_page + pud_index(addr);
+		pud_t *pud = pud_page + pud_index((unsigned long)__va(addr));
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
 
-- 
2.8.0.rc3.226.g39d4020
