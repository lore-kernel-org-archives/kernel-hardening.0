Return-Path: <SRS0=Cq6P=VT=lists.openwall.com=kernel-hardening-return-16524-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D890FC7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:30:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30C5621897
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LCaK/ME6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30C5621897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16524-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32742 invoked by uid 550); 22 Jul 2019 17:30:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32707 invoked from network); 22 Jul 2019 17:30:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wXvZqJm4NRH55ymNoRmcH6T+rFOJHy1EWdglu59DZzY=;
        b=LCaK/ME6Pd4ZhYx+ssvjkI9LB4O8oKSTekE0qoXW/GXXeDZdeImiGm1G894m1tuQ5d
         j4jm59UYARqR7BwdBJeMNi+wW6IACeBrIAZyYnIzB+Bf2TP6zdV6+XmQUQGC2cqW1qfz
         jp0pdd7QqJVQsL6Ga8AetHkGJfJcF/qfZrMBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wXvZqJm4NRH55ymNoRmcH6T+rFOJHy1EWdglu59DZzY=;
        b=nHzylX4oqij7yv1S9CHbxokxotAP5kxQAHLc2+aF9MElw94Lhd96Ce+ZGL4QVodWDK
         kBL5ccNiS4ZhqnwrLjvgPMif2pxu8EkMBSdv5eqKrMcplAtCeyIqCFxPuGGVQEvqT5Oj
         5PxLkWl03jwF4g8vWcZwyZCgEEOtbfh3q/IZpoJHHTE7n1ebLKhrVamhTyOxrw5OI7t2
         Oq2JOvWK+mZMzTCOmdUrUEQAUdAjVpn+piHdRzHlQ9kZR/On2qpTD59utx0bo7JV9at0
         5qSb5hdkPyhmu1TW+i3UeIZIY5zlXdvz/RZDACPbvdWnzaQ60TbE/TbvExFhWEQ7stSU
         A/Yw==
X-Gm-Message-State: APjAAAVYEGdw70yOzW/cn4jKx/l3x2DgNge+2kURy7vLxD8uWsfp38ID
	OTA82MvKpU2jG2VlY5sPve8OkQ==
X-Google-Smtp-Source: APXvYqwvLDHbYqo3arQbkK9RgZ93pgCYAX5DtW/EanFgFv84dn/XaNI+Z5j0/Jy0lEh1/UjJkqM4/w==
X-Received: by 2002:a63:e807:: with SMTP id s7mr70363111pgh.194.1563816630836;
        Mon, 22 Jul 2019 10:30:30 -0700 (PDT)
Date: Mon, 22 Jul 2019 10:30:29 -0700
From: Kees Cook <keescook@chromium.org>
To: NitinGote <nitin.r.gote@intel.com>
Cc: joe@perches.com, corbet@lwn.net, akpm@linux-foundation.org,
	apw@canonical.com, linux-doc@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
Message-ID: <201907221029.B0CBED4F@keescook>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717043005.19627-1-nitin.r.gote@intel.com>

On Wed, Jul 17, 2019 at 10:00:05AM +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> Added check in checkpatch.pl to
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.
> 
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Joe, does this address your checkpatch concerns?

-Kees

> ---
>  Documentation/process/deprecated.rst |  6 +++---
>  scripts/checkpatch.pl                | 24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 49e0f64a3427..c348ef9d44f5 100644
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
> +strscpy(). If, however, the destination buffer still needs NUL-padding,
> +the safe replacement is strscpy_pad().
> 
>  If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
>  still be used, but destinations should be marked with the `__nonstring
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bb28b178d929..1bb12127115d 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +        "strcpy"				=> "strscpy",
> +        "strlcpy"				=> "strscpy",
> +        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with __nonstring",
> +);
> +
> +#Create a search pattern for all these strings apis to speed up a loop below
> +our $deprecated_string_apis_search = "";
> +foreach my $entry (keys %deprecated_string_apis) {
> +        $deprecated_string_apis_search .= '|' if ($deprecated_string_apis_search ne "");
> +        $deprecated_string_apis_search .= $entry;
> +}
> +$deprecated_string_apis_search = "(?:${deprecated_string_apis_search})";
> +
>  our $mode_perms_world_writable = qr{
>  	S_IWUGO		|
>  	S_IWOTH		|
> @@ -6446,6 +6460,16 @@ sub process {
>  			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
>  		}
> 
> +# check for string deprecated apis
> +		if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
> +			my $deprecated_string_api = $1;
> +			my $new_api = $deprecated_string_apis{$deprecated_string_api};
> +			my $msg_level = \&WARN;
> +			$msg_level = \&CHK if ($file);
> +			&{$msg_level}("DEPRECATED_API",
> +				      "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
> +		}
> +
>  # check for various structs that are normally const (ops, kgdb, device_tree)
>  # and avoid what seem like struct definitions 'struct foo {'
>  		if ($line !~ /\bconst\b/ &&
> --
> 2.17.1
> 

-- 
Kees Cook
