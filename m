From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v4 21/23] x86/alternative: Comment about module removal races
Date: Mon, 22 Apr 2019 11:58:03 -0700
Message-Id: <20190422185805.1169-22-rick.p.edgecombe@intel.com>
In-Reply-To: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Masami Hiramatsu <mhiramat@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Nadav Amit <namit@vmware.com>

Add a comment to clarify that users of text_poke() must ensure that
no races with module removal take place.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/alternative.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 18f959975ea0..7b9b49dfc05a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -810,6 +810,11 @@ static void *__text_poke(void *addr, const void *opcode, size_t len)
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * Note that the caller must ensure that if the modified code is part of a
+ * module, the module would not be removed during poking. This can be achieved
+ * by registering a module notifier, and ordering module removal and patching
+ * trough a mutex.
  */
 void *text_poke(void *addr, const void *opcode, size_t len)
 {
-- 
2.17.1
