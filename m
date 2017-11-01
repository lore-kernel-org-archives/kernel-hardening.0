From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  1 Nov 2017 15:32:22 +1100
Message-Id: <1509510743-28429-2-git-send-email-me@tobin.cc>
In-Reply-To: <1509510743-28429-1-git-send-email-me@tobin.cc>
References: <1509510743-28429-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V10 1/2] kasan: use %pK to print addresses instead of %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

In preparation for hashing addresses printed using %p. We need the
actual address for error reporting in kasan.

Use %pK instead of %p to print addresses.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 mm/kasan/report.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 6bcfb01ba038..ad042f025a1a 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -134,7 +134,7 @@ static void print_error_description(struct kasan_access_info *info)
 
 	pr_err("BUG: KASAN: %s in %pS\n",
 		bug_type, (void *)info->ip);
-	pr_err("%s of size %zu at addr %p by task %s/%d\n",
+	pr_err("%s of size %zu at addr %pK by task %s/%d\n",
 		info->is_write ? "Write" : "Read", info->access_size,
 		info->access_addr, current->comm, task_pid_nr(current));
 }
@@ -206,7 +206,7 @@ static void describe_object_addr(struct kmem_cache *cache, void *object,
 	const char *rel_type;
 	int rel_bytes;
 
-	pr_err("The buggy address belongs to the object at %p\n"
+	pr_err("The buggy address belongs to the object at %pK\n"
 	       " which belongs to the cache %s of size %d\n",
 		object, cache->name, cache->object_size);
 
@@ -225,7 +225,7 @@ static void describe_object_addr(struct kmem_cache *cache, void *object,
 	}
 
 	pr_err("The buggy address is located %d bytes %s of\n"
-	       " %d-byte region [%p, %p)\n",
+	       " %d-byte region [%pK, %pK)\n",
 		rel_bytes, rel_type, cache->object_size, (void *)object_addr,
 		(void *)(object_addr + cache->object_size));
 }
@@ -302,7 +302,7 @@ static void print_shadow_for_address(const void *addr)
 		char shadow_buf[SHADOW_BYTES_PER_ROW];
 
 		snprintf(buffer, sizeof(buffer),
-			(i == 0) ? ">%p: " : " %p: ", kaddr);
+			(i == 0) ? ">%pK: " : " %pK: ", kaddr);
 		/*
 		 * We should not pass a shadow pointer to generic
 		 * function, because generic functions may try to
-- 
2.7.4
