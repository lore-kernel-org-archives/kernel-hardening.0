From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 29 Nov 2017 13:05:05 +1100
Message-Id: <1511921105-3647-6-git-send-email-me@tobin.cc>
In-Reply-To: <1511921105-3647-1-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V11 5/5] kasan: use %px to print addresses instead of %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Pointers printed with %p are now hashed by default. Kasan needs the
actual address. We can use the new printk specifier %px for this
purpose.

Use %px instead of %p to print addresses.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 mm/kasan/report.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 6bcfb01ba038..410c8235e671 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -134,7 +134,7 @@ static void print_error_description(struct kasan_access_info *info)
 
 	pr_err("BUG: KASAN: %s in %pS\n",
 		bug_type, (void *)info->ip);
-	pr_err("%s of size %zu at addr %p by task %s/%d\n",
+	pr_err("%s of size %zu at addr %px by task %s/%d\n",
 		info->is_write ? "Write" : "Read", info->access_size,
 		info->access_addr, current->comm, task_pid_nr(current));
 }
@@ -206,7 +206,7 @@ static void describe_object_addr(struct kmem_cache *cache, void *object,
 	const char *rel_type;
 	int rel_bytes;
 
-	pr_err("The buggy address belongs to the object at %p\n"
+	pr_err("The buggy address belongs to the object at %px\n"
 	       " which belongs to the cache %s of size %d\n",
 		object, cache->name, cache->object_size);
 
@@ -225,7 +225,7 @@ static void describe_object_addr(struct kmem_cache *cache, void *object,
 	}
 
 	pr_err("The buggy address is located %d bytes %s of\n"
-	       " %d-byte region [%p, %p)\n",
+	       " %d-byte region [%px, %px)\n",
 		rel_bytes, rel_type, cache->object_size, (void *)object_addr,
 		(void *)(object_addr + cache->object_size));
 }
@@ -302,7 +302,7 @@ static void print_shadow_for_address(const void *addr)
 		char shadow_buf[SHADOW_BYTES_PER_ROW];
 
 		snprintf(buffer, sizeof(buffer),
-			(i == 0) ? ">%p: " : " %p: ", kaddr);
+			(i == 0) ? ">%px: " : " %px: ", kaddr);
 		/*
 		 * We should not pass a shadow pointer to generic
 		 * function, because generic functions may try to
-- 
2.7.4
