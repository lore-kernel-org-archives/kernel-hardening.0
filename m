Return-Path: <kernel-hardening-return-21751-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id ECAEDC3271E
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 16:51:24 +0000 (UTC)
Received: (qmail 27854 invoked by uid 550); 8 Jul 2024 16:50:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5979 invoked from network); 8 Jul 2024 16:09:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720454950; x=1721059750; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsiFj/WxLrZpXhxwXs3+FDSwWwZ1Cd4GcIfLRJ1s7ho=;
        b=LWef2LuOkaFTf1EQxfunS2ikdRlzf+c0LVaLjk8Q/sxOcMOvM0Yi+6YpqZjL0g+Asn
         XC0X/X5GHX4/hOnpgyAC9puoSrHk8pkut+ZYUgkivj4Z6p3Q9WR0kIBZS0sBJxYlnWBq
         MSA4O0xW8VOMpUP21QDqL/PRvJ67o1iQ6txsVbqL4H2200eHMT+YmMsh60rme4RXjUcs
         fFSMlrscS1z8xYyLidIxtRCGfJmmkWB4KT2QZuJlG7bE8p8jT2vEMsczujfX1lcjWdI3
         tpbFQZ7FmqMFYa6kgZgl8Sh0kyHOdb801AANKWL57PzhU8j53rLSw69+xBhnlfQj7eGC
         QB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720454950; x=1721059750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsiFj/WxLrZpXhxwXs3+FDSwWwZ1Cd4GcIfLRJ1s7ho=;
        b=rQpqti77nD+LW5GMIKgyM1CU6ntCknUNjFfIV0vOm8TefsEjW9GlaQCtJ7uic5uhmf
         P/5AyF5DxwMPvcVal1oDUbDE8Cnx3NhAg2G0GWzUQDoVCrPriHvd3OWGbVjLTVnSLufP
         qsgM04e34sBVSc5XB0oCW6GOC534j5azgRssEYVhDIH26i3NVHJbSPjWQdCM/Mdw3H39
         IWvkC1v0zf2lEZbdiJqrMobohEmeiRx/iBz2hG2CV2+F4yKJoPgpwOteXweXkV6YEdjx
         Karhh8ZuIH8W9PA5NtGre/U8qe/zobhXjfPtF5mhIBksfBlvdOALYjb0OBGOonfxU/ZG
         5HkA==
X-Forwarded-Encrypted: i=1; AJvYcCUrA/XsP9ZZWPHVmymHGryiVxT02XO7c6zFDk2vyXrb+3XebeJyZyQky+7soCYmap8HKVIrlfvOYHW1+CLlxC0kYAzkHV4Swoq7e2QGYOjmksUarA==
X-Gm-Message-State: AOJu0YwcVeLF2iooapvSxg5ga0IYSg7dTOTvx8m+P6ooHMQVkdSCyVE+
	hddUc9guWJVxUwthGSWDmzZnkx880v9cohDRDknNA0alM9r+cPfH/9fgFthYUOrMZN8DXGCfSrU
	/D32dWya9toZCbflOva6gTI+fOTCaZu4k948I
X-Google-Smtp-Source: AGHT+IG68WVmOzY4xDmfQcCAQVMnFKtmNO3cbEdYJgbHLx0bLl7VhaJKp8PuklOozwexmfThc7tkOd6AwzlEUeRW6sA=
X-Received: by 2002:a50:8ad3:0:b0:57c:bb0d:5e48 with SMTP id
 4fb4d7f45d1cf-58e00933a13mr529925a12.2.1720454949927; Mon, 08 Jul 2024
 09:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87bk3bvhr1.fsf@oldenburg.str.redhat.com>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 09:08:29 -0700
Message-ID: <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
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

Hi

On Fri, Jul 5, 2024 at 11:03=E2=80=AFAM Florian Weimer <fweimer@redhat.com>=
 wrote:
>
> * Micka=C3=ABl Sala=C3=BCn:
>
> > Add a new AT_CHECK flag to execveat(2) to check if a file would be
> > allowed for execution.  The main use case is for script interpreters an=
d
> > dynamic linkers to check execution permission according to the kernel's
> > security policy. Another use case is to add context to access logs e.g.=
,
> > which script (instead of interpreter) accessed a file.  As any
> > executable code, scripts could also use this check [1].
>
> Some distributions no longer set executable bits on most shared objects,
> which I assume would interfere with AT_CHECK probing for shared objects.
> Removing the executable bit is attractive because of a combination of
> two bugs: a binutils wart which until recently always set the entry
> point address in the ELF header to zero, and the kernel not checking for
> a zero entry point (maybe in combination with an absent program
> interpreter) and failing the execve with ELIBEXEC, instead of doing the
> execve and then faulting at virtual address zero.  Removing the
> executable bit is currently the only way to avoid these confusing
> crashes, so I understand the temptation.
>
Will dynamic linkers use the execveat(AT_CHECK) to check shared
libraries too ?  or just the main executable itself.

Thanks.
-Jeff


> Thanks,
> Florian
>
