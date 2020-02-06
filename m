Return-Path: <SRS0=Riw8=32=lists.openwall.com=kernel-hardening-return-17726-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A0AC35247
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 21:33:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B71CA21927
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 21:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KVrwWF2S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B71CA21927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17726-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16191 invoked by uid 550); 6 Feb 2020 21:33:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16166 invoked from network); 6 Feb 2020 21:33:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZIR0O4XSSHJzQ5NKMOaMQy9m9LNXwiQasS8KWy7Rew=;
        b=KVrwWF2SKiVwKyoIsPVvbAikP44PdWvjeMhQkEtI1By6Zls5EW4B3PSNuMcCWXxG/v
         xusmhSnTOcGjtj7V7BFKf6KBGw/XRFI38EnRK/cpY6ftMFBmZV6TSFD8jSDg+m6fy/z9
         kWyh4e+ldTYzBi4iEsjBLdfXYAQLpCU5u9Vdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZIR0O4XSSHJzQ5NKMOaMQy9m9LNXwiQasS8KWy7Rew=;
        b=dfXglysMv4hIx8ok2LxVplWCxVSiwRU353r2Dcf1q0TfVILipWjI/5Vr31tAFW2NgV
         /MwOYRG/AHEtLVa5qpV1iyXb6D0HA0PYn4NjGg9KgHx5m/ygltZZ7NVC5eZp/mmn7aEk
         sq4r8CdAOd1oYq85s4bgh0VamRDz/m0qH9+ugPJPxyOX3dYRuoQjHJJX5xyoWBYbNbTO
         JJgZSK941MPqo1ANrbHmkNVRVi05TkMLk8X8vcT3n6Qm3SBUn8x6LhQvGYy4x6VXcZr3
         BlGn5y9BCAk1f+9VWkuJlZI9hsPpJkhTVTroBwZuDnKb2NAdf9Z0Qa5RJ0kpj241QHzF
         5BZg==
X-Gm-Message-State: APjAAAWUpKntOPr2ZGgsRjKiiCaH67fGbAK5oanN0R1D/gc4ulqU9JoG
	jsp2//x2QX8vkfWQNEU1j51FZA==
X-Google-Smtp-Source: APXvYqwvXjFqDoHHLLlHopScWku9ff/Blk8JGx7kXOUBy8QLwy4WBSOp/2rRgo7BA84Ute5uBspIMg==
X-Received: by 2002:aca:cd46:: with SMTP id d67mr81999oig.156.1581024771067;
        Thu, 06 Feb 2020 13:32:51 -0800 (PST)
Date: Thu, 6 Feb 2020 13:32:48 -0800
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 11/11] x86/boot: Move "boot heap" out of .bss
Message-ID: <202002061331.E5956EA@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-12-kristen@linux.intel.com>
 <20200206001103.GA220377@rani.riverdale.lan>
 <202002060251.681292DE63@keescook>
 <20200206142557.GA3033443@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206142557.GA3033443@rani.riverdale.lan>

On Thu, Feb 06, 2020 at 09:25:59AM -0500, Arvind Sankar wrote:
> On Thu, Feb 06, 2020 at 03:13:12AM -0800, Kees Cook wrote:
> > Yes, thank you for the reminder. I couldn't find the ZO_INIT_SIZE when I
> > was staring at this, since I only looked around the compressed/ directory.
> > :)
> > 
> 
> There's another thing I noticed -- you would need to ensure that the
> init_size in the header covers your boot heap even if you did split it
> out. The reason is that the bootloader will only know to reserve enough
> memory for init_size: it's possible it might put the initrd or something
> else following the kernel, or theoretically there might be reserved
> memory regions or the end of physical RAM immediately following, so you
> can't assume that area will be available when you get to extract_kernel.

Yeah, that's what I was worrying about after I wrote that patch. Yours
is the correct solution. :) (I Acked both of those now).

-- 
Kees Cook
