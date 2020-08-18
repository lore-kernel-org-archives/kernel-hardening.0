Return-Path: <SRS0=vPwd=B4=lists.openwall.com=kernel-hardening-return-19656-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C058C433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 20:30:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80A47206B5
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 20:30:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AaqvXdLE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A47206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19656-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27814 invoked by uid 550); 18 Aug 2020 20:30:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27782 invoked from network); 18 Aug 2020 20:30:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D15LCwUmBZtCmumlW6nr4jBG41orUHEOMwdRnfbgR3I=;
        b=AaqvXdLEWIYyzByL5W8jFlmRgpMuSQvypur0OweIWW7lJOOAcbTNog+aFSbjLqCQGx
         VXsS5i/KS620l5CI2bsOSgEdt7XmfjTKI9OLlZI6h82EWPkYOo5lH3zPCcSuh5j3AOtA
         P48Fqr5LH1vRGObUutUjPMHQ77tAbwKZ8J32M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D15LCwUmBZtCmumlW6nr4jBG41orUHEOMwdRnfbgR3I=;
        b=aAw6Wl82IRsCQBKxqJgSvsLVwmOO5B/znh9ZWN3SZ3B/+ROs/dxltCthitWVUWa21C
         ryNEsl0XqjnsRmN1ZyQ5WldmTMFmnZe2lZJT2NXfzCwYZIfu5dP1IMjK7pbemxj2eZJL
         FLuYq1AvR5R+9rMTzpTI/zy5DBco8cMwo/a5bdf8sBOh3lxV/WmCq8RwWo6/sH06UOmT
         QnlQ/sH2+v1xvoLb72HaqKp6I7wmTSJMEQSnKBPUr5CYv5/lU8W+N+jMXEIF2BtPVLBU
         /4llIXhUpsKWJtnNYkRAxkD/XpAoLbjEh6QvtYvTrk0vqbwPvt/ogWQFvdhVWaxn6cRG
         vosw==
X-Gm-Message-State: AOAM530ZtiCfHpOp3vJzHUCL1jazyHptXKxQtsXMXDptWDzbM8kiaL2+
	qYng4UFBeCAK5q/asfZkTk3yIwUriGBFig==
X-Google-Smtp-Source: ABdhPJxz5AWN0zlODj/jb+Q/+K9w2j8IJeiSiblaWapKUcFk4yrjEFTfl6XpKV0uc0NQNbyhFbjZYg==
X-Received: by 2002:a63:fc4b:: with SMTP id r11mr14098115pgk.342.1597782614606;
        Tue, 18 Aug 2020 13:30:14 -0700 (PDT)
Date: Tue, 18 Aug 2020 13:30:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: usercopy arch_within_stack_frames() is a no-op in almost all
 modern kernel configurations
Message-ID: <202008181326.44A7754497@keescook>
References: <CAG48ez00pYAER-RrXPBkiw=3W7NkkQ+hNxNXzY-XdXV7JEFBMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez00pYAER-RrXPBkiw=3W7NkkQ+hNxNXzY-XdXV7JEFBMg@mail.gmail.com>

On Tue, Aug 18, 2020 at 04:34:18AM +0200, Jann Horn wrote:
> I was looking at some usercopy stuff and noticed that
> arch_within_stack_frames() (the helper used by the usercopy
> bounds-checking logic to detect copies that cross stack frames) seems
> to be a no-op on almost all modern kernel configurations.

Yeah, this was unfortunate.

> It is only defined for x86 - no implementation for e.g. arm64 exists
> at all. The x86 version requires CONFIG_FRAME_POINTER, which is only
> selected by CONFIG_UNWINDER_FRAME_POINTER (whereas the more modern
> choice, and default, for x86-64 is CONFIG_UNWINDER_ORC).

usercopy hardening landed in upstream _just_ before the ORC unwinder.

> Personally, I don't feel very attached to that check; but if people
> are interested in keeping it, it should probably be reworked to use
> the proper x86 unwinder API: unwind_start(), unwind_next_frame(),
> unwind_get_return_address_ptr() and unwind_done() together would
> probably help with this. Otherwise, it should probably be removed,
> since in that case it's pretty much going to just be bitrot?

Right -- this was discussed at the time, and it seemed like it might be
a relatively expensive change. The coverage provided by
arch_within_stack_frames() just made sure that a given vector didn't
cross frames (and didn't reside entirely between frames).

I'm not too attached to the check, though I might be curious to see just
_how_ expensive it would be to implement it with the unwinder API.

-- 
Kees Cook
