Return-Path: <SRS0=glRK=32=lists.openwall.com=kernel-hardening-return-17723-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F518C35247
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 19:28:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92EFD21775
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 19:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rvfROt3n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92EFD21775
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17723-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29723 invoked by uid 550); 6 Feb 2020 19:28:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29703 invoked from network); 6 Feb 2020 19:28:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPzXTmDRqSItJwjA4stEZr45/Nmk9dtQCp0t0GcfvJw=;
        b=rvfROt3nBVHeNCQfPYWwuOMBfp5sQZIqkXiywCwoSlbuLD0R8zkM8I/44uAiL/SsWG
         m8pc4hnzhgAK7O7L9Mm0YtzToA4+uNCENjfatqKVEHKStfKAnwMD4IWW7jHLRQikdM9a
         QJsAft3GrJ6L4V0NEvCvWSIXW0n6YGuCLzvZUfoSNUXAozdf2Vmo01BVSUvel13iFfOV
         69wXY7b+REnUDlrLcBKbNwTH9NJhbfMsmO1PE3DYyzdQTiCvNH1RsZucMAwq8qvUXXW3
         LZDAShSyOYZQgIpYGlMYQAd/U72LOUhUYpHMb+S8g6auBLeO5B7nblSGM5a6u9TbkR7i
         jBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPzXTmDRqSItJwjA4stEZr45/Nmk9dtQCp0t0GcfvJw=;
        b=AQxt05arP5NuxCltifT0FxSmTJGyHC85PFXxyOfgFFd3iybqMHS2M+5ULoLNa/8Jar
         56Cws5BTqbjqpcRwy3feUZzaq9f1QYN6F8/icvLxzJ+hbjsS/Q221nsj7zn5kjaaaEnl
         3WqjWZ1gijqp9lVFDKqoBHpkyLpw21bGrs6cbPGpSKwgqSAjsEUxeZ47kRkK9cgh+OfO
         2wtbIejST1B0nBwdEJaXcbxr8nzPf9sx1sWzpv3rIvAN31oKYSE4qRIG0yRrkV05EAXl
         NvK/Bm354k5DisEwVeRKQk87U8VRFcd2N8mTZurzS97KjD81JAWX9G6ybQnWVs8pQ8rj
         8fBA==
X-Gm-Message-State: APjAAAWsOrrJaX52w6ABUgihxyZ60IPYc6dYqBU0YoOu58SJrPrCgmwa
	ju3Br48kpX5JRCW4BxAR6Vuo/Lz1fCb9/qicex5FZw==
X-Google-Smtp-Source: APXvYqwapGv/xZdFoWT4kXntbEcAkmogFT8Lk8w4susmDyaYarkU1eo5zWOTQAKb9bTDmLS5csh5ZQ5ckZLHFH+u4w8=
X-Received: by 2002:a05:6830:22cc:: with SMTP id q12mr32387120otc.110.1581017291747;
 Thu, 06 Feb 2020 11:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com> <202002060428.08B14F1@keescook>
 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
In-Reply-To: <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 6 Feb 2020 20:27:45 +0100
Message-ID: <CAG48ez2SucOZORUhHNxt-9juzqcWjTZRD9E_PhP51LpH1UqeLg@mail.gmail.com>
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, 
	Arjan van de Ven <arjan@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 6, 2020 at 6:51 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
> On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:
> > In the past, making kallsyms entirely unreadable seemed to break
> > weird
> > stuff in userspace. How about having an alternative view that just
> > contains a alphanumeric sort of the symbol names (and they will
> > continue
> > to have zeroed addresses for unprivileged users)?
> >
> > Or perhaps we wait to hear about this causing a problem, and deal
> > with
> > it then? :)
> >
>
> Yeah - I don't know what people want here. Clearly, we can't leave
> kallsyms the way it is. Removing it entirely is a pretty fast way to
> figure out how people use it though :).

FYI, a pretty decent way to see how people are using an API is
codesearch.debian.net, which searches through the source code of all
the packages debian ships:

https://codesearch.debian.net/search?q=%2Fproc%2Fkallsyms&literal=1
