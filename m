Return-Path: <SRS0=/gto=YJ=lists.openwall.com=kernel-hardening-return-17019-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492F4C4360C
	for <kernel-hardening@archiver.kernel.org>; Wed, 16 Oct 2019 10:12:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 93EFB20650
	for <kernel-hardening@archiver.kernel.org>; Wed, 16 Oct 2019 10:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXbT4hNK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93EFB20650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17019-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23559 invoked by uid 550); 16 Oct 2019 10:12:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22503 invoked from network); 16 Oct 2019 10:12:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIAc7kYct8VpQ13hbYyhIsPB/WrvUenHD8qPKsYEDRE=;
        b=oXbT4hNKhD2uIHDdhfwvtPdiz9aqjjELCUA3i1w6gPw4XwKjzXNwIigRbIWeWKfmtp
         9qdDj2ni9pzSrplpKkx6aKJJH5BVecMXKEjfRmExaUQkbwL6Dcg7EvK1RR+mqTWacUYW
         afiIQ1D+Zlqg++/0laoXe2Ar+6NnZo12uopWOpdTgCHSz/6ivR0s4meXhFjXftUJnn5E
         u99AwkDRQkUgDT8393Wwhx2I27Lqxuw4M8b1GclfRCON2hDd079wooQGxrYr/N6VM1o7
         IGBUyL45BfGQHihicMGzaYaw8u+pWwx2np1kLJ+F05A8Q1PHCL/cTaM4Mc7EM/5Ao3v8
         pcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIAc7kYct8VpQ13hbYyhIsPB/WrvUenHD8qPKsYEDRE=;
        b=Kwbe8I41y9BG1i6+MiHd1N2m6diSjeimqZoY3prEqdvruogcwOyqrURfTz+5QW66sH
         JDLpE59FvrHTAhZbXV6t1+/Up8aKzeDZUMMSzUHe8m+pnhoJwezQmVxcdu09DHuOPzZh
         1vx/SVYgO62RjIWsVao/yD3bBHrlwgyw0mW5R3FcCLbntT8Vwcuc9L9uexqNzeEk5pT4
         OkhJd4azwJbcQTw/h9fcalPAHkV15EDj0Z0haDybJvP8kuJcBO37XAY9e3JiIXP7KKOO
         OoLedtS8qRL0YafHa3wbIzCOrMKalAQcmCOs5wCcp7Q4L3d7MIfmO7g9scHjqo2PtCsv
         XWcQ==
X-Gm-Message-State: APjAAAVgKiw2nYrLZW4+Io0QAlWZIfm+eLc+LlNl5dwaCkfW9MdSFfP3
	1NPolovO0s4fu9PBMMa9aeutxtyatfsZ/9SOXQo=
X-Google-Smtp-Source: APXvYqzFzZuHz7bFYr0F46QP6TS5NUe9LqN11QyJ2UWcNxcs1w4oo6ZYum/5vBnHKrmP1nIOu2j9iO3oDTxaRC/J2Xg=
X-Received: by 2002:aca:dad6:: with SMTP id r205mr2642336oig.6.1571220719443;
 Wed, 16 Oct 2019 03:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191012122918.8066-1-mayhs11saini@gmail.com> <20191014022543.GA2674@ubuntu-m2-xlarge-x86>
In-Reply-To: <20191014022543.GA2674@ubuntu-m2-xlarge-x86>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Wed, 16 Oct 2019 15:41:39 +0530
Message-ID: <CAOfkYf5wagQzj0UboBdBh6iDq1ox=TN7inpatuhitw+Gsak1GQ@mail.gmail.com>
Subject: Re: [PATCH] kernel: dma: Make CMA boot parameters __ro_after_init
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, iommu@lists.linux-foundation.org, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Matthew Wilcox <willy@infradead.org>, 
	Christopher Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi Nathan,

On Mon, Oct 14, 2019 at 7:55 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Sat, Oct 12, 2019 at 05:59:18PM +0530, Shyam Saini wrote:
> > This parameters are not changed after early boot.
> > By making them __ro_after_init will reduce any attack surface in the
> > kernel.
> >
> > Link: https://lwn.net/Articles/676145/
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Christopher Lameter <cl@linux.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> > ---
> >  kernel/dma/contiguous.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> > index 69cfb4345388..1b689b1303cd 100644
> > --- a/kernel/dma/contiguous.c
> > +++ b/kernel/dma/contiguous.c
> > @@ -42,10 +42,10 @@ struct cma *dma_contiguous_default_area;
> >   * Users, who want to set the size of global CMA area for their system
> >   * should use cma= kernel parameter.
> >   */
> > -static const phys_addr_t size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
> > -static phys_addr_t size_cmdline = -1;
> > -static phys_addr_t base_cmdline;
> > -static phys_addr_t limit_cmdline;
> > +static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
>
> The 0day bot reported an issue with this change with clang:
>
> https://groups.google.com/d/msgid/clang-built-linux/201910140334.nhultlt8%25lkp%40intel.com
>
> kernel/dma/contiguous.c:46:36: error: 'size_cmdline' causes a section type conflict with 'size_bytes'
> static phys_addr_t __ro_after_init size_cmdline = -1;
>                                    ^
> kernel/dma/contiguous.c:45:42: note: declared here
> static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
>                                          ^
> kernel/dma/contiguous.c:47:36: error: 'base_cmdline' causes a section type conflict with 'size_bytes'
> static phys_addr_t __ro_after_init base_cmdline;
>                                    ^
> kernel/dma/contiguous.c:45:42: note: declared here
> static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
>                                          ^
> kernel/dma/contiguous.c:48:36: error: 'limit_cmdline' causes a section type conflict with 'size_bytes'
> static phys_addr_t __ro_after_init limit_cmdline;
>                                    ^
> kernel/dma/contiguous.c:45:42: note: declared here
> static const phys_addr_t __ro_after_init size_bytes = (phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
>                                          ^
> 3 errors generated.

Thanks for your feedback and reporting this error.

> The errors seem kind of cryptic at first but something that is const
> should automatically be in the read only section, this part of the
> commit seems unnecessary. Removing that part of the change fixes the error.

I have overlooked size_bytes variable
It shouldn't be const if it is declared as __ro_after_init.

I will fix and resend it.
