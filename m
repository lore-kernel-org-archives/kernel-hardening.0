Return-Path: <SRS0=DKA/=VA=lists.openwall.com=kernel-hardening-return-16343-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BCAC0650E
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 16:49:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B11372189E
	for <kernel-hardening@archiver.kernel.org>; Wed,  3 Jul 2019 16:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JqAR/obe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B11372189E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16343-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11324 invoked by uid 550); 3 Jul 2019 16:49:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11289 invoked from network); 3 Jul 2019 16:49:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gojg48FdD3zbRoRKCrB2uhrKKdC6I6VpM87kuq1jOKw=;
        b=JqAR/obejUV2wKILebZ3Jcq4JiPg51O8lZTxpbMWIoWDaucAaaUsOELmRQ5RxBAfPb
         Rsa8+UVX6zrsZRsjyc/UY4uFivfJYUfeOd0o1VqERHpHNkRqlxEpgOCulU7dmSsu6o1n
         UzOP305PKfP2Iqaks49/OuEXGyF7h7j5/cz7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gojg48FdD3zbRoRKCrB2uhrKKdC6I6VpM87kuq1jOKw=;
        b=E9hKb3FfRR8sbg0VuLCChAUB+sw3yeKgpfrQ80RNXQ/TTBh6MuVrwHuCo8frkDRczn
         9EUeKxV2A7QVcGqn1DjkNgcD98QX3d2nYd7IWxeRtZGx8P9dwkakzFwG/AMRjBlwj5ZL
         mQkJz50iyzBc09PLojmEFE4qBIMyt+2riWHwHzFDXMIIqyKMbwA81bG8pygjGl3aVGwF
         T/vO/Ug/jb+UgJ44qXdQQ0mPHl4PLVfxJD7+buUaZZAt/suUoHPfAutUxITeivtpt5/3
         2UOCCHeDPpJwELW/Inz7U7YH9/KAq64brb01CAfIPoCdQnBcXWuU/LGOymsJLszuBlmE
         eSvg==
X-Gm-Message-State: APjAAAWgevQynmckD7kBINgBeo9tSZbvD+cHAHz9yawE1DzkflZDo6aL
	fpki/+HjVRNRzxy4yWHl2rMxIQ==
X-Google-Smtp-Source: APXvYqzNm/CupAUGy1B7gix1tWFbEB3GMyvt2YABAHA1+dIWdJzbogtAaeYdftlOU0QWJJxsdJQyNQ==
X-Received: by 2002:a65:6406:: with SMTP id a6mr25437146pgv.393.1562172544902;
        Wed, 03 Jul 2019 09:49:04 -0700 (PDT)
Date: Wed, 3 Jul 2019 09:49:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Nitin Gote <nitin.r.gote@intel.com>
Cc: jannh@google.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2] checkpatch: Added warnings in favor of strscpy().
Message-ID: <201907030912.30942E2FF@keescook>
References: <1562134814-12966-1-git-send-email-nitin.r.gote@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562134814-12966-1-git-send-email-nitin.r.gote@intel.com>

On Wed, Jul 03, 2019 at 11:50:14AM +0530, Nitin Gote wrote:
> Added warnings in checkpatch.pl script to :
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.
> 
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>

Acked-by: Kees Cook <keescook@chromium.org>

This looks good. I think you're ready for sending this upstream. Please
see:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

The To: should likely be:
	Andrew Morton <akpm@linux-foundation.org>
and I recommend CC to:
	Jonathan Corbet <corbet@lwn.net>
	Andy Whitcroft <apw@canonical.com>
	Joe Perches <joe@perches.com>
	linux-doc@vger.kernel.org
	linux-kernel@vger.kernel.org
	kernel-hardening@lists.openwall.com

Thanks!

-Kees

> ---
>  Documentation/process/deprecated.rst | 6 +++---
>  scripts/checkpatch.pl                | 4 ++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 49e0f64..f564de3 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
>  and other misbehavior due to the missing termination. It also NUL-pads the
>  destination buffer if the source contents are shorter than the destination
>  buffer size, which may be a needless performance penalty for callers using
> -only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
> -(Users of :c:func:`strscpy` still needing NUL-padding will need an
> -explicit :c:func:`memset` added.)
> +only NUL-terminated strings. In this case, the safe replacement is
> +:c:func:`strscpy`. If, however, the destination buffer still needs
> +NUL-padding, the safe replacement is :c:func:`strscpy_pad`.
> 
>  If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
>  still be used, but destinations should be marked with the `__nonstring
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 342c7c7..2ce2340 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -595,6 +595,10 @@ our %deprecated_apis = (
> 	"rcu_barrier_sched"			=> "rcu_barrier",
> 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
> 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
> +	"strcpy"				=> "strscpy",
> +	"strlcpy"				=> "strscpy",
> +	"strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings,
> +	 strncpy() can still be used, but destinations should be marked with the __nonstring",
>  );
> 
>  #Create a search pattern for all these strings to speed up a loop below
> --
> 2.7.4

-- 
Kees Cook
