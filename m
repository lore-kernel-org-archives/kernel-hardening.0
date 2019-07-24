Return-Path: <SRS0=Qn+f=VV=lists.openwall.com=kernel-hardening-return-16581-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA40C76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 18:29:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E626621926
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 18:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E626621926
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16581-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11718 invoked by uid 550); 24 Jul 2019 18:29:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11676 invoked from network); 24 Jul 2019 18:29:30 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: ants48_8b108300b7635
X-Filterd-Recvd-Size: 2301
Message-ID: <0d69778626901a841108ae024b8a105da679d9af.camel@perches.com>
Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
From: Joe Perches <joe@perches.com>
To: "Gote, Nitin R" <nitin.r.gote@intel.com>, Kees Cook
 <keescook@chromium.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "akpm@linux-foundation.org"
	 <akpm@linux-foundation.org>, "apw@canonical.com" <apw@canonical.com>, 
	"linux-doc@vger.kernel.org"
	 <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com"
	 <kernel-hardening@lists.openwall.com>
Date: Wed, 24 Jul 2019 11:29:13 -0700
In-Reply-To: <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
	 <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
	 <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
	 <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-07-24 at 18:17 +0000, Gote, Nitin R wrote:
> Hi,

Hi again.

[]
> > > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Please remember there does not exist a single actual use
of strscpy_pad in the kernel sources and no apparent real
need for it.  I don't find one anyway.

> Could you please give your opinion on below comment.
>  
> > But, if the destination buffer needs extra NUL-padding for remaining size of
> > destination, then safe replacement is strscpy_pad().  Right?  If yes, then what
> > is your opinion on below change :
> > 
> >         "strncpy" => "strscpy, strcpy_pad - for non-NUL-terminated uses,
> > strncpy() dst should be __nonstring",
> > 
> If you agree on this, then I will include this change in next patch version.

Two things:

The kernel-doc documentation uses dest not dst.
I think stracpy should be preferred over strscpy.


