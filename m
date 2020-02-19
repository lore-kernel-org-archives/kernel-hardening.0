Return-Path: <SRS0=b7SB=4H=lists.openwall.com=kernel-hardening-return-17847-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028ABC34056
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 18:01:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 51BB524656
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 18:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gh6t3G5B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51BB524656
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17847-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1259 invoked by uid 550); 19 Feb 2020 18:01:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1228 invoked from network); 19 Feb 2020 18:01:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lkHXwFRTyqTPxv+c/LKoXDAeY6A/OlAl/xcBXxo2cgo=;
        b=gh6t3G5BECE9aN/9A6d1bwWVVZBG4fe4Jv0G9F7ySydWI5loDBjyb6KyvSnHC3H2xb
         PiYI+vSfh6PGP3+tITPcVcHh8lERKC8od4oC2sH0ZseserCl8/SeCqlEtOKaPowUnmOE
         2eXS1KVuXlN0wfgWz9OeANM1/plXi4TktMssP2HUeiH/l+o/2AxWa3NY/kVCtRCjJr+f
         dMd7adB5l/qvK2DvV3IcWYmCoMHtH9Kl4DGNXpxeVnHW2OLrpEsXBoFzatmkLtQ0Da/S
         Do49a64NNoQSLpsZnbjyOORpErFk4A1akDXWP+T4B/uvtpfqQAguJp3M14618EN8fHqX
         JuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lkHXwFRTyqTPxv+c/LKoXDAeY6A/OlAl/xcBXxo2cgo=;
        b=FAY6I0RMBP4fid9y0Yss6E7YNhjOIPaqLqfGVpJVHBGaTH/2ZvJZmTPZiVFDK9QsBo
         RnKU3Ro47Xr/G8F7NHfDF7Q3BtsKgYlUx4C47zx2L5QGSqCIDh4zqAKaT6CfjEWxivD7
         gwjksIEkPdc0EWnnRdpIHG5E3m4XCJcx2qxn6/j5GegZYGHsJb7Wv/rajKX0wn57Jva3
         rxOiZqHSdnbYhDeBlysiHu9xvTJ0xAx1lGyRiS3gBNkp199JDoQbeV+IsD0eJ+0cF/I2
         j8BL2V1B7U+lcWzeDLHcaKdg+DnadPunQka6oSXFL7pgKiMNVlo+hBpyDQnOlxV7ZKAI
         SAeQ==
X-Gm-Message-State: APjAAAWK2j8ApSdgdQMAOmbkG+OJo+VrEtwGOBoph+iDBUuoFsPHW/3a
	s2ssVQLjAqYDarinN1VXFHX+FOY9CNPTWVptK5FUhQ==
X-Google-Smtp-Source: APXvYqw3wiSQDj5QZ98aok1Lw9PhoU8kfJwXxmz9XhbJ0dJG+YvWrUVCRlfmeIwD1SQGOVaP3AytmkpGm/U6NhVXLLw=
X-Received: by 2002:a05:6102:1c8:: with SMTP id s8mr6086880vsq.44.1582135285718;
 Wed, 19 Feb 2020 10:01:25 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com> <20200219000817.195049-5-samitolvanen@google.com>
 <20200219113351.GA14462@lakrids.cambridge.arm.com>
In-Reply-To: <20200219113351.GA14462@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 19 Feb 2020 10:01:14 -0800
Message-ID: <CABCJKufsYiBX6a0cmaX4D+3RDDKLLeRLAuTZgxO4=QryHYUptQ@mail.gmail.com>
Subject: Re: [PATCH v8 04/12] scs: disable when function graph tracing is enabled
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morse <james.morse@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 19, 2020 at 3:34 AM Mark Rutland <mark.rutland@arm.com> wrote:
> Fangrui Song has implemented `-fpatchable-function-entry` in LLVM (for
> 10.x onwards), so we can support this when DYNAMIC_FTRACE_WITH_REGS is
> selected.
>
> This can be:
>
>         depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
>
> ... and we can update the commit message to something like:
>
> | With SCS the return address is taken from the shadow stack and the
> | value in the frame record has no effect. The mcount based graph tracer
> | hooks returns by modifying frame records on the (regular) stack, and
> | thus is not compatible. The patchable-function-entry graph tracer
> | used for DYNAMIC_FTRACE_WITH_REGS modifies the LR before it is saved
> | to the shadow stack, and is compatible.
> |
> | Modifying the mcount based graph tracer to work with SCS would require
> | a mechanism to determine the corresponding slot on the shadow stack
> | (and to pass this through the ftrace infrastructure), and we expect
> | that everyone will eventually move to the patchable-function-entry
> | based graph tracer anyway, so for now let's disable SCS when the
> | mcount-based graph tracer is enabled.
> |
> | SCS and patchable-function-entry are both supported from LLVM 10.x.
>
> Assuming you're happy with that:
>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Great, thanks for pointing that out! This looks good to me, I'll use this in v9.

Sami
