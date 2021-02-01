Return-Path: <SRS0=fP/D=HD=lists.openwall.com=kernel-hardening-return-20713-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7D7C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:30:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E3FEC64EA0
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3FEC64EA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20713-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9330 invoked by uid 550); 1 Feb 2021 18:30:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9298 invoked from network); 1 Feb 2021 18:30:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1612204196;
	bh=FipONDQzL82MzeHTs/g79CTahBPGOxpEHTPTJ0lePDc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HF5crvQOCYinS+g2qYz1n3FPqCP4s0WXG5bCzGQ5NIpFnDjDFT9wf3VfmedKU09dm
	 N6UTwD3wGk/V2fxdrdTTUHMPpTblp9jMXon6pDt0tYMAiLEDTHno//bYY2s8JTyWYw
	 PfbrzFlWWDWgqEuF4A5d3Qa/AXAWUMxdYhcA2lKqw9KacCRL7Yrbr23zZN3IrUHqZ6
	 iLK3m1WD9fkk1T3g+QTtH46wQ36MMebmDR+2xtO9CqqMeGFMMROSoAkzlfoAQli0Se
	 CfAfDnCEvAk0hLNBG/lDb7FIx85lEe9R/VNDMJDPKcpD2nVsQzY7km4rs53VBuc0xL
	 Xf33um5WqOsUQ==
X-Gm-Message-State: AOAM532Ku6KV7qfV/8MgVhf9HjpZ4ltZowGPYNRmRkWKblWFROlQn7Qc
	aojmumCsYT61SZKc5i63uaRYZno+HseWNC9FT17vtQ==
X-Google-Smtp-Source: ABdhPJw6dOEhiDFQAUIeq5FJYdEMHcfVEg53N7ay6QjEuCeH9MAxxhgO+nJtKNrTdXQpFRzl1I/ycbrY7LopiZrzeFE=
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr19862404edc.97.1612204194301;
 Mon, 01 Feb 2021 10:29:54 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
In-Reply-To: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 1 Feb 2021 10:29:42 -0800
X-Gmail-Original-Message-ID: <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
Message-ID: <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
Subject: Re: forkat(int pidfd), execveat(int pidfd), other awful things?
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, 
	Christian Brauner <christian.brauner@canonical.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 1, 2021 at 9:47 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Andy & others,
>
> I was reversing some NT stuff recently and marveling over how wild and
> crazy things are over in Windows-land. A few things related to process
> creation caught my interest:
>
> - It's possible to create a new process with an *arbitrary parent
> process*, which means it'll then inherit various things like handles
> and security attributes and tokens from that new parent process.
>
> - It's possible to create a new process with the memory space handle
> of a different process. Consider this on Linux, and you have some
> abomination like `forkat(int pidfd)`.

My general thought is that this is an excellent idea, but maybe not
quite in this form.  I do rather like a lot about the NT design,
although I have to say that their actual taste in the structures
passed into APIs is baroque at best.

If we're going to do this, though, can we stay away from fork and and
exec entirely?  Fork is cute but inefficient, and exec is the source
of neverending complexity and bugs in the kernel.  But I also think
that whole project can be decoupled into two almost-orthogonal pieces:

1. Inserting new processes into unusual places in the process tree.
The only part of setuid that really needs kernel help to replace is
for the daemon to be able to make its newly-spawned child be a child
of the process that called out to the daemon. Christian's pidfd
proposal could help here, and there could be a new API that is only a
minor tweak to existing fork/exec to fork-and-reparent.

2. A sane process creation API.  It would be delightful to be able to
create a fully-specified process without forking.  This might end up
being a fairly complicated project, though -- there are a lot of
inherited process properties to be enumerated.

(Bonus #3): binfmts are a pretty big attack surface.  Having a way to
handle all the binfmt magic in userspace might be a nice extension to
#2.

--Andy
