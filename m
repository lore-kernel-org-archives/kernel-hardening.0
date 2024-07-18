Return-Path: <kernel-hardening-return-21798-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 64DF5C3DA5D
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jul 2024 01:52:16 +0000 (UTC)
Received: (qmail 5394 invoked by uid 550); 18 Jul 2024 01:51:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5371 invoked from network); 18 Jul 2024 01:51:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721267510; x=1721872310; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJZ63+KcodZOUJ9CCw+HbTDjxj9KTImYwSLlP4nPFDI=;
        b=xEtB/IQ45l3Nix4fTRJm3Wvcbr/evnvhvRYPVdqIrNx0eS6gNCc0RB47zS9NIaS0v8
         uy1gpnMSAYUXnx0UG2Zac4CQwwVlvwx+Qh6AFg67imcITGGQ4LLZXuS7M1n6SjSPgAFx
         R5cBl7qzcCMaqcN0/DhwtOtoEhl5ozS+Nf/Nv0mWuXCPcxZTtRv0NxIMwh8a6G+RyNHK
         vrSBeLiL3+blKLygXsRe05Eyq/e6L2Xo2opmJOJp9+B4h/tv/rK+4KMV3XjNDrfru9/L
         G9ehA+O90pGeXrtog0JM0zKWw2oRbTwuf1qgAwr+Lb2DRFzacrMEK18mQgKHwoEUHY1a
         8Ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721267510; x=1721872310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJZ63+KcodZOUJ9CCw+HbTDjxj9KTImYwSLlP4nPFDI=;
        b=sIwyJ7mZ7b//EgTbv+qNKw7DVrlqcMsLWqN/A1Mrdsb+vLg7pLcnZE6523OD3YO3ys
         q5nrwM0Ig0r69XJd0zk7WjrwoXuxJyC5VEVs7l5KcrzQt7ARxIeo4GnXSt6wJKLeyiZ5
         JMO6FsKOVdG4yAELAkoiMXxfr8muaN6aAXSWaqJ7MQsMsL9tKloXcMxKaeHsotsWSlhD
         isXa/aP+GT6yamrbKwDt9FmoOAidsPgvACkF6RCjctawOsNXV4CZeeXRq6N++AyCHsFb
         HcxCQCnbWC/Sq6D6f9UgwlDPbSd0Jyq0Fpb8TYkfFatO7/KR1Da1DIOsxNTxNxFTzQqo
         QrFw==
X-Forwarded-Encrypted: i=1; AJvYcCXcA1+U61I2Pm+eElw2e6mvKLjcfS81fNmjBR56k/ts3HceJk6yzPEyzIUbcaItB2MfYUZFYiGZ8TNs7U1V3dN7Ki9OlQujFQ93sfWzE9cwkzunZg==
X-Gm-Message-State: AOJu0Yzu/ilfeLGaVkOYLZdn9zTBWTlkNUAk2H628i25JjkjNwfbcDpV
	JBStUmQEI7QgIQj0fujaxHcXBD/EAvvkTj2LUlJKQdfLELyXdV1B+twlwf4MU1LbC73W4lQYM6g
	PP+yUgccLlmtA4SRwPXbJBgcqPt0mljAu0ZPa
X-Google-Smtp-Source: AGHT+IH9jcKAI8n2GbWdrtyqQO31S0/aF0VaU5hERSsdL1d154MSEshBIghoJbVRDz92Y4QOgC4k+74aIDfa+EXvDTY=
X-Received: by 2002:a05:6402:254f:b0:58b:93:b623 with SMTP id
 4fb4d7f45d1cf-5a1afc473bdmr44730a12.5.1721267509612; Wed, 17 Jul 2024
 18:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org> <20240717.AGh2shahc9ee@digikod.net>
In-Reply-To: <20240717.AGh2shahc9ee@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Wed, 17 Jul 2024 18:51:11 -0700
Message-ID: <CALmYWFvxJSyi=BT5BKDiKCNanmbhLuZ6=iAMvv1ibnP24SC7fA@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Steve Dower <steve.dower@python.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 3:00=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
> > On 17/07/2024 07:33, Jeff Xu wrote:
> > > Consider those cases: I think:
> > > a> relying purely on userspace for enforcement does't seem to be
> > > effective,  e.g. it is trivial  to call open(), then mmap() it into
> > > executable memory.
> >
> > If there's a way to do this without running executable code that had to=
 pass
> > a previous execveat() check, then yeah, it's not effective (e.g. a Pyth=
on
> > interpreter that *doesn't* enforce execveat() is a trivial way to do it=
).
> >
> > Once arbitrary code is running, all bets are off. So long as all arbitr=
ary
> > code is being checked itself, it's allowed to do things that would bypa=
ss
> > later checks (and it's up to whoever audited it in the first place to
> > prevent this by not giving it the special mark that allows it to pass t=
he
> > check).
>
We will want to define what is considered as "arbitrary code is running"

Using an example of ROP, attackers change the return address in stack,
e.g. direct the execution flow to a gauge to call "ld.so /tmp/a.out",
do you consider "arbitrary code is running" when stack is overwritten
? or after execve() is called.
If it is later, this patch can prevent "ld.so /tmp/a.out".

> Exactly.  As explained in the patches, one crucial prerequisite is that
> the executable code is trusted, and the system must provide integrity
> guarantees.  We cannot do anything without that.  This patches series is
> a building block to fix a blind spot on Linux systems to be able to
> fully control executability.

Even trusted executable can have a bug.

I'm thinking in the context of ChromeOS, where all its system services
are from trusted partitions, and legit code won't load .so from a
non-exec mount.  But we want to sandbox those services, so even under
some kind of ROP attack, the service still won't be able to load .so
from /tmp. Of course, if an attacker can already write arbitrary
length of data into the stack, it is probably already a game over.
