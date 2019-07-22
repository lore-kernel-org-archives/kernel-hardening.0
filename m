Return-Path: <SRS0=0P22=VT=lists.openwall.com=kernel-hardening-return-16525-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2EAC7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:34:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F34F21903
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZowcOjJM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F34F21903
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16525-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4082 invoked by uid 550); 22 Jul 2019 17:33:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4050 invoked from network); 22 Jul 2019 17:33:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ax8I1mb7UwIFxfCmMJfuzkJQZA4WbZ7Ek1Ds9PvMQYU=;
        b=ZowcOjJMdxosv2QSzqf2eI08qVemvBx1XFUBmEfS4sU/PraJBWF671A5zObKnz4TfD
         zk/CQmr2CoQ/bq7hFwV/jk7C4Zl+sLHE/NGWoR8qwxKIwHpxQQ4RjoUJThjmRHvGEZgo
         CUZMefdwNypT9GNU3PI/XXImbp4GU9RlYE3TQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ax8I1mb7UwIFxfCmMJfuzkJQZA4WbZ7Ek1Ds9PvMQYU=;
        b=YsK0bY31Snv6nT5IITWa61e3z1UhkkiZyJThdzE24t+10vOtyK6oYdNTuERp60UD9S
         Spm701kBDYa/FQ2LvpcXw15gkvuzZt1Pzrz4Vu/KOA39PIc1zpc6fpbYpbHb9jlrPuvT
         6G720RupLYhXGkgDmOP5aPD79qpBIiTHlTQncAmzgo1Bl+6kmfrxP2gB06bu3jAea5ob
         8rO2YbP1V2+9wMAl1/Bu6ReTRshlOOOzWuoRFA++EYpx3QJ/gxB2OQWjTJVxBx9/emiD
         ofiXlsP0ls5SdexiHYOiwXTij+W4biVewdhI6olhnPTNY08U/DhMUCTbPxVz+qFtWs8y
         ceOA==
X-Gm-Message-State: APjAAAWleiEMRTroVuIatnB4MiRMWHgR1zsAk6B0rszv4boWO88t5+JU
	YvtKakGmUkiKNQHBN0GkZ1SC4Q==
X-Google-Smtp-Source: APXvYqyX5Rkq79yH7MiGBYeJZggeb9zVsBWnRCFtyBj046jkmfMHzDiZGrpNESNeWOyNSE0LXKj3OA==
X-Received: by 2002:a17:902:7043:: with SMTP id h3mr48081374plt.10.1563816821309;
        Mon, 22 Jul 2019 10:33:41 -0700 (PDT)
Date: Mon, 22 Jul 2019 10:33:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Nitin Gote <nitin.r.gote@intel.com>, akpm@linux-foundation.org,
	corbet@lwn.net, apw@canonical.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
Message-ID: <201907221031.8B87A9DE@keescook>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
 <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>

On Thu, Jul 04, 2019 at 05:15:57PM -0700, Joe Perches wrote:
> On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
> > On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
> > > Added warnings in checkpatch.pl script to :
> > > 
> > > 1. Deprecate strcpy() in favor of strscpy().
> > > 2. Deprecate strlcpy() in favor of strscpy().
> > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > > 
> > > Updated strncpy() section in Documentation/process/deprecated.rst
> > > to cover strscpy_pad() case.
> 
> []
> 
> I sent a patch series for some strscpy/strlcpy misuses.
> 
> How about adding a macro helper to avoid the misuses like:
> ---
>  include/linux/string.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 4deb11f7976b..ef01bd6f19df 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -35,6 +35,22 @@ ssize_t strscpy(char *, const char *, size_t);
>  /* Wraps calls to strscpy()/memset(), no arch specific code required */
>  ssize_t strscpy_pad(char *dest, const char *src, size_t count);
>  
> +#define stracpy(to, from)					\
> +({								\
> +	size_t size = ARRAY_SIZE(to);				\
> +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> +								\
> +	strscpy(to, from, size);				\
> +})
> +
> +#define stracpy_pad(to, from)					\
> +({								\
> +	size_t size = ARRAY_SIZE(to);				\
> +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> +								\
> +	strscpy_pad(to, from, size);				\
> +})
> +
>  #ifndef __HAVE_ARCH_STRCAT
>  extern char * strcat(char *, const char *);
>  #endif

This seems like a reasonable addition, yes. I think Coccinelle might
actually be able to find all the existing strscpy(dst, src, sizeof(dst))
cases to jump-start this conversion.

Devil's advocate: this adds yet more string handling functions... will
this cause even more confusion?

-- 
Kees Cook
