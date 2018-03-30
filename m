From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [v2] ftrace: drop a VLA in module_exists()
Date: Fri, 30 Mar 2018 10:53:08 +0200
Message-Id: <1522399988-8815-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

Avoid a VLA[1] by using a real constant expression instead of a variable.
The compiler should be able to optimize the original code and avoid using
an actual VLA. Anyway this change is useful because it will avoid a false
positive with -Wvla, it might also help the compiler generating better
code.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 kernel/trace/ftrace.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eac9ce2..16bbf06 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3902,14 +3902,13 @@ static bool module_exists(const char *module)
 {
 	/* All modules have the symbol __this_module */
 	const char this_mod[] = "__this_module";
-	const int modname_size = MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 1;
-	char modname[modname_size + 1];
+	char modname[MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 2];
 	unsigned long val;
 	int n;
 
-	n = snprintf(modname, modname_size + 1, "%s:%s", module, this_mod);
+	n = snprintf(modname, sizeof(modname), "%s:%s", module, this_mod);
 
-	if (n > modname_size)
+	if (n > sizeof(modname) - 1)
 		return false;
 
 	val = module_kallsyms_lookup_name(modname);
-- 
1.9.1
