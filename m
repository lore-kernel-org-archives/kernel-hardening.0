Return-Path: <SRS0=WLqH=62=lists.openwall.com=kernel-hardening-return-18765-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5C6C54E4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 05:55:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C9AE20733
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 05:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="YOi9zu/t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C9AE20733
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18765-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3651 invoked by uid 550); 12 May 2020 05:55:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3619 invoked from network); 12 May 2020 05:55:45 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 04C5tN2H031680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1589262924;
	bh=R1QyXhhfi6uyVISRMA353yWXmI83w82IGzf0lqkZ32g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YOi9zu/tAzeXRtqq4nr6XnAPOx019n+87/gbNmPG70ira4CC+pRfweZJ9djbiCZPK
	 VZufngkacRsVURSLzA/nCVZPjoiGHayewU7Fc9CdYMyAyAdY+tNN9HeWmUtwj0jT2I
	 bDASttsRnCLSwoUuGMAmEEI4H3tM78G4yrwGrZujzfqIHH+cqRm4cVIRMQjLAaD3Zj
	 00VZyOFRx1PPOd7sgqtCT6OguHHbao6Ade90TN0l6p+jOlnpiipCXU+2v6R+CgV7Bi
	 3+v4QXBbAUqZAQSWwPSYLE/klYd9BMaPlJJRFWL3S2NzsuawfgPo1Tr8PTFtIQ49qI
	 QqcZjgyyZECZw==
X-Nifty-SrcIP: [209.85.222.54]
X-Gm-Message-State: AOAM532KPWGcOxbljBWLUawTzBvW4Nsk/QKoCtyaVpWJwkfEftrZYbby
	vsVvyzms+Sp2Va2DtYEqNHN6cDV4b9+Yjo392+E=
X-Google-Smtp-Source: ABdhPJx6QiE8Lap+c9ItB/310joi8PjtYGhGB5b6X8mQGrfGWqo3dxH7g3ctBHE8D1Rp1QxbplEz2g/cB/p3dnllGZs=
X-Received: by 2002:ab0:3245:: with SMTP id r5mr1774480uan.109.1589262922884;
 Mon, 11 May 2020 22:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200510020044.958018-1-masahiroy@kernel.org> <202005091914.4B8CACB91@keescook>
In-Reply-To: <202005091914.4B8CACB91@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 12 May 2020 14:54:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNAShqo4=YJ9AxqZqHU9t4Axnmn2AdY4sOTTM5TEXVXTNzA@mail.gmail.com>
Message-ID: <CAK7LNAShqo4=YJ9AxqZqHU9t4Axnmn2AdY4sOTTM5TEXVXTNzA@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: remove always false $(if ...) in Makefile
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, May 10, 2020 at 11:14 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, May 10, 2020 at 11:00:44AM +0900, Masahiro Yamada wrote:
> > This is the remnant of commit c17d6179ad5a ("gcc-plugins: remove unused
> > GCC_PLUGIN_SUBDIR").
> >
> > $(if $(findstring /,$(p)),...) is always false because none of plugins
> > contains '/' in the file name.
> >
> > Clean up the code.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>


Applied to linux-kbuild.


-- 
Best Regards
Masahiro Yamada
