From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH v2] MAINTAINERS: Update LEAKING_ADDRESSES
Date: Mon, 26 Feb 2018 09:27:59 +1100
Message-Id: <1519597679-6101-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

MAINTAINERS is out of date for leaking_addresses.pl. There is now a tree on
kernel.org for development of this script.  We have a second maintainer now,
thanks Tycho.  Development of this scripts was started on kernel-hardening
mailing list so let's keep it there.

Update maintainer details; Add mailing list, kernel.org hosted tree, and second
maintainer.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

v1 subject line: [PATCH] MAINTAINERS: Add list, tree, and maintainer

v2
 - Improve subject line to include section
 - Re-order items to conform to standards (suggested by Joe Perches)

 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bdc260e36b7..80fbb7ab2460 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7905,9 +7905,13 @@ F:	drivers/scsi/53c700*
 
 LEAKING_ADDRESSES
 M:	Tobin C. Harding <me@tobin.cc>
+M:	Tycho Andersen <tycho@tycho.ws>
+L:	kernel-hardening@lists.openwall.com
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
 F:	scripts/leaking_addresses.pl
 
+
 LED SUBSYSTEM
 M:	Richard Purdie <rpurdie@rpsys.net>
 M:	Jacek Anaszewski <jacek.anaszewski@gmail.com>
-- 
2.7.4
