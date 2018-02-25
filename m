From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] MAINTAINERS: Add list, tree, and maintainer
Date: Sun, 25 Feb 2018 18:35:53 +1100
Message-Id: <1519544153-10360-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, tycho@tycho.ws
List-ID: <kernel-hardening.lists.openwall.com>

MAINTAINERS is out of date for leaking_addresses.pl. There is now a tree on
kernel.org for development of this script.  We have a second maintainer now,
thanks Tycho.  Development of this scripts was started on kernel-hardening
mailing list so let's keep it there.

Update maintainer details; Add mailing list, kernel.org hosted tree, and second
maintainer.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bdc260e36b7..e91b5ff1f5d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7905,8 +7905,11 @@ F:	drivers/scsi/53c700*
 
 LEAKING_ADDRESSES
 M:	Tobin C. Harding <me@tobin.cc>
+M:	Tycho Andersen <tycho@tycho.ws>
 S:	Maintained
 F:	scripts/leaking_addresses.pl
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
+L:	kernel-hardening@lists.openwall.com
 
 LED SUBSYSTEM
 M:	Richard Purdie <rpurdie@rpsys.net>
-- 
2.7.4
