From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v4 04/12] __wr_after_init: x86_64: enable
Date: Tue, 12 Feb 2019 01:27:41 +0200
Message-Id: <38307f2c7ae982478d33f55f7a7b827de489cdf3.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Set ARCH_HAS_PRMEM to Y for x86_64

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>

CC: Andy Lutomirski <luto@amacapital.net>
CC: Nadav Amit <nadav.amit@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Kees Cook <keescook@chromium.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 68261430fe6e..7392b53b12c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -32,6 +32,7 @@ config X86_64
 	select SWIOTLB
 	select X86_DEV_DMA_OPS
 	select ARCH_HAS_SYSCALL_WRAPPER
+	select ARCH_HAS_PRMEM
 
 #
 # Arch settings
-- 
2.19.1
