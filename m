Return-Path: <kernel-hardening-return-21575-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 47EECC433FE
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Oct 2022 23:23:15 +0000 (UTC)
Received: (qmail 1524 invoked by uid 550); 10 Oct 2022 23:22:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1487 invoked from network); 10 Oct 2022 23:22:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QF7MJOsOtlsQC0EmDUWgyeJyWHdhi+4+5WgA2w3JC3g=;
        b=BkShfqF8SyhtiqZT6gE3y8zPoxJMuIQH4Onh7QKoPkYRNvKmcggwoJaeo/uV3YctSC
         wtbL9DvhBagPC2lx2jXewV6r0qCXPwsLj3TgJKvqISfzlnBLfhGIlFZ9UGxKHKFzorrm
         Zr43goG23541zjyV+AcKGtPLj/KIvCcNlePAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QF7MJOsOtlsQC0EmDUWgyeJyWHdhi+4+5WgA2w3JC3g=;
        b=ElCP5xrXETcFqb3P1tjHRB+lPX8C77mNcFaXQb3UyEsEWX2Wtc2BV6WByOTUI3ZUzp
         XL1u4inQEOcmU04ApC6FonW86zmTxKqF+M7W007I90V+qBcYrXysqWXrkzrl0OpKDXaN
         K8Kw1QO59jL9UBtFzKlzhYojWS9DGPJJrKpbVTSTZUzezTDDWVlUeD6QqOfNgmT9y1U/
         H+9UtbkBM3zNkwVgTZHSEOe/FoBS9iuOuQxqLjh5cey6TuLNMMm3fBc5mn+hL4uPqv5T
         vAZj6xejyetlbJEzRQN1BhMmMzZpGZ86myUbP4cSzGjUag9Id+181SvL6ynRd5n+JO+W
         zvLg==
X-Gm-Message-State: ACrzQf0YdaSLTo+lfh77s6GEQby1ua7zdLOBdDvlWIWSaY2xUs/fO2D2
	0SFan62wyt5KpmzMIdfZWeDvvg==
X-Google-Smtp-Source: AMsMyM5/cujdcT78gRxEog7IR5B+lzupMRJjfjRQboVnh0oymMYyQqzGt6abkUA4YnXyYMd+Nr6iug==
X-Received: by 2002:a17:902:f70e:b0:178:8895:d1fb with SMTP id h14-20020a170902f70e00b001788895d1fbmr21795386plo.166.1665444170373;
        Mon, 10 Oct 2022 16:22:50 -0700 (PDT)
Date: Mon, 10 Oct 2022 16:22:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
	cgel.zte@gmail.com
Subject: Re: [Self-introduction] - Paulo Almeida
Message-ID: <202210101536.A46A0690@keescook>
References: <Y0JrBsGthQIiSzp+@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0JrBsGthQIiSzp+@mail.google.com>

On Sun, Oct 09, 2022 at 07:32:38PM +1300, Paulo Miguel Almeida wrote:
> My name is Paulo Almeida and as per the instructions listed on the KSPP
> page, this is my self-introduction email :)

Hello! Welcome to the circus. :)

> I will keep it short. 
> 
> - My background is in HPC and AI 
> - I've been writing software for around 20 years now
> - I've written my x86-64 hobbyist OS for fun and in my spare time I've
>   writing a MOS 6502 emulator for the same reason.

Heh, nice. That made me wonder if there was a QEmu port, but it seems
it hasn't been touched in a decade?
https://github.com/AVEx-6502/qemu-6502

Is there a particular 6502 system you're working to emulate?

> - Contributing to KSPP is going to be a side project of mine that I plan
>   to do outside of business hours... so expect a dedication of a few
>   hours per week.

Excellent! We're always glad to have folks helping.

> Q: What topics are you interested in?
> A: kernel driver development, x86 & ARM hardware architecture, Math, Data
> structures, Rust and virtualisation.
> 
> Q: What do you want to learn about?
> A: I see the KSPP project/initiative as a way to get exposed to pieces
> of code that I wouldn't normally come across which is always
> appreciated :)

Yeah, you'll end up uncovering some really weird stuff, as you seem to
have already found[1]. ;)

> I am also aware of the calibre of developers I will be dealing with and
> I'm sure that I will be learning really a lot from them :)

One of the double-edged swords with KSPP is while you get to work with
all the kernel's subsystem maintainers, you also have to work with all
the kernel's subsystem maintainers. ;) You'll learn a lot, but you can
also end up discovering very different requirements as you send patches.

> Q: What experience do you have with security, the kernel, programming, 
> 	or anything else you think is important.
> A: 
> I've contributed to the kernel a few times time in the past for both
> adding features and janitorial tasks.

Excellent! Yeah, it looks like you've been helping clean up some staging
drivers[2].

I see you touched rtl8192u -- there's a lot of duplicate code spread
around in the rtl* drivers. It would be interesting to see those
consolidated some day. If you're interested, it may be worth asking
about it on the wireless list.

> I took the Linux Kernel Internals (LF420) and the Linux Kernel Debugging
> and Security (LF44) courses by the Linux Foundation.

Cool -- did anything stand out for you in those courses?

> As for other experiences, due to the fact that I wrote my hobbyist OS, I
> do have a decent experience with the x86/x86-64 architecture. I also
> spent quite sometime writing static analysis parsers.... so should those
> experiences help anyone or any possible future plan for the KSPP, please
> count on me.

Great! One area that needs some review and testing that is x86-specific
is the userspace CET support[3]. That spans a wide range of from chipset
all the way up through compiler, kernel, and glibc. Getting more people
to try that series out and post results ("it works for me" or "I
couldn't trigger the protection", etc) would be very welcome.

You've already found the "remove the 1-element arrays" work, and there
are plenty more like that on the issue tracker. Trying to really put an
end to strlcpy[4] is ongoing[5] too, as there has been a fairly
concerted effort to remove them lately:

Count of "git grep strlcpy | wc -l" over recent releases:

         v5.17:  1535
         v5.18:  1525
         v5.19:  1507
          v6.0:  1379
        master:   544
 next-20221010:   401

Thanks for introducing yourself!

-Kees

[1] https://lore.kernel.org/linux-hardening/Y0IsXXYnS4DnWkMW@mail.google.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?qt=author&q=Paulo+Miguel+Almeida
[3] https://lore.kernel.org/lkml/Y0IsXXYnS4DnWkMW@mail.google.com/
[4] https://github.com/KSPP/linux/issues/89
[5] https://lore.kernel.org/lkml/?q=s%3A%22use+strscpy%22
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=strlcpy

-- 
Kees Cook
