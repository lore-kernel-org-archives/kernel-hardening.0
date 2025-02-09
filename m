Return-Path: <kernel-hardening-return-21927-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B1958C02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 03:45:13 +0000 (UTC)
Received: (qmail 21980 invoked by uid 550); 9 Feb 2025 03:45:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21949 invoked from network); 9 Feb 2025 03:45:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1739072694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TW1GVy7OXHVjEtLYS6l4yYsrDFNRMzSuR/4sETXaIT8=;
	b=P2yZHj8g4wGOTYHaiiXbppITdF3KTYKPqs0KJKDKYHXBeZyXusB768Ei67xAj7yPuav/Ky
	0M3zocDoCY5dcyJAadj8kwNh++GnSiRYjwaKnwg7ms7CLF8css1BmXEvCzM6rTlskuXBUa
	oEAwYOHnsR7riQOowyaGbri2fV9KSQEe+0jkexIK19rOC19UfEX2iDTNPCaEEnUyRx6B90
	dNv1eHVo46dAj7G+bgyRPjxyLOmQsTblBRnQFOO87O28s7yWwlEXsYHhWzIKLnUqiE8szV
	k5CnKvPJKHx/cUG1ZyuGRHW0Iw8l9Ek+Q73f+4lkSxFnhOXMy9Kws7qjTuaq3g==
Date: Sat, 8 Feb 2025 22:44:51 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: "rafael@kernel.org" <rafael@kernel.org>
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v3] thermal/debugfs: change kzalloc to kcalloc
Message-ID: <5gjmqurpvdyb6sxpeytev7clxxrkpbjncjb623z4dg3vbaqzvm@kavc7th7svwd>
References: <dmv2euctawmijgffigu7qr4yn7jtby4afuy5fgymq6s35c5elu@inovmydfkaez>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dmv2euctawmijgffigu7qr4yn7jtby4afuy5fgymq6s35c5elu@inovmydfkaez>
X-Rspamd-Queue-Id: 4YrD9d6h5rz9skP

I wanted to check in on this. Anything I need to change?

Thanks,
Ethan

On 25/01/19 01:35PM, Ethan Carter Edwards wrote:
> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].
> 
> [1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> Link: https://github.com/KSPP/linux/issues/162
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
>  v3: fix description and email client formatting
>  v2: fix typo
>  drivers/thermal/thermal_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
> index c800504c3cfe..29dc1431a252 100644
> --- a/drivers/thermal/thermal_debugfs.c
> +++ b/drivers/thermal/thermal_debugfs.c
> @@ -876,7 +876,7 @@ void thermal_debug_tz_add(struct thermal_zone_device *tz)
>  
>  	tz_dbg->tz = tz;
>  
> -	tz_dbg->trips_crossed = kzalloc(sizeof(int) * tz->num_trips, GFP_KERNEL);
> +	tz_dbg->trips_crossed = kcalloc(tz->num_trips, sizeof(int), GFP_KERNEL);
>  	if (!tz_dbg->trips_crossed) {
>  		thermal_debugfs_remove_id(thermal_dbg);
>  		return;
> -- 
> 2.47.1
> 
