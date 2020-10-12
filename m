Return-Path: <SRS0=jueF=DT=lists.openwall.com=kernel-hardening-return-20170-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A6C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 20:45:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3C43D20790
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 20:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iBvAVUob"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C43D20790
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20170-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15941 invoked by uid 550); 12 Oct 2020 20:45:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15873 invoked from network); 12 Oct 2020 20:45:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/je9IGonHzFsuF/SNifo0ZcXgtv4yeAu6zOR0qhli4g=;
        b=iBvAVUobGLxYChgzQDFIjdgKitAhC2jHTTevcSYvj7umuQsfw68FrsiS588nddPL9n
         rvr2pXp07ZQWqM/LOhZO8EaapVG+BSzu0jORrfEH3ohPyD3qyDxXqnlKu5B0F1SooZd2
         mIgofFGRcvthuFUyb4XxZSLu96zkfV5bLY9hc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/je9IGonHzFsuF/SNifo0ZcXgtv4yeAu6zOR0qhli4g=;
        b=BLTXhO9Re5o1kyxFt9rZVt1zIheLH/Uc+CgjbF1ibc0VauUIRbZL8my1bgI06Q2X92
         KN7PHWVzkxTzLYrvFA+hUZfbyTFgReoTOSfGidCq7mAO3jpKRWo7f42l3M9MhbgbjKjR
         PrY5fu9xdLUvdhnijdbe/bWraT55Zvncx+04CWPz9KodpJz8rhl0Ms5iX8UqiYBwRIEw
         K3S8K2EeQoY8wFeUonjC543bl+HyNsy5DZ2zmtzzczCW1E3gG0KECV5hK5cm18mu2kPw
         XvLfCBwwqecyFa9kHTeKwCEjEixPpum+evb7ehOLAtdvs88VJGyjzkYIuIjMSeNS83eJ
         Wudg==
X-Gm-Message-State: AOAM530D21aIoN6dAijFWJsirGodKcTQnexOb3lcjN/ZJTaWuoUgI8tE
	fRP+LvTKBe/jtXDQidaVjHhMZQ==
X-Google-Smtp-Source: ABdhPJxf12qi2TvIPdMo3b44hzG/IVxwKW/VadUKNptF9UK+YkxRipHLl4jP/u0pgN9HY2DkPgijnw==
X-Received: by 2002:a17:902:cd07:b029:d3:9be0:2679 with SMTP id g7-20020a170902cd07b02900d39be02679mr25530237ply.68.1602535499967;
        Mon, 12 Oct 2020 13:44:59 -0700 (PDT)
Date: Mon, 12 Oct 2020 13:44:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v5 25/29] arm64: allow LTO_CLANG and THINLTO to be
 selected
Message-ID: <202010121344.53780D8CD2@keescook>
References: <20201009161338.657380-1-samitolvanen@google.com>
 <20201009161338.657380-26-samitolvanen@google.com>
 <20201012083116.GA785@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012083116.GA785@willie-the-truck>

On Mon, Oct 12, 2020 at 09:31:16AM +0100, Will Deacon wrote:
> On Fri, Oct 09, 2020 at 09:13:34AM -0700, Sami Tolvanen wrote:
> > Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/arm64/Kconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index ad522b021f35..7016d193864f 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -72,6 +72,8 @@ config ARM64
> >  	select ARCH_USE_SYM_ANNOTATIONS
> >  	select ARCH_SUPPORTS_MEMORY_FAILURE
> >  	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
> > +	select ARCH_SUPPORTS_LTO_CLANG
> > +	select ARCH_SUPPORTS_THINLTO
> 
> Please don't enable this for arm64 until we have the dependency stuff sorted
> out. I posted patches [1] for this before, but I think they should be part
> of this series as they don't make sense on their own.

Oh, hm. We've been trying to trim down this series, since it's already
quite large. Why can't [1] land first? It would make this easier to deal
with, IMO.

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=rwonce/read-barrier-depends

-- 
Kees Cook
