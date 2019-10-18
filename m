Return-Path: <SRS0=6C5L=YL=lists.openwall.com=kernel-hardening-return-17055-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F074CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:56:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 60AED222C5
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="olkgjhwO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60AED222C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17055-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19671 invoked by uid 550); 18 Oct 2019 17:56:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19653 invoked from network); 18 Oct 2019 17:56:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIsMVriT4AZEDHIxtRQpfA6TPy6WxstpPPQy/ZvUwbM=;
        b=olkgjhwOKrpksh8vSJf+BJb84VfRZZ5qdUP2pzmiiZqrTACZC/i9cIiYRJgmne3ziR
         ko66mflPJkhk5jRiXb4zXEhdS1luvFe71S6s42yUYccUIDR8gcNMfCwXyOIkQ0Gko0RV
         9DDeaxIiSdr21FNjzVaFcXZqf9tjWZCrcL3qRov3yEgYNBhQlxpD7Y0HCFIxH9vXebne
         d7Vy0l+kXyB43SqiIgm7oTgLYpW6N+mFXKF9Zj9op9b/+csye2MIB4a6S4IXkCsA5zcb
         Kzwwm71iR1gVBxrHRBPCIqcw4pJfaGoi5yVhy4PX7/KiLlr7HDA6C7r7OOtLcEsTVBPf
         YuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIsMVriT4AZEDHIxtRQpfA6TPy6WxstpPPQy/ZvUwbM=;
        b=T3a8b/9b8831t5MXDnBG7pnftL6iTmSO3Q6r0XASDHWKKiXpiIjWrIL5w2q6TfnOQF
         rlES3DrN4K2rQkZ9ZPQYgXPbEsmTby77ebcnxHQal9TNTH0yAOsxsg/GHGX+d8vAE4CI
         HvPx8xtffh1EuWbBcYVdFdVoXMjEec5ThEgZAlKM924v8Jm/JLE35f1HtgyysXDj4cjY
         yjy4XHiVeXhVB8nJWRcG19XMnBilktshC+OtGsi1pwarz1tqezI99zzaF3vDUUpiA/3b
         1s99qC8IO0f5mJWPwFCDJ1eMs/oftHwmh53GBColg6ZOfev6TDF8HhgV+A8CWorF/rUI
         5ULw==
X-Gm-Message-State: APjAAAU+Df3wM6Xq+168MGHzXZZg5ACjc3Jh9VL86ewMx378x5Oxkx7a
	RRQnV6RnTVMVh+JLm9COd+hDYm/SPU6Zs6jY1Ip+fA==
X-Google-Smtp-Source: APXvYqyC2iv6T46643JVohCL0ZO6S+yxoXkbTD3puL0IDt0JZj5qGElfVp/07Oy94Ct1iZ+6cOvAdXJjbpJUq0GhLYM=
X-Received: by 2002:a1f:b202:: with SMTP id b2mr6023283vkf.59.1571421375752;
 Fri, 18 Oct 2019 10:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <CAG48ez30P_Af-cTui2sv-YVUY5DdA1DXHdMmAW1+KpvjEPWUOA@mail.gmail.com>
In-Reply-To: <CAG48ez30P_Af-cTui2sv-YVUY5DdA1DXHdMmAW1+KpvjEPWUOA@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:56:04 -0700
Message-ID: <CABCJKuf7KsgkzqHGMAVjyS5Zo_ix8a2d6vsRT6OGSUgVLuJ70g@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:42 AM Jann Horn <jannh@google.com> wrote:
> (As I mentioned in the other thread, the security documentation there
> doesn't fit the kernel usecase.)

True. I'll add a note about it here too.

> Without CONFIG_SHADOW_CALL_STACK_VMAP, after 128 small stack frames,
> you overflow into random physmap memory even if the main stack is
> vmapped... I guess you can't get around that without making the SCS
> instrumentation more verbose. :/

That's correct. In our testing, 128 stack frames is nearly twice the
maximum amount that's been used (on an arm64 device), and for many use
cases, allocating a full page is simply too costly despite the
advantages.

> Could you maybe change things so that independent of whether you have
> vmapped SCS or slab-allocated SCS, the scs_corrupted() check looks at
> offset 1024-8 (where it currently is for the slab-allocated case)?
> That way, code won't suddenly stop working when you disable
> CONFIG_SHADOW_CALL_STACK_VMAP; and especially if you use
> CONFIG_SHADOW_CALL_STACK_VMAP for development and testing but disable
> it in production, that would be annoying.

Yes, that's a great idea. I'll change this in v2.

Sami
