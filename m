Return-Path: <kernel-hardening-return-21972-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 04B6DC8303F
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 18:11:16 +0000 (UTC)
Received: (qmail 11568 invoked by uid 550); 25 Aug 2025 18:11:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11539 invoked from network); 25 Aug 2025 18:11:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756145458; x=1756750258; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f72AMp+CXzD5eYq7ijxL7Cpgy8ZEES5VfyxS8Suef1c=;
        b=HOgnwpqFmRZE+pymYD3AfGEeggJ25vOkRJ8qphWyrdlUCYaP0jp0ir0Z/JOTWS4837
         lYhWd8npX2pO6ppx6DrA32ux1sOoTwvjf/YSH6eDBuXWyymkjXpvrBphZWTae+zSZjHY
         N9IRv5KGXq0ThlVr6Jqs465LUc1KHV4UG/XPcSEqRNCu0NB0lRE+y8DcyoeN+JnoItj0
         KCuX8DInLECNVqw593CQUHdo9vDOUZmYuBc4IzZQCGpD4R7RUn+PyUa8lzSdVASb3S+5
         iAnkv7dLzZUVtoztWEwAyADqlIKZYHeXdnblSus9dQcsW4vYZMEHdtQASpLQf4GipsjY
         gVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756145458; x=1756750258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f72AMp+CXzD5eYq7ijxL7Cpgy8ZEES5VfyxS8Suef1c=;
        b=UjdeITJIh3CFXoHqubjy4ft8++SzEMCw/9fv+s/pcw5d88EzqK1AYhnTQgPndPT7LW
         Q8K3VPwjcgNYZuIh+NDHqK4mftItRllWl5Ag8MnsarkA6HUbewuIU44yaWrZZIGS95Qz
         DIQYJxamPAJIDEz9P0jJuUG/GhEdyCcsBsLr3Za2xTq+hgFegG1Ry/WOqeJnyIOTsgxb
         CO5gpa1BFBRJT25EYtroIOc60GJnv+M/Vpg78zLH6aUgsrmWYYBAijzoy74if8ddGAyv
         Pt2IlgGzULsP2uzfglv6lQwC8JQBvcGgQCPdigg41y+EIR9Yg/hT07iKm6gq1vmAlCjD
         TYzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnYoSa9fOcQsGQ24YZHBmngfKJ0wADwEoP3HaxP9uAM4lYpGNV/WFATxmuhPvw6CjrrOLVtslUsD4u13wCmKY5@lists.openwall.com
X-Gm-Message-State: AOJu0YwoFQwTfr+VQDCPwz4wTyVCWhYFdIy+HMigIupedsAFgwK4PN7j
	jEFxW34guIrISo5aZUUSgMEipz05wPiTamIDg5xDwsIGnd5vn0qxgaHQtHbeZq8k24Hxzl1v7ms
	a2SivT/F2fw56cvrMfyoicDKF8CoNF9gIZa0fXYCK
X-Gm-Gg: ASbGnctGQPqaUDym6aScAPv1K+cpGHy6Oxifq+CbwT56IOb0583+kyV3cioBB+i/jJ3
	U91Vx+uqFEg4t/QSNomgPte8plZC8tIU8Lb6xdBqQAqmE8+kzZthHmlS0hmPpHPL4ypArgfYKuh
	YDr9dGeuNtV9ZIISdDmrtq5EarH/RaydEpGtwHtTCaB+HNhVz3LTeHID7MfYJAiMtiSVhK0y9Rm
	SG7+zwk1HQuwUMDLllWUyA98D9Bc5NYD8WZSwTIFzo2
X-Google-Smtp-Source: AGHT+IEdzkmzQSE86sK/Re7Z3Y+S3h68XMMRvGS7u4Ul3xpIqcNPKL9CDchW0vRIxsbQVwF635c6eJCb0IgTL4iIJ34=
X-Received: by 2002:a05:600c:a102:b0:459:d7da:3179 with SMTP id
 5b1f17b1804b1-45b65f4e6ccmr13005e9.5.1756145458325; Mon, 25 Aug 2025 11:10:58
 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250822170800.2116980-2-mic@digikod.net>
 <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
 <20250824.Ujoh8unahy5a@digikod.net> <CALCETrWwd90qQ3U2nZg9Fhye6CMQ6ZF20oQ4ME6BoyrFd0t88Q@mail.gmail.com>
 <20250825.mahNeel0dohz@digikod.net> <CALCETrX+OpkRSvOZhaWiqOsAPr-hRb+kY5=Hh5LU3H+1xPb3qg@mail.gmail.com>
In-Reply-To: <CALCETrX+OpkRSvOZhaWiqOsAPr-hRb+kY5=Hh5LU3H+1xPb3qg@mail.gmail.com>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 25 Aug 2025 11:10:20 -0700
X-Gm-Features: Ac12FXyE5Uc9z6yYoKPiBcnlngqu1ThnovMVOVfP8SQyJlN2POaLvxRW9Wz9AP8
Message-ID: <CALmYWFvbcmrB6yDdi4_L-2iOaE216O3JTvtfMcwydHWR6ZVpEg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
To: Andy Lutomirski <luto@amacapital.net>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
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

On Mon, Aug 25, 2025 at 9:43=E2=80=AFAM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
> On Mon, Aug 25, 2025 at 2:31=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@dig=
ikod.net> wrote:
> >
> > On Sun, Aug 24, 2025 at 11:04:03AM -0700, Andy Lutomirski wrote:
> > > On Sun, Aug 24, 2025 at 4:03=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic=
@digikod.net> wrote:
> > > >
> > > > On Fri, Aug 22, 2025 at 09:45:32PM +0200, Jann Horn wrote:
> > > > > On Fri, Aug 22, 2025 at 7:08=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn =
<mic@digikod.net> wrote:
> > > > > > Add a new O_DENY_WRITE flag usable at open time and on opened f=
ile (e.g.
> > > > > > passed file descriptors).  This changes the state of the opened=
 file by
> > > > > > making it read-only until it is closed.  The main use case is f=
or script
> > > > > > interpreters to get the guarantee that script' content cannot b=
e altered
> > > > > > while being read and interpreted.  This is useful for generic d=
istros
> > > > > > that may not have a write-xor-execute policy.  See commit a5874=
fde3c08
> > > > > > ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
> > > > > >
> > > > > > Both execve(2) and the IOCTL to enable fsverity can already set=
 this
> > > > > > property on files with deny_write_access().  This new O_DENY_WR=
ITE make
> > > > >
> > > > > The kernel actually tried to get rid of this behavior on execve()=
 in
> > > > > commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that =
had
> > > > > to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
> > > > > because it broke userspace assumptions.
> > > >
> > > > Oh, good to know.
> > > >
> > > > >
> > > > > > it widely available.  This is similar to what other OSs may pro=
vide
> > > > > > e.g., opening a file with only FILE_SHARE_READ on Windows.
> > > > >
> > > > > We used to have the analogous mmap() flag MAP_DENYWRITE, and that=
 was
> > > > > removed for security reasons; as
> > > > > https://man7.org/linux/man-pages/man2/mmap.2.html says:
> > > > >
> > > > > |        MAP_DENYWRITE
> > > > > |               This flag is ignored.  (Long ago=E2=80=94Linux 2.=
0 and earlier=E2=80=94it
> > > > > |               signaled that attempts to write to the underlying=
 file
> > > > > |               should fail with ETXTBSY.  But this was a source =
of denial-
> > > > > |               of-service attacks.)"
> > > > >
> > > > > It seems to me that the same issue applies to your patch - it wou=
ld
> > > > > allow unprivileged processes to essentially lock files such that =
other
> > > > > processes can't write to them anymore. This might allow unprivile=
ged
> > > > > users to prevent root from updating config files or stuff like th=
at if
> > > > > they're updated in-place.
> > > >
> > > > Yes, I agree, but since it is the case for executed files I though =
it
> > > > was worth starting a discussion on this topic.  This new flag could=
 be
> > > > restricted to executable files, but we should avoid system-wide loc=
ks
> > > > like this.  I'm not sure how Windows handle these issues though.
> > > >
> > > > Anyway, we should rely on the access control policy to control writ=
e and
> > > > execute access in a consistent way (e.g. write-xor-execute).  Thank=
s for
> > > > the references and the background!
> > >
> > > I'm confused.  I understand that there are many contexts in which one
> > > would want to prevent execution of unapproved content, which might
> > > include preventing a given process from modifying some code and then
> > > executing it.
> > >
> > > I don't understand what these deny-write features have to do with it.
> > > These features merely prevent someone from modifying code *that is
> > > currently in use*, which is not at all the same thing as preventing
> > > modifying code that might get executed -- one can often modify
> > > contents *before* executing those contents.
> >
> > The order of checks would be:
> > 1. open script with O_DENY_WRITE
> > 2. check executability with AT_EXECVE_CHECK
> > 3. read the content and interpret it
>
> Hmm.  Common LSM configurations should be able to handle this without
> deny write, I think.  If you don't want a program to be able to make
> their own scripts, then don't allow AT_EXECVE_CHECK to succeed on a
> script that the program can write.
>
Yes, Common LSM could handle this, however, due to historic and app
backward compability reason, sometimes it is impossible to enforce
that kind of policy in practice, therefore as an alternative, a
machinism such as AT_EXECVE_CHECK is really useful.

> Keep in mind that trying to lock this down too hard is pointless for
> users who are allowed to to ptrace-write to their own processes.  Or
> for users who can do JIT, or for users who can run a REPL, etc.
>
The ptrace-write and /proc/pid/mem writing are on my radar, at least
for ChomeOS and Android.
AT_EXECVE_CHECK is orthogonal to those IMO, I hope eventually all
those paths will be hardened.

Thanks and regards,
-Jeff
