Reply-To: kernel-hardening@lists.openwall.com
From: Jason Cooper <jason@lakedaemon.net>
Date: Tue, 26 Jul 2016 03:01:58 +0000
Message-Id: <20160726030201.6775-4-jason@lakedaemon.net>
In-Reply-To: <20160726030201.6775-1-jason@lakedaemon.net>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
 <20160726030201.6775-1-jason@lakedaemon.net>
Subject: [kernel-hardening] [RFC patch 4/6] arm64: Use simpler API for random address requests
To: william.c.roberts@intel.com, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jason Cooper <jason@lakedaemon.net>, linux@arm.linux.org.uk, akpm@linux-foundation.org, keescook@chromium.org, tytso@mit.edu, arnd@arndb.de, gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com, ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, viro@zeniv.linux.org.uk, nnk@google.com, jeffv@google.com, alyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can
simplify the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 arch/arm64/kernel/process.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6cd2612236dc..11bf454baf86 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -374,12 +374,8 @@ unsigned long arch_align_stack(unsigned long sp)
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk;
-
 	if (is_compat_task())
-		range_end += 0x02000000;
+		return randomize_addr(mm->brk, 0x02000000);
 	else
-		range_end += 0x40000000;
-
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+		return randomize_addr(mm->brk, 0x40000000);
 }
-- 
2.9.2
