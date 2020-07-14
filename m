Return-Path: <SRS0=TUHF=AZ=lists.openwall.com=kernel-hardening-return-19300-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB239C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 05:09:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1FB3F217D9
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 05:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IW4ENinm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FB3F217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19300-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5403 invoked by uid 550); 14 Jul 2020 05:09:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5369 invoked from network); 14 Jul 2020 05:09:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tW3rcyFEuvP1y8EIRX6D7Qxty6AXhBVTfG91+hsBtfM=;
        b=IW4ENinmxNSZOuNmqmcdy+Wv/p0i+NStRxFEX2dAxw8Ql9hlROpGyUdW6ha59Zfzcf
         voGEk4XmqSinwsPeCTIuKY7U5Q1BautvGMAELiWvww8f5f2l33dwEkc0OEUUbLpoqVaW
         Kvrk8f3mpFK1F6QMsajcQyfx6kWsDCg2K/M+n6+k3AR0/ymsDJfCSIihWjJQLGkAucR/
         FLezGx/TceErDlK9/iVcXjaCRnqgu0cIEyR4tmYkVBtICPigDQRhcjDhcOWsYFmjOUQl
         07N2JESJ6I6qQxCL2DKkm2pD/Ym1RCqUVHM/aW6lrASWevohNpGGa4qIVm3VjcUvuvzS
         2XrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tW3rcyFEuvP1y8EIRX6D7Qxty6AXhBVTfG91+hsBtfM=;
        b=myC944nTEUCI2x7cRt15joSKeTh2fuJsrGKx3YPwEtwBvveazOM3V9FV0+IpQXcp53
         vT167p/B18lbZ1RrjsXUyCSAmsHCSxatxR6D6LCTDHUAR5Zq33+nawFJtnFBK9upZqwz
         IL7lFaAv/EhQ6Z8cB8qbtUBZDPpPE4MiwqJbBWgJZIFvRXcDG0GIfVsR3YTPQc0+f1f4
         WtL/urXoZTlrJx2yvsux5Uj/NAiWQRdffFuA+grpU7kEqxlaDMAIm5EXRO2i+7ds0bdf
         TbmcXVvpkPhqzqKKquY2YLjXUNa+22qKnANySsA2uwzZCHBOyA+pCKfwH2JQ8f0HZMsz
         OF0w==
X-Gm-Message-State: AOAM53151KkLgfrdgKRaP3nk4HMByPz2QE0RIk170IjTtgtnaiczxkGL
	MOT2RYBvhHq3eF9ci7ajne6B9Bzsht5zkJVO520=
X-Google-Smtp-Source: ABdhPJyPk649iruq5Opdbrvbe+59X3p9QBHlcaT0frltYNbxHhR3dLTnimRtbmxk/Fu5DKfPBy0v4EgAtpH+bdgwdk4=
X-Received: by 2002:a9d:65c2:: with SMTP id z2mr2635042oth.264.1594703374445;
 Mon, 13 Jul 2020 22:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu> <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
 <CAOMdWSJSXj4uC_=WRkqDoare-s1rcOtp=xJ7idCDAxhnTHacVw@mail.gmail.com> <202007130916.CD26577@keescook>
In-Reply-To: <202007130916.CD26577@keescook>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 Jul 2020 10:39:23 +0530
Message-ID: <CAOMdWSLMfeoUV4+LyTG2=EZvru5STb2ruNB=yF+ZOjYrvWnC0g@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

>
> Thanks for the update! I wonder if there is a way to collaborate better
> on this, so we're not all waiting on each other? (i.e. Romain got busy,
> Allen picked up the work, then Allen got busy, then Oscar picked up the
> work, then Allen returned, etc...)
>
> Perhaps split up testing? I'll like you and Oscar work it out. :)

 Yes, this has been a bit of a problem. But this time, I will ensure to get
this all upstreamed.

> > What I have done so far is to keep patches close to the original
> > series, but with changes
> > from the feedback received to those patches.
> >
> > Patches 1-10 have been retained as is, except for DECLARE_TASKLET which has been
> > moved to patch 1 from patch 12 in the series.
>
> I think the "prepare" patches should be collapsed into the "convert"
> patches (i.e. let's just touch a given driver once with a single patch).

 Yes, that is WIP.

>
> Yup -- it's that first patch that needs to land in a release so the rest can start
> landing too. (Timing here is the awkward part: the infrastructure change
> needs to be in -rc1 or -rc2 so the next development cycle can use it
> (i.e. subsystem maintainers effectively fork after the merge window is
> over). We can play other tricks (common merged branch) but I don't think
> that's needed here.
>

My Plan is to get it all ready by the end of 5.8 so that we are ready
for 5.9 merge.

Thoughts?

-- 
       - Allen
