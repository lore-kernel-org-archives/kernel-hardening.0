Return-Path: <SRS0=FcvL=3J=lists.openwall.com=kernel-hardening-return-17594-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AAFC33CB1
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 184662077C
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="QrJVXlru"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 184662077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17594-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19779 invoked by uid 550); 20 Jan 2020 07:44:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19688 invoked from network); 20 Jan 2020 07:44:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vGzxV+LL88B+fATt6abbCjZqtOsySmjlch7DJWcKIik=;
        b=QrJVXlruig0d5ecXvvbWcbKMcaX9f7bSq3DARYQAlfFXIYLoHZhe0LbKsZiw+/Pkhb
         Kqwn/mlr4ATbaCYDIVX2mYktnHVp6zNt5h0WTR1eNoomrO8vtOC5bN9V61quVFzBdmns
         X1eaQxmScrIri3kpRg8MH1wtaFeo3eYnH+fA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vGzxV+LL88B+fATt6abbCjZqtOsySmjlch7DJWcKIik=;
        b=iHeW3YORWU5L3siacAzBq4cckAro9LVIAAHpreS8itE0OaXQ37bCRPx3Bdju2JT+4C
         4kgr3fKJlsbUftlwOQWSxlV41srLbH+zJS8heHGW+ZLz2IOiQee3scYXV/y2OcMqpYhs
         qqynQWjpGKYTG2jT2FZHNkHaKX4sv4ym+nLqRGXdvs9xLyjg6ttDqqRGUly9FhseZn5u
         T2r6tMP5YVCcB6Ihe6aJSYmZd9r04HUY7K0CGF+KFGf7oKqtNfo/HWdqELl2dHeM39iR
         vHgiyvxbMghiK9NcRk28JMRCIlxe5uO2HCpt39C6vvM9H05Vny5ETMxJ7L7g2n1rmAh+
         8a3A==
X-Gm-Message-State: APjAAAUOSRdZ93hfsSRHcHCBMyyRtHqH5tzcZM52cJqDKWL68JMrdSpj
	UCALMdv2BPttZIaFhPknkCiQM42kTnY=
X-Google-Smtp-Source: APXvYqxRl1/EQDPVjdeMlWwspz86l1VCWkYGZLCYqdRqVMW2QddfAJWpVwh0yCdA65+wQtpZK0Lc5g==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr21966359pjt.122.1579506233119;
        Sun, 19 Jan 2020 23:43:53 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Daniel Axtens <dja@axtens.net>,
	"Igor M. Liplianin" <liplianin@netup.ru>
Subject: [PATCH 1/5] altera-stapl: altera_get_note: prevent write beyond end of 'key'
Date: Mon, 20 Jan 2020 18:43:40 +1100
Message-Id: <20200120074344.504-2-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120074344.504-1-dja@axtens.net>
References: <20200120074344.504-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

altera_get_note is called from altera_init, where key is kzalloc(33).

When the allocation functions are annotated to allow the compiler to see
the sizes of objects, and with FORTIFY_SOURCE, we see:

In file included from drivers/misc/altera-stapl/altera.c:14:0:
In function ‘strlcpy’,
    inlined from ‘altera_init’ at drivers/misc/altera-stapl/altera.c:2189:5:
include/linux/string.h:378:4: error: call to ‘__write_overflow’ declared with attribute error: detected write beyond size of object passed as 1st parameter
    __write_overflow();
    ^~~~~~~~~~~~~~~~~~

That refers to this code in altera_get_note:

    if (key != NULL)
            strlcpy(key, &p[note_strings +
                            get_unaligned_be32(
                            &p[note_table + (8 * i)])],
                    length);

The error triggers because the length of 'key' is 33, but the copy
uses length supplied as the 'length' parameter, which is always
256. Split the size parameter into key_len and val_len, and use the
appropriate length depending on what is being copied.

Detected by compiler error, only compile-tested.

Cc: "Igor M. Liplianin" <liplianin@netup.ru>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/misc/altera-stapl/altera.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/altera-stapl/altera.c b/drivers/misc/altera-stapl/altera.c
index 25e5f24b3fec..5bdf57472314 100644
--- a/drivers/misc/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@ -2112,8 +2112,8 @@ static int altera_execute(struct altera_state *astate,
 	return status;
 }
 
-static int altera_get_note(u8 *p, s32 program_size,
-			s32 *offset, char *key, char *value, int length)
+static int altera_get_note(u8 *p, s32 program_size, s32 *offset,
+			   char *key, char *value, int keylen, int vallen)
 /*
  * Gets key and value of NOTE fields in the JBC file.
  * Can be called in two modes:  if offset pointer is NULL,
@@ -2170,7 +2170,7 @@ static int altera_get_note(u8 *p, s32 program_size,
 						&p[note_table + (8 * i) + 4])];
 
 				if (value != NULL)
-					strlcpy(value, value_ptr, length);
+					strlcpy(value, value_ptr, vallen);
 
 			}
 		}
@@ -2189,13 +2189,13 @@ static int altera_get_note(u8 *p, s32 program_size,
 				strlcpy(key, &p[note_strings +
 						get_unaligned_be32(
 						&p[note_table + (8 * i)])],
-					length);
+					keylen);
 
 			if (value != NULL)
 				strlcpy(value, &p[note_strings +
 						get_unaligned_be32(
 						&p[note_table + (8 * i) + 4])],
-					length);
+					vallen);
 
 			*offset = i + 1;
 		}
@@ -2449,7 +2449,7 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 			__func__, (format_version == 2) ? "Jam STAPL" :
 						"pre-standardized Jam 1.1");
 		while (altera_get_note((u8 *)fw->data, fw->size,
-					&offset, key, value, 256) == 0)
+					&offset, key, value, 32, 256) == 0)
 			printk(KERN_INFO "%s: NOTE \"%s\" = \"%s\"\n",
 					__func__, key, value);
 	}
-- 
2.20.1

