From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 2/3] leaking_addresses: skip '/proc/1/syscall'
Date: Tue, 27 Feb 2018 15:45:10 +1100
Message-Id: <1519706711-18580-3-git-send-email-me@tobin.cc>
In-Reply-To: <1519706711-18580-1-git-send-email-me@tobin.cc>
References: <1519706711-18580-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

The pointers listed in /proc/1/syscall are user pointers, and negative
syscall args will show up like kernel addresses.

For example

/proc/31808/syscall: 0 0x3 0x55b107a38180 0x2000 0xffffffffffffffb0 \
0x55b107a302d0 0x55b107a38180 0x7fffa313b8e8 0x7ff098560d11

Skip parsing /proc/1/syscall

Reported-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index fb40e2828f43..ac84a164a528 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -60,6 +60,7 @@ my $page_offset_32bit = 0;	# Page offset for 32-bit kernel.
 my @skip_abs = (
 	'/proc/kmsg',
 	'/proc/device-tree',
+	'/proc/1/syscall',
 	'/sys/firmware/devicetree',
 	'/sys/kernel/debug/tracing/trace_pipe',
 	'/sys/kernel/security/apparmor/revision');
-- 
2.7.4
