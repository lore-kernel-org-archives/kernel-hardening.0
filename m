Return-Path: <SRS0=DF7D=YW=lists.openwall.com=kernel-hardening-return-17154-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645D3CA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:31:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A709220659
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eeDi1R76"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A709220659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17154-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9660 invoked by uid 550); 29 Oct 2019 21:31:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9639 invoked from network); 29 Oct 2019 21:31:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sG8ktVp69lBLldtD8XFYhZW6X0Mbz+fRfKIpBc3S1fE=;
        b=eeDi1R76xYCKBaFKAK/zVVjADW1kTa1srCPF0WcJM7yU0DkoXkUiJwryjC6xTYGZyo
         d0DNATnv8FA08H765+CI9jRvNYj3EkL7mDP3t8zyAFX536x5LRun/hUVHf0fYxeFR1Fz
         mtwefrj5sIbiglak1f5PhwDJFrPwYzq6Seu7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sG8ktVp69lBLldtD8XFYhZW6X0Mbz+fRfKIpBc3S1fE=;
        b=cQjWaMKxC7GphjHMeAUNleeGZgXL8rq2qEuLbF3klQEGqD1Cf1DbBEblHt19QFLdfT
         5cw9hGmME4WZTqRhA0VS+vvjqL6dzmTdedC1m/YK8YQxJVRqknOVx811uW9qO0babXcs
         XaOCnrThqdXW32j0y6eM/wuHcgEsSBUGw34mUihwh+FoS4J+ePZ/MwJNDp+aGuKvLXDP
         6XYIxQZzV2Ysr3hlfAp0U881Bmt1yvYGQA7YA1CVKtqHlLnKrzy4k668WKR4ALUGD2wr
         LAvmqb7bRHKRT/yfggp5iWTT9IG4bwZgM4E+aLc4dEh83iInpf5KU5VvVSsaUXHQK2Yz
         1tDQ==
X-Gm-Message-State: APjAAAUA3EfqLUhbm7rLiRG1jvHYFhagjISV0AMsxPygSKdlRvOF/ybg
	b/uiXoWCH14PlZQoC+n9zMplFxOjnJA=
X-Google-Smtp-Source: APXvYqwn3oMdw/J3J6w1Bso2qQAsbhGdmowOnulZXL4GZN2lxxztuokB/gTD9R3D7YN/HBxIS08BTA==
X-Received: by 2002:a50:eb92:: with SMTP id y18mr26854824edr.244.1572384688985;
        Tue, 29 Oct 2019 14:31:28 -0700 (PDT)
X-Received: by 2002:a1c:a9cf:: with SMTP id s198mr5907919wme.5.1572384687151;
 Tue, 29 Oct 2019 14:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-12-thgarnie@chromium.org> <20190812135701.GH23772@zn.tnic>
In-Reply-To: <20190812135701.GH23772@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Tue, 29 Oct 2019 14:31:15 -0700
X-Gmail-Original-Message-ID: <CAJcbSZGVAG_ODm+R9ukSOSfmhyHn1wbUtdnD_AtEVMaM3GgS+w@mail.gmail.com>
Message-ID: <CAJcbSZGVAG_ODm+R9ukSOSfmhyHn1wbUtdnD_AtEVMaM3GgS+w@mail.gmail.com>
Subject: Re: [PATCH v9 11/11] x86/alternatives: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 12, 2019 at 6:56 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Jul 30, 2019 at 12:12:55PM -0700, Thomas Garnier wrote:
> > Change the assembly options to work with pointers instead of integers.
>
> This commit message is too vague. A before/after example would make it a
> lot more clear why the change is needed.

Sorry for the late reply, busy couple months.

I will try to do my best to explain it better in next iteration.

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
