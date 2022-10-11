Return-Path: <kernel-hardening-return-21576-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 937F5C433F5
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Oct 2022 20:04:28 +0000 (UTC)
Received: (qmail 7904 invoked by uid 550); 11 Oct 2022 20:04:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27985 invoked from network); 11 Oct 2022 19:52:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=36gaJztTD7Uu2ZW2RLea6uFAwy/jXLZpWVXv/XfktXk=;
        b=Ve10jUZNmwwesY9R1A80/NYL/FfWUbHXrhExvnW+e4bBQwh/VXhEWIe1rVNb6kNQO3
         Y/iGpkcCDUQ8Og6r7kTfPmy6pZJ3ULV64SzUSXsx4Q8999N2aHcnT4uQBYzkc6h6fGts
         e4mBsOK2LLjfX0V2jrrbWTg9tC7QjMGhYNZKDkHM5miX0X58+GsqJ9JM9uX9awi3EcLm
         lGQznNB81V81YvWMN57F+vd9TdBlGsfBaNxfVM7Iy9sLBx9iNeFGZiM0SvUqgUoEXtA2
         EwmqjC7HhRnwu9LAokQjlwG2d2GGNgzyKstUmJvRwdkxSo45WwMNuq/ymIgk2iWnxvho
         8CfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36gaJztTD7Uu2ZW2RLea6uFAwy/jXLZpWVXv/XfktXk=;
        b=q3qQPwGHa2QbZfXyO+KxR1/9On0oJuWBljfOlhIjfHO5TKXO9wRRR7mV0Q5mNhYQ7T
         y3mzuC/S/w0Cfogwn34No7eKtW3xSCPWSVUumjpbjq26E4k7PP7DPQ/eYgBKfbZX+hWm
         z5G2lQnCrQgHTBdw7j8I6AkM5pRWxY81hCHKwCcYRL3u4ZqbgO/OqHbapkM5eWHqmzqq
         bDC9da6Z7wJYW4DUqE5jDnubgQd0pgBB64BwopUV+/gY+ambG16jNC3YNUEy0G1+Ega8
         8TBk+HpIXjQMNYpkyvyKWOzUOEkfHKmq9wvc7EuH7v5lnG6pqk/EusIyOv7an430ZDE2
         dmJQ==
X-Gm-Message-State: ACrzQf3q8y2KVhiDyJQsUzIFAyUgy1ZxlxR3OJEggWUSetzFiZgBg+iA
	uFVbDU4bRK9YhT+XxD8n1fA=
X-Google-Smtp-Source: AMsMyM6b/qVJbOYPS7tg5QgUOOoQo3VomJKaOtMazJqomEAVjhKZDan2ROXerFPGVONXDjOPaInHsQ==
X-Received: by 2002:a17:902:e547:b0:178:2aee:ab1d with SMTP id n7-20020a170902e54700b001782aeeab1dmr25332814plf.29.1665517972888;
        Tue, 11 Oct 2022 12:52:52 -0700 (PDT)
Date: Wed, 12 Oct 2022 08:52:47 +1300
From: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
	cgel.zte@gmail.com
Subject: Re: [Self-introduction] - Paulo Almeida
Message-ID: <Y0XJjxP/BzoqZ+ts@mail.google.com>
References: <Y0JrBsGthQIiSzp+@mail.google.com>
 <202210101536.A46A0690@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210101536.A46A0690@keescook>

On Mon, Oct 10, 2022 at 04:22:48PM -0700, Kees Cook wrote:
> On Sun, Oct 09, 2022 at 07:32:38PM +1300, Paulo Miguel Almeida wrote:
> > My name is Paulo Almeida and as per the instructions listed on the KSPP
> > page, this is my self-introduction email :)
> 
> Hello! Welcome to the circus. :)
> 
Thanks =)

> >   writing a MOS 6502 emulator for the same reason.
> 
> Heh, nice. That made me wonder if there was a QEmu port, but it seems
> it hasn't been touched in a decade?
> https://github.com/AVEx-6502/qemu-6502
> 
> Is there a particular 6502 system you're working to emulate?
> 
Yes, there is. I am trying to emulate Ricoh 2A03 (RP2A03). That's the
slightly modified 6502 CPU used in the NES system. It's a really
well-documented platform so I chose that one to dip my toes in writing
virtualisation-related software.

> > I took the Linux Kernel Internals (LF420) and the Linux Kernel Debugging
> > and Security (LF44) courses by the Linux Foundation.
> 
> Cool -- did anything stand out for you in those courses?
> 
I'm easily amused by debugging/instrumentation techniques and the
kernel has so many of them for various specific niches.

What really stood out at the time was learning how versatile ftrace can
be to the point that this "debugging/tracing" utility is one of the main
gears of kernel live patching. Initially it felt wrong but after
wrapping my head around it, that was a very creative solution.

> > As for other experiences, due to the fact that I wrote my hobbyist OS, I
> > do have a decent experience with the x86/x86-64 architecture. I also
> > spent quite sometime writing static analysis parsers.... so should those
> > experiences help anyone or any possible future plan for the KSPP, please
> > count on me.
> 
> Great! One area that needs some review and testing that is x86-specific
> is the userspace CET support[3]. That spans a wide range of from chipset
> all the way up through compiler, kernel, and glibc. Getting more people
> to try that series out and post results ("it works for me" or "I
> couldn't trigger the protection", etc) would be very welcome.
> 
That sounds like it's my cup of tea :) I just finished reading the Intel
CET paper, it's an interesting approach with lots of things to be
tested. Thanks for the recommendation, I will get involved with that. 

> You've already found the "remove the 1-element arrays" work, and there
> are plenty more like that on the issue tracker. Trying to really put an
> end to strlcpy[4] is ongoing[5] too, as there has been a fairly
> concerted effort to remove them lately:
> 
> Count of "git grep strlcpy | wc -l" over recent releases:
> 
>          v5.17:  1535
>          v5.18:  1525
>          v5.19:  1507
>           v6.0:  1379
>         master:   544
>  next-20221010:   401
> 
Fingers crossed! I saw many patches for the strlcpy replacement so you
seem to be well covered for that... I will continue with the one-element
array changes and try to get involved with the support for Intel CET =)

Thanks for all the suggestions Kees!

Paulo A.
