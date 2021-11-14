Return-Path: <SRS0=08Lk=QB=lists.openwall.com=kernel-hardening-return-21473-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2135C433F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 14 Nov 2021 15:32:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B495A61105
	for <kernel-hardening@archiver.kernel.org>; Sun, 14 Nov 2021 15:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B495A61105
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 21651 invoked by uid 550); 14 Nov 2021 15:32:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21628 invoked from network); 14 Nov 2021 15:32:36 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AMLZNNJz4rzWLCa/Dr8r4qa1Ugz4YCnUFphJhYJFFBo=;
        b=5vs5NlbdTDx9TNrMZug+rEm0U9A1sPGdro/fes9Lqq1AaXLd14PzC9NvB2pl/yAPRe
         sksz/UZVewNiazQP3VWgSBZQgm6BlHpN3uyLkmt9IEtuLGVmRmdY+8bupGxistipESyP
         /P215rbbNs8BNXC5Vx4Zb4SPboPYOfs7pgic63QJDNMpQyYT9rYvOT/aT3vi/opviDC3
         7HWzfa1EnikmeipqOrVX/u3QgsfLIb9yHyUHESVkTQf12Proat82qpucDjfbI2s/Te7e
         drRm3H5FsenxQaHFGl/6LVP5va7vRPTgbNM/W7QZ/1RBOvwrCNSIgOcOI0+fDBq72qra
         u24Q==
X-Gm-Message-State: AOAM53095ASX8+12X1XuCQIpr5S/FF2wfPIzR8yr9GZAG1IefYU3ad6a
	PA7Jmb+qBDLvbanWjr6Gq0+y+AbOjtJJVw==
X-Google-Smtp-Source: ABdhPJxkFoKsLbkx40Sf48EQnOBSnxEHu5UQtvPqJPQ2Z21mfBRIG0wr1tn9j43QGiAUtKXx6TW+5w==
X-Received: by 2002:ab0:4301:: with SMTP id k1mr47591472uak.75.1636903944998;
        Sun, 14 Nov 2021 07:32:24 -0800 (PST)
X-Received: by 2002:a05:6122:20a7:: with SMTP id i39mr47085557vkd.15.1636903933687;
 Sun, 14 Nov 2021 07:32:13 -0800 (PST)
MIME-Version: 1.0
References: <20211110190626.257017-1-mic@digikod.net> <20211110190626.257017-2-mic@digikod.net>
 <8a22a3c2-468c-e96c-6516-22a0f029aa34@gmail.com> <5312f022-96ea-5555-8d17-4e60a33cf8f8@digikod.net>
 <34779736-e875-c3e0-75d5-0f0a55d729aa@gmail.com>
In-Reply-To: <34779736-e875-c3e0-75d5-0f0a55d729aa@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 14 Nov 2021 16:32:02 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXj8fHDq-eFd41GJ4oNwGD5sxhPx82izNwKxE_=x8dqEA@mail.gmail.com>
Message-ID: <CAMuHMdXj8fHDq-eFd41GJ4oNwGD5sxhPx82izNwKxE_=x8dqEA@mail.gmail.com>
Subject: Re: [PATCH v16 1/3] fs: Add trusted_for(2) syscall implementation and
 related sysctl
To: "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, 
	Christian Heimes <christian@python.org>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alejandro,

On Sat, Nov 13, 2021 at 8:56 PM Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
> On 11/13/21 14:02, Micka=C3=ABl Sala=C3=BCn wrote:
> >> TL;DR:
> >>
> >> ISO C specifies that for the following code:
> >>
> >>      enum foo {BAR};
> >>
> >>      enum foo foobar;
> >>
> >> typeof(foo)    shall be int
> >> typeof(foobar) is implementation-defined
> >
> > I tested with some version of GCC (from 4.9 to 11) and clang (10 and 11=
)
> > with different optimizations and the related sizes are at least the sam=
e
> > as for the int type.
>
> GCC has -fshort-enums to make enum types be as short as possible.  I
> expected -Os to turn this on, since it saves space, but it doesn't.

Changing optimization level must not change the ABI, else debugging
would become even more of a nightmare.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
