Return-Path: <kernel-hardening-return-21970-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C5586CA0EFA
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 16:44:14 +0000 (UTC)
Received: (qmail 30511 invoked by uid 550); 25 Aug 2025 16:43:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28511 invoked from network); 25 Aug 2025 16:43:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1756140224; x=1756745024; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PLv6y/UhSOB8bdOkGYyaQMgyRuq9HEBdk6Xh5IVulM=;
        b=u0IPdn4BtjA8T19IDExpMMp1G4wTwWJ1w9/jWjPwwKwcDbzgh96Js8iPKiLXg8HdN3
         BCFiKhqn8xYy9AJicdwO9HDgGGhnG5c6AR//Qpqoi/tFudZEhBilo7Kg4U3fuLSmL8GR
         6yYZMQOcRw3iEnqD+PE8xDCxDc2HniBFaM547jj4c/nZW7Ppcks/esIDa+yed4IGjmM8
         7QdXJwOWwk8MJ1wE44hykNcwrUrNl+fTkm4wZgRNAHqLSVnaQCxgq6LzNFkQyBkkBkOU
         u5nMNfQ8gL7x1Ab/3GV5nyJNqMWZzLAsnNC27H8AvgMwqFAquKGqgyptBJTd+nqlZgz5
         x4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756140224; x=1756745024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PLv6y/UhSOB8bdOkGYyaQMgyRuq9HEBdk6Xh5IVulM=;
        b=cdpv/Y6u5sdAvvFT47l4l20GcXVh1+q35WDQVRgFvcf521XGCC9C50hnOdGPjW9Rpf
         seF8fT6H7KzoNkOYQ1az5NV1aOzjt/0QhDpw0thZ185KuJ7/o5UMSl+tmoE9xKwerDXD
         w2/VHpppmAfH91+R6m/mMkHLnoILVo887EjOuD2so2MDsg7y7JOnq33m8OERhX8IP/gx
         1PhVJrp7rsS88tWDCjykXA+1R6LyaP4Oxv0GPEYDDH7w73ZYvHA4b+Gnz2x9OyM/YJSE
         E211CoxLLdWc1KsjaDvNPPSE5CzteRoh/de/wfmppzW52ES4jIXQQBXUX0Q2dhLHeVPy
         mHgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQsbhiiFBNcxCDjIfUqo/iEH+z3E9EIUFDb7LBr56BKvppBnvfAbMn1fNeAnAA6JG6xZU8HhXZ0NBAqzlQzho+@lists.openwall.com
X-Gm-Message-State: AOJu0YxLeo/UyuyVP2DMLAlFE/dQ/gy+XTOROBmw3Qou7A/Yaai5m0gC
	u++vn4MXcqLqPgErPjeDuCZ+aqUTpFuMGWNyyece/fy/oXfCvomyOuYkKiFhRuypEmZ/zLgutUf
	u0a4Jh1jkJwhzLQ0rpQMBwwHPe4Y5qtHHyFPMOvRy
X-Gm-Gg: ASbGncvrBLZgs5n34I28nAN198zZ55dtmNVr59ETJthCKqkNZAa6TGe/fvaD7CWKCBE
	aZieg8RFnIUFIGGMM6IKPUet6vOgqvpfKgbZ8GYmVVkb6vDLuI8+nHACfRSO+F+jrIiXquLB0Rz
	xBfNo/5hG5m5ox5Op5NCk2LWd5sOsFiX5Cce7mBjp06BYfaOrmAiLjdxkTimoxa64j38/fq9JHy
	4zktg==
X-Google-Smtp-Source: AGHT+IEMdqK/C2LpKtNe8HwPygFUadpsqtunEn/HXVLtMBboXyEX1vSk+kxH2wVSUzVD8p+wSlL+I8mi2gjoh9eWb18=
X-Received: by 2002:a2e:a018:0:b0:330:d981:1755 with SMTP id
 38308e7fff4ca-33650de81e9mr24090271fa.6.1756140223780; Mon, 25 Aug 2025
 09:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250822170800.2116980-2-mic@digikod.net>
 <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
 <20250824.Ujoh8unahy5a@digikod.net> <CALCETrWwd90qQ3U2nZg9Fhye6CMQ6ZF20oQ4ME6BoyrFd0t88Q@mail.gmail.com>
 <20250825.mahNeel0dohz@digikod.net>
In-Reply-To: <20250825.mahNeel0dohz@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Aug 2025 09:43:31 -0700
X-Gm-Features: Ac12FXyB6lzRP1sYgoa00swEucBzjGB4o1VKS2fSTUJC8HJqzdooeCFOZN6Irw4
Message-ID: <CALCETrX+OpkRSvOZhaWiqOsAPr-hRb+kY5=Hh5LU3H+1xPb3qg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
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
	Jeff Xu <jeffxu@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

Hmm.  Common LSM configurations should be able to handle this without
deny write, I think.  If you don't want a program to be able to make
their own scripts, then don't allow AT_EXECVE_CHECK to succeed on a
script that the program can write.

Keep in mind that trying to lock this down too hard is pointless for
users who are allowed to to ptrace-write to their own processes.  Or
for users who can do JIT, or for users who can run a REPL, etc.

> > But maybe a less kludgy version could be used for real.  What if there
> > was a syscall that would take an fd and make a snapshot of the file?
>
> Yes, that would be a clean solution.  I don't think this is achievable
> in an efficient way without involving filesystem implementations though.

It wouldn't be so terrible to involve filesystem implementations.
Most of the filesystems that people who care at all about security run
their binaries from either support reflinks or are immutable.  Things
like OCI implementations may already fit meet those criteria, and it
would be pretty nifty if the kernel was actually aware that OCI layers
are intended to be immutable.  We could even have an API to
generically query the hash of an immutable file and to ask the kernel
if it's validating the hash on reads.
