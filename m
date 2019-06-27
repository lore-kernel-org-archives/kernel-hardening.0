Return-Path: <SRS0=wziy=U2=lists.openwall.com=kernel-hardening-return-16295-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE828C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:24:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3F08B2146E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gSaPGz9S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F08B2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16295-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3133 invoked by uid 550); 27 Jun 2019 16:24:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3115 invoked from network); 27 Jun 2019 16:24:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/8WNz6km09cjJozBXv1ttJOzdwKWqBjOCAwXZrmYZQY=;
        b=gSaPGz9S5mfM2IyW50EIddVjXzosJmFwIvLy5/3d96Mmi9TwrjccATn1f1RZjIlMFe
         g6G3RU+uVrFmGFVIUCd9KSLCraVscKPuB43D5SpFa4Cv14trV2iOCfUw1w+dnm1He+No
         Zzm+bbolLanUL6IWtcmRDluyh9DqPXsyiUfrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/8WNz6km09cjJozBXv1ttJOzdwKWqBjOCAwXZrmYZQY=;
        b=czPOdfHJqtrvTz/M+eLpJgO+xh5xIDxzABS18CFu8auJ4lcbEjASSSuqfkjXq3yhsV
         oKDdcKyIZvi77BNN3QbQsbZyEeyAP/q8gRx+tW+h6BWA/7SFjnFOIXl23qOulX7BAQP+
         u92HwMyTA2ljjh/4w0Q0HBMfF09nIhgpVOPl0uRw6V0Mj5nWGjHeHMynF+SkKaSoKLid
         L/Oypes592jLw2Up1+hVGeHWRUk4WfAYnJf8cEqLnSlEggX3CGKTg6PLmj1w2h41j0VS
         NGFnq2oyg71IcLHOb1BTt0B2L0KxOv7GSLt4Q0+6H0ncia/nC2pLShHUrMNh7onYhB05
         BvAw==
X-Gm-Message-State: APjAAAUc8q3SldhX9Vzj/XSQCLOzwtd2nJanaivsMFBRCTCBTt8RU4p7
	yrS7Zyhh5SaGJJE8OyB94svG5g==
X-Google-Smtp-Source: APXvYqzwszuLB5KUZT0GR9HWRZ7xGjWVY5pOYkuBOrrtrH5Vd2d27l5XG9aT2UNpuYPJaeE7Xhvg+A==
X-Received: by 2002:a17:90a:cf0d:: with SMTP id h13mr7015152pju.63.1561652639486;
        Thu, 27 Jun 2019 09:23:59 -0700 (PDT)
Date: Thu, 27 Jun 2019 09:23:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>, Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	clang-built-linux@googlegroups.com
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906270923.C73BAD213@keescook>
References: <20190626121943.131390-1-glider@google.com>
 <20190626121943.131390-2-glider@google.com>
 <1561572949.5154.81.camel@lca.pw>
 <201906261303.020ADC9@keescook>
 <20190627061534.GA17798@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627061534.GA17798@dhcp22.suse.cz>

On Thu, Jun 27, 2019 at 08:15:34AM +0200, Michal Hocko wrote:
> This sounds familiar: http://lkml.kernel.org/r/CABXOdTd-cqHM_feAO1tvwn4Z=kM6WHKYAbDJ7LGfMvRPRPG7GA@mail.gmail.com

Your memory is better than mine! I entirely forgot about this and it was
only 2 months ago. Whoops. :P

-- 
Kees Cook
