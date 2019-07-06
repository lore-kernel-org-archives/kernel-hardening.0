Return-Path: <SRS0=PqXD=VD=lists.openwall.com=kernel-hardening-return-16372-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,GAPPY_SUBJECT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C57C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 18:33:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 075FD20838
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 18:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rMLJmYNu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 075FD20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16372-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32027 invoked by uid 550); 6 Jul 2019 18:33:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31986 invoked from network); 6 Jul 2019 18:33:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8R4z3fd/pNkVMb+89dxA4ui8k10ocj37Bt7whLaC1Q=;
        b=rMLJmYNuSevuKWuCiVdI43bNmxi2G3pHLMt7d6UgYRzPT5IXjgo/GT6keDasRoZK4g
         /OBhvjWjUYS2v0qo9lkIJjfjkWE4kQLRuB6HOjB54kxbMOj7Ibd3pgQiMMTDL/I/5iCg
         2BeOM0HRHns6OEvAIi7NDoj2y/dlF3VxnijP9I+3HzHbLr7M1LTr+5Cg10Syh3dz5oTS
         pBae4r8DF086crOJ38wMkDHMpLDL60ovH7rl6Se08aUjhSzMzcn0vQpNsNrr1cgMoU/P
         YlfFMVxPhwry/SRvgTR1K80hTe9zWiuHkC34F1tIefAjUxRB4y7wu0+32btM3e8V9hGs
         3xLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8R4z3fd/pNkVMb+89dxA4ui8k10ocj37Bt7whLaC1Q=;
        b=Y1AaeiDCry0uTvRx2BSW6BehN454kE20M98WzGyUujUDNew+HBkMh0kx+lkzREi1v/
         /1ixPZqihDOeYF4sJs/79SRJH+IZN/41ndsO02XaDphhxpuB0i3bV662Zb3NFBED439E
         orsR2EszICwbRm5DA36MKyhJUAgubV/lQ+zQ+QY5EVwqiwcIPVJrok+rqG3fYt6o/xAQ
         cbbydxQPRBRDW848ecjqSgQUIO9z4oNLEt3q+of0r2Acwqw3osTbdh/5Yn4y1Clvu12E
         PfUL7mJBtZXZ8NsK+KT9IUtj4WJKaRfWQGhKkULBqg2ANnbr9PKDn+zo0pV/oVnwfkoW
         888A==
X-Gm-Message-State: APjAAAUD+bhjOV9xIgjrX/TN5k5OKtjM5tmyyKWos7XoE9UvbKnUAcGS
	X7xoSsPtyfoVcz4/TOp6qq455JZ/9nSokzKotP0iyA==
X-Google-Smtp-Source: APXvYqyBcck06VlUCnJhTINmdA4ZJqB4oH2g6lhQMqchyhM/oF3KhFa6xeVxaox70u4OowtbK7dZn6ufESL4f0s1zvE=
X-Received: by 2002:a9d:774a:: with SMTP id t10mr7301075otl.228.1562437994877;
 Sat, 06 Jul 2019 11:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com> <1562410493-8661-5-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1562410493-8661-5-git-send-email-s.mesoraca16@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Sat, 6 Jul 2019 20:32:48 +0200
Message-ID: <CAG48ez35oJhey5WNzMQR14ko6RPJUJp+nCuAHVUJqX7EPPPokA@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] S.A.R.A.: generic DFA for string matching
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, 
	PaX Team <pageexec@freemail.hu>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jul 6, 2019 at 12:55 PM Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Creation of a generic Discrete Finite Automata implementation
> for string matching. The transition tables have to be produced
> in user-space.
> This allows us to possibly support advanced string matching
> patterns like regular expressions, but they need to be supported
> by user-space tools.

AppArmor already has a DFA implementation that takes a DFA machine
from userspace and runs it against file paths; see e.g.
aa_dfa_match(). Did you look into whether you could move their DFA to
some place like lib/ and reuse it instead of adding yet another
generic rule interface to the kernel?

[...]
> +++ b/security/sara/dfa.c
> @@ -0,0 +1,335 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * S.A.R.A. Linux Security Module
> + *
> + * Copyright (C) 2017 Salvatore Mesoraca <s.mesoraca16@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.

Throughout the series, you are adding files that both add an SPDX
identifier and have a description of the license in the comment block
at the top. The SPDX identifier already identifies the license.
