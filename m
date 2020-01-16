Return-Path: <SRS0=5Biu=3F=lists.openwall.com=kernel-hardening-return-17564-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E14C32771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C40A52084D
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 01:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="B7I20849"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C40A52084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17564-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3926 invoked by uid 550); 16 Jan 2020 01:24:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3792 invoked from network); 16 Jan 2020 01:24:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q9yyIQHmH5l6RRr9oXrsGBCw2p7gy7/zKkbegYq6Q+s=;
        b=B7I20849zduaZUej22ttALxy7KpacppyUhdQv1th1EbyGmfRtv2NhklqGAXCd1Yk/D
         A2MkOc6mg+JxfrAnAoKrmKGlVo+my3T/Ah2SNdDuBATJOSh66n91QfvL5cLmwAOnMA1w
         CKqyQ779gOAv3EBPiHu5x7+K4nn9ELNeDZaUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9yyIQHmH5l6RRr9oXrsGBCw2p7gy7/zKkbegYq6Q+s=;
        b=C/POZVm5JqJIR8w2jCcKkfkCKqECrWRZGISYbpKXQ0QAwjN3eI1Q+Mj3S+aeucokMN
         u44NO0lBkKvC/oBrrA66mOt54evt//MsNUDTltSO5bfMV7Vd41vUga2PnYz/qKJMJ02t
         VZXHZN983QsipI9TEQGt8/6Vj2UMKP58rK+6A8E4Ic364KFToBn8j/n43cg69YQPKu8z
         HqxZk6Wf1V7oqljCJ8mIDOxzTUjSjzgGPaJP0GJLmGLOTzXbSS3EpkuwvSQPFxJIoJGp
         jqOcQtYJKP7mMf4b/R6XuqeFEoBn49ZA2tKwhLwSrsl7kTtb9Ap2nKMVo/4qiT/fPO6R
         226g==
X-Gm-Message-State: APjAAAXpypRDsMYao60rXJ5ygBrYDsWT+SlyOWm24V3N2BjRKH2Mp7vi
	kxac1tpFkY9USfab5ik7exPMHg==
X-Google-Smtp-Source: APXvYqyOAYblAndR/UL8Abnum2Ky8g1e0MSKZwDdBzyR2nJu09CRBhIWbjiNtyWu1tUKWCTcaalMuw==
X-Received: by 2002:a63:e0f:: with SMTP id d15mr36134094pgl.255.1579137864589;
        Wed, 15 Jan 2020 17:24:24 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	syzkaller@googlegroups.com
Subject: [PATCH v3 6/6] ubsan: Include bug type in report header
Date: Wed, 15 Jan 2020 17:23:21 -0800
Message-Id: <20200116012321.26254-7-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116012321.26254-1-keescook@chromium.org>
References: <20200116012321.26254-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When syzbot tries to figure out how to deduplicate bug reports, it
prefers seeing a hint about a specific bug type (we can do better than
just "UBSAN"). This lifts the handler reason into the UBSAN report line
that includes the file path that tripped a check. Unfortunately, UBSAN
does not provide function names.

Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/lkml/CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/ubsan.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index 429663eef6a7..057d5375bfc6 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -45,13 +45,6 @@ static bool was_reported(struct source_location *location)
 	return test_and_set_bit(REPORTED_BIT, &location->reported);
 }
 
-static void print_source_location(const char *prefix,
-				struct source_location *loc)
-{
-	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
-		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
-}
-
 static bool suppress_report(struct source_location *loc)
 {
 	return current->in_ubsan || was_reported(loc);
@@ -140,13 +133,14 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 	}
 }
 
-static void ubsan_prologue(struct source_location *location)
+static void ubsan_prologue(struct source_location *loc, const char *reason)
 {
 	current->in_ubsan++;
 
 	pr_err("========================================"
 		"========================================\n");
-	print_source_location("UBSAN: Undefined behaviour in", location);
+	pr_err("UBSAN: %s in %s:%d:%d\n", reason, loc->file_name,
+		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
 }
 
 static void ubsan_epilogue(void)
@@ -180,12 +174,12 @@ static void handle_overflow(struct overflow_data *data, void *lhs,
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, type_is_signed(type) ?
+			"signed integer overflow" :
+			"unsigned integer overflow");
 
 	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
-	pr_err("%s integer overflow:\n",
-		type_is_signed(type) ? "signed" : "unsigned");
 	pr_err("%s %c %s cannot be represented in type %s\n",
 		lhs_val_str,
 		op,
@@ -225,7 +219,7 @@ void __ubsan_handle_negate_overflow(struct overflow_data *data,
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "negation overflow");
 
 	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
 
@@ -245,7 +239,7 @@ void __ubsan_handle_divrem_overflow(struct overflow_data *data,
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "division overflow");
 
 	val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
 
@@ -264,7 +258,7 @@ static void handle_null_ptr_deref(struct type_mismatch_data_common *data)
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "NULL pointer dereference");
 
 	pr_err("%s null pointer of type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -279,7 +273,7 @@ static void handle_misaligned_access(struct type_mismatch_data_common *data,
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "misaligned access");
 
 	pr_err("%s misaligned address %p for type %s\n",
 		type_check_kinds[data->type_check_kind],
@@ -295,7 +289,7 @@ static void handle_object_size_mismatch(struct type_mismatch_data_common *data,
 	if (suppress_report(data->location))
 		return;
 
-	ubsan_prologue(data->location);
+	ubsan_prologue(data->location, "object size mismatch");
 	pr_err("%s address %p with insufficient space\n",
 		type_check_kinds[data->type_check_kind],
 		(void *) ptr);
@@ -354,7 +348,7 @@ void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "array index out of bounds");
 
 	val_to_string(index_str, sizeof(index_str), data->index_type, index);
 	pr_err("index %s is out of range for type %s\n", index_str,
@@ -375,7 +369,7 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 	if (suppress_report(&data->location))
 		goto out;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "shift out of bounds");
 
 	val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
 	val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
@@ -407,7 +401,7 @@ EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
 void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "unreachable");
 	pr_err("calling __builtin_unreachable()\n");
 	ubsan_epilogue();
 	panic("can't return from __builtin_unreachable()");
@@ -422,7 +416,7 @@ void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
 	if (suppress_report(&data->location))
 		return;
 
-	ubsan_prologue(&data->location);
+	ubsan_prologue(&data->location, "invalid load");
 
 	val_to_string(val_str, sizeof(val_str), data->type, val);
 
-- 
2.20.1

