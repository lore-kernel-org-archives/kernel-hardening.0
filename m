Return-Path: <kernel-hardening-return-21820-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C1391C3DA5D
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Jul 2024 02:00:09 +0000 (UTC)
Received: (qmail 18182 invoked by uid 550); 20 Jul 2024 01:59:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18157 invoked from network); 20 Jul 2024 01:59:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1721440785; x=1722045585; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hF0Wt/38bKIJqW5oK7QO5iRqmAOtacgZ7FH0L0aMp3Y=;
        b=x/Mx3xDlpjJzZ4TpOW/0OSI5UdYsAIqsahI81hgRAuv77fTXy/p5eGftpc15omObz8
         y40imJoNK025pjzm6xbNV3qYj2WpLJeGJPpXcUyNI9ujigG/wqZhfD+kkPt2slZ2Capr
         6yUTSo/q4F3cMCy0vuRiAjuukGC/mZMe/6lqk38/XMfZkQc5PPgO2KhmJVGeLWTp8xZJ
         CzOkzyD+6tLoUViK3HESFjEGIQSM1/ZAoZR9WI+m8p8GnBdmTOt7d4oTSG4KQ9ylwFBP
         ADBbObAgLdcCCDI2pQvadYQrHs2iwfKR9jxqkjArW0dajPBEcRjgYI5kjJN5fvg+jDAK
         8wVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721440785; x=1722045585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hF0Wt/38bKIJqW5oK7QO5iRqmAOtacgZ7FH0L0aMp3Y=;
        b=YUeYF6oygBEwlxrSEautzZXDPIyX4HpLArzf3BzTm2+1C1QMKFjYXsa1why94Sk3xe
         jW8px3o+QIqwaB1S+ozOz8hUu+W45ZEuEIEIYcFbpIpmUzUP9qPbgEQWDVpfgMCr0/r8
         /0gvnK2VGfStIaJUgvNJdTzm1tIrpQekwaH+vXv3dfM8wuRO2YGMj8Y8krlqvoFcp3Lx
         R+C5NhEcAsPkdHHj3fRpJQNg3JuTcoy+PeJhWCeTC7OA9ZkM6tDBD8PEYqMqW02J9L96
         Xti56kvwJzx/6shl7OfumCpMNna6itmQQ36XXMbdsnrULb9NvPZp1Bo96pkxZd/lzHoX
         Nf5w==
X-Forwarded-Encrypted: i=1; AJvYcCW0rupJmELa3ktBU5OjU13bR3w/QW8SsQcRa53tl0W0hlxjpd810917S7IGGjuPHTDKHNp99orT4F0l9NNd3zhCsyraP8NKaXk64yCDNsFBhNKmlw==
X-Gm-Message-State: AOJu0YxJ45ztTmOBqZik0k1BbpzswOAGKHStNf4LKxSfQtzCFl6IIkMe
	m9UJ6EGRKhWKDKpfe2AsZxXZZ6vySZKXRvCiPs3fYO962KrCWPzHauO++KreI3gqde4v5dRh4rd
	SFh3VFyV8NPjl6YxfLdWfVIjAxPIGe25JYNLO
X-Google-Smtp-Source: AGHT+IGPYuZjDvQfeyD4B+TT7ChrPYCBt+VlxtnMNlpScn9nrLy6yNlQv3uwy7Afge2EeZ7qAEBLsOBXVTnm/afPX2s=
X-Received: by 2002:a50:c051:0:b0:5a1:a469:4d9b with SMTP id
 4fb4d7f45d1cf-5a47967b45cmr145698a12.13.1721440785336; Fri, 19 Jul 2024
 18:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org> <20240717.AGh2shahc9ee@digikod.net>
 <CALCETrUcr3p_APNazMro7Y9FX1zLAiQESvKZ5BDgd8X3PoCdFw@mail.gmail.com> <20240718.Niexoo0ahch0@digikod.net>
In-Reply-To: <20240718.Niexoo0ahch0@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 20 Jul 2024 09:59:33 +0800
Message-ID: <CALCETrVVq4DJZ2q9V9TMuvZ1nb+-Qf4Eu8LVBgUy3XiTa=jFCQ@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Steve Dower <steve.dower@python.org>, Jeff Xu <jeffxu@google.com>, 
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
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Jul 18, 2024, at 8:22=E2=80=AFPM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> =EF=BB=BFOn Thu, Jul 18, 2024 at 09:02:56AM +0800, Andy Lutomirski wrote:
>>>> On Jul 17, 2024, at 6:01=E2=80=AFPM, Micka=C3=ABl Sala=C3=BCn <mic@dig=
ikod.net> wrote:
>>>
>>> On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
>>>>> On 17/07/2024 07:33, Jeff Xu wrote:
>>>>> Consider those cases: I think:
>>>>> a> relying purely on userspace for enforcement does't seem to be
>>>>> effective,  e.g. it is trivial  to call open(), then mmap() it into
>>>>> executable memory.
>>>>
>>>> If there's a way to do this without running executable code that had t=
o pass
>>>> a previous execveat() check, then yeah, it's not effective (e.g. a Pyt=
hon
>>>> interpreter that *doesn't* enforce execveat() is a trivial way to do i=
t).
>>>>
>>>> Once arbitrary code is running, all bets are off. So long as all arbit=
rary
>>>> code is being checked itself, it's allowed to do things that would byp=
ass
>>>> later checks (and it's up to whoever audited it in the first place to
>>>> prevent this by not giving it the special mark that allows it to pass =
the
>>>> check).
>>>
>>> Exactly.  As explained in the patches, one crucial prerequisite is that
>>> the executable code is trusted, and the system must provide integrity
>>> guarantees.  We cannot do anything without that.  This patches series i=
s
>>> a building block to fix a blind spot on Linux systems to be able to
>>> fully control executability.
>>
>> Circling back to my previous comment (did that ever get noticed?), I
>
> Yes, I replied to your comments.  Did I miss something?

I missed that email in the pile, sorry. I=E2=80=99ll reply separately.

>
>> don=E2=80=99t think this is quite right:
>>
>> https://lore.kernel.org/all/CALCETrWYu=3DPYJSgyJ-vaa+3BGAry8Jo8xErZLiGR3=
U5h6+U0tA@mail.gmail.com/
>>
>> On a basic system configuration, a given path either may or may not be
>> executed. And maybe that path has some integrity check (dm-verity,
>> etc).  So the kernel should tell the interpreter/loader whether the
>> target may be executed. All fine.
>>
>> But I think the more complex cases are more interesting, and the
>> =E2=80=9Cexecute a program=E2=80=9D process IS NOT BINARY.  An attempt t=
o execute can
>> be rejected outright, or it can be allowed *with a change to creds or
>> security context*.  It would be entirely reasonable to have a policy
>> that allows execution of non-integrity-checked files but in a very
>> locked down context only.
>
> I guess you mean to transition to a sandbox when executing an untrusted
> file.  This is a good idea.  I talked about role transition in the
> patch's description:
>
> With the information that a script interpreter is about to interpret a
> script, an LSM security policy can adjust caller's access rights or log
> execution request as for native script execution (e.g. role transition).
> This is possible thanks to the call to security_bprm_creds_for_exec().

=E2=80=A6

> This patch series brings the minimal building blocks to have a
> consistent execution environment.  Role transitions for script execution
> are left to LSMs.  For instance, we could extend Landlock to
> automatically sandbox untrusted scripts.

I=E2=80=99m not really convinced.  There=E2=80=99s more to building an API =
that
enables LSM hooks than merely sticking the hook somewhere in kernel
code. It needs to be a defined API. If you call an operation =E2=80=9Ccheck=
=E2=80=9D,
then people will expect it to check, not to change the caller=E2=80=99s
credentials.  And people will mess it up in both directions (e.g.
callers will call it and then open try to load some library that they
should have loaded first, or callers will call it and forget to close
fds first.

And there should probably be some interaction with dumpable as well.
If I =E2=80=9Ccheck=E2=80=9D a file for executability, that should not sudd=
enly allow
someone to ptrace me?

And callers need to know to exit on failure, not carry on.


More concretely, a runtime that fully opts in to this may well "check"
multiple things.  For example, if I do:

$ ld.so ~/.local/bin/some_program   (i.e. I literally execve ld.so)

then ld.so will load several things:

~/.local/bin/some_program
libc.so
other random DSOs, some of which may well be in my home directory

And for all ld.so knows, some_program is actually an interpreter and
will "check" something else.  And the LSMs have absolutely no clue
what's what.  So I think for this to work right, the APIs need to be a
lot more expressive and explicit:

check_library(fd to libc.so);  <-- does not transition or otherwise drop pr=
ivs
check_transition_main_program(fd to ~/.local/bin/some_program);  <--
may drop privs

and if some_program is really an interpreter, then it will do:

check_library(fd to some thing imported by the script);
check_transition_main_program(fd to the actual script);

And maybe that takes a parameter that gets run eval-style:

check_unsafe_user_script("actual contents of snippet");

The actual spelling of all this doesn't matter so much.  But the user
code and the kernel code need to be on the same page as to what the
user program is doing and what it's asking the kernel program to do.

--Andy
