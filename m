Return-Path: <SRS0=kHvQ=7R=lists.openwall.com=kernel-hardening-return-18931-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D732C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 15:06:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8D598206DC
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 15:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tiAiD1Bq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D598206DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18931-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9419 invoked by uid 550); 4 Jun 2020 15:06:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9399 invoked from network); 4 Jun 2020 15:06:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+rSrnYLVqsdod0ox2SKtnqs+7zx/Hz4GLO8xy+04nE=;
        b=tiAiD1BqLUtW8rAX1B3Txst9ck1bpANIDb6532CrOzxa8+SYqcQVzMWUIrIqHwfkFH
         PHnApukstTsgqnDgvZmZZF7f0AkvM5cutsl0XcGi2Pbymm48rAjoDeqUP0rQJufNbjNV
         U1DTwg8QQcTfmMvRFRaIc/PUvQCShSldTL5qsURtgnTw2mS3pb1YcCtRkFDi9qkdBmbs
         +w3hI2IMbAuFHS2rWaC6Am5XmtU2osSFlJTcvkeFDjXW3t+Mc804R2xEZJmK3Bg3lazk
         j1hTv/fbOlKG+IG25Puo8o29RBHnfgg8yktHPNROZW7UkPsslMdeaXUYMod2IAvkYUMH
         NIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+rSrnYLVqsdod0ox2SKtnqs+7zx/Hz4GLO8xy+04nE=;
        b=XLr6CIAH8BWT54HG2SFkDvt8bZ5T/0rCcX/3jqTSqlJv0VWDRz9C2hHIssY30R5Zpn
         uxaQzR7ufE5/yaO96WW5X6EjCsrTtUtXsk/VQQn7yqm59FQH9oTjsHYTqjNXVUlGaeEh
         xIGANlNB6nNEsOSEHIf8CUes04atH7omORwxbNHjiMJA3LmXKMxNHO5dNXIrB5KGesXD
         KZPD22DaNjmpspSMcTPaf0Ee0Lff7i0NOnBY9TsOl6phBD9VsG3PWunnlmdV9tLSznW9
         WTJxYQYRmlT5eFw/5WlySs1qKJP2xuzsKASUk8txop3NukfP9Ax2+cx7QqTQ8H/JELgY
         cCRg==
X-Gm-Message-State: AOAM532iyFrMpbeJoO97CqJguYE/zVFKvTBCMshHM4mrrUcOpVLJEFtd
	GPytYLmvIwWfDdQclCIPi+utsL7YC4AxZO6vj+0=
X-Google-Smtp-Source: ABdhPJym59bLbz+stiI4tSpXC23vh9zz45NG9ccDG3uOprvfDj3mzLXeDS2rNjrYy3cjr00XLkkVPcKs0ltgUoq5nkI=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr2534360ljo.29.1591283157446;
 Thu, 04 Jun 2020 08:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200604134957.505389-1-alex.popov@linux.com> <20200604134957.505389-3-alex.popov@linux.com>
In-Reply-To: <20200604134957.505389-3-alex.popov@linux.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Jun 2020 17:05:46 +0200
Message-ID: <CANiq72nfByD5sO0a2G2hKCPtHgOhdYfFaXcK7pHnxXRGRUUjDQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] gcc-plugins/stackleak: Use asm instrumentation to
 avoid useless register saving
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Thiago Jung Bauermann <bauerman@linux.ibm.com>, Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>, 
	Sven Schnelle <svens@stackframe.org>, Iurii Zaikin <yzaikin@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Collingbourne <pcc@google.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Alexander Monakov <amonakov@ispras.ru>, Mathias Krause <minipli@googlemail.com>, 
	PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, 
	Laura Abbott <labbott@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Alexander,

On Thu, Jun 4, 2020 at 3:50 PM Alexander Popov <alex.popov@linux.com> wrote:
>
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index cdf016596659..522d57ae8532 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -41,6 +41,7 @@
>  # define __GCC4_has_attribute___nonstring__           0
>  # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
>  # define __GCC4_has_attribute___fallthrough__         0
> +# define __GCC4_has_attribute___no_caller_saved_registers__ 0
>  #endif

Nit: if you do another version, please move it before `noclone` to
keep the order (`fallthrough` was added in the wrong place).

Otherwise don't worry, I will sort it together with `fallthrough` when
I send a patch.

> +/*
> + * Optional: only supported since gcc >= 7
> + *
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/x86-Function-Attributes.html#index-no_005fcaller_005fsaved_005fregisters-function-attribute_002c-x86
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#no-caller-saved-registers
> + */
> +#if __has_attribute(__no_caller_saved_registers__)
> +# define __no_caller_saved_registers   __attribute__((__no_caller_saved_registers__))
> +#else
> +# define __no_caller_saved_registers
> +#endif

Ditto.

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
