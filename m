Return-Path: <SRS0=80N2=DV=lists.openwall.com=kernel-hardening-return-20206-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101AFC433E7
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:43:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0597C2223F
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P+m7XeYy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0597C2223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20206-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2045 invoked by uid 550); 14 Oct 2020 22:43:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2011 invoked from network); 14 Oct 2020 22:43:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HXE7zd358OihnnXdqbHtVXM+0rFJH6HtXX7mG7HS7rs=;
        b=P+m7XeYyZ2d5m2JBT4Wg90TEWdILqbaLccqKq7i1SamEiRkb82fahXnlpg2f1W1wbg
         hYpm7jOYPcOHuFgqqHnuX4V3PF9C/c9wSPHpPybZudVDCal6bW+V4V423MNW5wH9Pi3v
         EAtrVXrDgHaNrDFivAYIB/ro+72Y46zcpNM1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HXE7zd358OihnnXdqbHtVXM+0rFJH6HtXX7mG7HS7rs=;
        b=e1lvw9AgmDXn6kqE9VWmo/w7TYHJ96ozJz4bx5Pm+3xCUKmeMfqzAXFqO4mwr67jGe
         8qssUbovRxR9j2EEoIXj0cEWRJj6cKe46vHvNdohArtcOuyyDC5dayY8pF3dlMy/kPZQ
         8hQ9uIvq4P0/rwCF+wn4aZKX9imZ6VloKFm2UdWNtYJIAPvsOxcnq5NvlLvbrqcm0q+1
         VLH/OWqMxo+AOKGc6Ut+Nfq6gX0AE/ipVHy/kuZMbQsP3JbK8ZS7aWSOCJNpkiqjelUn
         yDb70GYOFOXB3pLTknCVxVcaPOK7R3I373wPcs2WLqMYHD4QdrSpvE1Nx90SMBa4KQDw
         NaxQ==
X-Gm-Message-State: AOAM531YuPPdbnRDJ7QclZIp/iYvLtxkqv/C/O1JuLBKD3e89oxfMK0J
	6ewTd5mHfO/6dVeCwqcNFDQvSA==
X-Google-Smtp-Source: ABdhPJwfaPNC+AVzyD2mbtxihYKliPRj3PBojQshk4IbHIXu4wlCtL4Vs5DVZZ2Xhz60ywvob16sAw==
X-Received: by 2002:a63:77c4:: with SMTP id s187mr881793pgc.303.1602715405507;
        Wed, 14 Oct 2020 15:43:25 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:43:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 07/25] treewide: remove DISABLE_LTO
Message-ID: <202010141541.E689442E@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-8-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-8-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:31:45PM -0700, Sami Tolvanen wrote:
> This change removes all instances of DISABLE_LTO from
> Makefiles, as they are currently unused, and the preferred
> method of disabling LTO is to filter out the flags instead.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Hi Masahiro,

Since this is independent of anything else and could be seen as a
general cleanup, can this patch be taken into your tree, just to
separate it from the list of dependencies for this series?

-Kees

-- 
Kees Cook
