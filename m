Return-Path: <SRS0=OaxF=DT=lists.openwall.com=kernel-hardening-return-20172-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B0DC433E7
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 21:02:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CF64206DC
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 21:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aKY2mjZq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CF64206DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20172-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8092 invoked by uid 550); 12 Oct 2020 21:02:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8051 invoked from network); 12 Oct 2020 21:02:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SnB7E0mI9F7Ie4RlS2cFfqKwCDcopSImUj3IgUSKIxI=;
        b=aKY2mjZqZCjoAe1tt9s9T2FsyHGWEg2r94yXrTIjifMKj+9G5PGXHdmHun7LMLnVVf
         Iyx0hqwAI4RdNjsS7WRjj36UFpYvhE5Z30RnvNh8wxzPTZqIDq/V6FSJyRhQlm3vqAgv
         czJMjy/QiJI5hFODJh0hCucbVTQNfJmHuR7Ss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SnB7E0mI9F7Ie4RlS2cFfqKwCDcopSImUj3IgUSKIxI=;
        b=YztOpEYU21wRHYE0aayU7H5jgXxba4tK2dcApk+j6t4nf0bmqmjcgkLUErq2B1ZBo0
         npe8chQHnk3zh4SnageTTNFXjQ3hl7QvapIVeIcFPJprdn6AQQ0Hv9beGpOCtUZzC77O
         og6SVQeu9uiTZXTh4wWZRxVfn2c6Kzmrn7oVz4GQNN7ZXRO/LBwn06Z5I2xIbZfmuHzB
         JnhKknPJbi8C6V2VLIEw7ciXL/5bptpV6ZYwGUZyslXW3zX7+giFmAGqBwfS2ja59v3e
         S3061Mqb6VeDHK1SwQvW8jm/2iWj/qEboKR0vFeCBRcIkMvqKu9mmxHgrnocpemrLHe3
         zOeg==
X-Gm-Message-State: AOAM5300phfBi0TZI02kVw9lsKL9SVc9wp9y+ujSTkfEI9KcVxbh0Ysu
	iDtjSFk0bynT1Bp4UcUX928Z7g==
X-Google-Smtp-Source: ABdhPJzJnGcA0q8XKKQGw3kIUgQPIXUnpTwBiY6N5ghL0OHEl3zmbEFuNMnAsinW9yZvnNW49rm+aQ==
X-Received: by 2002:a63:5a11:: with SMTP id o17mr14040343pgb.287.1602536557163;
        Mon, 12 Oct 2020 14:02:37 -0700 (PDT)
Date: Mon, 12 Oct 2020 14:02:35 -0700
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
Message-ID: <202010121402.1EB5242@keescook>
References: <20201009161338.657380-1-samitolvanen@google.com>
 <20201009161338.657380-26-samitolvanen@google.com>
 <20201012083116.GA785@willie-the-truck>
 <202010121344.53780D8CD2@keescook>
 <20201012205108.GA1620@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012205108.GA1620@willie-the-truck>

On Mon, Oct 12, 2020 at 09:51:09PM +0100, Will Deacon wrote:
> On Mon, Oct 12, 2020 at 01:44:56PM -0700, Kees Cook wrote:
> > On Mon, Oct 12, 2020 at 09:31:16AM +0100, Will Deacon wrote:
> > > On Fri, Oct 09, 2020 at 09:13:34AM -0700, Sami Tolvanen wrote:
> > > > Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> > > > 
> > > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  arch/arm64/Kconfig | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > > index ad522b021f35..7016d193864f 100644
> > > > --- a/arch/arm64/Kconfig
> > > > +++ b/arch/arm64/Kconfig
> > > > @@ -72,6 +72,8 @@ config ARM64
> > > >  	select ARCH_USE_SYM_ANNOTATIONS
> > > >  	select ARCH_SUPPORTS_MEMORY_FAILURE
> > > >  	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
> > > > +	select ARCH_SUPPORTS_LTO_CLANG
> > > > +	select ARCH_SUPPORTS_THINLTO
> > > 
> > > Please don't enable this for arm64 until we have the dependency stuff sorted
> > > out. I posted patches [1] for this before, but I think they should be part
> > > of this series as they don't make sense on their own.
> > 
> > Oh, hm. We've been trying to trim down this series, since it's already
> > quite large. Why can't [1] land first? It would make this easier to deal
> > with, IMO.
> 
> I'm happy to handle [1] along with the LTO Kconfig change when the time
> comes, if that helps. I just don't want to merge dead code!

Okay, understood. Thanks!

> 
> Will
> 
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=rwonce/read-barrier-depends

-- 
Kees Cook
