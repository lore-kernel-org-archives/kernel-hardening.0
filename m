Return-Path: <SRS0=IU2q=VW=lists.openwall.com=kernel-hardening-return-16585-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F798C76190
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 18:50:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3CA9422BF5
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 18:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="h0hnsIDc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CA9422BF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16585-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26617 invoked by uid 550); 25 Jul 2019 18:50:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26573 invoked from network); 25 Jul 2019 18:50:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KgMBXseeuQsdqSuGEWeeA5eJNRzyR59gJRwHUubllLU=;
        b=h0hnsIDcQvjhJWJRuZyRt3d6rz/AwxMnaTk57/IR7ajs7S+RDYdbkAS/6vyiC7h8SL
         VhT1INz2v7ULdjkBv6/9w5NC3Zytn3nsGSNp3mXeqX0CdmKi49zJdVGz1bFGx5jiOLpA
         UD6wrgQBYTANPSwXX0RNScKtMlrpO9DaoU7Ao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KgMBXseeuQsdqSuGEWeeA5eJNRzyR59gJRwHUubllLU=;
        b=JLzItdP/dimC6CHAZnepRJBoY5vwiFN0Y5b/shHf+Td2GocpVoIogwBj/x9AUUpEKX
         VX/AFnhmVfGykH1VRTbee2LhEc+FjC6VIY+/srzUfDFYoHvgNwJkNh4Q+R1EBm5D/XZq
         U/d1Sm0PUEB9M0M+bss6oBWc8BPM3rsoETaRaSGF13IkJfNW3IJV/sCqmZP6LaT2HyMw
         8pHXuYkzu6FTY2fKU/dhwVxtSqnvIklyOTMZZUrxDJcQXiLJ2GE/HmfPc8Hlt7ouE9HU
         8CNYN79n/kTrcWFaqcuVFJrZWSlLvo43nOJgQYCDOh1CfVPuscWFfPc6cxw8EPkYSXDX
         R/tw==
X-Gm-Message-State: APjAAAWu99sF11aV96KUkzfmtVUDR1zlt3si+sHuDjVWokn1fgtVpm2K
	2lNICxnqrPauwxhUzuysKjTTkA==
X-Google-Smtp-Source: APXvYqzL95DjsC7OQDsa3RI77Al5cGi9B1bsdA6VXlgvY5+0zNMkNB31JjPd7Jg+pb2t7ijCDy8Rdg==
X-Received: by 2002:a63:9dcb:: with SMTP id i194mr42191627pgd.444.1564080624943;
        Thu, 25 Jul 2019 11:50:24 -0700 (PDT)
Date: Thu, 25 Jul 2019 11:50:23 -0700
From: Kees Cook <keescook@chromium.org>
To: NitinGote <nitin.r.gote@intel.com>
Cc: joe@perches.com, corbet@lwn.net, akpm@linux-foundation.org,
	apw@canonical.com, linux-doc@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6] Documentation/checkpatch: Prefer stracpy over
 strcpy/strlcpy/strncpy.
Message-ID: <201907251149.B7FD8631@keescook>
References: <20190725112219.6244-1-nitin.r.gote@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725112219.6244-1-nitin.r.gote@intel.com>

On Thu, Jul 25, 2019 at 04:52:19PM +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
> strncpy() in favor of stracpy().

stracpy() is preferred when the destination is a char array (rather than
a string pointer), so that likely needs to be clarified.

-Kees

> 
> Updated Documentation/process/deprecated.rst for stracpy().
> 
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> ---
>  Change log:
>  v5->v6
>  - Used stracpy() instead of strscpy().
> 
>  v4->v5
>  - Change the subject line as per review comment.
>  - v5 is Reviewed-by: Kees Cook <keescook@chromium.org>
> 
>  v3->v4
>  - Removed "c:func:" from deprecated.rst as per review comment.
> 
>  v2->v3
>  - Avoided use of $check in implementation.
>  - Incorporated trivial comments.
> 
>  v1->v2
>  - For string related apis, created different %deprecated_string_api
>    and these will get emitted at CHECK Level using command line option
>    -f/--file to avoid bad patched from novice script users.
> 
>  Documentation/process/deprecated.rst | 10 +++++-----
>  scripts/checkpatch.pl                | 24 ++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 49e0f64a3427..709662c71a1a 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -84,7 +84,7 @@ buffer. This could result in linear overflows beyond the
>  end of the buffer, leading to all kinds of misbehaviors. While
>  `CONFIG_FORTIFY_SOURCE=y` and various compiler flags help reduce the
>  risk of using this function, there is no good reason to add new uses of
> -this function. The safe replacement is :c:func:`strscpy`.
> +this function. The safe replacement is stracpy().
> 
>  strncpy() on NUL-terminated strings
>  -----------------------------------
> @@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
>  and other misbehavior due to the missing termination. It also NUL-pads the
>  destination buffer if the source contents are shorter than the destination
>  buffer size, which may be a needless performance penalty for callers using
> -only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
> -(Users of :c:func:`strscpy` still needing NUL-padding will need an
> -explicit :c:func:`memset` added.)
> +only NUL-terminated strings. In this case, the safe replacement is
> +stracpy(). If, however, the destination buffer still needs NUL-padding,
> +the safe replacement is stracpy_pad().
> 
>  If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
>  still be used, but destinations should be marked with the `__nonstring
> @@ -107,7 +107,7 @@ strlcpy()
>  :c:func:`strlcpy` reads the entire source buffer first, possibly exceeding
>  the given limit of bytes to copy. This is inefficient and can lead to
>  linear read overflows if a source string is not NUL-terminated. The
> -safe replacement is :c:func:`strscpy`.
> +safe replacement is stracpy().
> 
>  Variable Length Arrays (VLAs)
>  -----------------------------
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 342c7c781ba5..dddf5adf1aac 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +	"strcpy"		=> "stracpy",
> +	"strlcpy"		=> "stracpy",
> +	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
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
