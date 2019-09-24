Return-Path: <SRS0=fKM0=XT=lists.openwall.com=kernel-hardening-return-16931-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9E7C432C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 23:12:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 84881214DA
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 23:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fzh7+9Ja"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84881214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16931-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19952 invoked by uid 550); 24 Sep 2019 23:12:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19920 invoked from network); 24 Sep 2019 23:12:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/lrZtmQbGIRTXfA+Mejz4sJGfMjNvVkkNvaZuUAIn8s=;
        b=fzh7+9JaETp1Gb4AK4AmcbQlX5hZjzGY0ixkCTU28D7evVaVMh7COgruixXAYTy6LT
         fFFX0wEdrcCnlVRd1FzPQDWGk5hdwkg+4/OyDSIY4KWpv1XUdBuKstuYI6eL1xanRTKq
         IAZM6Br9ZGb3yMfBTq77oZnSJe2FZMGxEjYF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/lrZtmQbGIRTXfA+Mejz4sJGfMjNvVkkNvaZuUAIn8s=;
        b=nJnzqmBtoikNEYxa8L9HI61fgfdnAbUMrTRT2SxsiYx4c7HHVFT5UDx9wXDGDy+IEU
         wsNERHUrzpcEVJ9M8xH1qJmiv43fcrSlMeCeZVVBbeOpRtg0MizStofJc23GDoAkqsIt
         KqoDmryOzYGtvFUer1CT1GWYiNj1+8FZ6Q5a9E5HxW197JkAnviCqYyfnIXW654/NUhQ
         5/xSeE40HDu+JeB8qF36HfsQGvWRhfN7eB/1G+R0uNxDLAED6ily6lQoZnpKE+KpfdHT
         ZqVgVlCfisjJ/poGVGG5/10FLQqhWJLiJtYRI58pkokCPbhetJjdpxj4GlLftpq8RIrm
         dnng==
X-Gm-Message-State: APjAAAWhjnJOOIlmqwU5mnH4ySybMaX/Uc3MDpsBt8lymvEmSSnGqCzA
	8XzCVQapUAmqAYenCqXUFn3qkg==
X-Google-Smtp-Source: APXvYqx6L3tghYkhOwbSTKd4lmWbxTHqV6YWLTae0UI9YzNKuKauwmhbsSNSoVOvd7r0n46/v6zSsw==
X-Received: by 2002:a17:902:76c9:: with SMTP id j9mr5364975plt.187.1569366740550;
        Tue, 24 Sep 2019 16:12:20 -0700 (PDT)
Date: Tue, 24 Sep 2019 16:12:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Tianlin Li <tli@digitalocean.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Introduction and get involved
Message-ID: <201909241604.C4B6686@keescook>
References: <19962016-19D9-40F8-A2A0-B7188614A263@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19962016-19D9-40F8-A2A0-B7188614A263@digitalocean.com>

On Fri, Sep 20, 2019 at 01:59:57PM -0500, Tianlin Li wrote:
> Hello everyone,

Hello!

> My name is Tina. I am working at DigitalOcean Systems/kernel team, focusing on kernel security. I would like to get involved with Kernel Self Protection Project. 
> As a new hire, I don’t have much industry experience yet. But I have some research experience about memory virtualization. 

What kinds of things keep you up at night? :) Or rather, what have you
seen that you think needs fixing?

What exactly do you mean by "memory virtualization"? That seems like it
could be a lot of stuff. :) As far as the kernel's memory management
system goes, there's lots of areas to poke at. Is there any portion
you're specifically interested in?

> Is there any initial task that I can start with? 
> It is going to be a learning exercise for me at the beginning, but I will learn fast and start contributing value to the project. 

There has been some recent work on trying to replace dangerous (or
easily misused) APIs in the kernel with safer alternatives. (See the
recent stracpy() API that was proposed[1].)

[1] https://www.openwall.com/lists/kernel-hardening/2019/07/23/16

I've been keeping a (rather terse) TODO list here:
https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work#Specific_TODO_Items

But I'd like to turn that into an actual bug list on github or the like.

I wonder if working on something like this:
- set_memory_*() needs __must_check and/or atomicity
would be interesting?

The idea there is that set_memory_*() calls can fail, so callers should
likely be handling errors correctly. Adding the "__must_check" attribute
and fixing all the callers would be nice (and certainly touches the
memory management code!)

Welcome!

-Kees

-- 
Kees Cook
