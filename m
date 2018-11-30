From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH 1/1] stackleak: Register the 'stackleak_cleanup' pass before the 'mach' pass
Date: Fri, 30 Nov 2018 16:19:47 +0300
Message-Id: <1543583987-27948-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Florian Weimer <fweimer@redhat.com>, Richard Sandiford <richard.sandiford@arm.com>, Segher Boessenkool <segher@kernel.crashing.org>, Alexander Monakov <amonakov@ispras.ru>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, H Peter Anvin <hpa@zytor.com>, David S Miller <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org, gcc@gcc.gnu.org, alex.popov@linux.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently the 'stackleak_cleanup' pass deleting a CALL insn is executed
after the 'reload' pass. That allows gcc to do some weird optimization in
function prologues and epilogues, which are generated later [1].

Let's avoid that by registering the 'stackleak_cleanup' pass before
the 'mach' pass, which performs the machine dependent code transformations.
It's the moment when the stack frame size is final and function prologues
and epilogues are already generated.

[1] https://www.openwall.com/lists/kernel-hardening/2018/11/23/2

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 scripts/gcc-plugins/stackleak_plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 2f48da9..6f41b32 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -363,10 +363,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 						PASS_POS_INSERT_BEFORE);
 
 	/*
-	 * The stackleak_cleanup pass should be executed after the
-	 * "reload" pass, when the stack frame size is final.
+	 * The stackleak_cleanup pass should be executed before the "mach"
+	 * pass, which performs the machine dependent code transformations.
+	 * It's the moment when the stack frame size is already final and
+	 * function prologues and epilogues are generated.
 	 */
-	PASS_INFO(stackleak_cleanup, "reload", 1, PASS_POS_INSERT_AFTER);
+	PASS_INFO(stackleak_cleanup, "mach", 1, PASS_POS_INSERT_BEFORE);
 
 	if (!plugin_default_version_check(version, &gcc_version)) {
 		error(G_("incompatible gcc/plugin versions"));
-- 
2.7.4
