Return-Path: <SRS0=DY1+=44=lists.openwall.com=kernel-hardening-return-18126-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132D9C2BAEE
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 19:45:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C87A20691
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 19:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="QxSjkDa8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C87A20691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18126-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12249 invoked by uid 550); 11 Mar 2020 19:44:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12217 invoked from network); 11 Mar 2020 19:44:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1583955884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qhR6fZY9T1iS1MlozbrwkvsgypJ7t9l1Cqgx8z0l+kI=;
	b=QxSjkDa88cjKLLavCeDIljf3TJTfbpfbXYijlZarldmJUMiZo8E2ovyQL0oOO0w3QRL619
	4rZ5pA3j48Xqft54Rhc+/eNztqXUw93f+Y+SKPGkqGvHi+1vFhT1fIuqAugLvom2WqzvWf
	4p1J9rX8TTK11yvJ3fSlQV0Cex0eCWA=
Date: Wed, 11 Mar 2020 20:44:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>, Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] x86/elf: Add table to document READ_IMPLIES_EXEC
Message-ID: <20200311194446.GL3470@zn.tnic>
References: <20200225051307.6401-1-keescook@chromium.org>
 <20200225051307.6401-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200225051307.6401-2-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ozenn Mon, Feb 24, 2020 at 09:13:02PM -0800, Kees Cook wrote:
> Add a table to document the current behavior of READ_IMPLIES_EXEC in
> preparation for changing the behavior.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  arch/x86/include/asm/elf.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index 69c0f892e310..733f69c2b053 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -281,6 +281,25 @@ extern u32 elf_hwcap2;
>  /*
>   * An executable for which elf_read_implies_exec() returns TRUE will
>   * have the READ_IMPLIES_EXEC personality flag set automatically.
> + *
> + * The decision process for determining the results are:
> + *
> + *              CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
> + * ELF:              |            |                  |                |
> + * -------------------------------|------------------|----------------|
> + * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
> + * GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
> + * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |

In all those tables, you wanna do:

s/GNU_STACK/PT_GNU_STACK/g

so that it is clear what this define is.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
