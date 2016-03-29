Reply-To: kernel-hardening@lists.openwall.com
From: Scott Bauer <sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 13:53:27 -0600
Message-Id: <1459281207-24377-5-git-send-email-sbauer@eng.utah.edu>
In-Reply-To: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] [PATCH v4 4/4] Documentation: SROP Mitigation: Add documentation for SROP cookies
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org, Scott Bauer <sbauer@eng.utah.edu>, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds documentation and test code for SROP mitigation.

Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
Signed-off-by: Scott Bauer <sbauer@plzdonthack.me>
Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
---
 Documentation/security/srop-cookies.txt | 203 ++++++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+)
 create mode 100644 Documentation/security/srop-cookies.txt

diff --git a/Documentation/security/srop-cookies.txt b/Documentation/security/srop-cookies.txt
new file mode 100644
index 0000000..ee17181
--- /dev/null
+++ b/Documentation/security/srop-cookies.txt
@@ -0,0 +1,203 @@
+         Sigreturn-oriented programming and its mitigation
+
+
+A good write up can be found here: https://lwn.net/Articles/676803/
+It covers much of what is outlined in this documentation.
+
+If you're very curious you should read the SROP paper:
+http://www.cs.vu.nl/~herbertb/papers/srop_sp14.pdf
+
+If you're here to learn how to disable SROP issue the following
+Command:
+
+# echo 1 > /proc/sys/kernel/disable-srop-protection
+
+
+============================ Overview ============================
+
+Sigreturn-oriented programming(SROP) is a new technique to control
+a compromised userland process after successfully exploiting a bug.
+
+Signals are delivered to the process during context switches. The
+kernel will setup a signal frame on the process' stack which
+contains the saved state of the process prior to the context switch.
+The kernel then gives control the the process' signal handler. Once
+the process has delt with the signal it will call the sigreturn
+system call. During the context switch into the kernel, the previous
+state of where the process was executing prior to the delivery of
+the signal is overwritten, hence why the kernel must save the the
+state in a signal frame on the user's stack. The kernel will remove
+the signal frame from the process' stack and continue execution
+where the process left off.
+
+The issue with this signal delivery method is if an attacker can
+construct a fake signal frame on the compromised process' stack
+and ROP into the sigreturn system call, they have the ability to
+easily control the flow of execution by having the kernel return
+execution to wherever the signal frame says to continue execution.
+
+More importantly, SROP makes an attackers job easier. Previously
+attackers would have to search for ROP gadgets to get values into
+registers then call mprotect or mmap to get some memory where they
+could copy and execute shellcode. If the ROP gadgets didnt exist
+that allowed setting up a call to those functions then the attackers
+wouldn't be able to fully exploit the bug. With SROP however attackers
+dont' have to search for ROP gadgets to get specific values into
+registers. The attacker would simply lay out the ucontext on the stack
+as they choose then SROP into the mprotect or mmap call.
+
+======================== Mitigating  SROP ========================
+
+In order to prevent SROP the kernel must remember or be able to derive
+at runtime whether a sigreturn call it is currently processing is
+in respose to a legitimate signal delivered by the kernel.
+
+During delivery of a signal the kernel will place the signal frame
+with the saved process state on the stack. It will also place a cookie
+above the signal frame.
+
+The cookie is a per-process secret xor'd with the address where it will
+be stored. During a sigreturn the kernel will extract this cookie, and
+then compare the extracted cookie against a new generated cookie:
+(the per process secret xord with address where we extracted cookie from).
+
+If the two cookies match, then the kernel has verified that it is handling
+a sigreturn from a signal that was previously legitimately delivered.
+If the cookies do not match up the kernel sends a SIGSEGV to the process,
+terminating it.
+
+After verifying the cookie, the kernel will zero out the cookie to prevent
+any sort of leaking of the cookie.
+
+This prevents SROP because it forces an attacker to know the cookie in order
+to use SROP as an attack vector.
+
+
+======================== Possible Issues  ========================
+SROP protection will probably break any process or application which do
+some sort of checkpoint-restore in user space type things. As well as DOSEMU.
+
+
+
+===============================================================================
+Inlined are two programs that exploit SROP:
+
+For 32bit:
+
+Compile with if you're using a 64bit kernel:
+gcc -O0 -o srop_32 srop_32.c -g -fno-stack-protector -ffixed-ebp -ffixed-esp -m32 -DEMULATED_32
+
+or if you're already on a real 32bit kernel:
+gcc -O0 -o srop_32 srop_32.c -g -fno-stack-protector -ffixed-ebp -ffixed-esp
+
+When run without SROP protection it will exit gracefully, when SROP is
+enabled it will terminate with a SIGSEGV.
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <signal.h>
+
+void syscall(void)
+{
+  exit(1);
+}
+
+void test2(void)
+{
+  register int esp asm("esp");
+  register int ebp asm("ebp");
+  struct sigcontext scon = { 0 };
+
+  scon.eax = 11;
+  scon.ebx = 0x41;
+  scon.ecx = 0;
+  scon.edx = 0;
+  scon.esp = scon.ebp = ebp;
+  scon.eip = (int)syscall+6;
+
+#if defined EMULATED_32
+  scon.fs = 0x00;
+  scon.cs = 0x23;
+  scon.ss = scon.ds = scon.es = 0x2B;
+  scon.gs = 0x63;
+#else
+  scon.fs = 0x00;
+  scon.cs = 0x73;
+  scon.ss = scon.ds = scon.es = 0x7B;
+  scon.gs = 0x33;
+#endif
+  esp = (int) &scon;
+  asm("movl $119, %eax\n");//NR_SIGRETURN;
+  asm("int $0x80\n");
+}
+
+int main(void)
+{
+  test2();
+  return 1;
+}
+
+=====================================================
+
+
+For 64 bit:
+
+gcc -O0 -o srop srop.c -g  -fno-stack-protector -ffixed-rsp -ffixed-rbp
+When run the program exits normally, with SROP protetction it terminates
+with a segmentationf fault.
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+
+enum {
+	REG_R8 = 0,
+	REG_R9,
+	REG_R10,
+	REG_R11,
+	REG_R12,
+	REG_R13,
+	REG_R14,
+	REG_R15,
+	REG_RDI,
+	REG_RSI,
+	REG_RBP,
+	REG_RBX,
+	REG_RDX,
+	REG_RAX,
+	REG_RCX,
+	REG_RSP,
+	REG_RIP,
+	REG_EFL,
+	REG_CSGSFS,/* Actually short cs, gs, fs, __pad0.  */
+	REG_ERR,
+	REG_TRAPNO,
+	REG_OLDMASK,
+	REG_CR2
+};
+
+void _exit_(void)
+{
+	exit(1);
+}
+
+void test(void)
+{
+	struct ucontext ctx = { 0 };
+	register unsigned long rsp asm("rsp");
+	register unsigned long rbp asm("rbp");
+	ctx.uc_mcontext.gregs[REG_RIP] = (unsigned long) _exit_ + 4;
+	ctx.uc_mcontext.gregs[REG_RSP] = rsp;
+	ctx.uc_mcontext.gregs[REG_RBP] = rbp;
+	ctx.uc_mcontext.gregs[REG_CSGSFS] = 0x002b000000000033;
+	rsp = (unsigned long) &ctx;
+	asm("movq $0xf,%rax\n");
+	asm("syscall\n");
+}
+
+
+int main(void)
+{
+	test();
+	return 0;
+}
-- 
1.9.1
