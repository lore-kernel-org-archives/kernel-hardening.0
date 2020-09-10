Return-Path: <SRS0=fzs5=CT=lists.openwall.com=kernel-hardening-return-19871-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67589C43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:18:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D00420770
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e0bs/fLL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D00420770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19871-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21806 invoked by uid 550); 10 Sep 2020 23:18:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21779 invoked from network); 10 Sep 2020 23:18:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ahcfJWxMLLWCQWWMSaduDRixyqLU7R2VmWJmYScB+xI=;
        b=e0bs/fLL5/nal1hkQQK8DqWL0oUik0NhYYhdIwGet7sKAsECUiTvD0lpGfKcU5pPSz
         UWGqg4d+81XpUEqJGRxPydRngpjoC+VeTS1Z01mtq0/4saWZosh7U4GKnJWYMXaqhvex
         MrsLwwKtAJrOwh/txFCgXVdSCsIGtRRcNzL4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ahcfJWxMLLWCQWWMSaduDRixyqLU7R2VmWJmYScB+xI=;
        b=I3AskoyLYNgCA6qwh15Z8zZtYfG0cQ2hyjLGv/ypHEGFLtH2kHgaOx6l+E42p6Cxly
         WqRuredVwG+APzKKu1GUTJvwz6OoI00PlClUwufpWO7NqeumDkRzKSdx0W0jqpLnsOom
         4nXyeDqFT34fgJGCCTSoT+WRgFWaZsjVK9UGG1Vn8nr7aZ8r8GSYq30fJCjKsYS2FnLv
         vZx1+MKCuN32GaRl2S/Uz+g98w3KvykqpUHTo/PxyVKn6Cyp1On+2bkE+DY9eaWdI3vp
         oMaYQ64sGhzT1yV80wRU4vtYN2oATuq3hNJWJk5J4QUxfPfquevtJ5vA6JG51ov4Xhpp
         JHhA==
X-Gm-Message-State: AOAM531PM/2Ms0/SFmnkOxdOtf2oqZD5hIhLYjwASp5g4af/UxgzghOI
	bdKqEX1GQpWDs6M30dlICUIrvw==
X-Google-Smtp-Source: ABdhPJyDlBU+y8fl3h3ui9sPcSP+9dtdObZsk3zIBZIW66XSoC5FKE/37mQEGAa93/DFlZtCDe1HSw==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a080 with SMTP id b7-20020aa78ec70000b029013ed13da080mr7345919pfr.23.1599779890038;
        Thu, 10 Sep 2020 16:18:10 -0700 (PDT)
Date: Thu, 10 Sep 2020 16:18:08 -0700
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: John Wood <john.wood@gmx.com>, Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the
 fbfam feature
Message-ID: <202009101615.8566BA3967@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910202107.3799376-2-keescook@chromium.org>

On Thu, Sep 10, 2020 at 01:21:02PM -0700, Kees Cook wrote:
> From: John Wood <john.wood@gmx.com>
> 
> Add a menu entry under "Security options" to enable the "Fork brute
> force attack mitigation" feature.
> 
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  security/Kconfig       |  1 +
>  security/fbfam/Kconfig | 10 ++++++++++
>  2 files changed, 11 insertions(+)
>  create mode 100644 security/fbfam/Kconfig
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 7561f6f99f1d..00a90e25b8d5 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -290,6 +290,7 @@ config LSM
>  	  If unsure, leave this as the default.
>  
>  source "security/Kconfig.hardening"
> +source "security/fbfam/Kconfig"

Given the layout you've chosen and the interface you've got, I think
this should just be treated like a regular LSM.

>  
>  endmenu
>  
> diff --git a/security/fbfam/Kconfig b/security/fbfam/Kconfig
> new file mode 100644
> index 000000000000..bbe7f6aad369
> --- /dev/null
> +++ b/security/fbfam/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config FBFAM

To jump on the bikeshed: how about just calling this
FORK_BRUTE_FORCE_DETECTION or FORK_BRUTE, and the directory could be
"brute", etc. "fbfam" doesn't tell anyone anything.

-- 
Kees Cook
