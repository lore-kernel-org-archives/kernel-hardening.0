Return-Path: <kernel-hardening-return-21973-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 5A52AC8303F
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 21:56:52 +0000 (UTC)
Received: (qmail 21992 invoked by uid 550); 25 Aug 2025 21:56:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21949 invoked from network); 25 Aug 2025 21:56:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1756158992; x=1756763792; darn=lists.openwall.com;
        h=to:cc:date:message-id:subject:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0vMUZfpgo6grl0jsKLi/4oV66VhEtUf3p7bHbykWpng=;
        b=iCCMjenvq4vyLz5I9fidLzQQbGb6CfVx+6+KPE4QmXN7CTNVKa857Xfya1Rx0Y7Fgo
         qOk2nYZS1fU+bZlodq6Upmk+WYXxomxcnv3bUBJip/M6dTjhmjK6R4Nhe4b+sn955rV4
         1FPESH6ZDa5n9e7oIovDrZMmwYJ7ESJlU/+MW/rIL1PjdAN8E/VQc6QQlksa2Reh8gGJ
         HkbA+TPtdRYZvW+0apisjGJK2pcbXqLS944wT1rjgTWiRS/1fgxpO+1MVr5Vdn03iS+P
         e2qevXWAUBtYa6z/xLYmSw6++ugfVnfn8a4r/3ezI9211KNh0PIdpO3a2Pc26e+i9Wi8
         o38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756158992; x=1756763792;
        h=to:cc:date:message-id:subject:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0vMUZfpgo6grl0jsKLi/4oV66VhEtUf3p7bHbykWpng=;
        b=g1E1gxqVGhipaRsNGugJZWRyPb5W1YSZTQ4aLW0D3W4QVRP+OMC6GyS34zWTR6je4V
         ZnRG73opAPsa3Sto61g5zJ0Nmp1d9NAlzDBqe6o6D6COwM6sf7crpTYxNmDc+eNHLtV8
         gKQTW4mFBcYfdAMP/O9JMnxAbsEMHRhT6gNWUsveZZgUkeMFd4NFNK8+wMJPgKvIsdI9
         /YUAT8nopqeoqw2chlMaxgigOwC1HWCih3mNCNSAxWGQKZlC1PrIcRNY7YWbaK0Ob8rF
         BSK9swhtyaJlT081R52oF8Fib0UVsosgLD5N6GmR3CqvevYOc+itvbgUcP65STh229Or
         wl5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCvRKhhdpQaY9Moi47EKkQGHNgVDkB+2xRodGApgQ7aXu6SMuwD98HYFHg6OuXWM65zYkI5ykIWu1eVxTc9MSV@lists.openwall.com
X-Gm-Message-State: AOJu0YzBmZPvR5bZL5BR4qRj2wE4rXIni+YLdHNcTbwmfa1Xjf4VGnpP
	zbZj/gQKSSy+ALuePiQzJlsJcdlOdmQnCSV56pxYJgxtVIeFEBy/ARgRqkeOtuh1ag==
X-Gm-Gg: ASbGncurXmqTMHNYZgpMNB/u7pdmtMeJN+2AjOe8hnA2ZAftq8BtQlAICL6qrj+br9M
	Hn++RWI3Ett2tXHaAKX62f0D4HX/UB2kIjxqH8O3lVoKFNoNaSKOh/KQymRyCkN+CijkiIPpOO7
	FXZinCmF0a9hJlC2rM6GCK4aPxoVoQoHyIlGHF4gvrlFVlW67nlZkbCQ5q8Toa4251VQgyEnf/H
	OROTthrwoFQJa+BcclmnXhaGGfupGrc4zgdQH4QA1pt5bZi1o32DJ8WFZV7OpuIMOZ0lOYFKONO
	cYjqPs3q4jh4zpUJbEFQKNkf02yJXKj/FKhKKhchMkWBe/gc97XqcyhfxoSuHmVjnRhhjKl3JRP
	XBhdAQKFkk0qPuoruM7JNS0zVMJ0PXSbyVYTAmj6oMutVpU9C
X-Google-Smtp-Source: AGHT+IH0zqh5am1c9LUhvOIUND3Fr27yx9vrRpjaozAjD1PSKH7Z/Iy6+QDwmQ4jNnG1UUqeW6IVzg==
X-Received: by 2002:a05:6830:2801:b0:744:f08e:4d30 with SMTP id 46e09a7af769-74500ae61e4mr8071485a34.35.1756158991618;
        Mon, 25 Aug 2025 14:56:31 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
Message-Id: <F0E70FC7-8DCE-4057-8E91-9FA1AC5BC758@amacapital.net>
Date: Mon, 25 Aug 2025 14:56:18 -0700
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Christian Heimes <christian@python.org>,
 Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
 Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Luca Boccassi <bluca@debian.org>,
 Matt Bobrowski <mattbobrowski@google.com>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>,
 Robert Waite <rowait@microsoft.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Scott Shell <scottsh@microsoft.com>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
To: Jeff Xu <jeffxu@google.com>
X-Mailer: iPhone Mail (22G100)

=EF=BB=BF
> On Aug 25, 2025, at 11:10=E2=80=AFAM, Jeff Xu <jeffxu@google.com> wrote:
>=20
> =EF=BB=BFOn Mon, Aug 25, 2025 at 9:43=E2=80=AFAM Andy Lutomirski <luto@ama=
capital.net> wrote:
>>> On Mon, Aug 25, 2025 at 2:31=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@di=
gikod.net> wrote:
>>> On Sun, Aug 24, 2025 at 11:04:03AM -0700, Andy Lutomirski wrote:
>>>> On Sun, Aug 24, 2025 at 4:03=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
>>>>> On Fri, Aug 22, 2025 at 09:45:32PM +0200, Jann Horn wrote:
>>>>>> On Fri, Aug 22, 2025 at 7:08=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic=
@digikod.net> wrote:
>>>>>>> Add a new O_DENY_WRITE flag usable at open time and on opened file (=
e.g.
>>>>>>> passed file descriptors).  This changes the state of the opened file=
 by
>>>>>>> making it read-only until it is closed.  The main use case is for sc=
ript
>>>>>>> interpreters to get the guarantee that script' content cannot be alt=
ered
>>>>>>> while being read and interpreted.  This is useful for generic distro=
s
>>>>>>> that may not have a write-xor-execute policy.  See commit a5874fde3c=
08
>>>>>>> ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
>>>>>>> Both execve(2) and the IOCTL to enable fsverity can already set this=

>>>>>>> property on files with deny_write_access().  This new O_DENY_WRITE m=
ake
>>>>>> The kernel actually tried to get rid of this behavior on execve() in
>>>>>> commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that had
>>>>>> to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
>>>>>> because it broke userspace assumptions.
>>>>> Oh, good to know.
>>>>>>> it widely available.  This is similar to what other OSs may provide
>>>>>>> e.g., opening a file with only FILE_SHARE_READ on Windows.
>>>>>> We used to have the analogous mmap() flag MAP_DENYWRITE, and that was=

>>>>>> removed for security reasons; as
>>>>>> https://man7.org/linux/man-pages/man2/mmap.2.html says:
>>>>>> |        MAP_DENYWRITE
>>>>>> |               This flag is ignored.  (Long ago=E2=80=94Linux 2.0 an=
d earlier=E2=80=94it
>>>>>> |               signaled that attempts to write to the underlying fil=
e
>>>>>> |               should fail with ETXTBSY.  But this was a source of d=
enial-
>>>>>> |               of-service attacks.)"
>>>>>> It seems to me that the same issue applies to your patch - it would
>>>>>> allow unprivileged processes to essentially lock files such that othe=
r
>>>>>> processes can't write to them anymore. This might allow unprivileged
>>>>>> users to prevent root from updating config files or stuff like that i=
f
>>>>>> they're updated in-place.
>>>>> Yes, I agree, but since it is the case for executed files I though it
>>>>> was worth starting a discussion on this topic.  This new flag could be=

>>>>> restricted to executable files, but we should avoid system-wide locks
>>>>> like this.  I'm not sure how Windows handle these issues though.
>>>>> Anyway, we should rely on the access control policy to control write a=
nd
>>>>> execute access in a consistent way (e.g. write-xor-execute).  Thanks f=
or
>>>>> the references and the background!
>>>> I'm confused.  I understand that there are many contexts in which one
>>>> would want to prevent execution of unapproved content, which might
>>>> include preventing a given process from modifying some code and then
>>>> executing it.
>>>> I don't understand what these deny-write features have to do with it.
>>>> These features merely prevent someone from modifying code *that is
>>>> currently in use*, which is not at all the same thing as preventing
>>>> modifying code that might get executed -- one can often modify
>>>> contents *before* executing those contents.
>>> The order of checks would be:
>>> 1. open script with O_DENY_WRITE
>>> 2. check executability with AT_EXECVE_CHECK
>>> 3. read the content and interpret it
>> Hmm.  Common LSM configurations should be able to handle this without
>> deny write, I think.  If you don't want a program to be able to make
>> their own scripts, then don't allow AT_EXECVE_CHECK to succeed on a
>> script that the program can write.
> Yes, Common LSM could handle this, however, due to historic and app
> backward compability reason, sometimes it is impossible to enforce
> that kind of policy in practice, therefore as an alternative, a
> machinism such as AT_EXECVE_CHECK is really useful.

Can you clarify?  I=E2=80=99m suspicious that we=E2=80=99re taking past each=
 other.

AT_EXECVE_CHECK solves a problem that there are actions that effectively =E2=
=80=9Cexecute=E2=80=9D a file that don=E2=80=99t execute literal CPU instruc=
tions for it. Sometimes open+read has the effect of interpreting the content=
s of the file as something code-like.

But, as I see it, deny-write is almost entirely orthogonal. If you open a fi=
le with the intent of executing it (mmap-execute or interpret =E2=80=94 make=
s little practical difference here), then the kernel can enforce some policy=
. If the file is writable by a process that ought not have permission to exe=
cute code in the context of the opening-for-execute process, then LSMs need d=
eny-write to be enforced so that they can verify the contents at the time of=
 opening.

But let=E2=80=99s step back a moment: is there any actual sensible security p=
olicy that does this?  If I want to *enforce* that a process only execute ap=
proved code, then wouldn=E2=80=99t I do it be only allowing executing files t=
hat the process can=E2=80=99t write?

The reason that the removal of deny-write wasn=E2=80=99t security =E2=80=94 i=
t was a functionality issue: a linker accidentally modified an in-use binary=
. If you have permission to use gcc or lld, etc to create binaries, and you h=
ave permission to run them, then you pretty much have permission to run what=
ever code you like.

So, if there=E2=80=99s a real security use case for deny-write, I=E2=80=99m s=
till not seeing it.

>> Keep in mind that trying to lock this down too hard is pointless for
>> users who are allowed to to ptrace-write to their own processes.  Or
>> for users who can do JIT, or for users who can run a REPL, etc.
> The ptrace-write and /proc/pid/mem writing are on my radar, at least
> for ChomeOS and Android.
> AT_EXECVE_CHECK is orthogonal to those IMO, I hope eventually all
> those paths will be hardened.
>=20
> Thanks and regards,
> -Jeff
