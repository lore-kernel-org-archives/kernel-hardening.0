From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 1/2] arm64: mm: purge lazily unmapped vm regions before changing permissions
Date: Wed,  7 Nov 2018 11:36:19 +0100
Message-Id: <20181107103620.16054-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
References: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, labbott@redhat.com, will.deacon@arm.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Call vm_unmap_aliases() every time we apply any changes to permission
attributes of mappings in the vmalloc region. This avoids any potential
issues resulting from lingering writable or executable aliases of
mappings that should be read-only or non-executable, respectively.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/pageattr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index a56359373d8b..787f9e385e6d 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -93,6 +93,12 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!numpages)
 		return 0;
 
+	/*
+	 * Get rid of potentially aliasing lazily unmapped vm areas that may
+	 * have permissions set that deviate from the ones we are setting here.
+	 */
+	vm_unmap_aliases();
+
 	return __change_memory_common(start, size, set_mask, clear_mask);
 }
 
-- 
2.19.1
