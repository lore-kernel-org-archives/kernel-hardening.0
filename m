Return-Path: <kernel-hardening-return-21753-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6CCB5C3DA41
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 16:52:22 +0000 (UTC)
Received: (qmail 3785 invoked by uid 550); 8 Jul 2024 16:52:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30707 invoked from network); 8 Jul 2024 16:41:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720456883; x=1721061683; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5h9K8a8sSLubZd/W2Bpa7ei/SlFMORW/ZDCStOq+wM=;
        b=Yyyju3Stn/KCTBbXMs26b7KPAc19AWf51sMDmhZeiHw6SuC6bbdLadP05o6/C3BHTY
         hlB7boQ5rYcHgPBPy2FUVPxAlpntyIwVM0SbTDDQwqR4Uuxk6PeXFCuCjbdBf64rpDsL
         ExWUIxA1BN1gx7qkyL6ASRVcD0mSpYy0L1LZHoa3Wm7RC62Qn1jyPxg7n5DiNgosCOM2
         s/CFB4AM0a4TnRk9uY1B5z0PP2D6W1RnYcrjJP0md9oUp0yJcQXQQytGjWVp0Aug30d5
         CJ63OGDsEWoxtRyMSIGXiaO4DY1ofI6mxz7KDkSBqF944I32BHvfxGOibj3QDjCK/J9s
         9tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720456883; x=1721061683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T5h9K8a8sSLubZd/W2Bpa7ei/SlFMORW/ZDCStOq+wM=;
        b=b7ZEdc0d3020UjIP1QJYekBE7NXbWy/J0mSRfzqpL0U5vJ5rQ2EPGgovinS98sj85g
         5g5y/tvBQb89QlHw6xepeKRkdN6eB4JCL54Uu+S1+YjHxhMFcKd0Bni/UL5rmelJxDsn
         nNerbP/+s65THBnUDFfxD1rLxtTS/TtVRBIdONCVlof0ClnsfOnDgt+Ta5d5l9phGNgr
         s2+n2qXrTa+pKioVaHQpnaJTGMcpFNwTAmZ6Ds4dE7zUZTomvjgQtE0fCum/f4Wr2fgh
         Xs7zIu1ITQEbdawQ5oHWzyEZWz73O2VYYaCQlPMWlqI20lWfZlvYHgf5UkoAywiGaWQx
         Mpkg==
X-Forwarded-Encrypted: i=1; AJvYcCX+wrxKdAuy5duhjwrK4EfPk4SdxK/r0xxZ4DBmpDt1xEZ8ATqNMIiIivo4LLyLIcsHA2PbXZEXWeNXuZoO0y8aWGD63ED9OYlvE2Yt0hVzPr7Paw==
X-Gm-Message-State: AOJu0Yykun2a77bRe4ecVnQKLC+VMPangMHeOLZvWdZ5UBXV7WRx9SEz
	wsRRBhd7PfFNVxG34CM3OQwU1JKszlircGkja5Ibeju5teBdbVNouudYnntrSsdNAgajQJmQON3
	pwBocXlL7Q3D1dhRwzLNfxspNuWTUhJ3JiKNU
X-Google-Smtp-Source: AGHT+IGnZrn5/gF0KK99nMLQYDqQtH14UdCGc9dpKYr4CJb2IgbOmv7c7MrCZL5Np69D3hoUFnM393mMoyI6bE88g5c=
X-Received: by 2002:a50:bae9:0:b0:58b:dfaa:a5cd with SMTP id
 4fb4d7f45d1cf-59352e1a5b2mr174396a12.2.1720456883109; Mon, 08 Jul 2024
 09:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com> <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
 <87ed83etpk.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87ed83etpk.fsf@oldenburg.str.redhat.com>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 09:40:45 -0700
Message-ID: <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: Florian Weimer <fweimer@redhat.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Alejandro Colomar <alx.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 9:26=E2=80=AFAM Florian Weimer <fweimer@redhat.com> =
wrote:
>
> * Jeff Xu:
>
> > Will dynamic linkers use the execveat(AT_CHECK) to check shared
> > libraries too ?  or just the main executable itself.
>
> I expect that dynamic linkers will have to do this for everything they
> map.
Then all the objects (.so, .sh, etc.) will go through  the check from
execveat's main  to security_bprm_creds_for_exec(), some of them might
be specific for the main executable ?
e.g. ChromeOS uses security_bprm_creds_for_exec to block executable
memfd [1], applying this means automatically extending the block to
the .so object.

I'm not sure if other LSMs need to be updated ?  e.g.  will  SELINUX
check for .so with its process transaction policy ?

[1] https://chromium-review.googlesource.com/c/chromiumos/third_party/kerne=
l/+/3834992

-Jeff


> Usually, that does not include the maim program, but this can
> happen with explicit loader invocations (=E2=80=9Cld.so /bin/true=E2=80=
=9D).
>
> Thanks,
> Florian
>
