Return-Path: <SRS0=fiTU=4R=lists.openwall.com=kernel-hardening-return-18026-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453A8C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:23:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8FFF4222C2
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:23:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UmXHXH52"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FFF4222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18026-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12139 invoked by uid 550); 29 Feb 2020 23:23:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12107 invoked from network); 29 Feb 2020 23:23:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sC3t5GcfT+mcs+Zl2p6smFfDxG3Nl3S/QcoxnFPIWpo=;
        b=UmXHXH52+3Ibq5SY+DNh7RIg8T1q46HbakkJRAP/XErovTGr0KFi97JvUqadnH/Qjr
         L9w/0j4cC3oBKseA4rV+Y+oVI7+M4QrrFFuTVNOB7SlkP9qTSvM7MpXqakjP/ekXwrrQ
         TiWSi5ZIHMZ5aUBf8/dCfcojIKCdtRQ/4geaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sC3t5GcfT+mcs+Zl2p6smFfDxG3Nl3S/QcoxnFPIWpo=;
        b=A6b/ds/jxLWfyf44KjlOKt9RFSpRlgWTwlF4Ivi687Kz3MRlcc8w+d1E9miM+bPslm
         63AGX5nUO5HoQLFDO33VH+izYEmIcNf2nuG77Kd7m71OfJnrRunrFIikE6LaBo6f4dtB
         kWagrXafdKLEYtdnYZa0qYCzm24D3dAVv1WWER+R3QFkHOuqlI6vQbAbs+Ff65jOYbe8
         gSP2FtGH+haF+6MqXqPBLZoQps9zghWgXkoX5bLBDnPEIJXly8oqTBC7jfyQ6Er0r6wm
         zEKYxHRPK5dN9TV60PR6VnfIvPlK95U0sXKqzMR+CuGRTpe/cb6esnpY7RXa3cwZ5KUF
         zW4Q==
X-Gm-Message-State: APjAAAU2ZbIRwdHb9SslR5mjuGTIlcVSt1OVAQY6YN66t92dw+v6ynsR
	/SmVINog8un50paf2FNbDDLuBw==
X-Google-Smtp-Source: APXvYqzVpbm3DEESlR++G+OA4fQWfBPAh03D5/Ll8Sl1B81nyeETr8NLa8x/DcUXrDFDPjAxKgZrfw==
X-Received: by 2002:a17:902:44d:: with SMTP id 71mr10571774ple.95.1583018593161;
        Sat, 29 Feb 2020 15:23:13 -0800 (PST)
Date: Sat, 29 Feb 2020 15:23:10 -0800
From: Kees Cook <keescook@chromium.org>
To: x86@kernel.org
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	"Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/init: Stop printing pgt_buf addresses
Message-ID: <202002291522.0EDB380@keescook>
References: <20200229231120.1147527-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229231120.1147527-1-nivedita@alum.mit.edu>

On Sat, Feb 29, 2020 at 06:11:20PM -0500, Arvind Sankar wrote:
> This currently leaks kernel physical addresses into userspace.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

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

-- 
Kees Cook
