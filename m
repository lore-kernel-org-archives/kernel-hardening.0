Return-Path: <SRS0=xrq7=32=lists.openwall.com=kernel-hardening-return-17702-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C264FC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:33:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 20008214AF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IKGkaEps"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20008214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17702-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28601 invoked by uid 550); 6 Feb 2020 12:33:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28581 invoked from network); 6 Feb 2020 12:32:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLM+7gqdqC3q396oekNhXmeqeD/6nzSHAkgAw8RRcxI=;
        b=IKGkaEpsAEhkpEYCecxs9GUUfuL6q0mDPlCzadw0HhY3rPXN9CL5BBAWqteJekBDK6
         gHdUv4wAoxpNB9mRPtDrnGP/QTjlnOBxGVh5GEs5vXFlsfiAcEbbg45BRs9B906ssBHp
         dxLSSFSB/85Jd0J8zOwY6flBEvzL43fj7aNIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLM+7gqdqC3q396oekNhXmeqeD/6nzSHAkgAw8RRcxI=;
        b=ZfRE1gvg1HoMCJnkRR2w2gzWJ2JxWvrxYCP/HK3BSsKQ7VVr8TGYFCyHpi6bxbiio6
         B5CqJ8zLiIjpAnpdPJ/m2eRJ1VZunlJxm5Hn+TyEFQ+ITQm4XECeHBHBL5j4el5EbV0p
         4FCuyTOynZFGxZq5XZeM9SfpyYv4B/93U5FFrZw2+/D7ZPtdAEsWiYIzMYOmwW0210YL
         iGT/zMlp/H8LcLFVH2tJRde34ivRrrVeQxRtkvZdk27zZ5oGZhUQOz+zAAQZW0drVur+
         Uv/FFXAzGwDboTxEwVYUKrXNsiXR1KBY8NdJPsIlKj/jMpgKr4C0Zdy3GwgxAlQJl7hv
         12Ow==
X-Gm-Message-State: APjAAAWoEXHcCO1UD+rZ3o5HDLmlOlVmPqIBWdP+xTOkQGj2hcqrwAuy
	3QBp5VxWtYOYP58KDMHSWkzGTg==
X-Google-Smtp-Source: APXvYqz7Dv7a6C0TGyAiI0uDPQQDJJRkHgW/v/JXRpd1WQSzplbgixhc1y27uidc+q+YSRZxKd1WEA==
X-Received: by 2002:a05:6830:1050:: with SMTP id b16mr30676098otp.140.1580992367936;
        Thu, 06 Feb 2020 04:32:47 -0800 (PST)
Date: Thu, 6 Feb 2020 04:32:45 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Message-ID: <202002060428.08B14F1@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-10-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:48PM -0800, Kristen Carlson Accardi wrote:
> To support finer grained kaslr (fgkaslr), we need to make a couple changes
> to kallsyms. Firstly, we need to hide our sorted list of symbols, since
> this will give away our new layout. Secondly, we will export the seed used
> for randomizing the layout so that it can be used to make a particular
> layout persist across boots for debug purposes.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  kernel/kallsyms.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 136ce049c4ad..432b13a3a033 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -698,6 +698,21 @@ const char *kdb_walk_kallsyms(loff_t *pos)
>  }
>  #endif	/* CONFIG_KGDB_KDB */
>  
> +#ifdef CONFIG_FG_KASLR
> +extern const u64 fgkaslr_seed[] __weak;
> +
> +static int proc_fgkaslr_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%llx\n", fgkaslr_seed[0]);
> +	seq_printf(m, "%llx\n", fgkaslr_seed[1]);
> +	seq_printf(m, "%llx\n", fgkaslr_seed[2]);
> +	seq_printf(m, "%llx\n", fgkaslr_seed[3]);
> +	return 0;
> +}
> +#else
> +static inline int proc_fgkaslr_show(struct seq_file *m, void *v) { return 0; }
> +#endif
> +

I'd like to put the fgkaslr seed exposure behind a separate DEBUG
config, since it shouldn't be normally exposed. As such, its
infrastructure should be likely extracted from this and the main fgkaslr
patches and added back separately (and maybe it will entirely vanish
once the RNG is switched to ChaCha20).

>  static const struct file_operations kallsyms_operations = {
>  	.open = kallsyms_open,
>  	.read = seq_read,
> @@ -707,7 +722,20 @@ static const struct file_operations kallsyms_operations = {
>  
>  static int __init kallsyms_init(void)
>  {
> -	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
> +	/*
> +	 * When fine grained kaslr is enabled, we don't want to
> +	 * print out the symbols even with zero pointers because
> +	 * this reveals the randomization order. If fg kaslr is
> +	 * enabled, make kallsyms available only to privileged
> +	 * users.
> +	 */
> +	if (!IS_ENABLED(CONFIG_FG_KASLR))
> +		proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
> +	else {
> +		proc_create_single("fgkaslr_seed", 0400, NULL,
> +					proc_fgkaslr_show);
> +		proc_create("kallsyms", 0400, NULL, &kallsyms_operations);
> +	}
>  	return 0;
>  }
>  device_initcall(kallsyms_init);
> -- 
> 2.24.1

In the past, making kallsyms entirely unreadable seemed to break weird
stuff in userspace. How about having an alternative view that just
contains a alphanumeric sort of the symbol names (and they will continue
to have zeroed addresses for unprivileged users)?

Or perhaps we wait to hear about this causing a problem, and deal with
it then? :)

-- 
Kees Cook
