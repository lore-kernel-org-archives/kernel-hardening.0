From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 29 Nov 2017 13:05:01 +1100
Message-Id: <1511921105-3647-2-git-send-email-me@tobin.cc>
In-Reply-To: <1511921105-3647-1-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V11 1/5] docs: correct documentation for %pK
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Current documentation indicates that %pK prints a leading '0x'. This is
not the case.

Correct documentation for printk specifier %pK.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/printk-formats.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 361789df51ec..71b62db7eca2 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -85,13 +85,12 @@ Examples::
 	printk("Faulted at %pS\n", (void *)regs->ip);
 	printk(" %s%pB\n", (reliable ? "" : "? "), (void *)*stack);
 
-
 Kernel Pointers
 ===============
 
 ::
 
-	%pK	0x01234567 or 0x0123456789abcdef
+	%pK	01234567 or 0123456789abcdef
 
 For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
-- 
2.7.4
