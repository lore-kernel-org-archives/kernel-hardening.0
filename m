Return-Path: <SRS0=EWDU=X4=lists.openwall.com=kernel-hardening-return-16986-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B401C10F14
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 16:57:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A67F720673
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 16:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnAk8RZN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A67F720673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16986-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28650 invoked by uid 550); 3 Oct 2019 16:57:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26162 invoked from network); 3 Oct 2019 16:49:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fyk6Ys3oz+9CQQEy0sneBZ6KwRTXnrJ5/9JzvxiZ0FE=;
        b=LnAk8RZN/ujoUkUfGdZjCF9+54wlgRxU5zE+WsPBQcTus1dE6CMGBhCFb9/FL3SFub
         QgQU9amRIBsrOUYTcV78mQXXOAK/MvoSFykGEp0MrcO1WavdtY9/R9JvIE9//vBDegFQ
         uStWboDVvX3df9gJo1+qP2jdxbfynNfzoOX8OHt1a7g81VuQ7fgqa982QyRnMDqola9X
         fpxIhoCWURa2EbI8o1jajJM/ud8nSaqxoNSHCo2bDnZWRx+jhkk7ozuuR4NbHOMFsbgF
         A1t/HuSInAXNyAdYmplhzn43kMdnvwhKlPpMZq/W8lRLQmXO0ToaTHvGhVvK7ljVbaPW
         xV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fyk6Ys3oz+9CQQEy0sneBZ6KwRTXnrJ5/9JzvxiZ0FE=;
        b=rsy8O2wxT+nsJXhFxzjVA+fL94JfbKGx5B0Yd4cj9So3/bEJmVqY8yEwFdfZ784IBE
         wSNbfKSj43NrE78eSEtTf9UUujHmSjUTkB97SHOBs8IepJQurQpG7YrXzqIMcCBLSeSj
         q3MXheNDXNFyMwRl20RLxgaeBs6cEgPUC64enzCOTa7A2Eb3GppYZx8ik7254Hj8cgQG
         Ogg1tjH8A5NdQJ/P8l1n8udJb5BRkurXxQl7+hK0Ui3+aCk/90QxufhcBUiY+BmNTECm
         uIcPm6Bukrto7Fu8V9HCqps+bDJAlFEp9/LZBUl17qNtdez/I5LBzwjsSKO3TS95cSQs
         rUrQ==
X-Gm-Message-State: APjAAAWE9WcRLOpx83WEuxt13k7wQjmzDC7rgtZ0XudGWpzcpJHcHkzD
	nfB076eEdNRDD0zHVag4AsXHFu09f4pYUOwmEhA=
X-Google-Smtp-Source: APXvYqyUC3oTfQFJ2aj/p7KM+vrTJi1K79HN3/HJ1VlEgrrmvXde0NEQFGzOKrPkDE5DDbjB81g8kHosRm9d2NoUsUw=
X-Received: by 2002:aca:5697:: with SMTP id k145mr3321729oib.101.1570121340354;
 Thu, 03 Oct 2019 09:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook>
In-Reply-To: <201909301645.5FA44A4@keescook>
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Thu, 3 Oct 2019 22:18:48 +0530
Message-ID: <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 1, 2019 at 5:21 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Sep 26, 2019 at 01:47:00AM +0530, Muni Sekhar wrote:
> > I looked at the available tests with "cat
> > /sys/kernel/debug/provoke-crash/DIRECT", from this I=E2=80=99d like to =
know
> > which test causes system hang? I could not find any test case for
> > deadlock, is any reason for this?
>
> The various *LOCKUP tests will hang a CPU or task (though SPINLOCKUP
> needs to be called twice). You could keep calling HARDLOCKUP until
> you're out of CPUs, for example. :)
>
> What kind of deadlock do you want to test?
I'm looking for a test where crash dump fails.

>
> > I=E2=80=99m having a Linux system, I=E2=80=99m seeing it gets hung duri=
ng certain
> > tests. When it hung, it does not even respond for SYSRQ button, only
> > way to recover is power-button-only.  Does no response for SYSRQ
> > button means kernel crashed?
>
> That's an impressive hang! :(
>
> > After reboot I looked at the kern.log and most of the times it has
> > =E2=80=9C^@^@^@^ ...=E2=80=9C line just before reboot. Can someone clar=
ify me what the
> > kernel log entry =E2=80=9C^@^@^@^ ...=E2=80=9C means? I suspect kernel =
is crashed, but
> > it does give any crashdump in kern.log.
>
> That's a zero byte. I would suggest using something like pstore to
> capture this in RAM instead of hoping it makes it to disk.
>
> > Later I enabled the kernel crash dump(sudo apt install
> > linux-crashdump) and rerun the test but still nothing copied to the
> > disk(/var/crash/). I don=E2=80=99t have onboard serial port in my machi=
ne, so
> > I tried get the crash dump via netconsole, but this method also does
> > not able to catch the crash dump.
> >
> > Can someone help me how to debug in this scenario?
> >
> > And I'd like to know what other options available to get the crash
> > dump? Can someone please clarify me on this?
> >
> > Also , does the crash dump fails if incase deadlock occurs?
> >
> > Any help will be greatly appreciated.
>
> If you really need to hard-power your system to get it back, pstore may
> only work if you're really quick and likely enable software ECC.
Thanks a lot for letting me know about pstore, will try this option.
It will be helpful if you can share some pointers on 'how to enable
software ECC'?
>
> --
> Kees Cook



--=20
Thanks,
Sekhar
