Date: Thu, 4 Jan 2018 21:28:01 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20180104122801.GA3038@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] arm: Always use REFCOUNT_FULL
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, ard.biesheuvel@linaro.org, Dave.Martin@arm.com, will.deacon@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

arm prefers to use REFCOUNT_FULL by default.
This enables it for arm.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3d349b4..ec80270 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -100,6 +100,7 @@ config ARM
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select PERF_USE_VMALLOC
+	select REFCOUNT_FULL
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	# Above selects are sorted alphabetically; please add new ones
-- 
1.9.1
