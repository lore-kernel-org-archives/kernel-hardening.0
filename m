Return-Path: <SRS0=MyrV=DG=lists.openwall.com=kernel-hardening-return-20019-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2F5C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:19:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7689F208B8
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:19:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EgdYcQxE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7689F208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20019-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7486 invoked by uid 550); 29 Sep 2020 18:19:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7451 invoked from network); 29 Sep 2020 18:19:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=glZ74uXs4uVYpYfsBsjhUYHj82y51C7rtcPVZ0nTWqQ=;
        b=EgdYcQxE7ZZjtGIKn7hfGvTL2dAAS4WYGICct/4ovCNiMZS8Km97CjFJt3irHOI5b0
         1NWe9X+2BEnZBNDw5VjAHScU5u1VsM0MZGeZL2ZPww6WQLY/oSfCJ+ylsXnv6zQCov1F
         A9BS2Ff1KEPFtA7BOyPRVy9zLkxBaesNC7P0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=glZ74uXs4uVYpYfsBsjhUYHj82y51C7rtcPVZ0nTWqQ=;
        b=S2/QJ0XkNUc0ejxE1/UhOfvCvGwWKx/8XBhF3ChkNN3vke9QhjcRqYP7ND+DC88zBa
         mcaHo7rhEIag6Xyd6ou5bemHQkBgVUGnTBLSk9J4lf1xs3tFXshRKnTjwPfGH6721noC
         cZRqD6gY6x07Jq1cRY3i2CnmInwfrQyYurxYLhFBBNO/dE4xYXPGJW9BXyaOCKYgvm7d
         fGrNP4Rw+TEdgqaIe2klGitPhaH4COFZacYgtb0lQHnpbGkLm4P/4fJtdMlQYMXMvpVt
         KCpMtl4aw13f1LGwt/m+uCYJW68do5eVbPOl1PZl3Qj/vQi7m6O9Wbwm0uKTS144BSA2
         TObg==
X-Gm-Message-State: AOAM530sfcOGyu+ILnbwXwGhJElUWWC4r4oNBZErEZt6hdmkiwPp2pCf
	0oNp0ayf02FyhZ7skVX8MSbLwtMUdKsQLE7C
X-Google-Smtp-Source: ABdhPJzuL2+fzVC78Z9pEdc5ORcVZEwJAqOmtAdORpe3kHYq4M0bJk0KZSyfqie2KFGEJ6y7C2rEtg==
X-Received: by 2002:a63:2319:: with SMTP id j25mr3946103pgj.75.1601399645297;
        Tue, 29 Sep 2020 10:14:05 -0700 (PDT)
Date: Tue, 29 Sep 2020 10:14:03 -0700
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Linux-specific kernel hardening
Message-ID: <202009281907.946FBE7B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

The work of improving the Linux kernel's security is, of course,
and endless task. While many of the new features come through on the
kernel-hardening@lists.openwall.com list[1], there is a stated desire
to avoid "maintenance" topics[2] on the list, and that isn't compatible
with the on-going work done within the upstream Linux kernel development
community, which may need to discuss the nuances of performing that work.

As such there is now a new list, linux-hardening@vger.kernel.org[3],
which will take kernel-hardening's place in the Linux MAINTAINERS
file. New topics and on-going work will be discussed there, and I urge
anyone interested in Linux kernel hardening to join the new list. It's
my intention that all future upstream work can be CCed there, following
the standard conventions of the Linux development model, for better or
worse. ;)

For anyone discussing new topics or ideas, please continue to CC
kernel-hardening too, as there will likely be many people only subscribed
there. Hopefully this will get the desired split of topics between the
two lists.

Thanks and take care,

-Kees

[1] https://www.openwall.com/lists/kernel-hardening/
    https://lore.kernel.org/kernel-hardening/

[2] https://lore.kernel.org/kernel-hardening/20200902121604.GA10684@openwall.com/

[3] http://vger.kernel.org/vger-lists.html#linux-hardening
    https://lore.kernel.org/linux-hardening/

-- 
Kees Cook
