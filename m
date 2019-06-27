Return-Path: <SRS0=bY70=U2=lists.openwall.com=kernel-hardening-return-16297-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C692C48BD9
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:44:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5AB2D2146E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="geImDuUK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AB2D2146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lca.pw
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16297-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26231 invoked by uid 550); 27 Jun 2019 16:44:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26213 invoked from network); 27 Jun 2019 16:44:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w2BmOlVfFwkgLZSQC1w8R20Owu5XUJlV/BzLLVY15k0=;
        b=geImDuUK3nzgaKe4rg1kDwEEwfUdwvxURv/YU09DF9oFlWMFeIGMHkNFo+kl+Mvfgp
         3NO8fx+rX1WWjRagnKQMMJXa7pZt+GIeetEEtjHApswcGjlKc+gxyDCKrAzKCe62curu
         iW3bdzqK2OkSXzpeeJRpbwoTJgCh3u5Amano2cgvcnouqqXbiCvwAk366bvP8GkEgKAY
         1XYyATJFDwDk7/D++da1v3yBiCjkjfVbCeUbPEqBas4q+imDOQ1Gp08PVnQ835YTl4e3
         KVWwxlF+N5UDMQYpCb+jztRgrugr2eMpS3t4p9tRj4wNkE5ZVAADfT74LIah+lTkfQlG
         fWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w2BmOlVfFwkgLZSQC1w8R20Owu5XUJlV/BzLLVY15k0=;
        b=DmSiS8Dv+JLco07HYli/Br87ioO9AH8sz3ucC07ps2/yq4JIJ2k8OeFKHLlXadcLj6
         PHLye83ijisIrRP0u5JjMhmc8i6MP/bo3SNPgXz58n0OOLIZPGPHGkhiAx8Ajwy/tlmP
         NpsiZDYjhJGarQAtDBnnGenQrHXVRyr+1CIHxQkC5+q/AdXCKd1B/Z7ve7La83Hg8gKf
         BvTkvhuLLXUWyzHRizBkcPUrEvbYs1/F7owCMIIgAc3TfYOhSQcDY/jNSjWFkmM+F+Qa
         3yVLygzbWszhrU8roAtl4Ry9fP1xYglw+MJ10poc3l63cgUcOPXynWiJIbc/GHhAcq3W
         I8IA==
X-Gm-Message-State: APjAAAXYnpWYONFSchwlzzKc+6Db98MFyz4EaAZg2acBM9NOi+03arpJ
	OneDlg6C4Fqti7gLSGkFx+C+2A==
X-Google-Smtp-Source: APXvYqy634RuieC+fz/WCPxqpxiLBIdyBILOYC+PwsQcQ+t7LBPTDYlzrhZfeWGzOYF9AbMHbkQZYQ==
X-Received: by 2002:a37:5d07:: with SMTP id r7mr4294931qkb.4.1561653847500;
        Thu, 27 Jun 2019 09:44:07 -0700 (PDT)
Message-ID: <1561653844.5154.87.camel@lca.pw>
Subject: Re: [PATCH v9 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
From: Qian Cai <cai@lca.pw>
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Masahiro
 Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany
 <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil
 <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap
 <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland
 <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org,  kernel-hardening@lists.openwall.com
Date: Thu, 27 Jun 2019 12:44:04 -0400
In-Reply-To: <201906270926.02AAEE93@keescook>
References: <20190627130316.254309-1-glider@google.com>
	 <20190627130316.254309-2-glider@google.com>
	 <1561641911.5154.85.camel@lca.pw> <201906270926.02AAEE93@keescook>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-06-27 at 09:29 -0700, Kees Cook wrote:
> On Thu, Jun 27, 2019 at 09:25:11AM -0400, Qian Cai wrote:
> > On Thu, 2019-06-27 at 15:03 +0200, Alexander Potapenko wrote:
> > > +static int __init early_init_on_alloc(char *buf)
> > > +{
> > > +	int ret;
> > > +	bool bool_result;
> > > +
> > > +	if (!buf)
> > > +		return -EINVAL;
> > > +	ret = kstrtobool(buf, &bool_result);
> > > +	if (bool_result && IS_ENABLED(CONFIG_PAGE_POISONING))
> > > +		pr_warn("mem auto-init: CONFIG_PAGE_POISONING is on, will
> > > take precedence over init_on_alloc\n");
> > 
> > I don't like the warning here. It makes people think it is bug that need to
> > be
> > fixed, but actually it is just information. People could enable both in a
> > debug
> > kernel.
> 
> How would you suggest it be adjusted? Should it be silent, or be
> switched to pr_info()?

pr_info() sounds more reasonable to me, so people don't need to guess the
correct behavior. Ideally, CONFIG_PAGE_POISONING should be  renamed to something
like CONFIG_INIT_ON_FREE_CHECK, and it only does the checking part if enabled,
and init_on_free will gain an ability to poison a pattern other than 0.

Also, there might be some rooms to consolidate with SLAB_POSION as well.

> 
> Also, doesn't this need to check "want_page_poisoning", not just
> CONFIG_PAGE_POISONING? Perhaps just leave the warning out entirely?
> 

Yes, only checking CONFIG_PAGE_POISONING is not enough, and need to check
page_poisoning_enabled().
