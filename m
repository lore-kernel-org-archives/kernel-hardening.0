Return-Path: <kernel-hardening-return-21965-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 36607CA0EEB
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Aug 2025 19:46:29 +0000 (UTC)
Received: (qmail 13514 invoked by uid 550); 22 Aug 2025 19:46:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13491 invoked from network); 22 Aug 2025 19:46:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755891969; x=1756496769; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eDGPq2QAoamqAsn96zDYfVwrsh9uyHlSfDp4Mt63PH0=;
        b=dgr4hkLVl/vyeng8W/oQ25csyap7+EZbLrEFA7C1u9IR+etcx5XtUYtqU4fdsXYU7d
         tXuCj3XcyOrJOVYexm8yOs9HzrMEJ5DFo5XeMpQnjzUnoZBbsag/ZWA4LihNUQQdORyd
         mFIfP0QFLR1qG4cajSkisJf3QoXz00z6C5pOsqavlhBtIMRhb4yBb7eMcTUCxrhW2msS
         w98tUmVtsg1WtHpmxegFFghixo1F0CmfWBesRUeIYhKN0rQz4h2erIWKRlL3uPm0zZy6
         QZ3207A7bk3lRlXHU1egkXc9zPfwQFKGqlHw9w8o/O/f/KqfiOz0/sYnEWmOEILqqGLF
         I7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755891969; x=1756496769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDGPq2QAoamqAsn96zDYfVwrsh9uyHlSfDp4Mt63PH0=;
        b=Dxj7Rw3fNTyX+OtckyxWCHcXDBvzgI9pcPe+smzxY8FqrUeYxObolY1+vNz+hb5HgC
         bm/yt6+2pKWrbvjEDg9ZqacWjFtHEiKXbcclpAZR4sGfmpF7d7sl5qEFjJ2BDj7i4U6L
         6ZhIVnqvaTUJIRh+LamNLZODZIVjFBBeOfWKhTutXg6g5JStNeWmAZkhvIR4gKJ7uf58
         DrJFyDiZrKy1KthiOfpf9L4vAzGQGm6BoMhIkZHNDVw3mHULfpY9CFcFev4ee5KbkR7X
         rm+NiKc/DY5Ilvo2iw9XxAJhzBL44JVsQ539q0alcFtBZOaIPCuF57EZxkeOePMcktrL
         wOEg==
X-Forwarded-Encrypted: i=1; AJvYcCWZiPDAol4v+Lo0ggFPrX9q4ogdD18erB/pSVKrTdMX+YshDXayiyM9c+GOO4n6wpr6N25sSSQrNi+VZNtN1jrg@lists.openwall.com
X-Gm-Message-State: AOJu0YxAiJ3AORzdmc2zbsOfzdJprUgJv4KdDrkvNF64fxrmIujWgn6C
	Sepoto4TH+AcZHA1yMW3g6Lom3j4Tr4A+1QLwWuEPNjSUyi0d8RRfqS2BiFAB+523wpxvqYJDUm
	ADxTSA9zD7WXIzrfbolnROyK94gG5GsvrbOispvqJ
X-Gm-Gg: ASbGncvnKDNWn4A/1I37oAlFj+tkMFj1S7eQoqN45Szhro/9PhM5yoLXqrllDf7uGff
	qFIEn6hWomgGjRC+FnwQ7G+Vn3v4sw1/l04NIB2BzfZ5g2EQ3nWQk3hIvAn45cfGo1ec0/nNSqh
	dQ9PWxV12cvC97jZhtmdEeqr50I5l0MrkUuY7oQ5JD2N/yPHajy9XJ5DyDgLFdwNYpMFXt7S6W0
	X54jR4IcjtgnHywyXgcJEkDTW3tc296IQgPW0w=
X-Google-Smtp-Source: AGHT+IEp5JtOIpLeEMiI4+ZgwDstAGg61BU3UaS/vBzIt/3oQq6zs0o3AsSV2sCxqe1VwQ3ShoALvJizriSBAYLp6Cs=
X-Received: by 2002:a05:6402:2393:b0:61a:590c:481c with SMTP id
 4fb4d7f45d1cf-61c361f8759mr8808a12.6.1755891968513; Fri, 22 Aug 2025 12:46:08
 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250822170800.2116980-2-mic@digikod.net>
In-Reply-To: <20250822170800.2116980-2-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Fri, 22 Aug 2025 21:45:32 +0200
X-Gm-Features: Ac12FXwjpgWQzX75-i1-fxwmf--db3NEnzMzNGlpF6QflXz8uRcHgI7dwyXvzpA
Message-ID: <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Andy Lutomirski <luto@amacapital.net>, Jeff Xu <jeffxu@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025 at 7:08=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
> Add a new O_DENY_WRITE flag usable at open time and on opened file (e.g.
> passed file descriptors).  This changes the state of the opened file by
> making it read-only until it is closed.  The main use case is for script
> interpreters to get the guarantee that script' content cannot be altered
> while being read and interpreted.  This is useful for generic distros
> that may not have a write-xor-execute policy.  See commit a5874fde3c08
> ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
>
> Both execve(2) and the IOCTL to enable fsverity can already set this
> property on files with deny_write_access().  This new O_DENY_WRITE make

The kernel actually tried to get rid of this behavior on execve() in
commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that had
to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
because it broke userspace assumptions.

> it widely available.  This is similar to what other OSs may provide
> e.g., opening a file with only FILE_SHARE_READ on Windows.

We used to have the analogous mmap() flag MAP_DENYWRITE, and that was
removed for security reasons; as
https://man7.org/linux/man-pages/man2/mmap.2.html says:

|        MAP_DENYWRITE
|               This flag is ignored.  (Long ago=E2=80=94Linux 2.0 and earl=
ier=E2=80=94it
|               signaled that attempts to write to the underlying file
|               should fail with ETXTBSY.  But this was a source of denial-
|               of-service attacks.)"

It seems to me that the same issue applies to your patch - it would
allow unprivileged processes to essentially lock files such that other
processes can't write to them anymore. This might allow unprivileged
users to prevent root from updating config files or stuff like that if
they're updated in-place.
