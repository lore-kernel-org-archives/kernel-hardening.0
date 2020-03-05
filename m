Return-Path: <SRS0=zUX6=4W=lists.openwall.com=kernel-hardening-return-18087-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94D1C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:50:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4698820732
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:50:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="ulRcbiJE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4698820732
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18087-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24178 invoked by uid 550); 5 Mar 2020 20:50:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24143 invoked from network); 5 Mar 2020 20:50:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZN2bKPbKeIRtrM9iIgiOAYxD5vcZHWo0jv5xrjPRAk0=;
        b=ulRcbiJE8IyxHOYf0toI7GVOJUnzYm1nE08URECAHtMkc7tW2VwDS/KoP8Cp18LA9g
         WIWEmqqihik7TT2J6KG/KWusnIMnKOwBj7PvzuDBl7C8BiCAKyO9TgA259u1JZg7Q9BI
         KPSWVsP98pe/fehSp3HH5r543p7r+AYzcuS3G3tzMa8BAk8/QWvg3rLv8iX4x/9cGBVh
         zkr7/LrGLKEW1wwDndGzRCIY/Vn/vgUXLlYxa/Mru2MoKEOILj417aBEf7GiAVhkvzcQ
         ZmjnKsBLN0hKCAkF4RzJyh4Du0apmJ4JHK4wWErt8fB2R+Yh4I0s8LmkaXjc7UYn0/Zy
         Yzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZN2bKPbKeIRtrM9iIgiOAYxD5vcZHWo0jv5xrjPRAk0=;
        b=FV8xhzgheEg4iyK7Df5KVQ6FSgC+4v+g100ol8x/xQB4XpV0YD29zJYoBOjla446tW
         x2ZYYIIsgV0GZ0H2FQS3ZfClBTek7mV22TpyvJABSAW0/HKV8ScBJ5kFajh5cinVwCIb
         HHfBzTln8F7Gwde+7nNOKQS5ur5gBAMmDlj2KALYDIjON4eiQ3hV/OrrGBP7RPBWnBZh
         Izb9PWKR8NsZNs8jd95FvWamH2U154LDW5FtNPotqWmX8M8Cf4Pzq3PDVVzPsXOy7+fr
         SLHmXqFE/422RR7cN1zX1IoUUhsmJ8xutmqg3lLyzO+9V0GPNmD7/h8Jj0sg3oKgJYOy
         MHjw==
X-Gm-Message-State: ANhLgQ3GgCeGofTm0+hyeyHVNHjZUF+BZcJOoDVjjEQZBFfqBHnqYuYz
	9u9PyQthMifGBJH3jqAjpEXoqQ==
X-Google-Smtp-Source: ADFU+vuf8b03n0ektuyVOOaTbgELLufIJbGO8TesTTpByeRD4Pmk6NbMDojOYTn39X9+RHrcH3RU+g==
X-Received: by 2002:a0d:e7c6:: with SMTP id q189mr296834ywe.329.1583441441200;
        Thu, 05 Mar 2020 12:50:41 -0800 (PST)
Date: Thu, 5 Mar 2020 13:50:34 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com, Nick Hu <nickhu@andestech.com>,
	Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nds32/mm: Stop printing the virtual memory layout
Message-ID: <20200305205034.GC6506@cisco>
References: <202003021038.8F0369D907@keescook>
 <20200305150639.834129-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305150639.834129-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:06:39AM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Kees Cook points out:
> "These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally."
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Tycho Andersen <tycho@tycho.ws>
