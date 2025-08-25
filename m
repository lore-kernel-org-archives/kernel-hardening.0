Return-Path: <kernel-hardening-return-21974-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 4D513CA0FE7
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 23:07:35 +0000 (UTC)
Received: (qmail 11635 invoked by uid 550); 25 Aug 2025 23:07:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11606 invoked from network); 25 Aug 2025 23:07:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756163234; x=1756768034; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+L5AsGrJuImxDbD9S66ptTgGaLweygGmtz10pt7M4KI=;
        b=MH10qnws6HqW3nj1aiG44w5FzP8XAOPr7ePi897EwYXxRiGke2Dzet55wUM75XBu2I
         N3SOIuOqwlYYLSWfJpiKNZ98eTIi/DxuNfsCXz1nTE6F+zplteyitnsrGtRpJpdkuNv9
         ejvHQrZjfTTyS7dFdIhRoMPMwa2nU+kATMAuEGbHdIZ/EN/ZGKu0B02EABqMtqJKhZuE
         PZF8VJRe5ryoUv7wtxJsg+J46SbJx/VgpESzHTnh7OwTfagkg9cLtFRAgbjJgXsLRyms
         uREY/U1B6SAaBdC1GXp8xauTqtK5gUDTc54axAvVkaE3nvZINFNaDuM6RxfiH/WBzGWX
         aZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756163234; x=1756768034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+L5AsGrJuImxDbD9S66ptTgGaLweygGmtz10pt7M4KI=;
        b=GPDrXBb28BGJGOMxhLrLILfKnceAaT9p4oOhHhipQnob+fJyQ9VwGO35vp559EK5kU
         tO30bHh6cERe6F0IhMgJXu/E8Bg+cL+csI8wfHzvM/zReFRbqLBGwMazYAJD3cJy56Lv
         X3+dpvDs9EGC4Oa5irbFMOGw5zD8mvPhMq5WusX1nlKUBbDT1T/zlG6OJ/BqA4/76o8b
         4V+J6LVDo9dBro9m+XygywagCV5ynUByAeaDsZbtv/iGCNdS+lZcj3vwax4B3BqCZKGC
         XNPqVbguTU0oLKVokKwUDPPNI/dqnzqEwN0TquZiNjhEmV/s7YkE4693i1c9I+/oS9Lw
         PuIw==
X-Forwarded-Encrypted: i=1; AJvYcCWCmR9xI0FkhT2uhL7l3jG3sQbmkKvaSl0Mph6FRxaEmzM3KdZR73vVOyl46kp3P+URLHMZ25wxL5M6qd6gbaI/@lists.openwall.com
X-Gm-Message-State: AOJu0Yw2OPJRMTnaRlBig2lzviloc49FkpmHh8ujOLKvHmsG13reTCLM
	LrT1uofhtQ5uZd74zOF5OCRLU9078zugwMfX9HM05k04veQ5tY0egZ2aMoc6a9a1ivjv3ySkjEB
	6ByW+NNWWCjh08a1iNY/PL71yRSzBuiM1nYaFQgN0
X-Gm-Gg: ASbGncs23tvCLkq2U92r72Z8Xil7oU+RCphGe1+8tKNrNsQHZjFqxXt/YXyFyDfv8KQ
	JDOFMiwng/ugzlepBVaLzz/ORMPmC9iZXHb9lHkykZbBnwlFXFqJY3p06OeBpiVJm+mafi3lD/j
	nViXCFU8vUtbbkmeHnty39razikSswufW/ljpdeGZlqH/mRc0DuuqsSQeM7EA4Ksw7tpgw0EQxp
	9jKoceB8RMzK3AsToZg5I1517Z49JhZqnALDz0hlkbs
X-Google-Smtp-Source: AGHT+IHIdI2gVCWLS0AakXMTgfvOfywSQxcckFQOuk+b+Ouf9TyXhvGefpAayJFTAxmqY/j4TP3DjIWphxCApJMvrZE=
X-Received: by 2002:a05:600c:793:b0:442:feea:622d with SMTP id
 5b1f17b1804b1-45b669691bcmr131075e9.1.1756163233954; Mon, 25 Aug 2025
 16:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <F0E70FC7-8DCE-4057-8E91-9FA1AC5BC758@amacapital.net>
In-Reply-To: <F0E70FC7-8DCE-4057-8E91-9FA1AC5BC758@amacapital.net>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 25 Aug 2025 16:06:34 -0700
X-Gm-Features: Ac12FXyT_7DxME9htDUZJHRjmIirfag-BknO_I14rcxQwO3Vxf2xOZIPpcG4k04
Message-ID: <CALmYWFuijKhKO+xOJfcLT2OQnJJTC1WrNG5yevLdRBNdVtWcUA@mail.gmail.com>
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

On Mon, Aug 25, 2025 at 2:56=E2=80=AFPM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
>
> > On Aug 25, 2025, at 11:10=E2=80=AFAM, Jeff Xu <jeffxu@google.com> wrote=
:
> >
> > =EF=BB=BFOn Mon, Aug 25, 2025 at 9:43=E2=80=AFAM Andy Lutomirski <luto@=
amacapital.net> wrote:
> >>> On Mon, Aug 25, 2025 at 2:31=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic=
@digikod.net> wrote:
> >>> On Sun, Aug 24, 2025 at 11:04:03AM -0700, Andy Lutomirski wrote:
> >>>> On Sun, Aug 24, 2025 at 4:03=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mi=
c@digikod.net> wrote:
> >>>>> On Fri, Aug 22, 2025 at 09:45:32PM +0200, Jann Horn wrote:
> >>>>>> On Fri, Aug 22, 2025 at 7:08=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <=
mic@digikod.net> wrote:
> >>>>>>> Add a new O_DENY_WRITE flag usable at open time and on opened fil=
e (e.g.
> >>>>>>> passed file descriptors).  This changes the state of the opened f=
ile by
> >>>>>>> making it read-only until it is closed.  The main use case is for=
 script
> >>>>>>> interpreters to get the guarantee that script' content cannot be =
altered
> >>>>>>> while being read and interpreted.  This is useful for generic dis=
tros
> >>>>>>> that may not have a write-xor-execute policy.  See commit a5874fd=
e3c08
> >>>>>>> ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
> >>>>>>> Both execve(2) and the IOCTL to enable fsverity can already set t=
his
> >>>>>>> property on files with deny_write_access().  This new O_DENY_WRIT=
E make
> >>>>>> The kernel actually tried to get rid of this behavior on execve() =
in
> >>>>>> commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that h=
ad
> >>>>>> to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
> >>>>>> because it broke userspace assumptions.
> >>>>> Oh, good to know.
> >>>>>>> it widely available.  This is similar to what other OSs may provi=
de
> >>>>>>> e.g., opening a file with only FILE_SHARE_READ on Windows.
> >>>>>> We used to have the analogous mmap() flag MAP_DENYWRITE, and that =
was
> >>>>>> removed for security reasons; as
> >>>>>> https://man7.org/linux/man-pages/man2/mmap.2.html says:
> >>>>>> |        MAP_DENYWRITE
> >>>>>> |               This flag is ignored.  (Long ago=E2=80=94Linux 2.0=
 and earlier=E2=80=94it
> >>>>>> |               signaled that attempts to write to the underlying =
file
> >>>>>> |               should fail with ETXTBSY.  But this was a source o=
f denial-
> >>>>>> |               of-service attacks.)"
> >>>>>> It seems to me that the same issue applies to your patch - it woul=
d
> >>>>>> allow unprivileged processes to essentially lock files such that o=
ther
> >>>>>> processes can't write to them anymore. This might allow unprivileg=
ed
> >>>>>> users to prevent root from updating config files or stuff like tha=
t if
> >>>>>> they're updated in-place.
> >>>>> Yes, I agree, but since it is the case for executed files I though =
it
> >>>>> was worth starting a discussion on this topic.  This new flag could=
 be
> >>>>> restricted to executable files, but we should avoid system-wide loc=
ks
> >>>>> like this.  I'm not sure how Windows handle these issues though.
> >>>>> Anyway, we should rely on the access control policy to control writ=
e and
> >>>>> execute access in a consistent way (e.g. write-xor-execute).  Thank=
s for
> >>>>> the references and the background!
> >>>> I'm confused.  I understand that there are many contexts in which on=
e
> >>>> would want to prevent execution of unapproved content, which might
> >>>> include preventing a given process from modifying some code and then
> >>>> executing it.
> >>>> I don't understand what these deny-write features have to do with it=
.
> >>>> These features merely prevent someone from modifying code *that is
> >>>> currently in use*, which is not at all the same thing as preventing
> >>>> modifying code that might get executed -- one can often modify
> >>>> contents *before* executing those contents.
> >>> The order of checks would be:
> >>> 1. open script with O_DENY_WRITE
> >>> 2. check executability with AT_EXECVE_CHECK
> >>> 3. read the content and interpret it
> >> Hmm.  Common LSM configurations should be able to handle this without
> >> deny write, I think.  If you don't want a program to be able to make
> >> their own scripts, then don't allow AT_EXECVE_CHECK to succeed on a
> >> script that the program can write.
> > Yes, Common LSM could handle this, however, due to historic and app
> > backward compability reason, sometimes it is impossible to enforce
> > that kind of policy in practice, therefore as an alternative, a
> > machinism such as AT_EXECVE_CHECK is really useful.
>
> Can you clarify?  I=E2=80=99m suspicious that we=E2=80=99re taking past e=
ach other.
>
Apology, my response isn't clear.

> AT_EXECVE_CHECK solves a problem that there are actions that effectively =
=E2=80=9Cexecute=E2=80=9D a file that don=E2=80=99t execute literal CPU ins=
tructions for it. Sometimes open+read has the effect of interpreting the co=
ntents of the file as something code-like.
>
Yes. We have the same understanding of this.
As an example, shell script or java byte code, their file permission
can be rw, but no x bit set. The interpreter reads those and executes
them.

> But, as I see it, deny-write is almost entirely orthogonal. If you open a=
 file with the intent of executing it (mmap-execute or interpret =E2=80=94 =
makes little practical difference here), then the kernel can enforce some p=
olicy. If the file is writable by a process that ought not have permission =
to execute code in the context of the opening-for-execute process, then LSM=
s need deny-write to be enforced so that they can verify the contents at th=
e time of opening.
>
> But let=E2=80=99s step back a moment: is there any actual sensible securi=
ty policy that does this?  If I want to *enforce* that a process only execu=
te approved code, then wouldn=E2=80=99t I do it be only allowing executing =
files that the process can=E2=80=99t write?
>
I imagine the following situation: an app has both "rw" access to the
file that holds the script code, the "w" is needed because the app
updates the script sometimes.

What is a reasonable sandbox solution for such an app? There are maybe
two options:

1> split the app as two processes: processA has "w" access to the
script for updating when needed. Process B has "r" access but no "w",
for executing. ProcessA and ProcessB will coordinate to avoid racing
on the script update.

2> The process will use AT_EXECVE_CHECK (added by interpreter) to
validate the file before opening , and the file content held by the
process should be immutable while being validated and executed later
by interpreter.

option 1 is the ideal, and IIUC, you promote this too. However, that
requires refactoring the app as two processes.
option 2 is an alternative. Because it doesn't require the change from
the apps, therefore a solution worth considering.

> The reason that the removal of deny-write wasn=E2=80=99t security =E2=80=
=94 it was a functionality issue: a linker accidentally modified an in-use =
binary. If you have permission to use gcc or lld, etc to create binaries, a=
nd you have permission to run them, then you pretty much have permission to=
 run whatever code you like.
>
> So, if there=E2=80=99s a real security use case for deny-write, I=E2=80=
=99m still not seeing it.
>
Although the current patch might not be ideal due to the potential DOS
attack, it does offer a starting point to address the needs. Let's
continue the discussion based on this patch and explore different
ideas.

Thanks and regards,
-Jeff

> >> Keep in mind that trying to lock this down too hard is pointless for
> >> users who are allowed to to ptrace-write to their own processes.  Or
> >> for users who can do JIT, or for users who can run a REPL, etc.
> > The ptrace-write and /proc/pid/mem writing are on my radar, at least
> > for ChomeOS and Android.
> > AT_EXECVE_CHECK is orthogonal to those IMO, I hope eventually all
> > those paths will be hardened.
> >
> > Thanks and regards,
> > -Jeff
