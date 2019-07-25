Return-Path: <SRS0=bqjw=VW=lists.openwall.com=kernel-hardening-return-16589-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F54CC76190
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 22:57:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D6B402086D
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jul 2019 22:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6B402086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16589-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13313 invoked by uid 550); 25 Jul 2019 22:57:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12252 invoked from network); 25 Jul 2019 22:57:29 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: linen95_3f6004f62bf19
X-Filterd-Recvd-Size: 1633
Message-ID: <dd43e8789b82a072b89911f41560bbc203d11771.camel@perches.com>
Subject: Re: [PATCH v6] Documentation/checkpatch: Prefer stracpy over
 strcpy/strlcpy/strncpy.
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, keescook@chromium.org
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 25 Jul 2019 15:57:13 -0700
In-Reply-To: <20190725112219.6244-1-nitin.r.gote@intel.com>
References: <20190725112219.6244-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-25 at 16:52 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
> strncpy() in favor of stracpy().
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +our %deprecated_string_apis = (
> +	"strcpy"		=> "stracpy",
> +	"strlcpy"		=> "stracpy",
> +	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
> +);

Maybe:

our %deprecated_string_apis = (
	"strcpy"		=> "stracpy or strscpy",
	"strlcpy"		=> "stracpy or strscpy",
	"strncpy"		=> "stracpy or strscpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
);


