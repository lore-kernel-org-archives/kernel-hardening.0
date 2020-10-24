Return-Path: <SRS0=bKel=D7=lists.openwall.com=kernel-hardening-return-20262-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B2CC2D0A3
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 14:13:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1C8D220FC3
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 14:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzmyyaMK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C8D220FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20262-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3886 invoked by uid 550); 24 Oct 2020 14:12:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3842 invoked from network); 24 Oct 2020 14:12:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgJfeca/4s0satLk61+xOaVoEfLF7ds/Hi2JJEDziWU=;
        b=IzmyyaMKU2FOSHtQEv29DmMZ//m10onETt/WtXiLJiW/9Niiew7CKHOfdD0QD+iq0r
         g8ZU06WwFvjWtyJQhXFsnF/6x0Gm/ir3FAprI+07pbGtdb+FeM7MmjKdUOrn/ta+hCNz
         bELE3uPLlHqPSdnAfUdnmX6qg+RIoMep0UXSZZxA8ysv+nAeLrtlgclER3WEPFILvFpK
         nAvM6vXz4BVY0iErk77oeVia6Uo8SaaH0O7ljraTkjq0j/LMPpiKgvtBDxCYJ2xBOvsr
         lta/5kNNzxFL4BTXBv86WYLJt6KSo/Rki35Gkyce0gLg8q7gCcWN/7Xk8s9pROJmjw0C
         j2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgJfeca/4s0satLk61+xOaVoEfLF7ds/Hi2JJEDziWU=;
        b=jY/fzhZrfTyCvI8bY0U+cEC44rTyH+CQN9H6MIi7D68PVN9WPBUAIU+ENlmB8glEkQ
         tLk0gkTgsqMnVXVA9NkF7ZYokJDMgQtysnzttAK93ZnB0PneBheGUbWNFZj7u8Q8SWX1
         3604LSs//EhX9ZTeSyIl7qFHmeQgjecR+vCH1skBCeF17Px+hCTdbTp4NSXw3T3o+i5R
         ZVvt62XQ/xNM35pUOL+E1/9gi+SdfT5AQiHaWXAZTmbxkiVXmin5wiI225xtmHyqXyR0
         J4gZD8slP2qFk9pPQYUPgL0lg9bh2UXZY8E8TPoEdrim2txpUNS7Hx8Mnjye1FHRDX7w
         pg6A==
X-Gm-Message-State: AOAM530y3UH7UzI1PPzjO9u5Har10KfWJRWPqkDOaHv1FORaa2Vw+1SE
	6JEWe1yCUbCmcSHZVd1JYbvmQQYfrk1xGGAfZC0=
X-Google-Smtp-Source: ABdhPJxALtvx3WMpnAnGGl1WqPBhdzP0ukYGoUEMsX7+QBgav0+412nekJGtwDyIlYZt5kvFXudvUAnQw7PTyzqFPh4=
X-Received: by 2002:a05:6e02:d01:: with SMTP id g1mr4895628ilj.246.1603548767191;
 Sat, 24 Oct 2020 07:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com> <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com> <202010221256.A4F95FD11@keescook>
 <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com> <CAJHCu1Jrtx=OVEiTVwPJg7CxRkV83tS=HsYeLoAGRf_tgYq_iQ@mail.gmail.com>
 <3cb894d4-049f-aa25-4450-d1df36a1b92e@gmail.com>
In-Reply-To: <3cb894d4-049f-aa25-4450-d1df36a1b92e@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sat, 24 Oct 2020 15:12:36 +0100
Message-ID: <CAJHCu1JskXZTvSsspQD-wk4L59FxesvVJdjMSX=jiHg-R2zCuQ@mail.gmail.com>
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, 
	Jeremy Linton <jeremy.linton@arm.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, libc-alpha@sourceware.org, 
	systemd-devel@lists.freedesktop.org, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>, 
	Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <will.deacon@arm.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Oct 2020 at 12:34, Topi Miettinen <toiwoton@gmail.com> wrote:
>
> On 23.10.2020 20.52, Salvatore Mesoraca wrote:
> > Hi,
> >
> > On Thu, 22 Oct 2020 at 23:24, Topi Miettinen <toiwoton@gmail.com> wrote:
> >> SARA looks interesting. What is missing is a prctl() to enable all W^X
> >> protections irrevocably for the current process, then systemd could
> >> enable it for services with MemoryDenyWriteExecute=yes.
> >
> > SARA actually has a procattr[0] interface to do just that.
> > There is also a library[1] to help using it.
>
> That means that /proc has to be available and writable at that point, so
> setting up procattrs has to be done before mount namespaces are set up.
> In general, it would be nice for sandboxing facilities in kernel if
> there would be a way to start enforcing restrictions only at next
> execve(), like setexeccon() for SELinux and aa_change_onexec() for
> AppArmor. Otherwise the exact order of setting up various sandboxing
> options can be very tricky to arrange correctly, since each option may
> have a subtle effect to the sandboxing features enabled later. In case
> of SARA, the operations done between shuffling the mount namespace and
> before execve() shouldn't be affected so it isn't important. Even if it
> did (a new sandboxing feature in the future would need trampolines or
> JIT code generation), maybe the procattr file could be opened early but
> it could be written closer to execve().

A new "apply on exec" procattr file seems reasonable and relatively easy to add.
As Kees pointed out, the main obstacle here is the fact that SARA is
not upstream :(

Salvatore
