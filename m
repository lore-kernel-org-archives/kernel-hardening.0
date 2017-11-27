From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 27 Nov 2017 18:18:38 +0100
Message-Id: <1511803118-2552-6-git-send-email-tixxdz@gmail.com>
In-Reply-To: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH v5 next 5/5] net: modules: use request_module_cap() to load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This uses the new request_module_cap() facility to directly propagate
CAP_NET_ADMIN capability and the 'netdev' module prefix to the
capability subsystem as it was suggested.

We do not remove the explicit capable(CAP_NET_ADMIN) check here, but we
may remove it in future versions since it is also performed by the
capability subsystem. This allows to have a better interface where other
subsystems will just use this call and let the capability subsystem
handles the permission checks, if the modules should be loaded or not.

This is also an infrastructure fix since historically Linux always
allowed to auto-load modules without privileges, and later the net code
started to check capabilities and prefixes, adapted the CAP_NET_ADMIN
check with the 'netdev' prefix to prevent abusing the capability by
loading non-netdev modules. However from a bigger picture we want to
continue to support automatic module loading as non privileged but also
implement easy policy solutions like:

User=djalal
DenyNewFeatures=no

Which will translate to allow the interactive user djalal to load extra
Linux features. Others, volatile accounts or guests can be easily
blocked from doing so. We have introduced in previous patches the
necessary infrastructure and now with this change we start to use the
new request_module_cap() function to explicitly tell the capability
subsystem that we want to auto-load modules with CAP_NET_ADMIN if they
are prefixed.

This is also based on suggestions from Rusty Russel and Kees Cook [1]

[1] https://lkml.org/lkml/2017/4/26/735

Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Andy Lutomirski <luto@kernel.org>
Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 net/core/dev_ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7e690d0..fdd8560 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -382,8 +382,10 @@ void dev_load(struct net *net, const char *name)
 	rcu_read_unlock();
 
 	no_module = !dev;
+	/* "netdev-%s" modules are allowed if CAP_NET_ADMIN is set */
 	if (no_module && capable(CAP_NET_ADMIN))
-		no_module = request_module("netdev-%s", name);
+		no_module = request_module_cap(CAP_NET_ADMIN, "netdev",
+					       "%s", name);
 	if (no_module && capable(CAP_SYS_MODULE))
 		request_module("%s", name);
 }
-- 
2.7.4
