Return-Path: <SRS0=A+vq=VT=lists.openwall.com=kernel-hardening-return-16526-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B8AC76190
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:41:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6476C2190D
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6476C2190D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16526-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12066 invoked by uid 550); 22 Jul 2019 17:41:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12034 invoked from network); 22 Jul 2019 17:41:13 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: worm76_25cee27498045
X-Filterd-Recvd-Size: 2116
Message-ID: <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, NitinGote <nitin.r.gote@intel.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Mon, 22 Jul 2019 10:40:58 -0700
In-Reply-To: <201907221029.B0CBED4F@keescook>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 10:30 -0700, Kees Cook wrote:
> On Wed, Jul 17, 2019 at 10:00:05AM +0530, NitinGote wrote:
> > From: Nitin Gote <nitin.r.gote@intel.com>
> > 
> > Added check in checkpatch.pl to
> > 1. Deprecate strcpy() in favor of strscpy().
> > 2. Deprecate strlcpy() in favor of strscpy().
> > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > 
> > Updated strncpy() section in Documentation/process/deprecated.rst
> > to cover strscpy_pad() case.
> > 
> > Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Joe, does this address your checkpatch concerns?

Well, kinda.

strscpy_pad isn't used anywhere in the kernel.

And

+        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with __nonstring",

is a bit verbose.  This could be simply:

+        "strncpy" => "strscpy - for non-NUL-terminated uses, strncpy() dst should be __nonstring",

And I still prefer adding stracpy as it
reduces code verbosity and eliminates defects.


