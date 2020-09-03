Return-Path: <SRS0=OVoH=CM=lists.openwall.com=kernel-hardening-return-19778-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263A6C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 23:38:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6BF172083B
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 23:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gvG6wFPN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BF172083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19778-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13771 invoked by uid 550); 3 Sep 2020 23:38:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13735 invoked from network); 3 Sep 2020 23:38:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vpMIvEwuRSqC+Z+zTJmdoPgPG+oL4Eop2jtb25EWWgk=;
        b=gvG6wFPNF0Tcin4Ap2mhko2aiVRBSXzp1p2mlklenZECv4SocSBp+jn3VNJMansFKr
         OiZX2u7WDwqU4iPvPk8YmYriiePKsJQyUZuud8Bhv0KORwFRgLPlXNkRLZ2trFWXd5Y/
         oOBfwOcv/SeeoHkG8Ef4WwrqpQReE8/Tx8zcg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vpMIvEwuRSqC+Z+zTJmdoPgPG+oL4Eop2jtb25EWWgk=;
        b=PLaRhqAVbumwmMSbhmV7xmI45Sm1lVv7mAP6FHMdyt8yx4fbFg93hn8c0DQajqrtNa
         Wa033HeWjgQ1Y9ctIjZMafBopA+f4qgfdPfM19vVYIbDOFAi2/wHTpGun/TOVIfVNoJp
         I7s6yTYGQ6CIWqAyksjd3aVtuglYlH30o00HlUAdm+AQq/dMlNf+6HEISfre175Xk8cm
         DjU2Hpypb2h+ovR1hgQcRI4gi0mwOw4FwSlX1rbT/DVXXRG5uvpm8UX0G0kDeDczlLiS
         tqTpfkkkClphxioheXx9ZZnUwWQXwlXXkVC9sl07QKD5moIsvg8+psSkZ90N9iTHowte
         hs0Q==
X-Gm-Message-State: AOAM532MtZQo2i2kdzClEsS2BjmuCJYyOTWLP65pNakFYy0nRnCYFw+7
	YH3Lpr37NKVWgkJxZ1QUThakuw==
X-Google-Smtp-Source: ABdhPJyiZpxHVqfKKsHge2peFlT0tOhsV4ucarLlAr1ffPxhOv0TOSI8XtiKBiFflmROB6YHqiVGkg==
X-Received: by 2002:a17:90a:d514:: with SMTP id t20mr5116667pju.134.1599176301506;
        Thu, 03 Sep 2020 16:38:21 -0700 (PDT)
Date: Thu, 3 Sep 2020 16:38:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
Message-ID: <202009031634.876182D@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:25PM -0700, Sami Tolvanen wrote:
> This patch series adds support for building x86_64 and arm64 kernels
> with Clang's Link Time Optimization (LTO).
> [...]
> base-commit: e28f0104343d0c132fa37f479870c9e43355fee4

And if you're not a b4 user, this tree can be found at either of these places:

https://github.com/samitolvanen/linux/commits/clang-lto

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git kspp/sami/lto/v2

-- 
Kees Cook
