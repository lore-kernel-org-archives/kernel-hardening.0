Return-Path: <SRS0=+sez=E2=lists.openwall.com=kernel-hardening-return-20435-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7FFC2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:29:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DCA892223F
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="slPQ//pe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCA892223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20435-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1297 invoked by uid 550); 20 Nov 2020 20:29:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1274 invoked from network); 20 Nov 2020 20:29:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWEyiKtLOwc5BKH8g+Q/g+4/sPbOaRfc0dXxralt2Mw=;
        b=slPQ//pemKZh9f5kkjudlch0CBWhSXQy2VCSu7HRkD1RW0Ao5+0ftQM2E6UPD3hccj
         qjQNNmRuGGdK3qOvq5NYurgRaP3hJJuevD4jAH/fmKo+acNl1pILRNLqMDFd7QZ+2prZ
         tmcUlDky6roTiagY+1Ks0VwGJwggfgRDYhMNyjlvUprVonMn9YqbkCKWYuYbATXQn2JP
         H9tN2HQsAdXChUj0afdmZW/4fCcfq/VPLcHKF5jmoDMHeF6P0ZDz4TumaSvPvAlnmbSp
         9HEAzto9pPBh3Vc65NGET29HWmFU7wMfbtObL4BW7Zce7yCYVt0G+SkyUa9ICW+0aIqa
         CMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWEyiKtLOwc5BKH8g+Q/g+4/sPbOaRfc0dXxralt2Mw=;
        b=ZWS0pSqTJcFmpV2FC7q0m2EHN+4oBSeGqfZPhg0ZGK+4YLIUqfvItxghBYUhiOjSzV
         lGIRg0j2H48tDaaR0dSkEHcUtDp5Jz5mgdm/ncI9EBNEYOvGle+7Wf7rnCeWh1edyZls
         r3EckTHLF1vnFUuI1otBvkW+rmZgCKAvlmMPCgNAlF6CZqZbfL5FkV6nyXPH71UHcroH
         3Y81kCJcH1Xq11/xdHuXIL77Z6kSikFL1GDN3VTmnlvzfH+51FbK2tpC45fe8+DPHoWY
         RFdZhzf6NqiQgI2OIUTXgv0pO3SgERS5ViEAK11mCpdoYhajEEcrbbUuV0Zkv2WEdDtv
         NDgg==
X-Gm-Message-State: AOAM531vAJ+zVSHeHbt9+LrP5txCIF+CI6kjLS1w05Acbu42eARMflOV
	LW+6M5E0Fj5X68cwCZY5+vY=
X-Google-Smtp-Source: ABdhPJyeXkg7uuNpc9skA29Vf8QCCxes8SLhmi9OBG/8zRZ22lxtrFLvm4CI1/fXBFji9v0sjbaDkA==
X-Received: by 2002:ac8:3496:: with SMTP id w22mr17736541qtb.222.1605904178000;
        Fri, 20 Nov 2020 12:29:38 -0800 (PST)
Date: Fri, 20 Nov 2020 13:29:35 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
Message-ID: <20201120202935.GA1220359@ubuntu-m3-large-x86>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com>
 <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
 <202011201144.3F2BB70C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011201144.3F2BB70C@keescook>

On Fri, Nov 20, 2020 at 11:47:21AM -0800, Kees Cook wrote:
> On Fri, Nov 20, 2020 at 08:23:11AM -0800, Sami Tolvanen wrote:
> > Changing the ThinLTO config to a choice and moving it after the main
> > LTO config sounds like a good idea to me. I'll see if I can change
> > this in v8. Thanks!
> 
> Originally, I thought this might be a bit ugly once GCC LTO is added,
> but this could be just a choice like we're done for the stack
> initialization. Something like an "LTO" choice of NONE, CLANG_FULL,
> CLANG_THIN, and in the future GCC, etc.

Having two separate choices might be a little bit cleaner though? One
for the compiler (LTO_CLANG versus LTO_GCC) and one for the type
(THINLTO versus FULLLTO). The type one could just have a "depends on
CC_IS_CLANG" to ensure it only showed up when needed.

Cheers,
Nathan
