Return-Path: <SRS0=nVoA=Y5=lists.openwall.com=kernel-hardening-return-17293-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AA9C5DF61
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 20:00:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 874DE21D7C
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 20:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IlrzHL7e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 874DE21D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17293-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27757 invoked by uid 550); 5 Nov 2019 20:00:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27737 invoked from network); 5 Nov 2019 20:00:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijT2GiWjIk0i5IPeCeqTo4IKLHUoxPnZNqQGZcLSsUM=;
        b=IlrzHL7ezty7NJqDoQVYCYZlgd5TLmozpoptOSResx7u8dduPfsVCwxetHhcwt9646
         G5tawFW78NnqVIQt8407pHG1e5zjGMrJqwSAl/oTDeue+ZI2bATAOFZnrvI5R4CrFfiJ
         n/6N9z9oo1SS6gVNC+qeZlwIfm5V4ROnhCdfuQ88aX5YBI34+oEw7Plr+gCPLfYF88Vv
         t5tkx9zp3H7o8W4fjZlCkI79/q3S/1dYYa3tpdlZAhUsRg24PXeyBp+HEkPn07uvN5Ub
         L9GkaFYee6+WNZPm2Nz3Y0BWrpxuapPuy18/e3w0kK2dmoGn0+nwp0yPpHzqG6gUGVPj
         itFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijT2GiWjIk0i5IPeCeqTo4IKLHUoxPnZNqQGZcLSsUM=;
        b=r6nm/5LcORFWmzqurvv3adUvnJaOfKB4UVxcJvaSBO8zZUXIfpWRCKIZf/mf/t4QZv
         rQyl9HxSN69cN+u1dI1kd+X3U2fr4GaDw/TwWy9KlYmYiMhwA5YY4jiBXD3xUixKE87m
         mXfd5qTpTN5ZwG7KS54RSdxzeF0+nx0p1R8nkRiaxnkdNIIfc6X0RHHCofaABwCAwE+G
         n5G6qSkFzEIloMUODlOzX1fVMYnXzU40Ty6hI2QolvAqVFDsAgeze9VdBGp8A8WsSRpp
         I3gliBlCnJEa43CraFOdnqD9BCBSH6eIz+ib7zPcmIeGS3SjOT+UbCsgL5B1orSUgRlU
         Z0IQ==
X-Gm-Message-State: APjAAAXoEAmemOKTQIIBdVSK3j01Ba0Y0Xc/jbeBSnBdm+WIhe9DUaEF
	6qakxp80TO9VHB/R3rnGOxEoaQ3KkBM0cqQlXKNSjQ==
X-Google-Smtp-Source: APXvYqyIFpCKniQqTsvrpnzyV0E86VzxTLXkPlxCMRfFt3g4qhjOa1M4benI/dNGWIb6R6YCFbVunWVoJWRhpBKoHRs=
X-Received: by 2002:a17:90a:178e:: with SMTP id q14mr1056137pja.134.1572984037414;
 Tue, 05 Nov 2019 12:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-12-samitolvanen@google.com>
 <20191104171132.GB2024@lakrids.cambridge.arm.com> <CABCJKufDnLjP9vA-wSW0gSY05Cbr=NOpJ-WCh-bdj2ZNq7VNXw@mail.gmail.com>
 <20191105091301.GB4743@lakrids.cambridge.arm.com>
In-Reply-To: <20191105091301.GB4743@lakrids.cambridge.arm.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 5 Nov 2019 12:00:25 -0800
Message-ID: <CAKwvOd=3mEUaxMX7Q6n3DAMAdge4eB=KYdiQxn2tY77taCD1NA@mail.gmail.com>
Subject: Re: [PATCH v4 11/17] arm64: disable function graph tracing with SCS
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 5, 2019 at 11:55 AM Mark Rutland <mark.rutland@arm.com> wrote:
> Similarly, if clang gained -fpatchable-funciton-etnry, we'd get that for
> free.

Filed: https://bugs.llvm.org/show_bug.cgi?id=43912
-- 
Thanks,
~Nick Desaulniers
