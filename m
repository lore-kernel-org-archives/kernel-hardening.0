Return-Path: <SRS0=VjtO=VG=lists.openwall.com=kernel-hardening-return-16398-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31307C606B0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 05:58:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B578216C4
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 05:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B578216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16398-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16311 invoked by uid 550); 9 Jul 2019 05:58:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16273 invoked from network); 9 Jul 2019 05:58:12 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: month28_7fc9c36087e4a
X-Filterd-Recvd-Size: 3399
Message-ID: <5e2fb063f50b0d0d8caac5742117488245c4b052.camel@perches.com>
Subject: Re: [PATCH v2] Added warnings in checkpatch.pl script to :
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, akpm@linux-foundation.org
Cc: corbet@lwn.net, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Mon, 08 Jul 2019 22:57:56 -0700
In-Reply-To: <20190709054055.21984-1-nitin.r.gote@intel.com>
References: <20190709054055.21984-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-09 at 11:10 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Kees, I think the concept is fine, but perhaps your
acked-by here isn't great.  There are a few clear
defects in the checkpatch code that you also might
have overlooked.

>  Change log:
>  v1->v2
>  - For string related apis, created different %deprecated_string_api
>    and these will get emitted at CHECK Level using command line option
>    -f/--file to avoid bad patched from novice script users.
> 

[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl

[]
> @@ -605,6 +605,21 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +        "strcpy"                                => "strscpy",
> +        "strlcpy"                               => "strscpy",
> +        "strncpy"                               => "strscpy, strscpy_pad or for non-NUL-terminated strings,
> +         strncpy() can still be used, but destinations should be marked with the __nonstring",

This last strncpy line should not be on multiple lines.
checkpatch output is single line.

[]

> @@ -6446,6 +6461,16 @@ sub process {
>  			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
>  		}
> 
> +# check for string deprecated apis
> +                if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
> +                        my $deprecated_string_api = $1;
> +                        my $new_api = $deprecated_string_apis{$deprecated_string_api};
> +			$check = 1;
> +                        CHK("DEPRECATED_API",
> +                             "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
> +			$check = 0;

nack.

Please use consistent tab indentation and no,
do not set and unset $check.

Please use the same style as the rest of the script
when emitting at different levels for -f uses

			my $msg_level = \&WARN;
			$msg_level = \&CHK if ($file);
			&{$msg_level}("DEPRECATED_API", etc...


