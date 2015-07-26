Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 26 Jul 2015 16:46:50 +0300
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20150726134650.GB1111@cachalot>
References: <20150726134324.GA1068@cachalot>
 <20150726134519.GA1111@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150726134519.GA1111@cachalot>
Subject: [kernel-hardening] [PATCH 3/3] remove not-used poison pointer macros
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Vasily Kulikov <segoon@openwall.com> 
---
 include/linux/poison.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index a721bcd..4a27153 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -73,10 +73,6 @@
 #define ATM_POISON_FREE		0x12
 #define ATM_POISON		0xdeadbeef
 
-/********** net/ **********/
-#define NEIGHBOR_DEAD		0xdeadbeef
-#define NETFILTER_LINK_POISON	0xdead57ac
-
 /********** kernel/mutexes **********/
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
@@ -87,7 +83,4 @@
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
-/********** sound/oss/ **********/
-#define OSS_POISON_FREE		0xAB
-
 #endif
-- 
2.1.0
