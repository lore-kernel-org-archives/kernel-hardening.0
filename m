Return-Path: <SRS0=VkvY=VV=lists.openwall.com=kernel-hardening-return-16576-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616ACC7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 15:54:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B2F29229F3
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 15:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ik90mLvO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2F29229F3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16576-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26576 invoked by uid 550); 24 Jul 2019 15:54:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26558 invoked from network); 24 Jul 2019 15:54:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JHukw73OgEOriwdsLMhpivCbyH6cvsJtw9qqzYYPqGE=;
        b=Ik90mLvOG+X12MYkfJNW6qLHk5ypaW1M2wjaht/c5226g1ypJeQVluQAmvTh2XlhXC
         7If3MJd50Bgsp/roy1lFi1cKyhpozoMHxhSG3ucy/tZhW6gVM9s0OYayAeuTsS0sqxVR
         WmAHl1K/AZrKp4dV8wxVthI00OdOR0xVxLNAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JHukw73OgEOriwdsLMhpivCbyH6cvsJtw9qqzYYPqGE=;
        b=WUrIJneruOFlmCbSzLZIT7ph7Q/eU4rBR1MdsbOtRuPw6CwaC3NIQDK53GJo8YwIwz
         poUR4FWbz+GS7YsxO4FiPN9c6B4kGmxvNckjOkA1EPdpgRcxoE9Reojf0M2ShWclu08r
         Zd76K3CP2n51q46VUl3OCdUxzU2ITfCts/KHOCToejBB45WEENTqDJAQgcaLlwaP6jWS
         fojAoEn/onxvrHT/5FzKZbIMYo67ZlNaa0Bo6ET9+tkdEppcQqf2MeU593Q0b/jOCIoX
         Qf57Bbo4tzXtIz3SEfCH5c8jNMoekJWGJCnK9g8fT7zY9p0J8HlKqdEk7yWAyUA53V6i
         ggfQ==
X-Gm-Message-State: APjAAAXgFdMqTk4wRYFRZBKWPyz2ZSUjAsRVsZx8yBKjx7PCg5Hmj6OT
	gc26F0zSbiQuN2xcJRxtsJtiiQ==
X-Google-Smtp-Source: APXvYqynOrVoLdvqWKYRZRVAhvhaA12eXVFnmOQowISaUwv4yMX6yfjlcao9aUbIf+j3Ef+pi6vEvw==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr88610142pjz.117.1563983645153;
        Wed, 24 Jul 2019 08:54:05 -0700 (PDT)
Date: Wed, 24 Jul 2019 08:54:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	NitinGote <nitin.r.gote@intel.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Eric Paris <eparis@parisplace.org>,
	SElinux list <selinux@vger.kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
Message-ID: <201907240852.6D10622B2@keescook>
References: <20190722113151.1584-1-nitin.r.gote@intel.com>
 <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
 <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>
 <201907231516.11DB47AA@keescook>
 <CAG48ez2eXJwE+vS2_ahR9Vuc3qD8O4CDZ5Lh6DcrrOq+7VKOYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2eXJwE+vS2_ahR9Vuc3qD8O4CDZ5Lh6DcrrOq+7VKOYQ@mail.gmail.com>

On Wed, Jul 24, 2019 at 04:28:31PM +0200, Jann Horn wrote:
> On Wed, Jul 24, 2019 at 12:17 AM Kees Cook <keescook@chromium.org> wrote:
> > Perhaps we need a "statistics" counter type for these kinds of counters?
> > "counter_t"? I bet there are a lot of atomic_t uses that are just trying
> > to be counters. (likely most of atomic_t that isn't now refcount_t ...)
> 
> This isn't a statistics counter though; this thing needs ordered
> memory accesses, which you wouldn't need for statistics.

Okay, it'd be a "very accurate" counter type? It _could_ be used for
statistics. I guess what I mean is that there are a lot of places using
atomic_t just for upward counting that don't care about wrapping, etc.

-- 
Kees Cook
