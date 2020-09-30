Return-Path: <SRS0=o6mr=DH=lists.openwall.com=kernel-hardening-return-20071-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E207EC4727C
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 20:45:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0FF532064E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 20:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="N1JSnjgI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FF532064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20071-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22106 invoked by uid 550); 30 Sep 2020 20:45:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22074 invoked from network); 30 Sep 2020 20:45:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JgQmmymEepmTyKfdtmZJjASTO5kyTURiWqToh5meDKE=;
        b=N1JSnjgIbsN1xv7O/7f3T3QNscpYc+Oc8Onavg+xJhKmu87Vl5txC0mRnj581yP+T5
         vji39GuQ54k3KnvTyItbHHJyjV7n/9yiIdpidKzXo0JDXhzi+h96aiFk9fi64j8d2bCt
         gMDMVPAGpbUo9icFxVDwyRsfPfCjPc7VT3l7U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JgQmmymEepmTyKfdtmZJjASTO5kyTURiWqToh5meDKE=;
        b=tRF9f9vfpGgyl9B4CXwffZorZa3Te2FWKnNz+tN7/ATQpgrT5zpgN3dSb5GhvBrsmG
         SOl9vW3+p7gsZP18902v535AxENB77cvysItJcDTscQ2G4d81kDolrWw0XJXETFnITlD
         HOFnqurU7RWVnbScjxR14g5wJNKCDPCd5K7dOXU7jc8lQlB4uk+LTXLFc5Gaq0rkgiAq
         NAOoAJj+WHpY2S4JSFYUIEfJWs/zWpHw0LsyxkZ8pHn/tBW0d/reKYSMELzX4J28wIP7
         1otOFlFvittmUg8mtO5I3EDU1piJhewlUYmAdNw2GvbdXVMihbg+nn3DGw5/Zc0UDBwx
         Srmw==
X-Gm-Message-State: AOAM5314TAxhYomfBAu2dNpJsuRGWcXI90iesl024z479u2oS7bcZKft
	kKBM7/M7GJ+M9Egce/KxBKCukg==
X-Google-Smtp-Source: ABdhPJwj25UpjOCh8s4y4qnI0EKHGhfilZz0SCC4DlHMi6btWQ6hwRXxTigXsih3jOgTEpH2lz1kwQ==
X-Received: by 2002:a63:4d4a:: with SMTP id n10mr3430255pgl.96.1601498706030;
        Wed, 30 Sep 2020 13:45:06 -0700 (PDT)
Date: Wed, 30 Sep 2020 13:45:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v4 10/29] treewide: remove DISABLE_LTO
Message-ID: <202009301344.3949D2FA8@keescook>
References: <20200929214631.3516445-1-samitolvanen@google.com>
 <20200929214631.3516445-11-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929214631.3516445-11-samitolvanen@google.com>

On Tue, Sep 29, 2020 at 02:46:12PM -0700, Sami Tolvanen wrote:
> This change removes all instances of DISABLE_LTO from
> Makefiles, as they are currently unused, and the preferred
> method of disabling LTO is to filter out the flags instead.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thanks! I think this makes things cleaner in the later patches. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
