Return-Path: <SRS0=bcS+=VU=lists.openwall.com=kernel-hardening-return-16556-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF22C7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70042218BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 13:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70042218BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16556-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13892 invoked by uid 550); 23 Jul 2019 13:52:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13838 invoked from network); 23 Jul 2019 13:51:58 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: page82_83b617262f530
X-Filterd-Recvd-Size: 3984
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
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH V2 2/2] kernel-doc: core-api: Include string.h into core-api
Date: Tue, 23 Jul 2019 06:51:37 -0700
Message-Id: <29f998b4c1a9d69fbeae70500ba0daa4b340c546.1563889130.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1563889130.git.joe@perches.com>
References: <cover.1563889130.git.joe@perches.com>

core-api should show all the various string functions including the
newly added stracpy and stracpy_pad.

Miscellanea:

o Update the Returns: value for strscpy
o fix a defect with %NUL)

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Correct return of -E2BIG descriptions

 Documentation/core-api/kernel-api.rst |  3 +++
 include/linux/string.h                |  5 +++--
 lib/string.c                          | 10 ++++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index 08af5caf036d..f77de49b1d51 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -42,6 +42,9 @@ String Manipulation
 .. kernel-doc:: lib/string.c
    :export:
 
+.. kernel-doc:: include/linux/string.h
+   :internal:
+
 .. kernel-doc:: mm/util.c
    :functions: kstrdup kstrdup_const kstrndup kmemdup kmemdup_nul memdup_user
                vmemdup_user strndup_user memdup_user_nul
diff --git a/include/linux/string.h b/include/linux/string.h
index 7572cd78cf9f..3cf684db4bc6 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -519,8 +519,9 @@ static inline void memcpy_and_pad(void *dest, size_t dest_len,
  * But this can lead to bugs due to typos, or if prefix is a pointer
  * and not a constant. Instead use str_has_prefix().
  *
- * Returns: 0 if @str does not start with @prefix
-         strlen(@prefix) if @str does start with @prefix
+ * Returns:
+ * * strlen(@prefix) if @str starts with @prefix
+ * * 0 if @str does not start with @prefix
  */
 static __always_inline size_t str_has_prefix(const char *str, const char *prefix)
 {
diff --git a/lib/string.c b/lib/string.c
index 461fb620f85f..f7bc10da4259 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -173,8 +173,9 @@ EXPORT_SYMBOL(strlcpy);
  * doesn't unnecessarily force the tail of the destination buffer to be
  * zeroed.  If zeroing is desired please use strscpy_pad().
  *
- * Return: The number of characters copied (not including the trailing
- *         %NUL) or -E2BIG if the destination buffer wasn't big enough.
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if count is 0 or @src was truncated.
  */
 ssize_t strscpy(char *dest, const char *src, size_t count)
 {
@@ -253,8 +254,9 @@ EXPORT_SYMBOL(strscpy);
  * For full explanation of why you may want to consider using the
  * 'strscpy' functions please see the function docstring for strscpy().
  *
- * Return: The number of characters copied (not including the trailing
- *         %NUL) or -E2BIG if the destination buffer wasn't big enough.
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if count is 0 or @src was truncated.
  */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count)
 {
-- 
2.15.0

