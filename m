Return-Path: <SRS0=XKYJ=6Y=lists.openwall.com=kernel-hardening-return-18743-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E957C47257
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 02:14:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DFA5E208DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 02:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CB1zlWsc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFA5E208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18743-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18357 invoked by uid 550); 10 May 2020 02:14:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18322 invoked from network); 10 May 2020 02:14:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cEaISn4aYW6sNpdaPku8rFfOgtLafeMU2iyoWjdjjIo=;
        b=CB1zlWscAJiNGPFdk+mvKg1Ror2ZwaWyjHTl6hA63TPJAJ54YNXsmNndHRRgWBadoh
         m7h089nXKGmFJtDB0dgKycY4IG7kCuSFeDgqhw2StcpmsTcA8ScQK7/9//qEl4RglKLb
         q2za0cl72jGSP41zzdmNeOVJl3CbJ8mZEyTUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cEaISn4aYW6sNpdaPku8rFfOgtLafeMU2iyoWjdjjIo=;
        b=GMMbuFetLKSzNnPPYdps+el5SJFKrQXcCg/m3uLqtQS4r/yc8wJbq1O1s1hkRUjlDd
         Ncam25SeR3UFo/LVYEfX4545hsnEkX8CV4sKzEpLPv1F4UcrrxHqNvr1BvOhl2ovO0cf
         ukeV4D0vSvHIy0SMkmEa5k35mCucGDkD0q/dK5T4LbEu/MWLhzCP6QJFLn3+vdsFQMG7
         gGGx6ibvOcQwiIl0H2zssjRCns7PwzKAfDE4mJwuxT6cJHIvekS5pxaVnQ9mwR4thdMG
         9WpCqd0Dq5oTP5e+1VMSjS+QNS65uOy4tcdLfC3rSiKCU0YQoVAzmMLuJsJpUfjEoR5v
         qsFQ==
X-Gm-Message-State: AGi0PuamL5l2WgzZftiBbde8ZX0n9jU7cuBVrYJXZ75hz1WOLd4MDInJ
	tXwJEpLaPmb9Cik2yBZBwX0uSQ==
X-Google-Smtp-Source: APiQypK/WEi9HEriHyYud4v8Zjn3umQzs6Ce8tTau6FjoLV4/bJA8pc/CHX7Or5DHWDchH0mPHswFA==
X-Received: by 2002:a17:90a:8b:: with SMTP id a11mr13947466pja.163.1589076853704;
        Sat, 09 May 2020 19:14:13 -0700 (PDT)
Date: Sat, 9 May 2020 19:14:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins: remove always false $(if ...) in Makefile
Message-ID: <202005091914.4B8CACB91@keescook>
References: <20200510020044.958018-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510020044.958018-1-masahiroy@kernel.org>

On Sun, May 10, 2020 at 11:00:44AM +0900, Masahiro Yamada wrote:
> This is the remnant of commit c17d6179ad5a ("gcc-plugins: remove unused
> GCC_PLUGIN_SUBDIR").
> 
> $(if $(findstring /,$(p)),...) is always false because none of plugins
> contains '/' in the file name.
> 
> Clean up the code.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
