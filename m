Return-Path: <kernel-hardening-return-21822-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BF2CFC3DA49
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Jul 2024 13:48:09 +0000 (UTC)
Received: (qmail 19517 invoked by uid 550); 20 Jul 2024 13:47:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11710 invoked from network); 20 Jul 2024 11:44:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721475833;
	bh=rw4nH2UHgn5T7FRDMb5wZ9ureFZDCLODRd4xCi/HFpc=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=DsFuW5U2JLq70FLgSERfxYXkl0cHGvICJLn9KuagbTHWf6h7XZE/VxGyN6j5Xos4Q
	 rkURmlCbpNrvl+MAtXxU92bFrdFfQkgAtwbCwtR4xp8O/Fcsjp3UWKQs7B+DLZiGMy
	 3ISRBT76LPZmLU48ix5qAReV5Q+XsNs04GRmDD4cXNQKU/PmxF13YI+C/kC1PR9vMR
	 /NxLFPhv7MaDNuAAEgqGNtaWBAXpEz3dRsHFdRnM3y6JFAzjPhnis+2ryBi76OXHZ8
	 oeDCyJX9KFtgyW/0RNz4HFt74r7kvMM6M5v0OnCiYqnFSUcCqwuSV+0kSlegOEtjYo
	 MQyymRippIwDA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 20 Jul 2024 14:43:41 +0300
Message-Id: <D2UC8YVOX9WU.1DRD4QFQ92L1U@kernel.org>
Cc: "Steve Dower" <steve.dower@python.org>, "Jeff Xu" <jeffxu@google.com>,
 "Al Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Kees Cook" <keescook@chromium.org>, "Linus Torvalds"
 <torvalds@linux-foundation.org>, "Paul Moore" <paul@paul-moore.com>,
 "Theodore Ts'o" <tytso@mit.edu>, "Alejandro Colomar" <alx@kernel.org>,
 "Aleksa Sarai" <cyphar@cyphar.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Andy Lutomirski" <luto@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Casey Schaufler" <casey@schaufler-ca.com>,
 "Christian Heimes" <christian@python.org>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Eric Biggers" <ebiggers@kernel.org>, "Eric Chiang"
 <ericchiang@google.com>, "Fan Wu" <wufan@linux.microsoft.com>, "Florian
 Weimer" <fweimer@redhat.com>, "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "James Morris" <jamorris@linux.microsoft.com>, "Jan Kara" <jack@suse.cz>,
 "Jann Horn" <jannh@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Jordan
 R Abrahams" <ajordanr@google.com>, "Lakshmi Ramasubramanian"
 <nramas@linux.microsoft.com>, "Luca Boccassi" <bluca@debian.org>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>, "Matt Bobrowski"
 <mattbobrowski@google.com>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Miklos Szeredi"
 <mszeredi@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Nicolas
 Bouchinet" <nicolas.bouchinet@ssi.gouv.fr>, "Scott Shell"
 <scottsh@microsoft.com>, "Shuah Khan" <shuah@kernel.org>, "Stephen
 Rothwell" <sfr@canb.auug.org.au>, "Steve Grubb" <sgrubb@redhat.com>,
 "Thibaut Sautereau" <thibaut.sautereau@ssi.gouv.fr>, "Vincent Strubel"
 <vincent.strubel@ssi.gouv.fr>, "Xiaoming Ni" <nixiaoming@huawei.com>, "Yin
 Fengwei" <fengwei.yin@intel.com>, <kernel-hardening@lists.openwall.com>,
 <linux-api@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, "Elliott Hughes" <enh@google.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to
 execveat(2)
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Andy Lutomirski" <luto@amacapital.net>,
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
X-Mailer: aerc 0.17.0
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org>
 <20240717.AGh2shahc9ee@digikod.net>
 <CALCETrUcr3p_APNazMro7Y9FX1zLAiQESvKZ5BDgd8X3PoCdFw@mail.gmail.com>
 <20240718.Niexoo0ahch0@digikod.net>
 <CALCETrVVq4DJZ2q9V9TMuvZ1nb+-Qf4Eu8LVBgUy3XiTa=jFCQ@mail.gmail.com>
In-Reply-To: <CALCETrVVq4DJZ2q9V9TMuvZ1nb+-Qf4Eu8LVBgUy3XiTa=jFCQ@mail.gmail.com>

On Sat Jul 20, 2024 at 4:59 AM EEST, Andy Lutomirski wrote:
> > On Jul 18, 2024, at 8:22=E2=80=AFPM, Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
> >
> > =EF=BB=BFOn Thu, Jul 18, 2024 at 09:02:56AM +0800, Andy Lutomirski wrot=
e:
> >>>> On Jul 17, 2024, at 6:01=E2=80=AFPM, Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> >>>
> >>> On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
> >>>>> On 17/07/2024 07:33, Jeff Xu wrote:
> >>>>> Consider those cases: I think:
> >>>>> a> relying purely on userspace for enforcement does't seem to be
> >>>>> effective,  e.g. it is trivial  to call open(), then mmap() it into
> >>>>> executable memory.
> >>>>
> >>>> If there's a way to do this without running executable code that had=
 to pass
> >>>> a previous execveat() check, then yeah, it's not effective (e.g. a P=
ython
> >>>> interpreter that *doesn't* enforce execveat() is a trivial way to do=
 it).
> >>>>
> >>>> Once arbitrary code is running, all bets are off. So long as all arb=
itrary
> >>>> code is being checked itself, it's allowed to do things that would b=
ypass
> >>>> later checks (and it's up to whoever audited it in the first place t=
o
> >>>> prevent this by not giving it the special mark that allows it to pas=
s the
> >>>> check).
> >>>
> >>> Exactly.  As explained in the patches, one crucial prerequisite is th=
at
> >>> the executable code is trusted, and the system must provide integrity
> >>> guarantees.  We cannot do anything without that.  This patches series=
 is
> >>> a building block to fix a blind spot on Linux systems to be able to
> >>> fully control executability.
> >>
> >> Circling back to my previous comment (did that ever get noticed?), I
> >
> > Yes, I replied to your comments.  Did I miss something?
>
> I missed that email in the pile, sorry. I=E2=80=99ll reply separately.
>
> >
> >> don=E2=80=99t think this is quite right:
> >>
> >> https://lore.kernel.org/all/CALCETrWYu=3DPYJSgyJ-vaa+3BGAry8Jo8xErZLiG=
R3U5h6+U0tA@mail.gmail.com/
> >>
> >> On a basic system configuration, a given path either may or may not be
> >> executed. And maybe that path has some integrity check (dm-verity,
> >> etc).  So the kernel should tell the interpreter/loader whether the
> >> target may be executed. All fine.
> >>
> >> But I think the more complex cases are more interesting, and the
> >> =E2=80=9Cexecute a program=E2=80=9D process IS NOT BINARY.  An attempt=
 to execute can
> >> be rejected outright, or it can be allowed *with a change to creds or
> >> security context*.  It would be entirely reasonable to have a policy
> >> that allows execution of non-integrity-checked files but in a very
> >> locked down context only.
> >
> > I guess you mean to transition to a sandbox when executing an untrusted
> > file.  This is a good idea.  I talked about role transition in the
> > patch's description:
> >
> > With the information that a script interpreter is about to interpret a
> > script, an LSM security policy can adjust caller's access rights or log
> > execution request as for native script execution (e.g. role transition)=
.
> > This is possible thanks to the call to security_bprm_creds_for_exec().
>
> =E2=80=A6
>
> > This patch series brings the minimal building blocks to have a
> > consistent execution environment.  Role transitions for script executio=
n
> > are left to LSMs.  For instance, we could extend Landlock to
> > automatically sandbox untrusted scripts.
>
> I=E2=80=99m not really convinced.  There=E2=80=99s more to building an AP=
I that
> enables LSM hooks than merely sticking the hook somewhere in kernel
> code. It needs to be a defined API. If you call an operation =E2=80=9Cche=
ck=E2=80=9D,
> then people will expect it to check, not to change the caller=E2=80=99s
> credentials.  And people will mess it up in both directions (e.g.
> callers will call it and then open try to load some library that they
> should have loaded first, or callers will call it and forget to close
> fds first.
>
> And there should probably be some interaction with dumpable as well.
> If I =E2=80=9Ccheck=E2=80=9D a file for executability, that should not su=
ddenly allow
> someone to ptrace me?
>
> And callers need to know to exit on failure, not carry on.
>
>
> More concretely, a runtime that fully opts in to this may well "check"
> multiple things.  For example, if I do:
>
> $ ld.so ~/.local/bin/some_program   (i.e. I literally execve ld.so)
>
> then ld.so will load several things:
>
> ~/.local/bin/some_program
> libc.so
> other random DSOs, some of which may well be in my home directory

What would really help to comprehend this patch set would be a set of
test scripts, preferably something that you can run easily with
BuildRoot or similar.

Scripts would demonstrate the use cases for the patch set. Then it
would be easier to develop scripts that would underline the corner
cases. I would keep all this out of kselftest shenanigans for now.

I feel that the patch set is hovering in abstractions with examples
that you cannot execute.

I added the patches to standard test CI hack:

https://codeberg.org/jarkko/linux-tpmdd-test

But after I booted up a kernel I had no idea what to do with it. And
all this lenghty discussion makes it even more confusing.

Please find some connection to the real world before sending any new
version of this (e.g. via test scripts). I think this should not be
pulled before almost anyone doing kernel dev can comprehend the "gist"
at least in some reasonable level.

BR, Jarkko
