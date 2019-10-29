Return-Path: <SRS0=S1ih=YW=lists.openwall.com=kernel-hardening-return-17149-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265BECA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 17:45:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 737F020856
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 17:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rPGbbUqA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 737F020856
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17149-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14177 invoked by uid 550); 29 Oct 2019 17:45:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14159 invoked from network); 29 Oct 2019 17:45:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65YP9F0KitFD9legdxyLM59RAjKBzdRGrjI3L/m7ObE=;
        b=rPGbbUqAwVHq7Cm0rGfrw8aZKG5VrL44JQ4WF1AX8zOdwQI8rkKHDe3Opfeq0pYbYi
         ZvPBEVky5mJq0A1utYxoVfchIrzcrJxh4cYKqeEyKqh3F5ZpGjwR7FuS+45Wd+YvZTAR
         FCYHhGld6MAkj8PSSTu0jSSloZk6eBz34o6f90VAXFRXs/86osn7qCWlcHM8wNytg3QS
         uJNMarnDvny6K3ClI88qEsq5+XwNmoTiSipJzzK0eD0W9Nwi+d6vcizeA7IRNM1KW01T
         8D5hlGzbW/5Mpci+BoZWh8xm7HIZT8sr5w3L36adlm6C6pBdnby12ApWTEuM8rl7eyke
         UlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65YP9F0KitFD9legdxyLM59RAjKBzdRGrjI3L/m7ObE=;
        b=dcp1k0U0kqS9l5/rp2KWh94EEmwNJPdwDNdplsUn8ecY6a+sUO81oSpPCW3qqZBXUJ
         JmYGXEOj94hgSNzcU8XVYBwQeU+OMp7/bB3+5NLFJ7ynOl6M+DkBwdSjh6VZoeZ05Rpf
         M0Lurv2dc8Z3D/PkoziZapGaPlzFN6rgTbPOPpv1lxwobEKofDHbbrI1PXebJmxhE/gv
         Oznm/DVQJaJbu4GEvjxDqhJld9ddPfUaw37c2tMpkDfnAknGIUjNQScwzNrMG38MOzpT
         VtNtIHeUEFpvsafbugiGSMoGGNYwobCm+w6iX9coR5a/+CvoN26SbmLzJQDC13HFLWV1
         2lnw==
X-Gm-Message-State: APjAAAVDI6iSB4IX2Jv+vKQs3EhaaQP5l+dVK30gTTtLhY9zgV6xbggY
	IhTqBywrmFX72MCSRlIeGUPbEWU3jKCbeZgZcwdnMQ==
X-Google-Smtp-Source: APXvYqyofjlHaKbwoCfizqOngvFU3/FN2jdIJr9xQCjuFQ8iVqA3V1NcHewQYwziFUY5XcE5H3ggNp7mqR1GIqnLUe8=
X-Received: by 2002:a1f:7d88:: with SMTP id y130mr12501967vkc.71.1572371133208;
 Tue, 29 Oct 2019 10:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com> <20191024225132.13410-10-samitolvanen@google.com>
 <20191025110313.GE40270@lakrids.cambridge.arm.com>
In-Reply-To: <20191025110313.GE40270@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 29 Oct 2019 10:45:22 -0700
Message-ID: <CABCJKud1xYEx_GVgfBHUuwNGKMxX+uVaE5TR6DEqo7CoSJJnNA@mail.gmail.com>
Subject: Re: [PATCH v2 09/17] arm64: disable function graph tracing with SCS
To: Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 25, 2019 at 4:03 AM Mark Rutland <mark.rutland@arm.com> wrote:
> I'm guessing it's difficult to always figure out the SCS slot for an
> instrumented callsite unless we pass this explicitly from the ftrace
> entry code, so we'd probably have to change some common infrastructure
> for that.
>
> We have a similar issue with pointer authentication, and we're solving
> that with -fpatchable-function-entry, which allows us to hook the
> callsite before it does anything with the return address. IIUC we could
> use the same mechanism here (and avoid introducing a third).
>
> Are there plans to implement -fpatchable-function-entry on the clang
> side?

I'm not sure if there are plans at the moment, but if this feature is
needed for PAC, adding it to clang shouldn't be a problem. Nick, did
you have any thoughts on this?

Sami
