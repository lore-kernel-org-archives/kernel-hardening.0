Date: Fri, 5 Jan 2018 18:02:12 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20180105090212.GA4026@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] arm: Always use REFCOUNT_FULL
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, ard.biesheuvel@linaro.org, Dave.Martin@arm.com, will.deacon@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t overflow detection is implemented as two way.

1. REFCOUNT_FULL

- It means the full refcount_t implementation
  which has validation but is slightly slower.
- (fd25d19f6b8d ("locking/refcount:
  Create unchecked atomic_t implementation"))

2. ARCH_HAS_REFCOUNT

- refcount_t overflow detection can be optimized
  via an arch-dependent way.
- It is based on atomic_t infrastructure
  with some instruction added for detection.
- It is faster than REFCOUNT_FULL,
  as fast as unprotected atomic_t infrastructure.
- (7a46ec0e2f48 ("locking/refcounts, x86/asm:
  Implement fast refcount overflow protection"))

ARCH_HAS_REFCOUNT has implemented for x86,
not implemented for others.

In the case of arm64,
Will Deacon said he didn't want the specialized
"fast but technically incomplete" refcounting as seen with x86's.

But rather to set REFCOUNT_FULL by default
because no one could point to real-world performance impacts with
REFCOUNT_FULL vs unprotected atomic_t infrastructure.

This is the reason arm64 ended up enabling REFCOUNT_FULL.
(4adcec1164de ("arm64: Always use REFCOUNT_FULL"))

As with the decision of arm64,
arm can set REFCOUNT_FULL by default.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
v2: Write a better commit message
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 64713b6..e111a62 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -101,6 +101,7 @@ config ARM
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select PERF_USE_VMALLOC
+	select REFCOUNT_FULL
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	# Above selects are sorted alphabetically; please add new ones
-- 
1.9.1
