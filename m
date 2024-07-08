Return-Path: <kernel-hardening-return-21757-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id DD018C3DA41
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 17:53:35 +0000 (UTC)
Received: (qmail 32312 invoked by uid 550); 8 Jul 2024 17:53:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32292 invoked from network); 8 Jul 2024 17:53:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720461195; x=1721065995; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3TbkBbvUVbFeDVSEP1fW1+EltO1UgtRB4Zsk2MimJk=;
        b=4Kz+o6KeGkIK7dX0fOyFtZr3IVg3qJBv7Oo5GRrDq4SN7K+XM5Bp4BDXBjmBr03CYo
         /yWxEVc0SSsYOl30IW2XgN94oEzLRff0qSCFNQlNutkNXSNIVsKJ9noy/K8M70uUXVuE
         LzDYbGohhpx0aOLDwrdTOevHi96P41yag2+TvJGdIlUM56DMoF0iTsk5Ull60qr3uCmN
         Jj2O4ipW8ZNs2ShiLYBX6CMw8sF8m+TzZUyz/JZ+YLO7M0phsW+3Ztr1C5KmHdB7S6iL
         lU12pkVLqQcnSXewhoRZBtmqR6r5OuXQp1m1IqNNmoihG7D4JEcUOZZZd4JfSs/L+Zso
         DkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720461195; x=1721065995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3TbkBbvUVbFeDVSEP1fW1+EltO1UgtRB4Zsk2MimJk=;
        b=Ao0CyTQSjXTTuIY4FIFn5e8L1spT1zSgsGtX+JyROmIO+JHXHv+hRJCor41n5av3Dw
         U4/3kBz2G1NKcBH99ncesUFRgrbW4Zxoo1dcYNPNEqG3a66wYZ52FiIiWSnUH6LkYE1Q
         QlYB7Xe9yzxxLoVkpO1xC4E+Z5DVjShUwUF3Aish9qR/n/y75YQ8DNEnVHVJzpRBmZ8R
         Rog3ivVIJx1hsVtSUUL6GU4tGza0fkj4YHaGicZYIlzpUPw6fn7GwLJY7Qe3L0C4rL5C
         is28Q9UzwKxfkj1sunQk3Siv1ycBRdnkoslBdsL+kzS3CgT4asQORXZmvQbeOSdOFYwX
         6W2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8LNO+t0lXF09YC3eM04k3uS/kpevlEuE58gWedLmbnuTCoHgC1aJYC1ZjFd1Y8Xhp6hHTmxqDBNnyXKV7H7HexbH43FDQCktFzKwexhow5aKJ8A==
X-Gm-Message-State: AOJu0YwDZBi5SObMpFtYV3fRuLDIfWOtIQEsQzUdGX5rtCWEDzJkSyFd
	eIIlQ4qCwt7Yd3BvJLyQz2zKxuzjHHjknREw8qx5jjCTeluPl/ra353IVTV3PwdkPTmTpLWuTdZ
	DlQRjaZ1AhSgI1f6ibz9ItAhG+/2d2PLifHLM
X-Google-Smtp-Source: AGHT+IHHxKVbyksIrCSInAfN33CbHiJrGetzywRVqsOhmUb93ffLYHC9Q2t9UkNSdOIhMtNmgF5pWC4xS+6p5oWJ6ps=
X-Received: by 2002:a50:bb2c:0:b0:57c:c5e2:2c37 with SMTP id
 4fb4d7f45d1cf-594d6d8047dmr3249a12.3.1720461194964; Mon, 08 Jul 2024 10:53:14
 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com> <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
 <87ed83etpk.fsf@oldenburg.str.redhat.com> <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
 <87r0c3dc1c.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87r0c3dc1c.fsf@oldenburg.str.redhat.com>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 10:52:36 -0700
Message-ID: <CALmYWFvA7VPz06Tg8E-R_Jqn2cxMiWPPC6Vhy+vgqnofT0GELg@mail.gmail.com>
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

On Mon, Jul 8, 2024 at 10:33=E2=80=AFAM Florian Weimer <fweimer@redhat.com>=
 wrote:
>
> * Jeff Xu:
>
> > On Mon, Jul 8, 2024 at 9:26=E2=80=AFAM Florian Weimer <fweimer@redhat.c=
om> wrote:
> >>
> >> * Jeff Xu:
> >>
> >> > Will dynamic linkers use the execveat(AT_CHECK) to check shared
> >> > libraries too ?  or just the main executable itself.
> >>
> >> I expect that dynamic linkers will have to do this for everything they
> >> map.
> > Then all the objects (.so, .sh, etc.) will go through  the check from
> > execveat's main  to security_bprm_creds_for_exec(), some of them might
> > be specific for the main executable ?
>
> If we want to avoid that, we could have an agreed-upon error code which
> the LSM can signal that it'll never fail AT_CHECK checks, so we only
> have to perform the extra system call once.
>
Right, something like that.
I would prefer not having AT_CHECK specific code in LSM code as an
initial goal, if that works, great.

-Jeff

> Thanks,
> Florian
>
