Return-Path: <SRS0=WBF6=U2=lists.openwall.com=kernel-hardening-return-16296-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95757C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:29:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E9F002133F
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QZVkVU5E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9F002133F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16296-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9367 invoked by uid 550); 27 Jun 2019 16:29:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9349 invoked from network); 27 Jun 2019 16:29:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3r/LDh8YvAZ3OZnTOWNg6U8i2IFKGtlQBfJAup/Xu4=;
        b=QZVkVU5ECiQEZD8bocjFgSEpqVctlMN9h8L1wAaFRjHXqF0bnW+Ftzzw3DzKHNAcjy
         nt1g/aE2ZEZhbd+4VS6rlk8nZwJ8oWZyePXLyV+B5tlPwkyvKPf9ZyvcqXhXbwmjBpsu
         9we+HaXyTyjBsGacmNDTBFRk/MACpSqLCaF7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3r/LDh8YvAZ3OZnTOWNg6U8i2IFKGtlQBfJAup/Xu4=;
        b=XOi2+QdJ03pVWsGEZ2lJoS9hQNJgCU/lCCr17eHP1M1rtfRb5tayHMldVeLlQXtpdd
         xDQnb/ruI7AzdEIuL7cTiRUsIYYLD55XPYTzPoSWz3JRC7kjdtoeeYfg79dBGIi5bHLo
         b48IGZ1qZzfrVz2ki0eASxS1xHkB0r1h8g8a+Ggir7ikFABWFPYy8LUFTBg8LPdIFwcq
         kaI6CgDuWHWc3spzYg+Xvgzfp4mlMWSl4BVkZc4ZSMzZMYrjTW62uon8fw0+p/xd1A4k
         6TpOfGxPLwSUkx9As2GDP4kSoyxE90plx46qF7PcgaQ39g1lgFSh0hZvGhf3fMF7TqJQ
         nUxg==
X-Gm-Message-State: APjAAAXEmDU0dzUO2GynFQxx7XNccP4zv230zVDqrZD+HRQVpA2ddRyl
	Uz2Iho1JkUxXDpbljybJ/xGlTA==
X-Google-Smtp-Source: APXvYqwrMEoacKO75gwBZzta/Mh/OJxKqL+3tX7W1+GI48YaQAhoOPnpVsAFn4qoZf/KqcBmiY+0Bg==
X-Received: by 2002:a63:6a49:: with SMTP id f70mr4495703pgc.55.1561652953275;
        Thu, 27 Jun 2019 09:29:13 -0700 (PDT)
Date: Thu, 27 Jun 2019 09:29:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Qian Cai <cai@lca.pw>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v9 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906270926.02AAEE93@keescook>
References: <20190627130316.254309-1-glider@google.com>
 <20190627130316.254309-2-glider@google.com>
 <1561641911.5154.85.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561641911.5154.85.camel@lca.pw>

On Thu, Jun 27, 2019 at 09:25:11AM -0400, Qian Cai wrote:
> On Thu, 2019-06-27 at 15:03 +0200, Alexander Potapenko wrote:
> > +static int __init early_init_on_alloc(char *buf)
> > +{
> > +	int ret;
> > +	bool bool_result;
> > +
> > +	if (!buf)
> > +		return -EINVAL;
> > +	ret = kstrtobool(buf, &bool_result);
> > +	if (bool_result && IS_ENABLED(CONFIG_PAGE_POISONING))
> > +		pr_warn("mem auto-init: CONFIG_PAGE_POISONING is on, will
> > take precedence over init_on_alloc\n");
> 
> I don't like the warning here. It makes people think it is bug that need to be
> fixed, but actually it is just information. People could enable both in a debug
> kernel.

How would you suggest it be adjusted? Should it be silent, or be
switched to pr_info()?

Also, doesn't this need to check "want_page_poisoning", not just
CONFIG_PAGE_POISONING? Perhaps just leave the warning out entirely?

-- 
Kees Cook
