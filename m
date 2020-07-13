Return-Path: <SRS0=FYAG=AY=lists.openwall.com=kernel-hardening-return-19296-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C87C433EA
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 16:16:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E6E382076D
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 16:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WugZOMCG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6E382076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19296-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3561 invoked by uid 550); 13 Jul 2020 16:16:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3526 invoked from network); 13 Jul 2020 16:16:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=arF9/WfQf8O+zXfqHDfW3zJEksp4/JkE/sE/kjxelos=;
        b=WugZOMCGJNyDO4AC1fQGNcOaQsax8CTDyR8XhxeG+tOVefm2zk+cgTFBIoAq/+ta86
         qRsy0MrhimuoKxetVSVQn7T9y1yZEKkbw3obFXNqPV0WN0VnHQBh6D+EkyYRoAN9DqxH
         o4lnXvQOCDDHBhShHkSbeY4nmrVmPma6zA6+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=arF9/WfQf8O+zXfqHDfW3zJEksp4/JkE/sE/kjxelos=;
        b=ENQAJDbvNkBqgQmCqBttgNZfEn98DKKgWw2Q3dY8s6xAo6zPUMMOSsmPeBnT9Z55gG
         vUC6S+Q6g2N+6VTBsDgCswYs+1cUtq13sSHEzzWyTakXexbmd564uVxNxEkEoXJHxGcA
         xmEUmbNoCTaY6KhR2gtTt58IQ9HDWxbgsWuJFsDoosWgAzvCrHRqENGgdywCxNyyfme9
         WI5BVIt+1z7mnehUiPwjp+KNO2yJQ+dvkOSZRlrCrzj/a66Ye6iG5HDHiuWYfCnSRiZQ
         NLVF43887Nt7kI5YLb4TMzsi0trdO/W6rG/QVi8ii5AcPSaidQLVwPcaN4JSMEO2t7Wz
         lywg==
X-Gm-Message-State: AOAM531eh9NE1U0SxjKcR3M+gD8tEBuiFAPuBYjEZFiseRKFTpqskp6x
	qd1pCed5DQ6ncVAK4Qamxq8Lcg==
X-Google-Smtp-Source: ABdhPJweB6DZUW5dbFNYa7U3T0bZFjMrr/pVD3pZPVbMUNxcNYaWR9I89+g+l/lFeQChgOBoFu76fA==
X-Received: by 2002:a63:ab0d:: with SMTP id p13mr68725214pgf.327.1594656975178;
        Mon, 13 Jul 2020 09:16:15 -0700 (PDT)
Date: Mon, 13 Jul 2020 09:16:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Allen <allen.lkml@gmail.com>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Clarification about the series to modernize the tasklet api
Message-ID: <202007130914.E9157B3@keescook>
References: <20200711174239.GA3199@ubuntu>
 <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>

On Mon, Jul 13, 2020 at 02:55:22PM +0530, Allen wrote:
> Oscar,
> >
> > I'm working to modernize the tasklet api but I don't understand the reply
> > to the patch 12/16 [1] of the patch series of Romain Perier [2].
> 
>  Am working on the same too. I did try reaching out to Romain but not luck.
> Let's hope we are not duplicating efforts.
> 
> > If this patch is combined with the first one, and the function prototypes
> > are not changed accordingly and these functions don't use the from_tasklet()
> > helper, all the users that use the DECLARE_TASKLET macro don't pass the
> > correct argument to the .data field.
> >
> >  #define DECLARE_TASKLET(name, func, data) \
> > -struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
> > +struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
> >
> 
>  Ideally this above bit should have been part of the first patch.

Right, the idea was to have a single patch that contained all the
infrastructure changes to support the conversion patches.

-- 
Kees Cook
