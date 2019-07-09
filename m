Return-Path: <SRS0=+a18=VG=lists.openwall.com=kernel-hardening-return-16401-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1146C73C56
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 16:10:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5A85220656
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2019 16:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A85220656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16401-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31799 invoked by uid 550); 9 Jul 2019 16:10:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31765 invoked from network); 9 Jul 2019 16:10:31 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: front40_59e25574f9562
X-Filterd-Recvd-Size: 2588
Message-ID: <040b50f00501ae131256bb13a5362731ebdd6bfe.camel@perches.com>
Subject: Re: [PATCH v4] Added warnings in checkpatch.pl script to :
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, corbet@lwn.net
Cc: akpm@linux-foundation.org, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Tue, 09 Jul 2019 09:10:16 -0700
In-Reply-To: <20190709154806.26363-1-nitin.r.gote@intel.com>
References: <20190709154806.26363-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-09 at 21:18 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.

Please slow down your patch submission rate for
this instance and respond appropriately to the
comments you've been given.

This stuff is not critical bug fixing.

The subject could be something like:

Subject: [PATCH v#] Documentation/checkpatch: Prefer strscpy over strcpy/strlcpy

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +        "strcpy"				=> "strscpy",
> +        "strlcpy"				=> "strscpy",
> +        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with the __nonstring",

'the' is not necessary.

There could likely also be a strscat created for
strcat, strlcat and strncat.

btw:

There were several defects in the kernel for misuses
of strlcpy.

Did you or anyone else have an opinion on stracpy
to avoid duplicating the first argument in a
sizeof()?

	strlcpy(foo, bar, sizeof(foo))
to
	stracpy(foo, bar)

where foo must be char array compatible ?

https://lore.kernel.org/lkml/d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com/



