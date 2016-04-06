Reply-To: kernel-hardening@lists.openwall.com
From: Emrah Demir < ed@abdsec.com >
Date: Wed,  6 Apr 2016 16:03:02 +0300
Message-Id: <1459947782-5071-1-git-send-email-ed@abdsec.com>
Subject: [kernel-hardening] [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, dan.j.rosenberg@gmail.com, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org, davej@redhat.com, Emrah Demir <ed@abdsec.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Emrah Demir <ed@abdsec.com>

Even though KASLR is aiming to mitigate remote attacks, with a simple LFI vulnerability through a web application, local leaks become as important as remote ones.
On the KASLR enabled systems in order to achieve expected protection, some files are needed to edited/modified to prevent leaks.

/proc/iomem file leaks offset of text section. By adding 0x80000000, Attackers can get _text base address. KASLR will be bypassed.

$ cat /proc/iomem | grep 'Kernel code'
38600000-38b7fe92 : Kernel code
$ python -c 'print hex(0x38600000 + 0x80000000)'
0xb8600000
# cat /proc/kallsyms | grep 'T _text'
ffffffffb8600000 T _text

By this patch after insertion resources, start and end address are zeroed. /proc/iomem and /proc/ioports sources, which use request_resource and insert_resource now shown as 0 value.

Signed-off-by: Emrah Demir <ed@abdsec.com>
---
 kernel/resource.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index 2e78ead..5b9937e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -321,6 +321,8 @@ int request_resource(struct resource *root, struct resource *new)
 	struct resource *conflict;
 
 	conflict = request_resource_conflict(root, new);
+	new->start = 0;
+	new->end = 0;
 	return conflict ? -EBUSY : 0;
 }
 
@@ -864,6 +866,8 @@ int insert_resource(struct resource *parent, struct resource *new)
 	struct resource *conflict;
 
 	conflict = insert_resource_conflict(parent, new);
+	new->start = 0;
+	new->end = 0;
 	return conflict ? -EBUSY : 0;
 }
 EXPORT_SYMBOL_GPL(insert_resource);
-- 
2.8.0.rc3
