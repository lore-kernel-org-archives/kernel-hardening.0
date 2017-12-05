From: Alexander Popov <alex.popov@linux.com>
Date: Wed,  6 Dec 2017 02:33:47 +0300
Message-Id: <1512516827-29797-7-git-send-email-alex.popov@linux.com>
In-Reply-To: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v6 6/6] doc: self-protection: Add information about STACKLEAK feature
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

Add information about STACKLEAK feature to "Stack depth overflow" and
"Memory poisoning" sections of self-protection.rst.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 Documentation/security/self-protection.rst | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/security/self-protection.rst b/Documentation/security/self-protection.rst
index 60c8bd8..9693a90 100644
--- a/Documentation/security/self-protection.rst
+++ b/Documentation/security/self-protection.rst
@@ -165,10 +165,15 @@ Stack depth overflow
 A less well understood attack is using a bug that triggers the
 kernel to consume stack memory with deep function calls or large stack
 allocations. With this attack it is possible to write beyond the end of
-the kernel's preallocated stack space and into sensitive structures. Two
-important changes need to be made for better protections: moving the
-sensitive thread_info structure elsewhere, and adding a faulting memory
-hole at the bottom of the stack to catch these overflows.
+the kernel's preallocated stack space and into sensitive structures.
+The combination of the following measures gives better protection:
+
+* moving the sensitive thread_info structure off the stack
+  (``CONFIG_THREAD_INFO_IN_TASK``);
+* adding a faulting memory hole at the bottom of the stack to catch
+  these overflows (``CONFIG_VMAP_STACK``);
+* runtime checking that alloca() calls don't overstep the stack boundary
+  (``CONFIG_GCC_PLUGIN_STACKLEAK``).
 
 Heap memory integrity
 ---------------------
@@ -287,11 +292,11 @@ sure structure holes are cleared.
 Memory poisoning
 ----------------
 
-When releasing memory, it is best to poison the contents (clear stack on
-syscall return, wipe heap memory on a free), to avoid reuse attacks that
-rely on the old contents of memory. This frustrates many uninitialized
-variable attacks, stack content exposures, heap content exposures, and
-use-after-free attacks.
+When releasing memory, it is best to poison the contents, to avoid reuse
+attacks that rely on the old contents of memory. E.g., clear stack on a
+syscall return (``CONFIG_GCC_PLUGIN_STACKLEAK``), wipe heap memory on a
+free. This frustrates many uninitialized variable attacks, stack content
+exposures, heap content exposures, and use-after-free attacks.
 
 Destination tracking
 --------------------
-- 
2.7.4
