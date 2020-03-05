Return-Path: <SRS0=14c+=4W=lists.openwall.com=kernel-hardening-return-18085-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92256C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:49:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7B3920870
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="oCjzxHqs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7B3920870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18085-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21511 invoked by uid 550); 5 Mar 2020 20:49:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20455 invoked from network); 5 Mar 2020 20:49:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5zmgxN7VRZXC7kbix0t7HZalzUvTentTfjnGm/3hMTE=;
        b=oCjzxHqsExisvhlxj2vLbWI+LleP320DIA63HiMC3CvCVE+taSKApySOErK4ZOUpEt
         J9NEAZwHZEmWGlvwUQRcTkTuMMzGpWOQXnz4PiGwEe5CWdNMxavPFDWW2EAGixCQhviZ
         +I4OFEjaLBOeE10vj1L+uU8FohllLaMLab6RAz0XnnMv15zFailN4BfRGHiOaoAiaIYw
         8y7qzIaNpPZH88IK1Cp3LTrqck3d8e8y5MxZg3BI38HsHzkuz/kBeEblxNYQ8e5miY8W
         LR739rAjjIcqXS5O5Y8bv+USeISElSCSY4fbxmQTRCK7NaVpZZ18/K2gcxXqCO097Yi6
         pKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5zmgxN7VRZXC7kbix0t7HZalzUvTentTfjnGm/3hMTE=;
        b=UUSQwjsF4GjltPwE+oMzdiHEBVfFJckectzvarFYA9I382O5fMGrfCAnpLMEMtEjDO
         qkADJ2dGKCc1b+rfMsXXOyXmkgo/CP82jXJaFxZl3tkpBVb+WWLU7ijkCQa7Qk8GRUT+
         tAi7jXY9lYg8/mytAl0gWsy3jYaDOPgi1nPLRXvcCAzmhjOvxKWKw4d/ChcBQzUk3UYA
         SNcphNXTm9453FKnOrZcRXAYHD8FfaUmQ2My0hGK1Hqe92X5wShCw11S5rtykscWqJWq
         PgW6MZaZWN90F9E97Q2YgtQjGK//7W9UbiQQXmT91pj3UpNmKxdgs/KQ/+6AMYe7U+IG
         mYgQ==
X-Gm-Message-State: ANhLgQ0KrHJ+tGWiyavB9oEO4HnpApbD2TSfsqxaOx437LptEErPCgpC
	pRZRoOFJ9TC/8B7K2O98OoTzrw==
X-Google-Smtp-Source: ADFU+vut5SaFR53pXBOtJjgao2EQ5xqKFPyU2dbqIJP6N0WO2apubN/ljUNmlK9XJyrF+68bzRL6FA==
X-Received: by 2002:a25:860d:: with SMTP id y13mr137357ybk.310.1583441366443;
        Thu, 05 Mar 2020 12:49:26 -0800 (PST)
Date: Thu, 5 Mar 2020 13:49:08 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86/mm/init_32: Stop printing the virtual memory
 layout
Message-ID: <20200305204908.GA6506@cisco>
References: <202003021039.257258E1B@keescook>
 <20200305150152.831697-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305150152.831697-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:01:52AM -0500, Arvind Sankar wrote:
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
