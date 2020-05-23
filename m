Return-Path: <SRS0=xKAB=7F=lists.openwall.com=kernel-hardening-return-18859-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477B4C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 01:51:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B23F2072C
	for <kernel-hardening@archiver.kernel.org>; Sat, 23 May 2020 01:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP3CkkiM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B23F2072C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18859-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22210 invoked by uid 550); 23 May 2020 01:51:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22173 invoked from network); 23 May 2020 01:51:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dl+KxsROb4cPj2iQZSsr1bvDaOCEwSXc+9sPYn2MtWc=;
        b=EP3CkkiMjXBNO33JU9tRJ5LOwWZYredBb+mvwPWhXXCKQAWAlsiQQsQRPkFQPC0nRx
         ZkbxSuoT6LV4EXeZ4pWL3Yhlfo8nx80UCABTT4KAbIxUlWTcaOC87qRpVUQnN1IlECSU
         /f+YDMuL2deibxh4BYYOUk4wDVykqh2S0uUepuWSGiRzpC4QkrCSzFjtTeDpiepWSJeA
         69mziKBIWAi7G48ZvWI8Rlrg0FIyT63r8u1qZR+xIGts5r6/I3G/fPw2tZOQnL8WoJLm
         RhlPUh8PkYbfgy0f++xZ7SI/Er7oQu6UxF6+uaIp1H+2mLVxKbQZCpilU8MEltoMVjjs
         8dlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dl+KxsROb4cPj2iQZSsr1bvDaOCEwSXc+9sPYn2MtWc=;
        b=HbmiTlQZMwnmPYpvyu8EXOkfXzz8f/+nnwbX11HkjJPenBcG0YO5dSXSTHMbjAjYQC
         aIy93yXLqYBZXvj2RzlfRDtD3pS+pp9VkmdX8CgNXVvUXd9fNp7yie75qkMAaID+haE9
         d8vcG/nKFKt73+F+clDN7HfdoJXwtEEPBa/IviMUyQuVsJO9/NVjKlOaC3D35uQlJNEk
         yZlZQyrWQAlH0T0KDNvFKE35o+pyBIJJeLFtSE3OiVYOEQCM7rZpxQUJ9KJ+XNanfTX+
         mrHhMuAesL5gjoILHXQt57eTvrJ3In2KT5fkBf6AVDfpTOelUkvYqSZt/9dLI3TBZQVs
         59zg==
X-Gm-Message-State: AOAM532UvhseboIk+m8a/End3vfqXLtwOm0FS2CM60R0mAXfYR4qnvId
	8D57Myav3fLtkEo/+b4kQOs=
X-Google-Smtp-Source: ABdhPJwzByhTsHMepg7YrKn+Hzag2OKQNukvBSM7yD5thAMQVpVOrtmWv5O46EbvlNY9CVs+/Upmng==
X-Received: by 2002:ac8:699a:: with SMTP id o26mr18085807qtq.92.1590198691654;
        Fri, 22 May 2020 18:51:31 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Fri, 22 May 2020 21:51:29 -0400
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/init: Stop printing pgt_buf addresses
Message-ID: <20200523015129.GA717759@rani.riverdale.lan>
References: <20200229231120.1147527-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200229231120.1147527-1-nivedita@alum.mit.edu>

On Sat, Feb 29, 2020 at 06:11:20PM -0500, Arvind Sankar wrote:
> This currently leaks kernel physical addresses into userspace.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> ---
>  arch/x86/mm/init.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e7bb483557c9..dc4711f09cdc 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -121,8 +121,6 @@ __ref void *alloc_low_pages(unsigned int num)
>  	} else {
>  		pfn = pgt_buf_end;
>  		pgt_buf_end += num;
> -		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
> -			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
>  	}
>  
>  	for (i = 0; i < num; i++) {
> -- 
> 2.24.1
> 

Ping.

https://lore.kernel.org/lkml/20200229231120.1147527-1-nivedita@alum.mit.edu/
