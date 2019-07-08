Return-Path: <SRS0=WB88=VF=lists.openwall.com=kernel-hardening-return-16383-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,GAPPY_SUBJECT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F170C606C5
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:38:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E417620644
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTS27VBG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E417620644
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16383-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15448 invoked by uid 550); 8 Jul 2019 17:38:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15415 invoked from network); 8 Jul 2019 17:38:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7dDlUWXE3BDiYJAkGp7CGjzY68vf5TiBs2gkLxCROPg=;
        b=oTS27VBGAXTGyWJrG+1bRf5KktV5vuIvxa8IWh1u4JAjBQEhi23d4SyczOUH26kY2R
         y//ajtI2TI29q75dcyp4FSN6kHo6UyR1wPu6Y62WtELMtJtY2Xkr824CBphlKwNvrFuO
         ieIrosIuDlKuPw3h2M3licdQ3No/OcsZmxHFpt3c0Kc+o5hSNDIzOkDfH9Z91ZQWyD9C
         grhZTvCUxZJhweX5ja9rWveALtoabLG30fihRzI/xTkp6fk/mdSPQab2R5qH1XoaWpiD
         o9GNdIcFxNYegyyTxVLrvQTgO8RvIuuA7e/Fsm1h2c1BcSOCqsarhQ/oMOQ4o/vR2/An
         BE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7dDlUWXE3BDiYJAkGp7CGjzY68vf5TiBs2gkLxCROPg=;
        b=DY1WUELyye7JQ0dkJIJoSvHaEecrGyJ5QUwV/zvJz9Nqi5WnuKsh8Vse6JEuoMcThm
         TCuCHR9iTE56HDswdflHtxhSs8iVVmgkwLZQSTaEXUkA/FAOdMb2tS3gcAuTAeAyGIT8
         rykzMCiQyJgpDgLwreylL135hRGGA8hwYySaKu4bOs5Vgh6fhjxlDxuIkDGcOzyTilCD
         8//KAl6n7N9F4QTT91ftyaHpL/1glktP3uoB0EqHvCdVjT3bVgb1g9PZNNqn5K7d1KUV
         JfdpBf6RutC28gifleP8BPPRKSGEdJPFgpsI96dRIK2ES6MVwO5kctBsseYWWd8qMlvP
         U70g==
X-Gm-Message-State: APjAAAWWA3Uo8vNYRWxp00OwxeEX9iq0ZNSLPr+uqPuP07Csm7WtntMq
	5WM90bVjHjwadj3tKKw6Hq/d9NhzC1xNnZG1BMwaRg==
X-Google-Smtp-Source: APXvYqxWC2WzfHpl8ZigyXVHyyT6QtrbedYXY8/NrWJL/zNHr0x2cmYj/XsDrwdBKxwSxPY6OsYxHdMmiMEzeBNat6Y=
X-Received: by 2002:aca:b06:: with SMTP id 6mr10585303oil.175.1562607480451;
 Mon, 08 Jul 2019 10:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-5-git-send-email-s.mesoraca16@gmail.com> <CAG48ez35oJhey5WNzMQR14ko6RPJUJp+nCuAHVUJqX7EPPPokA@mail.gmail.com>
 <CAJHCu1+35GhGJY8jDMPEU8meYhJTVgvzY5sJgVCuLrxCoGgHEg@mail.gmail.com>
In-Reply-To: <CAJHCu1+35GhGJY8jDMPEU8meYhJTVgvzY5sJgVCuLrxCoGgHEg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 8 Jul 2019 19:37:33 +0200
Message-ID: <CAG48ez2f1TbUZt_0F99DLyzn-3DhjuoTJZ7Dwxgmto7J9ZQ95g@mail.gmail.com>
Subject: Re: [PATCH v5 04/12] S.A.R.A.: generic DFA for string matching
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>, 
	John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Jul 7, 2019 at 6:01 PM Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Jann Horn <jannh@google.com> wrote:
> > Throughout the series, you are adding files that both add an SPDX
> > identifier and have a description of the license in the comment block
> > at the top. The SPDX identifier already identifies the license.
>
> I added the license description because I thought it was required anyway.
> IANAL, if you tell me that SPDX it's enough I'll remove the description.

IANAL too, but Documentation/process/license-rules.rst says:

====
The common way of expressing the license of a source file is to add the
matching boilerplate text into the top comment of the file.  Due to
formatting, typos etc. these "boilerplates" are hard to validate for
tools which are used in the context of license compliance.

An alternative to boilerplate text is the use of Software Package Data
Exchange (SPDX) license identifiers in each source file.  SPDX license
identifiers are machine parsable and precise shorthands for the license
under which the content of the file is contributed.  SPDX license
identifiers are managed by the SPDX Workgroup at the Linux Foundation and
have been agreed on by partners throughout the industry, tool vendors, and
legal teams.  For further information see https://spdx.org/

The Linux kernel requires the precise SPDX identifier in all source files.
The valid identifiers used in the kernel are explained in the section
`License identifiers`_ and have been retrieved from the official SPDX
license list at https://spdx.org/licenses/ along with the license texts.
====

and there have been lots of conversion patches to replace license
boilerplate headers with SPDX identifiers, see e.g. all the "treewide:
Replace GPLv2 boilerplate/reference with SPDX" patches.
