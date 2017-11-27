From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 09:30:19 +1100
Message-Id: <1511821819-5496-4-git-send-email-me@tobin.cc>
In-Reply-To: <1511821819-5496-1-git-send-email-me@tobin.cc>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 3/3] trace: print address if symbol not found
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Ingo Molnar <mingo@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Fixes behaviour modified by: commit bd6b239cdbb2 ("kallsyms: don't leak
address when symbol not found")

Previous patch changed behaviour of kallsyms function sprint_symbol() to
return an error code instead of printing the address if a symbol was not
found. Ftrace relies on the original behaviour. We should not break
tracing when applying the previous patch. We can maintain the original
behaviour by checking the return code on calls to sprint_symbol() and
friends.

Check return code and print actual address on error (i.e symbol not
found).

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 kernel/trace/trace.h             | 24 ++++++++++++++++++++++++
 kernel/trace/trace_events_hist.c |  6 +++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2a6d0325a761..881b1a577d75 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1814,4 +1814,28 @@ static inline void trace_event_eval_update(struct trace_eval_map **map, int len)
 
 extern struct trace_iterator *tracepoint_print_iter;
 
+static inline int
+trace_sprint_symbol(char *buffer, unsigned long address)
+{
+	int ret;
+
+	ret = sprint_symbol(buffer, address);
+	if (ret == -1)
+		ret = sprintf(buffer, "0x%lx", address);
+
+	return ret;
+}
+
+static inline int
+trace_sprint_symbol_no_offset(char *buffer, unsigned long address)
+{
+	int ret;
+
+	ret = sprint_symbol_no_offset(buffer, address);
+	if (ret == -1)
+		ret = sprintf(buffer, "0x%lx", address);
+
+	return ret;
+}
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 1e1558c99d56..3e28522a76f4 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -982,7 +982,7 @@ static void hist_trigger_stacktrace_print(struct seq_file *m,
 			return;
 
 		seq_printf(m, "%*c", 1 + spaces, ' ');
-		sprint_symbol(str, stacktrace_entries[i]);
+		trace_sprint_symbol_addr(str, stacktrace_entries[i]);
 		seq_printf(m, "%s\n", str);
 	}
 }
@@ -1014,12 +1014,12 @@ hist_trigger_entry_print(struct seq_file *m,
 			seq_printf(m, "%s: %llx", field_name, uval);
 		} else if (key_field->flags & HIST_FIELD_FL_SYM) {
 			uval = *(u64 *)(key + key_field->offset);
-			sprint_symbol_no_offset(str, uval);
+			trace_sprint_symbol_no_offset(str, uval);
 			seq_printf(m, "%s: [%llx] %-45s", field_name,
 				   uval, str);
 		} else if (key_field->flags & HIST_FIELD_FL_SYM_OFFSET) {
 			uval = *(u64 *)(key + key_field->offset);
-			sprint_symbol(str, uval);
+			trace_sprint_symbol(str, uval);
 			seq_printf(m, "%s: [%llx] %-55s", field_name,
 				   uval, str);
 		} else if (key_field->flags & HIST_FIELD_FL_EXECNAME) {
-- 
2.7.4
