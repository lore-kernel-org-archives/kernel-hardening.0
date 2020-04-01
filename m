Return-Path: <SRS0=ny3p=5R=lists.openwall.com=kernel-hardening-return-18364-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35171C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:56:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86898206D3
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JfE6FWMW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86898206D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18364-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25857 invoked by uid 550); 1 Apr 2020 23:56:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25837 invoked from network); 1 Apr 2020 23:56:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BfWZS5+9as5lD6vEMwl/6xxGz06a9gloYkQ+RKeiao=;
        b=JfE6FWMW0WrTIHwAtwqL3bo+qhTInr5LXI005KEawz6BRmX/rJrge8UmPsiMK5pPpc
         uTi9rFGFrfCf6pGgobgz2x2SN1yInjn8O4MwUNtnjY4Fxxg3pNbTXYvif4DrVZeLWFYk
         NwMooEZifjvk8bHNwWTVKU9ykqNbijKLOcb/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BfWZS5+9as5lD6vEMwl/6xxGz06a9gloYkQ+RKeiao=;
        b=BVpbgCdJbllnSY59Z25HuVi0hwF+hYuR6UKWO0hC2g9CXxa9idczIDwSba8LZjyHeA
         fBc+SnLezmiEhjwsX6boyacyE/MAGJze8pnCmdHbNKda0lnAYjNZhZgbOB5HfvVonDkg
         dmxt12Y5EEQxV4e67CUizmLrw3ycxKJP8bn+0hItdohx8kDE1ZApvoj54IepEemFY3vt
         LmZs9VY/U5AbSw3rJs7JHF0oLcXiOAw12CktsE409rPGCejH7eHxmctnLN1yVB+m6mMX
         5bS4otwF8TTXhQ9PDFP9YneKYfxgJwjcaYyoeKIYyhsrLoMCa7uFJpZktiY5SMZatvQT
         6kag==
X-Gm-Message-State: AGi0PuaF8EOT6EKEIJkjIvLKofjPNHUBm5i+tc8T+x5AghfUP9qESQGi
	yUgA0UnXNfT2LY+9u5Dgd0p7uz0VZRY=
X-Google-Smtp-Source: APiQypJi20g7wYESJp1kDEQeKKcBIbv8GQ7gDuC6sNUfWlOlDuoDzV6kANwvdp4EMT4wZp3pXXUUnw==
X-Received: by 2002:a2e:9718:: with SMTP id r24mr326765lji.287.1585785360505;
        Wed, 01 Apr 2020 16:56:00 -0700 (PDT)
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr371604ljm.201.1585785358260;
 Wed, 01 Apr 2020 16:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Apr 2020 16:55:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
Message-ID: <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To: Jann Horn <jannh@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, 
	Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Akira Yokosawa <akiyks@gmail.com>, 
	Daniel Lustig <dlustig@nvidia.com>, Adam Zabrocki <pi3@pi3.com.pl>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Oleg Nesterov <oleg@redhat.com>, 
	Andy Lutomirski <luto@amacapital.net>, Bernd Edlinger <bernd.edlinger@hotmail.de>, 
	Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 1, 2020 at 4:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It's literally testing a sequence counter for equality. If you get
> tearing in the high bits on the write (or the read), you'd still need
> to have the low bits turn around 4G times to get a matching value.

Put another way: first you'd have to work however many weeks to do 4
billion execve() calls, and then you need to hit basically a
single-instruction race to take advantage of it.

Good luck with that. If you have that kind of God-like capability,
whoever you're attacking stands no chance in the first place.

                  Linus
