Return-Path: <SRS0=3KzG=VU=lists.openwall.com=kernel-hardening-return-16541-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3A9C76190
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 00:38:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2347A21BE6
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 00:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2347A21BE6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16541-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23670 invoked by uid 550); 23 Jul 2019 00:38:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22513 invoked from network); 23 Jul 2019 00:38:35 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wheel67_2bd70514adf25
X-Filterd-Recvd-Size: 3459
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>,
	Kees Cook <keescook@chromium.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com,
	kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Date: Mon, 22 Jul 2019 17:38:15 -0700
Message-Id: <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1563841972.git.joe@perches.com>
References: <cover.1563841972.git.joe@perches.com>

Several uses of strlcpy and strscpy have had defects because the
last argument of each function is misused or typoed.

Add macro mechanisms to avoid this defect.

stracpy (copy a string to a string array) must have a string
array as the first argument (to) and uses sizeof(to) as the
size.

These mechanisms verify that the to argument is an array of
char or other compatible types like u8 or unsigned char.

A BUILD_BUG is emitted when the type of to is not compatible.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/string.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 4deb11f7976b..f80b0973f0e5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -35,6 +35,47 @@ ssize_t strscpy(char *, const char *, size_t);
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
 
+/**
+ * stracpy - Copy a C-string into an array of char
+ * @to: Where to copy the string, must be an array of char and not a pointer
+ * @from: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy.
+ * Copies a maximum of sizeof(@to) bytes of @from with %NUL termination.
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @to is a zero size array.
+ */
+#define stracpy(to, from)					\
+({								\
+	size_t size = ARRAY_SIZE(to);				\
+	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
+								\
+	strscpy(to, from, size);				\
+})
+
+/**
+ * stracpy_pad - Copy a C-string into an array of char with %NUL padding
+ * @to: Where to copy the string, must be an array of char and not a pointer
+ * @from: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy_pad.
+ * Copies a maximum of sizeof(@to) bytes of @from with %NUL termination
+ * and zero-pads the remaining size of @to
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @to is a zero size array.
+ */
+#define stracpy_pad(to, from)					\
+({								\
+	size_t size = ARRAY_SIZE(to);				\
+	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
+								\
+	strscpy_pad(to, from, size);				\
+})
+
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
 #endif
-- 
2.15.0

