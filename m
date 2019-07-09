Return-Path: <SRS0=0cqE=VG=lists.openwall.com=kernel-hardening-return-16397-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAA3C606B0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 05:42:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 514FF2073D
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 05:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 514FF2073D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16397-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1773 invoked by uid 550); 9 Jul 2019 05:42:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1741 invoked from network); 9 Jul 2019 05:42:24 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,469,1557212400"; 
   d="scan'208";a="249045835"
From: NitinGote <nitin.r.gote@intel.com>
To: akpm@linux-foundation.org,
	joe@perches.com
Cc: corbet@lwn.net,
	apw@canonical.com,
	keescook@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Nitin Gote <nitin.r.gote@intel.com>
Subject: [PATCH v2] Added warnings in checkpatch.pl script to :
Date: Tue,  9 Jul 2019 11:10:55 +0530
Message-Id: <20190709054055.21984-1-nitin.r.gote@intel.com>
X-Mailer: git-send-email 2.17.1

From: Nitin Gote <nitin.r.gote@intel.com>

1. Deprecate strcpy() in favor of strscpy().
2. Deprecate strlcpy() in favor of strscpy().
3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Updated strncpy() section in Documentation/process/deprecated.rst
to cover strscpy_pad() case.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
---
 Change log:
 v1->v2
 - For string related apis, created different %deprecated_string_api
   and these will get emitted at CHECK Level using command line option
   -f/--file to avoid bad patched from novice script users.

 This patch is already reviewed by mailing list
 kernel-hardening@lists.openwall.com. Refer below link
 <https://www.openwall.com/lists/kernel-hardening/2019/07/03/4>
Acked-by: Kees Cook <keescook@chromium.org>

 Documentation/process/deprecated.rst |  6 +++---
 scripts/checkpatch.pl                | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 49e0f64a3427..f564de3caf76 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
 and other misbehavior due to the missing termination. It also NUL-pads the
 destination buffer if the source contents are shorter than the destination
 buffer size, which may be a needless performance penalty for callers using
-only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
-(Users of :c:func:`strscpy` still needing NUL-padding will need an
-explicit :c:func:`memset` added.)
+only NUL-terminated strings. In this case, the safe replacement is
+:c:func:`strscpy`. If, however, the destination buffer still needs
+NUL-padding, the safe replacement is :c:func:`strscpy_pad`.

 If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
 still be used, but destinations should be marked with the `__nonstring
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bb28b178d929..10bd72e99dc8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -605,6 +605,21 @@ foreach my $entry (keys %deprecated_apis) {
 }
 $deprecated_apis_search = "(?:${deprecated_apis_search})";

+our %deprecated_string_apis = (
+        "strcpy"                                => "strscpy",
+        "strlcpy"                               => "strscpy",
+        "strncpy"                               => "strscpy, strscpy_pad or for non-NUL-terminated strings,
+         strncpy() can still be used, but destinations should be marked with the __nonstring",
+);
+
+#Create a search pattern for all these strings apis to speed up a loop below
+our $deprecated_string_apis_search = "";
+foreach my $entry (keys %deprecated_string_apis) {
+        $deprecated_string_apis_search .= '|' if ($deprecated_string_apis_search ne "");
+        $deprecated_string_apis_search .= $entry;
+}
+$deprecated_string_apis_search = "(?:${deprecated_string_apis_search})";
+
 our $mode_perms_world_writable = qr{
 	S_IWUGO		|
 	S_IWOTH		|
@@ -6446,6 +6461,16 @@ sub process {
 			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
 		}

+# check for string deprecated apis
+                if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
+                        my $deprecated_string_api = $1;
+                        my $new_api = $deprecated_string_apis{$deprecated_string_api};
+			$check = 1;
+                        CHK("DEPRECATED_API",
+                             "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
+			$check = 0;
+                }
+
 # check for various structs that are normally const (ops, kgdb, device_tree)
 # and avoid what seem like struct definitions 'struct foo {'
 		if ($line !~ /\bconst\b/ &&
--
2.17.1

