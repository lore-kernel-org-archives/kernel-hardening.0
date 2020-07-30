Return-Path: <SRS0=GS97=BJ=lists.openwall.com=kernel-hardening-return-19498-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70E8C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:42:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13B12206F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/akzAAc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13B12206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19498-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16012 invoked by uid 550); 30 Jul 2020 16:42:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15972 invoked from network); 30 Jul 2020 16:42:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uOgsUbAvtb07X2t6oCOXPaH/oAL+aoYjRmE457oKQVE=;
        b=F/akzAAcghFkbb5rg2I+dUhbCLh5STTtsK7MimVF+Ch5DDzPABUu5CF+W+vBRvRLgS
         ePuaSTbpwmciMZQHJEU47jnoOqSdnhckGm4nG13TjSQSQjX0gY0WbwBWahgzeVMpj/IM
         b0eabTrV3OuLVQ/76ZO1iZziutwAD9nfjMcMldjskzEHHzFiVgTj1JGpoevduOyAc5JB
         s9COTq/fxE+6qX0URVjIKtPxK+4JiFAGf5uCYqW8cFD/oi0MCSAC77+Kz7D4av0mRq1R
         NjsxdcZHq3+X0fOJebWbt6A/XJZjnsbGjQ24sx5XtlhOAo0L5E3/MGOYiA2xOMKua07A
         C9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uOgsUbAvtb07X2t6oCOXPaH/oAL+aoYjRmE457oKQVE=;
        b=ZnEP6NwqQB1eLJPIr4WlUYA4zOupwUgTTA2To4LEvqAbtRhWgmeuKNh0Pk+yBhFdVh
         TthKP87AEOFLHtuO0u+3DKQBQ721BXGbb1VY9wGeXTk1iklCl1BV8CBWpT0OgAV/Zqqb
         P2F6HqYR/iOtPhaNZ/CLadsI6S7ECAmCZ9pJQLIYsOztkZZcnwD8vmZvuQtqnqyI5ziP
         tKf/n1fZlnYIjjoBSqfD0C3KRuEB0gAN9L4lDKOfyu0f0dhthqpvz4p0Z0UKyCEtqdLI
         +T7C6EtZJCFAicaFUoCFGaHCXy7WHOKHPMmwDwK2tuFl22FQO8NkFYRH+UPxppdilKeM
         PiQg==
X-Gm-Message-State: AOAM533mitOf7wUkhhCP8cqrzId/gZywCWTvT+WJSyfyWqDmcQfisy7D
	UCmTDz1NYf88lHT4GEC3V6IejAOgXib6Zwl5yux+Ug==
X-Google-Smtp-Source: ABdhPJwqLir8etUYa8a7uyi48sMcY0xMDD9OCpUUEIzG6Kyrg5O2YRcXX3ofIoRkrkqEUCyjzA8TyGUPErzO0SL5fIc=
X-Received: by 2002:a2e:9251:: with SMTP id v17mr66150ljg.138.1596127327122;
 Thu, 30 Jul 2020 09:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <87k0ylgff0.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87k0ylgff0.fsf@oldenburg2.str.redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 30 Jul 2020 18:41:40 +0200
Message-ID: <CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
Subject: Re: Alternative CET ABI
To: Florian Weimer <fweimer@redhat.com>
Cc: oss-security@lists.openwall.com, x86-64-abi@googlegroups.com, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 30, 2020 at 6:02 PM Florian Weimer <fweimer@redhat.com> wrote:
> Functions no longer start with the ENDBR64 prefix.  Instead, the link
> editor produces a PLT entry with an ENDBR64 prefix if it detects any
> address-significant relocation for it.  The PLT entry performs a NOTRACK
> jump to the target address.  This assumes that the target address is
> subject to RELRO, of course, so that redirection is not possible.
> Without address-significant relocations, the link editor produces a PLT
> entry without the ENDBR64 prefix (but still with the NOTRACK jump), or
> perhaps no PLT entry at all.

How would this interact with function pointer comparisons? As in, if
library A exports a function func1 without referencing it, and
libraries B and C both take references to func1, would they end up
with different function pointers (pointing to their respective PLT
entries)? Would this mean that the behavior of a program that compares
function pointers obtained through different shared libraries might
change?

I guess you could maybe canonicalize function pointers somehow, but
that'd probably at least break dlclose(), right?
