Return-Path: <SRS0=n4Dy=7W=lists.openwall.com=kernel-hardening-return-18943-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52478C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 19:09:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A601D2067B
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 19:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jnaQZ8ME"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A601D2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18943-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30420 invoked by uid 550); 9 Jun 2020 19:09:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30397 invoked from network); 9 Jun 2020 19:09:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQ56nm4mooZrZLgVMVr3lZPOBHVENmtQeTfjkfw/YJA=;
        b=jnaQZ8MEekRFeh3Jik9anJ+/Px5C4alE3zNqedi1bqR8jiPLxE/33C7/RiybjLNOsq
         AmQ9rdfd3Ze4Ax/HonsNV1UFkPQEvOwezedHn5AF5Jnzkw2BlAW1K5ep2YZIi8eWslnH
         VFv1//pXv1ACBo1/iRJVPWdY32ebVtXojWK9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQ56nm4mooZrZLgVMVr3lZPOBHVENmtQeTfjkfw/YJA=;
        b=ZRqMEP3tmgWt9ExxrDcWUkRu1xTVrlxeSjgZrXtJ0DX0kGkUQSnj65m8hUxGZX1rN+
         mjF71Gy3Ar7pRI4THxrFFXJxlm1KlMNJ0qe+v7XN50CrOeU/PVtJzQYTKZn9YvfqFkpA
         9iM4DrlMZPTcGpSWOL7Hqq7wX/muDajzgt55V/qc46DlK1o3QYzaDo8eN/ZU43UWqEHE
         RT2TwdMDUtgHe1DUaQhiE4h9y2Y7jQg7Fkro25t8y2thMdBS4npM3yeAP68ARJRTlzWG
         etmg5ZEcSQDaYf91BubctOWGPrd5PsZQ196dAWr5kCKCnakrgqDV/7KoqZJ/TQCqLmG9
         melw==
X-Gm-Message-State: AOAM531IpNPMNPT7J8x395lDIr5wHwu0uNhwog4KI+ItOA+PX1wa2G8I
	YbBLNIlUXBYMOxdH2Ntf13tzFw==
X-Google-Smtp-Source: ABdhPJyKqh5iCm5EpXlVTd6GWynqUSgX0FSb3wwJXSw5Kt+fNblO4xqG/eduJstaxdLXws8XUiWjng==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr1188647pll.237.1591729769700;
        Tue, 09 Jun 2020 12:09:29 -0700 (PDT)
Date: Tue, 9 Jun 2020 12:09:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH 5/5] gcc-plugins/stackleak: Don't instrument
 vgettimeofday.c in arm64 VDSO
Message-ID: <202006091149.6C78419@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-6-alex.popov@linux.com>
 <20200604135806.GA3170@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604135806.GA3170@willie-the-truck>

On Thu, Jun 04, 2020 at 02:58:06PM +0100, Will Deacon wrote:
> On Thu, Jun 04, 2020 at 04:49:57PM +0300, Alexander Popov wrote:
> > Don't try instrumenting functions in arch/arm64/kernel/vdso/vgettimeofday.c.
> > Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
> > is disabled.
> > 
> > Signed-off-by: Alexander Popov <alex.popov@linux.com>
> > ---
> >  arch/arm64/kernel/vdso/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> > index 3862cad2410c..9b84cafbd2da 100644
> > --- a/arch/arm64/kernel/vdso/Makefile
> > +++ b/arch/arm64/kernel/vdso/Makefile
> > @@ -32,7 +32,8 @@ UBSAN_SANITIZE			:= n
> >  OBJECT_FILES_NON_STANDARD	:= y
> >  KCOV_INSTRUMENT			:= n
> >  
> > -CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> > +CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables \
> > +		$(DISABLE_STACKLEAK_PLUGIN)
> 
> I can pick this one up via arm64, thanks. Are there any other plugins we
> should be wary of? It looks like x86 filters out $(GCC_PLUGINS_CFLAGS)
> when building the vDSO.

I didn't realize/remember that arm64 retained the kernel build flags for
vDSO builds. (I'm used to x86 throwing all its flags away for its vDSO.)

How does 32-bit ARM do its vDSO?

My quick run-through on plugins:

arm_ssp_per_task_plugin.c
	32-bit ARM only (but likely needs disabling for 32-bit ARM vDSO?)

cyc_complexity_plugin.c
	compile-time reporting only

latent_entropy_plugin.c
	this shouldn't get triggered for the vDSO (no __latent_entropy
	nor __init attributes in vDSO), but perhaps explicitly disabling
	it would be a sensible thing to do, just for robustness?

randomize_layout_plugin.c
	this shouldn't get triggered (again, lacking attributes), but
	should likely be disabled too.

sancov_plugin.c
	This should be tracking the KCOV directly (see
	scripts/Makefile.kcov), which is already disabled here.

structleak_plugin.c
	This should be fine in the vDSO, but there's not security
	boundary here, so it wouldn't be important to KEEP it enabled.

-- 
Kees Cook
