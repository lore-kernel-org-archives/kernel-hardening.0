Return-Path: <SRS0=6t9f=4H=lists.openwall.com=kernel-hardening-return-17843-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E06C34022
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 07:50:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 83CDE2176D
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 07:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDMncoWz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83CDE2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17843-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9527 invoked by uid 550); 19 Feb 2020 07:50:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9506 invoked from network); 19 Feb 2020 07:50:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582098621;
	bh=n9/IYLfWjgkCKFVGCPxr4KX26RCkPAV8w7mDru6LtEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vDMncoWz6cyx/LEWprHHL1KKF8u2M0zVhoV3U7QW96vnLDpV9SpUz/C8WhZ/F6KQ9
	 YncQJYbHErBSsNhGEwfBpLM0CHztjSaRJpeHZxAq+YnK2huwndGdG3vj4fJlNo7pip
	 GuGWPMKe8h+xvf5GvRLEulvNK6ibg/YYZE7740ro=
Date: Wed, 19 Feb 2020 07:50:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel
 <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
 james.morse@arm.com, Dave Martin <Dave.Martin@arm.com>, Kees Cook
 <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Miguel
 Ojeda <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 09/12] arm64: disable SCS for hypervisor code
Message-ID: <20200219075017.41e17f08@why>
In-Reply-To: <20200219000817.195049-10-samitolvanen@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20200219000817.195049-1-samitolvanen@google.com>
	<20200219000817.195049-10-samitolvanen@google.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: samitolvanen@google.com, will@kernel.org, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, james.morse@arm.com, Dave.Martin@arm.com, keescook@chromium.org, labbott@redhat.com, ndesaulniers@google.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 18 Feb 2020 16:08:14 -0800
Sami Tolvanen <samitolvanen@google.com> wrote:

> Disable SCS for code that runs at a different exception level by
> adding __noscs to __hyp_text.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Acked-by: Marc Zyngier <maz@kernel.org>

	M.
-- 
Jazz is not dead. It just smells funny...
