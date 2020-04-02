Return-Path: <SRS0=ntng=5S=lists.openwall.com=kernel-hardening-return-18366-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C4BC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 02:06:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7817A2072E
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 02:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEz92/cj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7817A2072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18366-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5704 invoked by uid 550); 2 Apr 2020 02:06:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5683 invoked from network); 2 Apr 2020 02:06:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQMUHcx5ZJebHuFeNsiV5oTqPrmJdOW/j745+2PrxT0=;
        b=FEz92/cjgu/KjeUfKUAamLHbiMYZP/JE8iQyr8PNIMC5adYQCca21soCJysmTW8le/
         u+EmuDxNfwEIB6iFxacesqUbrDJuUXTQH1CifqeNvpd7zFcILB7eKw8/Qk1LJLcobXrc
         6HoPfDxgcA61kzOR0e4ZTAsOnzIaIrzLDUVEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQMUHcx5ZJebHuFeNsiV5oTqPrmJdOW/j745+2PrxT0=;
        b=WQowKhFzN4RJL92SrgT7Es7Nn59RdQ9H/UIYGa+E8U/UXxFGwpoka2p3XDPWj5XiBT
         /DwXoiLgBxkpsGchZGSfPO/E1x0sRSKyOyOMYbT8m/x2VZ7DwPNaFMJ2N4dodZNivDsk
         lINrLncTZ282FHNP8e0Z6wFBlmFWD0dxbB//kI5oEZfD2F8sLPbsXwLiFffyIUmT0oV8
         6YKkJEPiVLBvNgsobOip0eB9t1VSkQ4Equ+f6GUoaSpW1USaWcCLwIlxmr6EDmP7oM5H
         KiFgk5E27fUylUXD5oUiVtJ+P8pA1SKfyP1fN+TC+vSoS8Ya6SNLEC8cli9OUSrIOml5
         CpWA==
X-Gm-Message-State: AGi0Pub7OtVeZeCoQytz9IWYiViJsz8gD+O4KfSSBEZ6ZjgUq/yUZ3aq
	VGxOUQwnRDw6DYVSQXqLwz0+9W9xmcI=
X-Google-Smtp-Source: APiQypLuJzXALIoKw/Y13zWVlk8oZuUrIGt7exXdVoGLI+M2nt5e+dvE5Imaa3ckKwZUoqqfWhxSow==
X-Received: by 2002:a2e:9789:: with SMTP id y9mr534831lji.207.1585793176843;
        Wed, 01 Apr 2020 19:06:16 -0700 (PDT)
X-Received: by 2002:a19:7f96:: with SMTP id a144mr643180lfd.31.1585793175190;
 Wed, 01 Apr 2020 19:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
 <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com> <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
In-Reply-To: <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Apr 2020 19:05:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
Message-ID: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
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
	stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 1, 2020 at 6:36 PM Jann Horn <jannh@google.com> wrote:
>
> Since the read is already protected by the tasklist_lock, an
> alternative might be to let the execve path also take that lock to
> protect the sequence number update,

No.

tasklist_lock is aboue the hottest lock there is in all of the kernel.

We're not doing stupid things for theoretical issues.

Stop this crazy argument.

A comment - sure. 64-bit atomics or very expensive locks? Not a chance.

                   Linus
