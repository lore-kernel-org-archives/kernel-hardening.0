Reply-To: kernel-hardening@lists.openwall.com
From: Jason Cooper <jason@lakedaemon.net>
Date: Wed,  3 Aug 2016 23:39:10 +0000
Message-Id: <20160803233913.32511-5-jason@lakedaemon.net>
In-Reply-To: <20160803233913.32511-1-jason@lakedaemon.net>
References: <20160728204730.27453-1-jason@lakedaemon.net>
 <20160803233913.32511-1-jason@lakedaemon.net>
Subject: [kernel-hardening] [PATCH v3 4/7] arm64: Use simpler API for random address requests
To: Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, "Roberts, William C" <william.c.roberts@intel.com>, Yann Droneaud <ydroneaud@opteya.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening <kernel-hardening@lists.openwall.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org, paulus@samba.org, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, viro@zeniv.linux.org.uk, Nick Kralevich <nnk@google.com>, Jeffrey Vander Stoep <jeffv@google.com>, Daniel Cashman <dcashman@android.com>, Jason Cooper <jason@lakedaemon.net>
List-ID: <kernel-hardening.lists.openwall.com>

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can
simplify the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Will Deacon <will.deacon@arm.com>
---
Changes from v2:
 - s/randomize_addr/randomize_page/ (Kees Cook)

 arch/arm64/kernel/process.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6cd2612236dc..6ac2950ffb78 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -374,12 +374,8 @@ unsigned long arch_align_stack(unsigned long sp)
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk;
-
 	if (is_compat_task())
-		range_end += 0x02000000;
+		return randomize_page(mm->brk, 0x02000000);
 	else
-		range_end += 0x40000000;
-
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+		return randomize_page(mm->brk, 0x40000000);
 }
-- 
2.9.2
