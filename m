Return-Path: <kernel-hardening-return-21971-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A3D40CA0FE7
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 17:58:55 +0000 (UTC)
Received: (qmail 9491 invoked by uid 550); 25 Aug 2025 17:58:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9424 invoked from network); 25 Aug 2025 17:58:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756144715; x=1756749515; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5yo9Tha3EYZ7QDWhjTh1gNp5eXSF1E//nUjICwrq4k=;
        b=nHs+VJ5cgu4sEXPAMG5mIWBJL1Y6Vuzx900Z7pkEx2H3yGRdp+ePR5ABW4aif2CoTM
         e1q+B2PN34+6QVz3sQuyLjPm3YJOXPVnoMONn3CwleuBkLyhtUl3B4L8XbOKIkUha8qz
         cxQTihTF1B5NxziN2H8tHOcqh/TduMZGqWRAeC0s7GoCZlYDiXdOm6ToRef8ZaIp1l63
         /gOVnCNsk9HhKbfwnqSasF59FMD5uzmJ4KUWFp32jDSC8AAwj+DL2tDbZ6hKtmZTFLY/
         vVt87ng8ZkqUwgvGjrlu6qD4x4cgo11icCRIgvbz+xyZ/QUfPGdnjD/e/dDNPP11jShj
         WaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756144715; x=1756749515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5yo9Tha3EYZ7QDWhjTh1gNp5eXSF1E//nUjICwrq4k=;
        b=FMFbiKVuoAeLzBrjQEk5y6/pKMq7xQXBLS1Emj0LqD/PgNhpm/Apb6bGKUfMEZv3pB
         XPHcwup/7XaHqGXW9L5zA4+laJQ5+MccwRN6/H/F8lQ4jbJO4GsVcW06zGOxF+lwSrR5
         9iQ5wMp4p7LKkMtiUMWofZ+hrDcpO1BFak0txgZ/Lb627sl8O+aqxpDA+zZu94spBQ/l
         714ntbxTw8SXcYZ74HV5QoJe0SX8jN6A006YhsSa/OThoRn68yGa8RmH+93Nv1vt85ne
         sUYQyYIV+td1Uca4oNGNH5+phqbVxubfodfmBKrLObHhLDaYzcJ8qk/hk4leSjMkoOtG
         TVqA==
X-Forwarded-Encrypted: i=1; AJvYcCVdQgOcLKRB7arzAId1a3axOLQQhCE8G3u9oKWkIimhq0Z29vdTIotzfC0mezatPLWa/Ir45QNgIYmztgtGh9Wd@lists.openwall.com
X-Gm-Message-State: AOJu0Yy2y4fYIBzs7UK5z6veGot0wpEgB2/Ho14RgHAojyL1lMmTJyV5
	/gGj3Rh9dDgLvGtAgaIdnTbC8IW5d0FxbVteuNIrdT6I2wEJGQf1KpoKtm1g5iy4y9iAGyFa87P
	bD7KV2RGw+z43epU/KXApL1vEGRSjtfmU6dAxgp+H
X-Gm-Gg: ASbGncuSRjich2ZBNnY8JllhxDa4p4G9pJQCiDzfLejCXeZk9sj5nFOyYh9APtwG5zP
	NPr7d3XXbLGtVv8Z8zIg8FlbpmZOan74poICJDShNyhmHFnC6yiEo1BXd7Mqf0ej4YQVfk4mh1D
	suavP8zKWbipuTVWy7qxPtrf2vRpEXkXqLIk64IB0whyrhBQCHhaDdzAHUiwyXdVyPnW9rqoVG/
	fWcL8Mwmtw6xCzZ2hTv/E6Zr5R5rQJatdg9gC2VzIoP
X-Google-Smtp-Source: AGHT+IGoEbuuaQmf6ejPreW/3EnO6Pdxa5HefL1xaCUoTpRbYEOTACur/ikE7cpdM/TuCFok1aNUpgjgLfri4GxZboA=
X-Received: by 2002:a05:600c:3b9f:b0:439:8f59:2c56 with SMTP id
 5b1f17b1804b1-45b65e97671mr61125e9.2.1756144714893; Mon, 25 Aug 2025 10:58:34
 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250822170800.2116980-2-mic@digikod.net>
 <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
 <20250824.Ujoh8unahy5a@digikod.net> <CALCETrWwd90qQ3U2nZg9Fhye6CMQ6ZF20oQ4ME6BoyrFd0t88Q@mail.gmail.com>
 <20250825.mahNeel0dohz@digikod.net>
In-Reply-To: <20250825.mahNeel0dohz@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 25 Aug 2025 10:57:57 -0700
X-Gm-Features: Ac12FXxz9pJE0h6HrBGgWJl3z0z4f3e-FfLHbDFV9MrECVyOF6U4dJWEVdkn5yM
Message-ID: <CALmYWFv90uzq0J76+xtUFjZxDzR2rYvrFbrr5Jva5zdy_dvoHA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Jeff Xu <jeffxu@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Micka=C3=ABl

On Mon, Aug 25, 2025 at 2:31=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Sun, Aug 24, 2025 at 11:04:03AM -0700, Andy Lutomirski wrote:
> > On Sun, Aug 24, 2025 at 4:03=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Fri, Aug 22, 2025 at 09:45:32PM +0200, Jann Horn wrote:
> > > > On Fri, Aug 22, 2025 at 7:08=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > > Add a new O_DENY_WRITE flag usable at open time and on opened fil=
e (e.g.
> > > > > passed file descriptors).  This changes the state of the opened f=
ile by
> > > > > making it read-only until it is closed.  The main use case is for=
 script
> > > > > interpreters to get the guarantee that script' content cannot be =
altered
> > > > > while being read and interpreted.  This is useful for generic dis=
tros
> > > > > that may not have a write-xor-execute policy.  See commit a5874fd=
e3c08
> > > > > ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
> > > > >
> > > > > Both execve(2) and the IOCTL to enable fsverity can already set t=
his
> > > > > property on files with deny_write_access().  This new O_DENY_WRIT=
E make
> > > >
> > > > The kernel actually tried to get rid of this behavior on execve() i=
n
> > > > commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that ha=
d
> > > > to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
> > > > because it broke userspace assumptions.
> > >
> > > Oh, good to know.
> > >
> > > >
> > > > > it widely available.  This is similar to what other OSs may provi=
de
> > > > > e.g., opening a file with only FILE_SHARE_READ on Windows.
> > > >
> > > > We used to have the analogous mmap() flag MAP_DENYWRITE, and that w=
as
> > > > removed for security reasons; as
> > > > https://man7.org/linux/man-pages/man2/mmap.2.html says:
> > > >
> > > > |        MAP_DENYWRITE
> > > > |               This flag is ignored.  (Long ago=E2=80=94Linux 2.0 =
and earlier=E2=80=94it
> > > > |               signaled that attempts to write to the underlying f=
ile
> > > > |               should fail with ETXTBSY.  But this was a source of=
 denial-
> > > > |               of-service attacks.)"
> > > >
> > > > It seems to me that the same issue applies to your patch - it would
> > > > allow unprivileged processes to essentially lock files such that ot=
her
> > > > processes can't write to them anymore. This might allow unprivilege=
d
> > > > users to prevent root from updating config files or stuff like that=
 if
> > > > they're updated in-place.
> > >
> > > Yes, I agree, but since it is the case for executed files I though it
> > > was worth starting a discussion on this topic.  This new flag could b=
e
> > > restricted to executable files, but we should avoid system-wide locks
> > > like this.  I'm not sure how Windows handle these issues though.
> > >
> > > Anyway, we should rely on the access control policy to control write =
and
> > > execute access in a consistent way (e.g. write-xor-execute).  Thanks =
for
> > > the references and the background!
> >
> > I'm confused.  I understand that there are many contexts in which one
> > would want to prevent execution of unapproved content, which might
> > include preventing a given process from modifying some code and then
> > executing it.
> >
> > I don't understand what these deny-write features have to do with it.
> > These features merely prevent someone from modifying code *that is
> > currently in use*, which is not at all the same thing as preventing
> > modifying code that might get executed -- one can often modify
> > contents *before* executing those contents.
>
> The order of checks would be:
> 1. open script with O_DENY_WRITE
> 2. check executability with AT_EXECVE_CHECK
> 3. read the content and interpret it
>
I'm not sure about the O_DENY_WRITE approach, but the problem is worth solv=
ing.

AT_EXECVE_CHECK is not just for scripting languages. It could also
work with bytecodes like Java, for example. If we let the Java runtime
call AT_EXECVE_CHECK before loading the bytecode, the LSM could
develop a policy based on that.

> The deny-write feature was to guarantee that there is no race condition
> between step 2 and 3.  All these checks are supposed to be done by a
> trusted interpreter (which is allowed to be executed).  The
> AT_EXECVE_CHECK call enables the caller to know if the kernel (and
> associated security policies) allowed the *current* content of the file
> to be executed.  Whatever happen before or after that (wrt.
> O_DENY_WRITE) should be covered by the security policy.
>
Agree, the race problem needs to be solved in order for AT_EXECVE_CHECK.

Enforcing non-write for the path that stores scripts or bytecodes can
be challenging due to historical or backward compatibility reasons.
Since AT_EXECVE_CHECK provides a mechanism to check the file right
before it is used, we can assume it will detect any "problem" that
happened before that, (e.g. the file was overwritten). However, that
also imposes two additional requirements:
1> the file doesn't change while AT_EXECVE_CHECK does the check.
2>The file content kept by the process remains unchanged after passing
the AT_EXECVE_CHECK.

I imagine, the complete solution for AT_EXECVE_CHECK would include
those two grantees.

Thanks
-Jeff
