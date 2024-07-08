Return-Path: <kernel-hardening-return-21766-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BCFD5C3DA42
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 22:08:23 +0000 (UTC)
Received: (qmail 20236 invoked by uid 550); 8 Jul 2024 22:08:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20216 invoked from network); 8 Jul 2024 22:08:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720476482; x=1721081282; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z7bTn4O9eTr2aCFrLSGHovaOIDt2y0TRFcSEpZcps+A=;
        b=LZzmx1VjMM9vPbSO16qAwZiVGCpIjasWAPoGKwXPTUx0+NUumI42ycoReQ4hoWeJcM
         S4vtPNrsT+VfG2FEwZGfGWKrMiB/kZqaM9IcCD5rrrKTPeKAVLIPMJVsEVnVaohjYDl+
         mFNZtxeN9KknKU1IT/fxcQXPp4GzRRgThNHtaSe3KrwWsZ4sLI3itOcLGWc1gWqzOnEq
         iIJWsYTzCShIXCtVry/OMc4bUfrZWHoKU+ll8JNe2K/Yvt8QVrOXmZUJX3GMbOTL/ART
         t/K3y13x73e1MvKjyC4V17cBjkU77872vkOO0IC0BXyC9pbdq4cm5roIlTlq+un2xp/f
         0AwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720476482; x=1721081282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7bTn4O9eTr2aCFrLSGHovaOIDt2y0TRFcSEpZcps+A=;
        b=E5kCI3dLtsziQEqCADA+AunHt5mJffjs2HCx8cy6bq6iup+qaewrNLjTro0HVNa7rO
         1V6iI9J0zN1SS+Lp17G59l6jYzXYKE0Wxha+ut9LnlTo9wdlEZm8rVeXg1E4l+9gN2sQ
         jC7sO2SXd/zQgkzMItEp6Q2ifF7vgc/cxxSrxWQssNln++vinrCNgfsVleuba68B9afG
         7o+6jxvPrZEJfd6qqDqZ9nsyMx7BJvxTcV0k9PYIpcCB85Qf3Vw+bJ5BbfGVUDRLUqEA
         0+RBbCTqp/5FYKFOKBBo80GcuEc56/43IRYKT1xeL0NlLuB+0umRW3qgl55G/1QaqmDM
         pZlg==
X-Forwarded-Encrypted: i=1; AJvYcCWZKRh0ckbRjL01Em5FTKCVokAdSP9UsuDjdGZlacOpLBMm5307ti/LMWEh6PPVUdqba3Pnt/m9Wb9EbmK5H1sdAu0eVcSCpW0jcWFPGACbP4PzQQ==
X-Gm-Message-State: AOJu0Yw3NnhF5yiSO0eCgDc2qMH104Ryn5nyho8NVmMigyhpjISnVM3s
	NijLIGzuvhmTgPsROF39HVFAN3W0JEtV9ApL9a3ZCHncCApT8uMcWMwC+Zz/VXxoOkoDO+TqdOB
	hUbM76z6sa2FvW+QhKhSAYLr7Ysdbt7zgkMcm
X-Google-Smtp-Source: AGHT+IHvwrZF+sD8hiUMuOI0mETWWoP7JD1Mi+rw83YkQOqjyP7kYFiISHKE1V9Tv7EGbEO+Y6qMxWIETtxF0JNU+kY=
X-Received: by 2002:a50:9fc1:0:b0:58b:21f2:74e6 with SMTP id
 4fb4d7f45d1cf-594cf64511dmr86189a12.0.1720476481691; Mon, 08 Jul 2024
 15:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-3-mic@digikod.net>
 <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
 <CALmYWFsLUhkU5u1NKH8XWvSxbFKFOEq+A_eqLeDsN29xOEAYgg@mail.gmail.com>
 <20240708.quoe8aeSaeRi@digikod.net> <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
 <ef3281ad-48a5-4316-b433-af285806540d@python.org>
In-Reply-To: <ef3281ad-48a5-4316-b433-af285806540d@python.org>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 15:07:24 -0700
Message-ID: <CALmYWFuFE=V7sGp0_K+2Vuk6F0chzhJY88CP1CAE9jtd=rqcoQ@mail.gmail.com>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
To: Steve Dower <steve.dower@python.org>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:25=E2=80=AFPM Steve Dower <steve.dower@python.org>=
 wrote:
>
> On 08/07/2024 22:15, Jeff Xu wrote:
> > IIUC:
> > CHECK=3D0, RESTRICT=3D0: do nothing, current behavior
> > CHECK=3D1, RESTRICT=3D0: permissive mode - ignore AT_CHECK results.
> > CHECK=3D0, RESTRICT=3D1: call AT_CHECK, deny if AT_CHECK failed, no exc=
eption.
> > CHECK=3D1, RESTRICT=3D1: call AT_CHECK, deny if AT_CHECK failed, except
> > those in the "checked-and-allowed" list.
>
> I had much the same question for Micka=C3=ABl while working on this.
>
> Essentially, "CHECK=3D0, RESTRICT=3D1" means to restrict without checking=
.
> In the context of a script or macro interpreter, this just means it will
> never interpret any scripts. Non-binary code execution is fully disabled
> in any part of the process that respects these bits.
>
I see, so Micka=C3=ABl does mean this will block all scripts.
I guess, in the context of dynamic linker, this means: no more .so
loading, even "dlopen" is called by an app ?  But this will make the
execve()  fail.

> "CHECK=3D1, RESTRICT=3D1" means to restrict unless AT_CHECK passes. This
> case is the allow list (or whatever mechanism is being used to determine
> the result of an AT_CHECK check). The actual mechanism isn't the
> business of the script interpreter at all, it just has to refuse to
> execute anything that doesn't pass the check. So a generic interpreter
> can implement a generic mechanism and leave the specifics to whoever
> configures the machine.
>
In the context of dynamic linker. this means:
if .so passed the AT_CHECK, ldopen() can still load it.
If .so fails the AT_CHECK, ldopen() will fail too.

Thanks
-Jeff

> The other two case are more obvious. "CHECK=3D0, RESTRICT=3D0" is the
> zero-overhead case, while "CHECK=3D1, RESTRICT=3D0" might log, warn, or
> otherwise audit the result of the check, but it won't restrict execution.
>
> Cheers,
> Steve
