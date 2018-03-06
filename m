Date: Tue, 6 Mar 2018 20:22:41 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH] arm: mm: Kconfig: Disable KUSER_HELPERS in ARMv6 or later as
 default
Message-ID: <20180306112241.GA5938@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org, vladimir.murzin@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Codes for KUSER_HELPERS can be abused as ROP gadaget,
So that It's better to disable that as if possible.

Since over ARMv6 has ldrex/strex at user-space,
NEED_KUSER_HELPERS is not selected for over ARMv6.

But, Even though NEED_KUSER_HELPERS is not selected,
current configuration enable KUSER_HELPERS as default.

* as-is

- Enable KUSER_HELPERS as default even though over ARMv6.
- User can disable KUSER_HELPERS.

* to-be

- Disable KUSER_HELPERS in ARMv6 or later as default.
- User can enable KUSER_HELPERS for compatibility.

This change removes the unnecessary configuration that has security-risk.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 7f14acf..40e5fe5 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -840,7 +840,7 @@ config NEED_KUSER_HELPERS
 config KUSER_HELPERS
 	bool "Enable kuser helpers in vector page" if !NEED_KUSER_HELPERS
 	depends on MMU
-	default y
+	default y if NEED_KUSER_HELPERS
 	help
 	  Warning: disabling this option may break user programs.
 
-- 
1.9.1
