Reply-To: kernel-hardening@lists.openwall.com
From: Jann Horn <jann@thejh.net>
Date: Tue, 12 Jan 2016 20:25:45 +0100
Message-Id: <1452626745-31708-1-git-send-email-jann@thejh.net>
Subject: [kernel-hardening] [RFC] kernel/panic: place an upper limit on number of oopses
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>

To prevent an attacker from turning a mostly harmless oops into an
exploitable issue using a refcounter wraparound caused by repeated
oopsing, limit the number of oopses.

I have not experimentally verified whether the attack I describe
in the comment works, but I don't see why it wouldn't.
(f_count increments through fget() use atomic_long_inc_not_zero(),
but get_file() just does a normal increment and is e.g.
used by dup_fd().)

This approach is strictly inferior to PAX_REFCOUNT, but as long
as that's not upstreamed and turned on by default, it might make
sense to at least use this patch.

Opinions?

Signed-off-by: Jann Horn <jann@thejh.net>
---
 kernel/panic.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 4b150bc..27a480d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -422,9 +422,37 @@ void print_oops_end_marker(void)
  */
 void oops_exit(void)
 {
+	static atomic_t oops_counter = ATOMIC_INIT(0);
+
 	do_oops_enter_exit();
 	print_oops_end_marker();
 	kmsg_dump(KMSG_DUMP_OOPS);
+
+	/*
+	 * Every time the system oopses, if the oops happens while a
+	 * reference to an object was held (e.g. in a VFS function),
+	 * the reference leaks. If the oops doesn't also leak memory,
+	 * repeated oopsing can cause the reference counter to wrap
+	 * around - in particular, on 32bit systems, f_count in
+	 * struct file is only 32 bits long and can realistically
+	 * wrap around.
+	 * This means that an oops, even if it's just caused by an
+	 * unexploitable-looking NULL pointer dereference or so,
+	 * could maybe be turned into a use-after-free through a
+	 * counter overincrement, and a use-after-free might be
+	 * exploitable.
+	 * To reduce the probability that this happens, place an
+	 * upper bound on how often the kernel may oops - after this
+	 * limit is reached, just panic.
+	 * The constant used as limit should be low enough to
+	 * mitigate this kind of exploitation attempt, but high
+	 * enough to avoid unnecessary panics.
+	 */
+	if (atomic_inc_return(&oops_counter) >= 0x100000 &&
+			panic_on_oops == 0) {
+		pr_emerg("oopsed too often, setting panic_on_oops=1\n");
+		panic_on_oops = 1;
+	}
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-- 
2.1.4
