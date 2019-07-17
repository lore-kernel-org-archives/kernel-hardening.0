Return-Path: <SRS0=ZyRM=VO=lists.openwall.com=kernel-hardening-return-16492-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB37C76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 04:31:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4312C21743
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2019 04:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4312C21743
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16492-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7352 invoked by uid 550); 17 Jul 2019 04:31:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7317 invoked from network); 17 Jul 2019 04:31:40 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,272,1559545200"; 
   d="scan'208";a="251375368"
From: NitinGote <nitin.r.gote@intel.com>
To: joe@perches.com,
	corbet@lwn.net
Cc: akpm@linux-foundation.org,
	apw@canonical.com,
	keescook@chromium.org,
	linux-doc@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Nitin Gote <nitin.r.gote@intel.com>
Subject: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad over strcpy/strlcpy/strncpy
Date: Wed, 17 Jul 2019 10:00:05 +0530
Message-Id: <20190717043005.19627-1-nitin.r.gote@intel.com>
X-Mailer: git-send-email 2.17.1

From: Nitin Gote <nitin.r.gote@intel.com>

Added check in checkpatch.pl to
1. Deprecate strcpy() in favor of strscpy().
2. Deprecate strlcpy() in favor of strscpy().
3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Updated strncpy() section in Documentation/process/deprecated.rst
to cover strscpy_pad() case.

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
---
 Documentation/process/deprecated.rst |  6 +++---
 scripts/checkpatch.pl                | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 49e0f64a3427..c348ef9d44f5 100644
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
+strscpy(). If, however, the destination buffer still needs NUL-padding,
+the safe replacement is strscpy_pad().

 If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
 still be used, but destinations should be marked with the `__nonstring
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bb28b178d929..1bb12127115d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
 }
 $deprecated_apis_search = "(?:${deprecated_apis_search})";

+our %deprecated_string_apis = (
+        "strcpy"				=> "strscpy",
+        "strlcpy"				=> "strscpy",
+        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with __nonstring",
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
@@ -6446,6 +6460,16 @@ sub process {
 			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
 		}

+# check for string deprecated apis
+		if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
+			my $deprecated_string_api = $1;
+			my $new_api = $deprecated_string_apis{$deprecated_string_api};
+			my $msg_level = \&WARN;
+			$msg_level = \&CHK if ($file);
+			&{$msg_level}("DEPRECATED_API",
+				      "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
+		}
+
 # check for various structs that are normally const (ops, kgdb, device_tree)
 # and avoid what seem like struct definitions 'struct foo {'
 		if ($line !~ /\bconst\b/ &&
--
2.17.1

