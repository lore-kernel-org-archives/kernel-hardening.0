Return-Path: <SRS0=mk2g=6D=lists.openwall.com=kernel-hardening-return-18560-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B179C38A29
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Apr 2020 22:36:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A2B0A2075E
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Apr 2020 22:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="piifZJ1T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2B0A2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18560-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19628 invoked by uid 550); 19 Apr 2020 22:36:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19593 invoked from network); 19 Apr 2020 22:36:12 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 03JMZTon031403
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1587335730;
	bh=zMWxdUUCCNSYYynmB04/IvDKcTobqxHnW5dxNuMCTfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=piifZJ1TH1J9hZ6a0+7jSOX9udOXnka8Ms25jI3q5O5YF/lEwwEaIKQrGHU9aX5mw
	 ZHEWNoJumhu1ULQf74LYpUgMCuQdT5Qztno5hn1EIsqiy+A1qjSUYEI/p7uhDFV35A
	 0DF/kFRorLMHlQTQ1Dq1zHPYu555C9OzL2V1kZSJRaYU+z1ExR8YGVV5dqAF50q/5/
	 dRKfHSnYeozlNPrm8ZpJ3gKYEgeY68XTa7IbqHgOXW81v+fH9I0wOBt8rvze1u1Hhs
	 FDN1KdYj3NlmbUI7wUG4PdQ7nfA3UJSKkWsn0uVgoczXYTSS334CFLsS7+Zjl5t3Pc
	 7a9qjgO7GD0/w==
X-Nifty-SrcIP: [209.85.221.173]
X-Gm-Message-State: AGi0PuaHYC2Es4Efwcaq8f3WYK1eBLCFhjLBXxHnIqqEqvgQLoasF4r7
	DjD4eO1yd6sdyJbvQfWhLpUT6mst13COK7dXrok=
X-Google-Smtp-Source: APiQypK3B2oyKlFhDZ3EfF6PD6sZ1oTdgVehCaeITCP3PwttpRCWg8SNYNjXB6TYUlNo379OqDVCczlSDmxSzPaCKEA=
X-Received: by 2002:a1f:5c03:: with SMTP id q3mr9615938vkb.66.1587335728877;
 Sun, 19 Apr 2020 15:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200419215558.GU30496@eidolon.nox.tf>
In-Reply-To: <20200419215558.GU30496@eidolon.nox.tf>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 20 Apr 2020 07:34:53 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS+=hWM=CvMKMWNa0Fb4S7XL6yPBCQ=TnpM2REsuOYniQ@mail.gmail.com>
Message-ID: <CAK7LNAS+=hWM=CvMKMWNa0Fb4S7XL6yPBCQ=TnpM2REsuOYniQ@mail.gmail.com>
Subject: Re: gcc extended format checking plugin
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        David Lamparter <equinox@diac24.net>
Content-Type: text/plain; charset="UTF-8"

FW: GCC-plugin maintainers



On Mon, Apr 20, 2020 at 7:04 AM David Lamparter <equinox@diac24.net> wrote:
>
> Hello kernel build hackers,
>
>
> in case it is of interest to anyone, we've recently added an extended
> format string checking plugin in the FRRouting project.  We took
> inspiration from the Linux kernel and modified a printf (funnily enough,
> the one from FreeBSD) to support things like %pI4, and we wanted better
> warnings for this.  Since the scheme is the same as in the Linux kernel,
> it may or may not be worth someone's time to take a look.
>
> The plugin is found here:
> https://github.com/FRRouting/frr/tree/master/tools/gcc-plugins
>
> It's derived from gcc's "c-format.c", as such it may make sense to look
> at the diff instead of the straight source.  The original GCC code is in
> the git history there.  It's tested against gcc 9.3.0, YMMV on other
> versions.
>
> Note that the plugin needs a single-line GCC source code modification:
> https://github.com/FRRouting/frr/blob/master/tools/gcc-plugins/gcc-retain-typeinfo.patch
> this is to stop GCC from prematurely stripping information, specifically
> from casts in function parameters.  It does work without the change, but
> it may produce false-positive/negative warnings.
>
> Aside from %pXX suffix support, the plugin also contains two other
> changes that are probably irrelevant to kernel land:
> - it makes some typedefs "final" types since these are not guaranteed to
>   be consistent in size across platforms and therefore can't be
>   printf'd without a cast (e.g. pid_t, uid_t, time_t, etc.)
> - it reserves %Lu for uint64_t
>
> Please don't expect too much on its code quality, I'm not a GCC
> developer and essentially wrote this by trial and error ;)
>
> Cheers,
>
>
> -David



-- 
Best Regards
Masahiro Yamada
