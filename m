Return-Path: <SRS0=yl6J=DG=lists.openwall.com=kernel-hardening-return-20028-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BECC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:59:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F36D52076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iUYptqhO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F36D52076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20028-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23675 invoked by uid 550); 29 Sep 2020 18:59:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23644 invoked from network); 29 Sep 2020 18:59:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dk1cTODLxYw48Etf8ZXYv1O0s0b1u8jvfbtZJWNF/FU=;
        b=iUYptqhO1Cb1oqT70B6OiYOEYPvUtMv6DmPRynZqXb0UsVj/WglJDwZUkMpyqS2El8
         Fd8UtabAKffredo2BSoKxIcFQbo25h/vpQ00kE9PoG5u9WEJ0ixa5dWISEAnpDqMzojB
         +00ID59hznF2RjXcFfPz2RjUs2bfCHrZQogjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dk1cTODLxYw48Etf8ZXYv1O0s0b1u8jvfbtZJWNF/FU=;
        b=ecYm3m/mlYtjGb2Q23Zs6pGHWvZ04mt7YWZnVUevspd1W0CNThnjb27O5NtWMtZww8
         lJKfNS+jNv4l8URrwpeUkWv443p09gV9AcdkW4UkdXft21yrYi0szj9z67EN0FHBJXcG
         +wzqdOk4/Gt0CtCz0IP/zg5ijJ239nIWueYv30o10RwXdLFjoU6rD/w7NiRzIIGT6qzs
         gSxagd5PmFvCr5PAnABbRfed+73iPPFGZvv13jCCVL7alk50CPXMLyW41DaIWl0g7GLR
         T30Al12/sJbUvozMh7qcOsKmO96PxcvuWdp33BEQm8m02xRcN7bc80R4C3r6SXa545qD
         oP2A==
X-Gm-Message-State: AOAM532FYuh/VixQeaC3VfpPjRLIqMwFqQMIiBg0AseJe8RNodbXSEDR
	Favs5ETZA2UUZSd2xsOklmZ/1g==
X-Google-Smtp-Source: ABdhPJzU/8kPj+74FsXi5Gk92Xw8EMgcTBYX8nGMWdrd6Q+OG2MvX/M1oO4s/mu3/8z3kZaxwqcXlA==
X-Received: by 2002:a62:1dc1:0:b029:13e:d13d:a051 with SMTP id d184-20020a621dc10000b029013ed13da051mr5198108pfd.23.1601405940393;
        Tue, 29 Sep 2020 11:59:00 -0700 (PDT)
Date: Tue, 29 Sep 2020 11:58:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v5 00/10] Function Granular KASLR
Message-ID: <202009291156.075F4215@keescook>
References: <20200923173905.11219-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923173905.11219-1-kristen@linux.intel.com>

On Wed, Sep 23, 2020 at 10:38:54AM -0700, Kristen Carlson Accardi wrote:
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.
> 
> Changes in v5:
> --------------
> [...]

Builds and boots; looks happy. Hopefully this can go into -tip after
the coming v5.10 merge window, for v5.11? Thoughts?

Tested-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
