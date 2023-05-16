Return-Path: <kernel-hardening-return-21671-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 46CEAC77B75
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 May 2023 20:17:59 +0000 (UTC)
Received: (qmail 1343 invoked by uid 550); 16 May 2023 20:17:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1300 invoked from network); 16 May 2023 20:17:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684268256; x=1686860256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YJEJEgHLDw3Nrf2OYxAw65J2/yLmkvxFlpYWiAtQcmA=;
        b=HnGWjuYOAI8Ajbhmofm3GokXhD5YgSqiF6UQCDCLlwnbaHtP73wUieT9TUP2SHAOuO
         90idaRSc566+i6YTMHc7sZ415zRHQJMrUOZPDCys53qkJdWi3b5hDQ/MN+RLydISIgE2
         GwdnyrHrai/aOeaCCSDIFQHmxVT8/mRzDgfCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684268256; x=1686860256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJEJEgHLDw3Nrf2OYxAw65J2/yLmkvxFlpYWiAtQcmA=;
        b=NScaNrY8x+XLCa6i+5STqagUrZRTI/+yDG6KrMnovEzTtfuqFEJ5VAfz+r0ZsdO534
         /6//QvvpOqUYvQoKTHC0LIWZUrYLksqbah0KPcRWt3FQscosgomLlamMDIEOXNRrUR8L
         zSy21ldVIFiHIeIJcbcE2+FwC5oDkwr8cgLxwBb4sN/LNm2BLZ+pz9z/gDmXTn8chXts
         JCd37ZKnRp5P43WXvOLI/bGteVGXInTd7BvVBZMIC5qvDZ75OcLfoFJpQrAGuhZgA/gH
         oMEfuu73P/yNsfFf/KcDosNA8oH3yP04Uj8gnlJgH8nJuwj//QPAtRwJihLCLFnS2+7H
         mfVg==
X-Gm-Message-State: AC+VfDyLtmnaCPNXynMJjCAa7ugEFA6jdIlHTi12hm9E0fEnAmxa2Wez
	DbHDAEj3uYeQ6q9N8grcca7a6A==
X-Google-Smtp-Source: ACHHUZ6Oynxwi7sloZ3Ypg7XgSCwwZO30bG7FPKKxxgXTbfRZw5iZB64xYqMeanZeGOcTKnSKanXQg==
X-Received: by 2002:a05:6a00:189a:b0:646:7234:cbfc with SMTP id x26-20020a056a00189a00b006467234cbfcmr43435667pfh.27.1684268255812;
        Tue, 16 May 2023 13:17:35 -0700 (PDT)
Date: Tue, 16 May 2023 13:17:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Michael McCracken <michael.mccracken@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	serge@hallyn.com, tycho@tycho.pizza,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
Message-ID: <202305161312.078E5E7@keescook>
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504213002.56803-1-michael.mccracken@gmail.com>

On Thu, May 04, 2023 at 02:30:02PM -0700, Michael McCracken wrote:
> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
> sysctl to 0444 to disallow all runtime changes. This will prevent
> accidental changing of this value by a root service.
> 
> The config is disabled by default to avoid surprises.
> 
> Signed-off-by: Michael McCracken <michael.mccracken@gmail.com>
> ---
>  kernel/sysctl.c | 4 ++++
>  mm/Kconfig      | 7 +++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index bfe53e835524..c5aafb734abe 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1913,7 +1913,11 @@ static struct ctl_table kern_table[] = {
>  		.procname	= "randomize_va_space",
>  		.data		= &randomize_va_space,
>  		.maxlen		= sizeof(int),
> +#if defined(CONFIG_RO_RANDMAP_SYSCTL)
> +		.mode		= 0444,
> +#else
>  		.mode		= 0644,
> +#endif

The way we've dealt with this in the past for similarly sensitive
sysctl variables to was set a "locked" position. (e.g. 0==off, 1==on,
2==cannot be turned off). In this case, we could make it, 0, 1, 2,
3==forced on full.

I note that there is actually no min/max (extra1/extra2) for this sysctl,
which is itself a bug, IMO. And there is just a magic "> 1" test that
should be a define or enum:

fs/binfmt_elf.c:        if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {

I think much of this should be improved.

Regardless, take a look at yama_dointvec_minmax(), which could, perhaps,
be generalized and used here.

Then we have a run-time way to manage this bit, without needing full
kernel rebuilds, etc, etc.

-Kees

-- 
Kees Cook
