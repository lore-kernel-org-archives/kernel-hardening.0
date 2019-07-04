Return-Path: <SRS0=d8kF=VB=lists.openwall.com=kernel-hardening-return-16347-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2488BC0651F
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jul 2019 20:46:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 76EBB218A0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jul 2019 20:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76EBB218A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16347-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22340 invoked by uid 550); 4 Jul 2019 20:46:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22305 invoked from network); 4 Jul 2019 20:46:40 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: space91_1b23faa223b5f
X-Filterd-Recvd-Size: 2807
Message-ID: <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
From: Joe Perches <joe@perches.com>
To: Nitin Gote <nitin.r.gote@intel.com>, akpm@linux-foundation.org
Cc: corbet@lwn.net, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Thu, 04 Jul 2019 13:46:25 -0700
In-Reply-To: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
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

OK, for whatever reason, this when into a spam folder.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -595,6 +595,11 @@ our %deprecated_apis = (
>  	"rcu_barrier_sched"			=> "rcu_barrier",
>  	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
>  	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
> +	"strcpy"				=> "strscpy",
> +	"strlcpy"				=> "strscpy",
> +	"strncpy"				=> "strscpy, strscpy_pad or for
> +	non-NUL-terminated strings, strncpy() can still be used, but
> +	destinations should be marked with the __nonstring",
>  );

$ git grep -w strcpy | wc -l
2239
$ git grep -w strlcpy | wc -l
1760
$ git grep -w strncpy | wc -l
839

These functions are _really_ commonly used in the kernel.

This should probably be a different %deprecated_string_api
and these should probably not be emitted at WARN level
when using command line option -f/--file but at CHECK level
so that novice script users just don't send bad patches.

Also, perhaps there could be some macro for the relatively
commonly used

	strscpy(foo, bar, sizeof(foo))
and
	strlcpy(foo, bar, sizeof(foo))

so argument 1 doesn't have to be repeated in the sizeof()

Something like:

#define stracpy(to, from)					\
({								\
	size_t size = ARRAY_SIZE(to);				\
	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
								\
	strscpy(to, from, size);				\
})


