Return-Path: <SRS0=ugoG=Y6=lists.openwall.com=kernel-hardening-return-17315-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16D6C5DF62
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 04:46:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13F562087E
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Nov 2019 04:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGaoiWuH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13F562087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17315-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9530 invoked by uid 550); 6 Nov 2019 04:46:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9510 invoked from network); 6 Nov 2019 04:46:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJMPHhKHFX8udqWNx4esBxs7+6CjmiT3KwNBEYCiDu4=;
        b=AGaoiWuH4Fsah/5Mrnysi1CUGLJA95+VACk5fohzuSyNRGRqjFWx/bzNkkjPzfXmn4
         Y56Mfrcr6KlRajYlG8J7KWJAzdar9H1F0kQSjY+NkGPXkylSOBzxNGc8EYAurRfcmB6W
         43XMW6wWO+KuWZ1x2OgcbRKsHTZipTg9iq1cqcSeYN66xeR7uy8Njsi51KVfJz+5ptjW
         6D0z5JCz3b+KpM0c+b+GyEa3DW++SaLoFMLmFNX+jRCwBR7lqHsH0/t1F5oUENfxCUfW
         SzqAF/JT6aUsvr6p7H9ff6QpT6lsCCcdg5dNgHRCLTaRIyLqKDptL5tfjfXLbtrBDfPD
         2HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJMPHhKHFX8udqWNx4esBxs7+6CjmiT3KwNBEYCiDu4=;
        b=GXasL1heZwvhJOHeN3ymZ2kg3z/6bostGACSOyNIqB2TNBa2pO75MJo61POPK53Kfs
         0+udkglJumVeJiuxqfAKoMyAPBbb5kx/8otgkV2fKEufeJzNaid9cM4EN/GfHMx84nyO
         xnZa1CUR1yqK0QAtACm9xridRkdc7BBaf+bOrAbYceWtaYqAWwodbo/LxepjnLUPQqAD
         wHZCyGVuef8hrfSZCIU8qkUe3G2SxErE93ke7drqalNOoP3MCNpfhOSatwa8QzkNLsr8
         oNcXcgBymAe3rew4h7yLGayhE2oIw+w5/Q/Ll8s5njm9XRDrSLha0BoxAlcBCr8FsGMO
         GDDg==
X-Gm-Message-State: APjAAAWM5d9xw9Wqt6xBonOhMs80Sg7soUs1ErdJZtsBy1b4unhw09v+
	Rdl72lH4tkDAIPLDiKbnk9gNxY5WCuSU8Uc4wDo=
X-Google-Smtp-Source: APXvYqzoj6tUsrC/BVFopD/SaOTrIMULCeKMkv2c1g5ElpPga9joMdtHCw+m/HoGVDnKOKrvi8XqjS+oHuccO/VR5HI=
X-Received: by 2002:a2e:2419:: with SMTP id k25mr252654ljk.59.1573015560588;
 Tue, 05 Nov 2019 20:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com> <20191105235608.107702-12-samitolvanen@google.com>
In-Reply-To: <20191105235608.107702-12-samitolvanen@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 6 Nov 2019 05:45:49 +0100
Message-ID: <CANiq72mZC-G_R_RJjapZS+NvkQcrjdiri0NyHUgesFzUpe-MDg@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] arm64: efi: restore x18 if it was corrupted
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 6, 2019 at 12:56 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> If we detect a corrupted x18 and SCS is enabled, restore the register
> before jumping back to instrumented code. This is safe, because the
> wrapper is called with preemption disabled and a separate shadow stack
> is used for interrupt handling.

In case you do v6: I think putting the explanation about why this is
safe in the existing comment would be best given it is justifying a
subtlety of the code rather than the change itself. Ard?

Cheers,
Miguel
