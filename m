Return-Path: <SRS0=Nkp7=AF=lists.openwall.com=kernel-hardening-return-19152-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31672C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 23:22:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BD972078D
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 23:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R9IB6Osr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BD972078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19152-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18321 invoked by uid 550); 24 Jun 2020 23:21:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18289 invoked from network); 24 Jun 2020 23:21:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XsZH2ZlxCr6iT3L+49rRTJJnEJ39rkW4+RYUadIzOtA=;
        b=R9IB6Osrb2qY+Afwa3MRErRuIdvIh83bCWGDGkn1jNRVAI7V/i8wm4cDEgG3oqoLAv
         ELOwYrGok06AlaYBhZeZ+3IfjuhQsuGjYu2XatVJ/71OLiUAIZZySCSiajaFHNciHcFf
         e0IKPhqtq2BJSLy0T3JT47Wx5ej+SaC5oLqz/thfZAX/s5DAQJIfcE/zGNUmp4i50yLi
         wUXNjKP97yKO1chFosjCP6jHbHl9M5gNbhQQQZuBjkNuOh9sE2u/RnliQkupdRrTnB78
         ensm1H7mTXgoQvxbhovdB3WMbvG5GPp88KUT1PvrdRHxTRQ8uR2fd7wNsVlZSXgqslAt
         PztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XsZH2ZlxCr6iT3L+49rRTJJnEJ39rkW4+RYUadIzOtA=;
        b=Emq3gL4cbfI8Ku3d+sjAZjKXN7fkGN1mr/A0rh+WuAoGZV8JQifFqIk5N6ZWY5T5B2
         wrGxUTASJ/h1SW0r1Sau4oAXHigbnBuBPE2/FplS7lzelZ99frgB/YmTUlT1svCDX1ZO
         3+7iTNNmFzsdlUyoPA9Ah5cTTNLVI99POXFf88Ao1A39S9+aPXOboIVO0zlR/FBdYc0n
         h9sPdeG/hN5j2wKUOecZDgkYb8FQEv4aD3Dceb5r0am/v24aIeBPQfcunVzwo0oxUvVv
         kA+5tCKZfHW2tO2uu4yY07iwLAaHPubN7dJ71Ty9yRTp15LpF4txgzXPcWaB/4et8AJO
         5mEg==
X-Gm-Message-State: AOAM5317n6VjrkZ1FuhQD2f0NND3kliZgqlwjo3vaopUT6ZWs+sCtGAv
	eSnWeNrL2zA8CNw7MtMNY/hVCA==
X-Google-Smtp-Source: ABdhPJyQvGPhhCDkDPs//GgXdG4S7pu68Q1Tt12Ksb/sgYYUwtokZaIU62eANn1ZR6ZjIyAunxBX0w==
X-Received: by 2002:a17:90a:ea18:: with SMTP id w24mr186844pjy.158.1593040903445;
        Wed, 24 Jun 2020 16:21:43 -0700 (PDT)
Date: Wed, 24 Jun 2020 16:21:37 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: kernel test robot <lkp@intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>, kbuild-all@lists.01.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 11/22] pci: lto: fix PREL32 relocations
Message-ID: <20200624232137.GA243469@google.com>
References: <20200624203200.78870-12-samitolvanen@google.com>
 <202006250618.DQj64eMK%lkp@intel.com>
 <CAKwvOdnREuOmN_Vinn8pn6fxEpjzCM1_=9tDzbd2z884GNLFeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnREuOmN_Vinn8pn6fxEpjzCM1_=9tDzbd2z884GNLFeA@mail.gmail.com>

On Wed, Jun 24, 2020 at 04:03:48PM -0700, Nick Desaulniers wrote:
> On Wed, Jun 24, 2020 at 3:50 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Sami,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on 26e122e97a3d0390ebec389347f64f3730fdf48f]
> >
> > url:    https://github.com/0day-ci/linux/commits/Sami-Tolvanen/add-support-for-Clang-LTO/20200625-043816
> > base:    26e122e97a3d0390ebec389347f64f3730fdf48f
> > config: i386-alldefconfig (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> > reproduce (this is a W=1 build):
> >         # save the attached .config to linux build tree
> >         make W=1 ARCH=i386
> 
> Note: W=1 ^
> 
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    In file included from arch/x86/kernel/pci-dma.c:9:
> > >> include/linux/compiler-gcc.h:72:45: warning: no previous prototype for '__UNIQUE_ID_via_no_dac190' [-Wmissing-prototypes]
> >       72 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
> >          |                                             ^~~~~~~~~~~~
> >    include/linux/pci.h:1914:7: note: in definition of macro '___DECLARE_PCI_FIXUP_SECTION'
> >     1914 |  void stub(struct pci_dev *dev) { hook(dev); }   \
> >          |       ^~~~
> 
> Should `stub` be qualified as `static inline`? https://godbolt.org/z/cPBXxW
> Or should stub be declared in this header, but implemented in a .c
> file?  (I'm guessing the former, since the `hook` callback comes from
> the macro).

Does static inline guarantee that the compiler won't rename the symbol?
The purpose of this change is to have a stable symbol name, which we can
safely use in inline assembly.

Sami
