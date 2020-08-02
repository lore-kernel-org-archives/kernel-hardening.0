Return-Path: <SRS0=RkMi=BM=lists.openwall.com=kernel-hardening-return-19514-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F77AC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Aug 2020 20:01:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B527020722
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Aug 2020 20:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFOS7lJY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B527020722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19514-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27900 invoked by uid 550); 2 Aug 2020 20:01:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27877 invoked from network); 2 Aug 2020 20:01:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596398466;
	bh=dArsY75FWjtt7As5xgbBwC+egu06UpMYVG1i87QOXX4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lFOS7lJYqGZDUwyxfvUbEw3DcXArYKRSiYijAubBtPRJsaSTkU+wCq03sdFRLVP4y
	 AxSKRyRIeluQfLLcwq6rbGsNh5LQAyLHEcwqj39yOsWbZUGcPQzjGSJYbrAmCsU3Z1
	 2xtGHK38WBWYXZvVcRrlBcdTDy5mCbY9rXYSK5Qc=
X-Gm-Message-State: AOAM531HiV5UKuAysNXnI6GCf9KM0KQbIzIYIcTv2fpf3xTHG+70vtIV
	6AyBYWztPL/RCKS6SQCqyvTbjn3GuEl2DbfWER3ViA==
X-Google-Smtp-Source: ABdhPJzzn0TKME2O/OiT/zeV9TBqi5bQ33rtcB/MxXB3Iouj0pekgUtP+crNwDATDo4OGLVWkntyqQrZSKf4qTC10bw=
X-Received: by 2002:adf:fa85:: with SMTP id h5mr12474521wrr.18.1596398464878;
 Sun, 02 Aug 2020 13:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com> <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
In-Reply-To: <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 2 Aug 2020 13:00:53 -0700
X-Gmail-Original-Message-ID: <CALCETrUJ2hBmJujyCtEqx4=pknRvjvi1-Gj9wfRcMMzejjKQsQ@mail.gmail.com>
Message-ID: <CALCETrUJ2hBmJujyCtEqx4=pknRvjvi1-Gj9wfRcMMzejjKQsQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux API <linux-api@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 2, 2020 at 11:54 AM Madhavan T. Venkataraman
<madvenka@linux.microsoft.com> wrote:
>
> More responses inline..
>
> On 7/28/20 12:31 PM, Andy Lutomirski wrote:
> >> On Jul 28, 2020, at 6:11 AM, madvenka@linux.microsoft.com wrote:
> >>
> >> =EF=BB=BFFrom: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.co=
m>
> >>
> >
> > 2. Use existing kernel functionality.  Raise a signal, modify the
> > state, and return from the signal.  This is very flexible and may not
> > be all that much slower than trampfd.
>
> Let me understand this. You are saying that the trampoline code
> would raise a signal and, in the signal handler, set up the context
> so that when the signal handler returns, we end up in the target
> function with the context correctly set up. And, this trampoline code
> can be generated statically at build time so that there are no
> security issues using it.
>
> Have I understood your suggestion correctly?

yes.

>
> So, my argument would be that this would always incur the overhead
> of a trip to the kernel. I think twice the overhead if I am not mistaken.
> With trampfd, we can have the kernel generate the code so that there
> is no performance penalty at all.

I feel like trampfd is too poorly defined at this point to evaluate.
There are three general things it could do.  It could generate actual
code that varies by instance.  It could have static code that does not
vary.  And it could actually involve a kernel entry.

If it involves a kernel entry, then it's slow.  Maybe this is okay for
some use cases.

If it involves only static code, I see no good reason that it should
be in the kernel.

If it involves dynamic code, then I think it needs a clearly defined
use case that actually requires dynamic code.

> Also, signals are asynchronous. So, they are vulnerable to race condition=
s.
> To prevent other signals from coming in while handling the raised signal,
> we would need to block and unblock signals. This will cause more
> overhead.

If you're worried about raise() racing against signals from out of
thread, you have bigger problems to deal with.
