From: "Tobin C. Harding" <me@tobin.cc>
Date: Sat,  6 Jan 2018 09:59:32 +1100
Message-Id: <1515193172-20279-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH] leaking_addresses: add files to skip
To: linux-kernel@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, kaiwan.billimoria@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Script currently times out when parsing the following files:

	/proc/kallsyms
	/proc/sched_debug
	/proc/PID/smaps

None of these files leak kernel addresses. We can skip parsing them.

Add entries to list of files to skip.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index ce5d58f3e619..32e2fc9fc8c3 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -58,7 +58,9 @@ my @skip_parse_files_abs = ('/proc/kmsg',
 			    '/sys/firmware/devicetree',
 			    '/proc/device-tree',
 			    '/sys/kernel/debug/tracing/trace_pipe',
-			    '/sys/kernel/security/apparmor/revision');
+			    '/sys/kernel/security/apparmor/revision',
+			    '/proc/kallsyms',
+			    '/proc/sched_debug');
 
 # Do not parse these files under any subdirectory.
 my @skip_parse_files_any = ('0',
@@ -71,7 +73,8 @@ my @skip_parse_files_any = ('0',
 			    'snapshot_raw',
 			    'trace_pipe_raw',
 			    'ptmx',
-			    'trace_pipe');
+			    'trace_pipe',
+			    'smaps');
 
 # Do not walk these directories (absolute path).
 my @skip_walk_dirs_abs = ();
-- 
2.7.4
