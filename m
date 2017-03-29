From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:15:59 -0700
Message-Id: <1490811363-93944-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1490811363-93944-1-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [RFC v2][PATCH 07/11] ARM: mm: set DOMAIN_WR_RARE for rodata
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

This creates DOMAIN_WR_RARE for the kernel's .rodata section, separate
from DOMAIN_KERNEL to avoid predictive fetching in device memory during
a DOMAIN_MANAGER transition.

TODO: handle kernel module vmalloc memory, which needs to be marked as
DOMAIN_WR_RARE too, for module .rodata sections.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/domain.h | 3 +++
 arch/arm/mm/dump.c            | 2 ++
 arch/arm/mm/init.c            | 7 ++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index 8b33bd7f6bf9..b5ca80ac823c 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -43,6 +43,7 @@
 #define DOMAIN_IO	0
 #endif
 #define DOMAIN_VECTORS	3
+#define DOMAIN_WR_RARE	4
 
 /*
  * Domain types
@@ -69,11 +70,13 @@
 #define DACR_INIT \
 	(__DACR_INIT_USER | \
 	 domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
+	 domain_val(DOMAIN_WR_RARE, DOMAIN_CLIENT) | \
 	 domain_val(DOMAIN_IO, DOMAIN_CLIENT) | \
 	 domain_val(DOMAIN_VECTORS, DOMAIN_CLIENT))
 
 #define __DACR_DEFAULT \
 	domain_val(DOMAIN_KERNEL, DOMAIN_CLIENT) | \
+	domain_val(DOMAIN_WR_RARE, DOMAIN_CLIENT) | \
 	domain_val(DOMAIN_IO, DOMAIN_CLIENT) | \
 	domain_val(DOMAIN_VECTORS, DOMAIN_CLIENT)
 
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 35ff45470dbf..b1aa9a17e0c3 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -288,6 +288,8 @@ static const char *get_domain_name(pmd_t *pmd)
 		return "IO     ";
 	case PMD_DOMAIN(DOMAIN_VECTORS):
 		return "VECTORS";
+	case PMD_DOMAIN(DOMAIN_WR_RARE):
+		return "WR_RARE";
 	default:
 		return "unknown";
 	}
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 1d8558ff9827..d54a74b5718b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -642,9 +642,10 @@ static struct section_perm ro_perms[] = {
 		.mask   = ~L_PMD_SECT_RDONLY,
 		.prot   = L_PMD_SECT_RDONLY,
 #else
-		.mask   = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE),
-		.prot   = PMD_SECT_APX | PMD_SECT_AP_WRITE,
-		.clear  = PMD_SECT_AP_WRITE,
+		.mask   = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE | PMD_DOMAIN_MASK),
+		.prot   = PMD_SECT_APX | PMD_SECT_AP_WRITE | \
+			  PMD_DOMAIN(DOMAIN_WR_RARE),
+		.clear  = PMD_SECT_AP_WRITE | PMD_DOMAIN(DOMAIN_KERNEL),
 #endif
 	},
 };
-- 
2.7.4
