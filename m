Date: Mon, 11 Dec 2017 21:50:43 +0900
From: Jinbum Park <jinb.park7@gmail.com>
Message-ID: <20171211125043.GA17299@pjb1027-Latitude-E5410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening][PATCH] arm: hw_breakpoint: Mark variables as
 __ro_after_init
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: will.deacon@arm.com, mark.rutland@arm.com, linux@armlinux.org.uk, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

core_num_brps, core_num_wrps, debug_arch, has_ossr,
max_watchpoint_len are setup once while init stage,
and never changed after that.
so it is good candidate for __ro_after_init.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/kernel/hw_breakpoint.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index af2a7f1..629e251 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -44,17 +44,17 @@
 static DEFINE_PER_CPU(struct perf_event *, wp_on_reg[ARM_MAX_WRP]);
 
 /* Number of BRP/WRP registers on this CPU. */
-static int core_num_brps;
-static int core_num_wrps;
+static int core_num_brps __ro_after_init;
+static int core_num_wrps __ro_after_init;
 
 /* Debug architecture version. */
-static u8 debug_arch;
+static u8 debug_arch __ro_after_init;
 
 /* Does debug architecture support OS Save and Restore? */
-static bool has_ossr;
+static bool has_ossr __ro_after_init;
 
 /* Maximum supported watchpoint length. */
-static u8 max_watchpoint_len;
+static u8 max_watchpoint_len __ro_after_init;
 
 #define READ_WB_REG_CASE(OP2, M, VAL)			\
 	case ((OP2 << 4) + M):				\
-- 
1.9.1
