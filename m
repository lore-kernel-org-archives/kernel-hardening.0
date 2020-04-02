Return-Path: <SRS0=/vtR=5S=lists.openwall.com=kernel-hardening-return-18382-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC78C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 13:18:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35D4720719
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 13:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OHFqzXVg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35D4720719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18382-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30246 invoked by uid 550); 2 Apr 2020 13:17:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30214 invoked from network); 2 Apr 2020 13:17:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rr2+JiyOTzs2D6VximK33Aonne21icc+eHi8FG/OnsQ=;
        b=OHFqzXVgCRW79+evfsGJ+kuZ94Ph3DbjI/cTcvPV402yG5nto9O5kiCL6nH1/ilwad
         P6532gUewqNBMEgllX6tCRBOtx3JEva1KlJfeC0UgLZdWSfZwkIgEzx0gn3MZuq/clpu
         xzv5W/9bmWHbnCVGIKEOWh01uMHGtNQu0mxXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=rr2+JiyOTzs2D6VximK33Aonne21icc+eHi8FG/OnsQ=;
        b=ROpHz6NGg5dlvkPqr055ltsMBCrWuvtHkhTHHGV7V9/MpT8tSHBDi2ALpbSLK9qGEF
         ScV1bEuWxaSfw5qdMGxqM0QSRXAt97shkRxF+5Lp1ZXjxfyvjJwRTAjUAcO8PDnhAHw/
         F3e0z7/nlzLqzD7dVoUrSbWzYUZmQ8uU1a3ioc9UejFdFu/vC/n9r5AY4jb0iO4bEJIz
         zJae7fLB8RkfDPzSluqI/nDGHUnCjpCIwWjUsbUk0ukgZ4sRyMbI/wQkY2sbIEXBpIMx
         vfxL4o5/bjeS4lWd8jchs560EZBjrwXOApiFVDhcSHFH7WmYIHXtiCabq11JROUs4p3+
         PVNg==
X-Gm-Message-State: AGi0PuZ3Qg6nUZHpnpeoKR/zNfaXNQEO8d8Rt13F3DZlWLfx7PGx6nTt
	Vk9FFqj/UCCWA1H5V9MD2YMnhXEZRQ0=
X-Google-Smtp-Source: APiQypJ1LS6Q4XLKxKhj4KtCkhkkBK2oMRUFgRtWym8HkRx+R3SgX2/W68HhQ4MfO49pRYbr+N4Gmw==
X-Received: by 2002:a63:cf50:: with SMTP id b16mr2200848pgj.189.1585815049479;
        Thu, 02 Apr 2020 01:10:49 -0700 (PDT)
Date: Thu, 2 Apr 2020 01:10:47 -0700
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: Alexander Popov <alex.popov@linux.com>,
	Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] gcc-plugins/stackleak: Avoid assignment for unused macro
 argument
Message-ID: <202004020103.731F201@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

With GCC version >= 8, the cgraph_create_edge() macro argument using
"frequency" goes unused. Instead of assigning a temporary variable for
the argument, pass the compute_call_stmt_bb_frequency() call directly
as the macro argument so that it will just not be uncalled when it is
not wanted by the macros.

Silences the warning:

scripts/gcc-plugins/stackleak_plugin.c:54:6: warning: variable ‘frequency’ set but not used [-Wunused-but-set-variable]

Now builds cleanly with gcc-7 and gcc-9. Both boot and pass
STACKLEAK_ERASING LKDTM test.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/stackleak_plugin.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index dbd37460c573..cc75eeba0be1 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -51,7 +51,6 @@ static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
 	gimple stmt;
 	gcall *stackleak_track_stack;
 	cgraph_node_ptr node;
-	int frequency;
 	basic_block bb;
 
 	/* Insert call to void stackleak_track_stack(void) */
@@ -68,9 +67,9 @@ static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
 	bb = gimple_bb(stackleak_track_stack);
 	node = cgraph_get_create_node(track_function_decl);
 	gcc_assert(node);
-	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
 	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
-			stackleak_track_stack, bb->count, frequency);
+			stackleak_track_stack, bb->count,
+			compute_call_stmt_bb_frequency(current_function_decl, bb));
 }
 
 static bool is_alloca(gimple stmt)
-- 
2.20.1


-- 
Kees Cook
