Return-Path: <SRS0=MExo=V4=lists.openwall.com=kernel-hardening-return-16673-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E7CC32751
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 18:00:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20B7C2067D
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 18:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gu1U/Sf5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20B7C2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16673-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5463 invoked by uid 550); 31 Jul 2019 18:00:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5429 invoked from network); 31 Jul 2019 18:00:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=FRx+uLUc3KZyCAuddc+oPKsXnjik76gQN/gmEXW9OR0=;
        b=gu1U/Sf5wItTquYMTsWGjxOpKbFvX6G8j8vnPQfr8dIrUzAEdFWOp/doTNqUe/yH4x
         lmj4cyGkaJpkdDym4wZD2eekDodpvCTLSjn2vvUhsgi8UGbrXHzR9IWpTnynB+LzXllJ
         S1tuqczMFGVaEGAi89Ij8RpOSUdvbEL7NfV5XoeczdLtgevPRi3EC7tIc6ClAecSVO3X
         YL0zt7IWfXzCa81eFvv6ZUqQsATbv5UMvlXSw8g1m3HbBOIhM7LfgP4a+jknbGdGeGe5
         5TsQHmX3Xw+/qPV/I7N4NKJwn0TazchFtfm4ob7IrpasKm+NvGl9Co7GmFphAtMCh5aT
         hnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FRx+uLUc3KZyCAuddc+oPKsXnjik76gQN/gmEXW9OR0=;
        b=FIvUPIq9zSTU6j+BsPvv2sLVuR26oWP8ZIDHhLlX+e6VxJXI/zsr7Udwrvkt/Ao0x0
         k2nprFTOp/vwWTqBeu3m0AkcOZRB4VCM0kxPsaaubZ651g2GLXvd8Hk7QbWVyLS5Ldvj
         AH2tlkJiny0cx69ySQ6lwDkdNttzMn641svKypeGRJXRn5hv+PntXcsNiyzhBehk3VnO
         45YhM1QyZFpFSxhl4Lq70XlkUi+MzsjSxDOBeR30tehjARb5Vb05/JtgomBvDmjrOjus
         1CN29GkwkwlGhL/8xA9+lbFVZCUU2dCGmeeUiVE6S5tcoa04Y+ZPq08tO/Q8kQ0pshbd
         BaJw==
X-Gm-Message-State: APjAAAV+XNU0c0dpXca4kKH7S9nFtSssUc59VIAeBwZ8u4FsBnWZ8hzL
	n+HXa6en4w+0xFEcI+yzo1A=
X-Google-Smtp-Source: APXvYqwZuHT7YK4tM/LtFJdXWvQ1Gru+TpgeeJWZcFRMPf9EjVmIuiH5DPpHS3XrbLf0PXy1ORaxqg==
X-Received: by 2002:a62:e910:: with SMTP id j16mr50018305pfh.123.1564596039923;
        Wed, 31 Jul 2019 11:00:39 -0700 (PDT)
Date: Thu, 1 Aug 2019 03:00:27 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: [PATCH 0/2] fix is_pure_ops_struct()
Message-ID: <cover.1564595346.git.kjw1627@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)

Hello,

This series fixes unreachable code bug and removes dead code in
is_pure_ops_struct().

Thanks.

Joonwon Kang (2):
  randstruct: fix a bug in is_pure_ops_struct()
  randstruct: remove dead code in is_pure_ops_struct()

 scripts/gcc-plugins/randomize_layout_plugin.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

-- 
2.17.1

