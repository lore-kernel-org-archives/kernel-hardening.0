Return-Path: <SRS0=GXQ8=AZ=lists.openwall.com=kernel-hardening-return-19299-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBADC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 00:02:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E02121883
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 00:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VyWImzAa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E02121883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19299-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32131 invoked by uid 550); 14 Jul 2020 00:02:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32094 invoked from network); 14 Jul 2020 00:02:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mbFAIuqzTHeVd9pAzA2rWMcBebKkbwn3z6c3vYPviE0=;
        b=VyWImzAaZGosylSb2Z1IrTzcEwFeV4vgfnex1Q3khH6rHsbhUvYG1fK5lDyj32+tT2
         NGQw15Ae21R5RSd8Adfq8crx9w/TkrMoOHp3XZ+4ruQi/KLB+LKystPxj8+vNh9DWFk4
         2jdGHQ14GMJ2nQVKbZoiuhBDgMpCslN3732Iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mbFAIuqzTHeVd9pAzA2rWMcBebKkbwn3z6c3vYPviE0=;
        b=KiAEL3E4PqPidQeifTG8uxhLKdMEw7Y2bHn+GDMZVn/tWfvgOc0IWlbkhTITKog6c0
         +ZDLWaMiNDkcQ2nU8dNG6wW+zflkz0xmLFGoxwvwH9KpiUvLS2jTOh/BQhVLPw+Zq7U1
         cgfWiP170rfSrxDdtZj3DtgtqaTxR76g3VLGAJkyV6zRjIRWPAFyf0S8lELmM1Pv+ftR
         ol5CabnF3PUqCZL9pky1HZg6Wa+mk4kKh9BQ4ABxq0XVwcQOx1FA3OsaX31nHiXAP+W9
         AoUTYD9XqJw1Sor0jTyfWXDglg65NJhmprSOSY50P/cPLUTvNNLo77WRENNP3y2qHdwf
         0AZg==
X-Gm-Message-State: AOAM531hMPu2rMstXagXv6P1pecpJ2fmrr6iNHUn/spG8GT6TQxVSco/
	GnJpZx7mgXBzSW1IyMr9e/crOw==
X-Google-Smtp-Source: ABdhPJxeI05OWQ1yRSNYrIt2cdh3+CNJ7LdifuLYdehpSGU+Hih3Y6loj9dFg/dHk7T9oGRAK/lvAA==
X-Received: by 2002:a63:f814:: with SMTP id n20mr1267596pgh.92.1594684931594;
        Mon, 13 Jul 2020 17:02:11 -0700 (PDT)
Date: Mon, 13 Jul 2020 17:02:09 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007131658.69C96B7D3@keescook>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com>

On Mon, Jul 13, 2020 at 03:54:44PM +0530, Allen wrote:
> https://github.com/allenpais/tasklets/commits/ref_tasklets

Okay, I took a look at this series. I'd like to introduce the new API
differently than was done for timer_struct because I think it'll be
easier and more CFI-friendly. Here's what I've got:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/tasklets/new-api/v1

All the rest can apply on top of that (though it looks like many patches
need work, I got a lot of errors from "make allmodconfig && make".

How does that look?

-- 
Kees Cook
