Return-Path: <SRS0=kOCb=VU=lists.openwall.com=kernel-hardening-return-16555-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E68C7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1DA0A218BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DA0A218BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16555-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13673 invoked by uid 550); 23 Jul 2019 13:51:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13559 invoked from network); 23 Jul 2019 13:51:56 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: silk37_83499df992928
X-Filterd-Recvd-Size: 3970
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
Subject: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
Date: Tue, 23 Jul 2019 06:51:36 -0700
Message-Id: <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1563889130.git.joe@perches.com>
References: <cover.1563889130.git.joe@perches.com>

Several uses of strlcpy and strscpy have had defects because the
last argument of each function is misused or typoed.

Add macro mechanisms to avoid this defect.

stracpy (copy a string to a string array) must have a string
array as the first argument (dest) and uses sizeof(dest) as the
count of bytes to copy.

These mechanisms verify that the dest argument is an array of
char or other compatible types like u8 or s8 or equivalent.

A BUILD_BUG is emitted when the type of dest is not compatible.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Use __same_type testing char[], signed char[], and unsigned char[]
    Rename to, from, and size, dest, src and count
    Correct return of -E2BIG descriptions

 include/linux/string.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 4deb11f7976b..7572cd78cf9f 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -35,6 +35,51 @@ ssize_t strscpy(char *, const char *, size_t);
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
 
+/**
+ * stracpy - Copy a C-string into an array of char/u8/s8 or equivalent
+ * @dest: Where to copy the string, must be an array of char and not a pointer
+ * @src: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy().
+ * Copies a maximum of sizeof(@dest) bytes of @src with %NUL termination.
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @dest is a zero size array or @src was truncated.
+ */
+#define stracpy(dest, src)						\
+({									\
+	size_t count = ARRAY_SIZE(dest);				\
+	BUILD_BUG_ON(!(__same_type(dest, char[]) ||			\
+		       __same_type(dest, unsigned char[]) ||		\
+		       __same_type(dest, signed char[])));		\
+									\
+	strscpy(dest, src, count);					\
+})
+
+/**
+ * stracpy_pad - Copy a C-string into an array of char/u8/s8 with %NUL padding
+ * @dest: Where to copy the string, must be an array of char and not a pointer
+ * @src: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy_pad().
+ * Copies a maximum of sizeof(@dest) bytes of @src with %NUL termination
+ * and zero-pads the remaining size of @dest
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @dest is a zero size array or @src was truncated.
+ */
+#define stracpy_pad(dest, src)						\
+({									\
+	size_t count = ARRAY_SIZE(dest);				\
+	BUILD_BUG_ON(!(__same_type(dest, char[]) ||			\
+		       __same_type(dest, unsigned char[]) ||		\
+		       __same_type(dest, signed char[])));		\
+									\
+	strscpy_pad(dest, src, count);					\
+})
+
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
 #endif
-- 
2.15.0

