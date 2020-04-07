Return-Path: <SRS0=4wH6=5X=lists.openwall.com=kernel-hardening-return-18461-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB3BC2BA1A
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 17:48:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 05A8B20771
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 17:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nZIVGBc4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05A8B20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18461-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7334 invoked by uid 550); 7 Apr 2020 17:48:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7300 invoked from network); 7 Apr 2020 17:48:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NC51PyoeamQkUwNgNNp8H/PX+EtaFEIUJWMw1TZOgI8=;
        b=nZIVGBc4jmA4lzk0Zkn7WALd70Xd5qFDNwJxNppCL9xq1otHq76X/b0bXcWGG6I5bP
         KVMETgaTH6b21yCO5T4HZu/i/h9PCNi7OnQdgXMl0w+EbVE7vwuxpvV2JykIHuhSjeZI
         KTpgwFZ+6nU8HQSi0sFOyKKBCeSym/YN1wsxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NC51PyoeamQkUwNgNNp8H/PX+EtaFEIUJWMw1TZOgI8=;
        b=GuHWFnTZBsP3OwbSTHljCYr4JdsHwVt8tfS9u/pzG1mNrMgFFI0IpNsE94RI3INsp9
         2NdkqfPnt+ZDrp7pDsOiuIoZLRey3m6VZmVcfKiBN3EWXwsvjUrhtYyDnh+ARz20f0HV
         bZ6HhnQqgiC0bNFMblvMDI27oE+ss5kWv8jc3Wj9wbCF3Cedol0YHJoUBTkpW6DxZAgA
         saV3U0+xblGIrrL1rntmovgXLpEML+usgETOqS9nmxs13ujcRomMm0W62xEaynD2flhG
         3pxu4chgOIDtd8Xkv+HdGPtaD1RBT4UF5eCLy8dRKNxCW1kZNRgKeq2YRxH1i66O3H2k
         6bpg==
X-Gm-Message-State: AGi0PuZJSmKTr6kODKgi3+ydMkoLg1eUog25e8C4jgq+4nPQ83qnq/s5
	Y3wMbQQV9CHwaJFLLFwZzD4d9Q==
X-Google-Smtp-Source: APiQypI25g0jV1NZvt8ma29F7Vt2lnrWAbATkwBHXyull3NZyvOgwZ2gvZdTN+f9ALFqpzAbFfOswg==
X-Received: by 2002:a63:6d4a:: with SMTP id i71mr2545924pgc.445.1586281694084;
        Tue, 07 Apr 2020 10:48:14 -0700 (PDT)
Date: Tue, 7 Apr 2020 10:48:12 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Pierret <frederic.pierret@qubes-os.org>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-common.h: 'params.h' has been dropped in GCC10
Message-ID: <202004071044.0B773CCB4B@keescook>
References: <20200407113259.270172-1-frederic.pierret@qubes-os.org>
 <202004070945.D6E095F7@keescook>
 <3119553b-49dc-9d88-158f-2665f56f7b5c@qubes-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3119553b-49dc-9d88-158f-2665f56f7b5c@qubes-os.org>

On Tue, Apr 07, 2020 at 07:22:55PM +0200, Frédéric Pierret wrote:
> 
> 
> On 2020-04-07 18:45, Kees Cook wrote:
> > 
> > Hi! Thanks for the patch. I don't think this is a hack: it's the right
> > thing to do here, yes? GCC 10 includes this helper in gimple.h, so we
> > can ifdef it out in gcc-common.h.
> > 
> > -Kees
> Hi Kees,
> Thank you very much for your comment. Would you like me to rephrase the commit including your comment too? "Hacky" mostly meaning humble modification from my point of view :)

Heh, no worries. I've just reproduced the failure you found with gcc 10,
and I've updated your commit log (and added -Wno-format-diag to the plug
builds). Here's what I've got in my tree now:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=for-next/gcc-plugins&id=dda632f1bc6da784baab8069e26547e3f4144dbe

Thanks for the patch!

-Kees

-- 
Kees Cook
