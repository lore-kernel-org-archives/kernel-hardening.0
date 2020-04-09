Return-Path: <SRS0=SVnE=5Z=lists.openwall.com=kernel-hardening-return-18484-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7999C2BA19
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Apr 2020 22:19:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1ED3620692
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Apr 2020 22:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayC55L88"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ED3620692
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18484-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13910 invoked by uid 550); 9 Apr 2020 22:19:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13866 invoked from network); 9 Apr 2020 22:19:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yF+4ifTZpgac0AbgqyHYOhjvKVGLdZBmX5qyHKVLzpw=;
        b=ayC55L881C6xg8HNUeEsEsdG+JjdxCnjA7UteuNLnWVIETAYJFL0syDwTwbXrwKNQL
         aTbVmOYsLBPrcWQXkiUI0SCP1s+aJ1i08TjGVWGMvHeLKysNIYCnLC7eb32KIrzy/Tiu
         v4nq50XzsOXfMouLuH1upugXdP8A3MXgtAKvbyjlMVcufRn2qSZiqRMbthmhcuouwzuC
         7YsB3TGQSigp5bYimeU9pryCMNu2H2HJzm8+B0E5BHgrFb0VgT2CZTMzWvGtZIALp9g8
         k/jv+Klv0FmpvLvIuFG3AKlNFlBeo3LnegGrWnxxKuEtfuZljPdSScQR/+iEm/RDMkzn
         gCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yF+4ifTZpgac0AbgqyHYOhjvKVGLdZBmX5qyHKVLzpw=;
        b=kuvhlTcxiTiCHd4szPpCtNqNWnRK0oi0wlANORWQRU4iGhqScdxAVywl3vkKtu0GqL
         tlJfLPaOuN0dj+3/cJFHyS1xWgyKIcrg6z94XXtD00R+wrqBwByIBBH9cg04Y9rz+AlN
         0bsaUfnT9PpGEZMGK9Rrr/p7Gn+1rZ4j/fVevpvVO/qnU4TJPTwHHOxTKANDDDZ1PBGc
         OQYE6aPRoctUZ2k6QmlXz/ws5/DL2ul6vepG4mvRga6f7kWA30D53gOu7weGdspvFREy
         QL6cVYb60/9qFhDa0nXIUU3bC9gtwqu6wGD8i3Df/yayA/XrenVBTQGKPi39oxo01QVL
         AViA==
X-Gm-Message-State: AGi0Puau/ItM8Ber6ZZx5bsCjxvp+zEcN721E6DUvCcvkoYLtAJTvKoq
	W61PdJTQP/8ILTRrXKzr0co=
X-Google-Smtp-Source: APiQypJrKv7Asjch32aD4xEpFDeOyjpzVmOBQiF/yaYfcx+nuoITzrJsRZSj7Udu9wt+ElHx97bWzQ==
X-Received: by 2002:a37:ae04:: with SMTP id x4mr1187661qke.278.1586470762165;
        Thu, 09 Apr 2020 15:19:22 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 9 Apr 2020 18:19:19 -0400
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/init: Stop printing pgt_buf addresses
Message-ID: <20200409221919.GA1460035@rani.riverdale.lan>
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

This was acked by Kees, is it ok for merge?

Thanks.
