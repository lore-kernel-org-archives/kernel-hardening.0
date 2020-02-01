Return-Path: <SRS0=V/1n=3V=lists.openwall.com=kernel-hardening-return-17648-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2697DC33CB3
	for <kernel-hardening@archiver.kernel.org>; Sat,  1 Feb 2020 16:40:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 777A1205F4
	for <kernel-hardening@archiver.kernel.org>; Sat,  1 Feb 2020 16:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jsFiPNcF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 777A1205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17648-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9788 invoked by uid 550); 1 Feb 2020 16:40:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9754 invoked from network); 1 Feb 2020 16:40:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QwZ3CLPSOKerZ4q2cB/Hi0ai1yGFzd/B3udh3ZqTtuM=;
        b=jsFiPNcF+Kv+AD+cCoimAjdmxdXVfz+jklLjuWAodKYGoYYpsmGFXd7lewm9b+k+0a
         YxyMuZnoFgQBJJT4fvhBfbLaQinvoO/ovQPcFEXi5AGzl5olCx5gYZ4Eq7/UZCm/eIOr
         OQ9onHvvIcrtHkP4clI72kPgvkSCx4wYKUuIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwZ3CLPSOKerZ4q2cB/Hi0ai1yGFzd/B3udh3ZqTtuM=;
        b=Df8Lj7ylv7scb73/jKvbpvMvR7XwgMxlzvXpbVehfchXIfWP1Dy0pyqmx85XCsLLKD
         yaRNxRtmt2tpuffyCDXuwqGrjECmqpfS9Uv41Oanvlyyn0tiN68FDtMp0rZflLLLLXUn
         cH4U19Me800DTNqBBwW75qEX8f8O31WLML9ZOGBKpc/f/0rS1NRqyZySiXJj1q8H2hrP
         Q2932JPV0q5ndZrSccA65vIS17PQMi8awelo9wS87FZ28671aDZPn0w2xJMTMRPHa2vz
         vMWpTfu8Ba6aKc1K9aNQmzSas7DqTsFCmo99AC3AZ89b6lxSMjOBPPcQFbuPozpB/Qfs
         fONg==
X-Gm-Message-State: APjAAAXOofcd9pgmhhjBcSUtwfyPuWkLUT1PyYqNJ85XfJTdpqNsHFDM
	ouG6Lmjm2T0dZDlXe1zmTdagUA==
X-Google-Smtp-Source: APXvYqxXMppfrfTklyz+pwg0P3CdY6ihdgY9Vslz5MfHbndtzF8KzUGwo01U+1jLgg/AvUUKozH1GA==
X-Received: by 2002:a17:902:d20f:: with SMTP id t15mr16360800ply.55.1580575236433;
        Sat, 01 Feb 2020 08:40:36 -0800 (PST)
Date: Sat, 1 Feb 2020 08:40:34 -0800
From: Kees Cook <keescook@chromium.org>
To: Russell Currey <ruscur@russell.cc>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>, mpe@ellerman.id.au,
	linux-kernel@vger.kernel.org, dja@axtens.net,
	kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lkdtm: Test KUAP directional user access unlocks on
 powerpc
Message-ID: <202002010836.76B19684@keescook>
References: <20200131053157.22463-1-ruscur@russell.cc>
 <1b40cea6-0675-731a-58b1-bdc65f1e495e@c-s.fr>
 <0b016861756cbe27e66651b5c21229a06558cb57.camel@russell.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b016861756cbe27e66651b5c21229a06558cb57.camel@russell.cc>

On Fri, Jan 31, 2020 at 05:53:14PM +1100, Russell Currey wrote:
> Correct, the ACCESS_USERSPACE test does the same thing.  Splitting this
> into separate R and W tests makes sense, even if it is unlikely that
> one would be broken without the other.

That would be my preference too -- the reason it wasn't separated before
was because it was one big toggle before. I just had both directions in
the test out of a desire for completeness.

Splitting into WRITE_USERSPACE and READ_USERSPACE seems good. Though if
you want to test functionality (read while only write disabled), then
I'm not sure what that should look like. Does the new
user_access_begin() API provide a way to query existing state? I'll go
read the series...

-- 
Kees Cook
