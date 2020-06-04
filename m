Return-Path: <SRS0=Z08e=7R=lists.openwall.com=kernel-hardening-return-18925-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747DFC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:58:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C5F5A207D0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uGZWLY/9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5F5A207D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18925-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17999 invoked by uid 550); 4 Jun 2020 13:58:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17979 invoked from network); 4 Jun 2020 13:58:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591279094;
	bh=NECwl9V9eUPjMiBKm4/NUElVNzAVswrtLb5Ash6AmNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uGZWLY/90X3PHBwBJBECC5AEfkkUvXvRftsarwbHRlL1ye5SM0NXKjjA7fXltKfGL
	 /httPXwbNmxOx61CMzCyRmmNhJ4+zpJaCMxhkZyxsAuEoa42eK0fxNKhxjslhbGNOe
	 FH0d0K3cWhCZARJdAG4cZYTOH1PPjLcVIF1yjwFA=
Date: Thu, 4 Jun 2020 14:58:06 +0100
From: Will Deacon <will@kernel.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
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
Message-ID: <20200604135806.GA3170@willie-the-truck>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-6-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-6-alex.popov@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Jun 04, 2020 at 04:49:57PM +0300, Alexander Popov wrote:
> Don't try instrumenting functions in arch/arm64/kernel/vdso/vgettimeofday.c.
> Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
> is disabled.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  arch/arm64/kernel/vdso/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> index 3862cad2410c..9b84cafbd2da 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -32,7 +32,8 @@ UBSAN_SANITIZE			:= n
>  OBJECT_FILES_NON_STANDARD	:= y
>  KCOV_INSTRUMENT			:= n
>  
> -CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> +CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables \
> +		$(DISABLE_STACKLEAK_PLUGIN)

I can pick this one up via arm64, thanks. Are there any other plugins we
should be wary of? It looks like x86 filters out $(GCC_PLUGINS_CFLAGS)
when building the vDSO.

Will
