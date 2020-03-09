Return-Path: <SRS0=fJeB=42=lists.openwall.com=kernel-hardening-return-18109-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EE2C10F27
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Mar 2020 16:15:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 69A6224655
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Mar 2020 16:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bFsZ5+xS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69A6224655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18109-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1831 invoked by uid 550); 9 Mar 2020 16:15:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1797 invoked from network); 9 Mar 2020 16:15:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YnKNr3hKRT5ikwt9roCSkDxlo76o8UWZ8pQ2c566Cf4=;
        b=bFsZ5+xSdTR8H8crWlM6K47GKUWc1rJ515OZGp73trVfjgiNteU9a+Cahp2oKyNWjY
         5fyUr2Je7MMc9pQbQScjAk+4L4d7mu0qzQ67QIx5ntGMze9FCj00EIuaXj45eRA9xwLC
         Q39gzs6fLraauHczp7CUQ/uvpSu/Pv3g1+zyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YnKNr3hKRT5ikwt9roCSkDxlo76o8UWZ8pQ2c566Cf4=;
        b=ba9lkHRSobgc+JE91emwIWH5UvR0rx5mozBnOU+VIw3W73jtmsMSfobfYlCoaEYgPt
         kaBCahl+mDpSC9ddE1IpSBw63t6UchVfODpn8oZFyUpasbl/r+RcmbTcOqLDOn6d4XYY
         mE4aDw9L9sMmszdUGCtFt3KEinYtBmlP7swgcpN36rRryQxB2tKr/aMUcBSpV/GCukok
         WTdxPe7M3AO1Oh70cGpYhRjav+vvMvqp1orL6M9zrBG7+uF3L5YyFJEssVdMjRn0fk+X
         hyh4//O/ru2DdhxQn2kwv2oY5zhaMFzztYoGK9BzfpwvyPu8soezMheVLcXYZ3W04wV0
         ygQw==
X-Gm-Message-State: ANhLgQ2UgkI7HcQLyVlBhRpRgVpGNFW2y4HkP3/589rMXIHja8F+jzQ6
	LR9CfAHwtv9j2xzQpSwQwGkRVA==
X-Google-Smtp-Source: ADFU+vvFjBxaKhEtFtDyy5FhCQR6zvOlDckAvu416t13ucxmTgfU3D8gVc8Q+eGzqzcwU5poa34MfQ==
X-Received: by 2002:a17:90a:a588:: with SMTP id b8mr71771pjq.182.1583770512109;
        Mon, 09 Mar 2020 09:15:12 -0700 (PDT)
Date: Mon, 9 Mar 2020 09:15:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Phong Tran <tranmanphong@gmail.com>, catalin.marinas@arm.com,
	will@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
	akpm@linux-foundation.org, steven.price@arm.com,
	steve.capper@arm.com, broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] arm64: add check_wx_pages debugfs for CHECK_WX
Message-ID: <202003090914.F6720CFF13@keescook>
References: <20200307093926.27145-1-tranmanphong@gmail.com>
 <20200309121713.GA26309@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309121713.GA26309@lakrids.cambridge.arm.com>

On Mon, Mar 09, 2020 at 12:17:14PM +0000, Mark Rutland wrote:
> On Sat, Mar 07, 2020 at 04:39:26PM +0700, Phong Tran wrote:
> > follow the suggestion from
> > https://github.com/KSPP/linux/issues/35
> 
> That says:
> 
> | This should be implemented for all architectures
> 
> ... so surely this should be in generic code, rahter than being
> arm64-specific?

Not all architectures have implemented CONFIG_DEBUG_WX...

-Kees

> 
> Thanks,
> Mark.
> 
> > 
> > Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> > ---
> >  arch/arm64/Kconfig.debug        |  3 ++-
> >  arch/arm64/include/asm/ptdump.h |  2 ++
> >  arch/arm64/mm/dump.c            |  1 +
> >  arch/arm64/mm/ptdump_debugfs.c  | 18 ++++++++++++++++++
> >  4 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> > index 1c906d932d6b..be552fa351e2 100644
> > --- a/arch/arm64/Kconfig.debug
> > +++ b/arch/arm64/Kconfig.debug
> > @@ -48,7 +48,8 @@ config DEBUG_WX
> >  	  of other unfixed kernel bugs easier.
> >  
> >  	  There is no runtime or memory usage effect of this option
> > -	  once the kernel has booted up - it's a one time check.
> > +	  once the kernel has booted up - it's a one time check and
> > +	  can be checked by echo "1" to "check_wx_pages" debugfs in runtime.
> >  
> >  	  If in doubt, say "Y".
> >  
> > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > index 38187f74e089..b80d6b4fc508 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -24,9 +24,11 @@ struct ptdump_info {
> >  void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
> >  #ifdef CONFIG_PTDUMP_DEBUGFS
> >  void ptdump_debugfs_register(struct ptdump_info *info, const char *name);
> > +int ptdump_check_wx_init(void);
> >  #else
> >  static inline void ptdump_debugfs_register(struct ptdump_info *info,
> >  					   const char *name) { }
> > +static inline int ptdump_check_wx_init(void) { return 0; }
> >  #endif
> >  void ptdump_check_wx(void);
> >  #endif /* CONFIG_PTDUMP_CORE */
> > diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> > index 860c00ec8bd3..60c99a047763 100644
> > --- a/arch/arm64/mm/dump.c
> > +++ b/arch/arm64/mm/dump.c
> > @@ -378,6 +378,7 @@ static int ptdump_init(void)
> >  #endif
> >  	ptdump_initialize();
> >  	ptdump_debugfs_register(&kernel_ptdump_info, "kernel_page_tables");
> > +	ptdump_check_wx_init();
> >  	return 0;
> >  }
> >  device_initcall(ptdump_init);
> > diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
> > index 1f2eae3e988b..73cddc12c3c2 100644
> > --- a/arch/arm64/mm/ptdump_debugfs.c
> > +++ b/arch/arm64/mm/ptdump_debugfs.c
> > @@ -16,3 +16,21 @@ void ptdump_debugfs_register(struct ptdump_info *info, const char *name)
> >  {
> >  	debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
> >  }
> > +
> > +static int check_wx_debugfs_set(void *data, u64 val)
> > +{
> > +	if (val != 1ULL)
> > +		return -EINVAL;
> > +
> > +	ptdump_check_wx();
> > +
> > +	return 0;
> > +}
> > +
> > +DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, "%llu\n");
> > +
> > +int ptdump_check_wx_init(void)
> > +{
> > +	return debugfs_create_file("check_wx_pages", 0200, NULL,
> > +				   NULL, &check_wx_fops) ? 0 : -ENOMEM;
> > +}
> > -- 
> > 2.20.1
> > 

-- 
Kees Cook
