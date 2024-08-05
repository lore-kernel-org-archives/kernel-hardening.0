Return-Path: <kernel-hardening-return-21828-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 60ACBC3DA7F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2024 18:36:07 +0000 (UTC)
Received: (qmail 3768 invoked by uid 550); 5 Aug 2024 18:35:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3748 invoked from network); 5 Aug 2024 18:35:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722882947; x=1723487747; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bThA5FjCHLI5cTw21zmhlv/WBFyj5sN+HqnnHYmexPA=;
        b=0X/OfnEo5LC3dEVKplPcKPUdALBgMxzARSGwmgNEGOnkM6pWAgIm/nJKfgnfhWp5A8
         HPi7Au3oZhavz9NtHq4bHVstrioPjM+dwhNEZ48TMUiFw/9qXRK5zkxGbDwPimUbQRUx
         yf+TGZus0JUnsCEf7TpHRAzdUDJvt4hdsH7WTjNe77GSJUP948GyFvi6pH3dE+YlF70R
         YAyfcB321E4swmGoIb7pZs906TXfyjg/hw4Tdym9bYuzBAwVzU6AtM23dRyFOrQ5X/Zf
         +NMfxYWrhYE6c7HTFzsFcVhawHxQ2PDwoir2Gqdd4e8YT8F1Z7TBJYDK9VXbiRZkjYyZ
         fSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722882947; x=1723487747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bThA5FjCHLI5cTw21zmhlv/WBFyj5sN+HqnnHYmexPA=;
        b=cKQP0UNJwxawz7SjCaAWZ8KOR83Xw/H8ip4gvfacjlC4RtQQR/zdjkvYVgJgqR7Dt4
         QLNHOChAK0XAIrP3ScF6gkY3UGebSMXsdrN50b6cI4E1NOweUcPJGtANv+jmVNM7mR79
         LRtZEYbTfBHr5a1Gg4/WsecOZuajViCv84410WKATVOPU7Tpq6QLEIO7pBGUs0KXqfuL
         dJZeD77uSb2XJ/lLO/CQwf0Pg3S1DngCxItdC4LxjGsOALZQNujDH3W7Q4DTjSFAdHzl
         SiJKeDnze95Uw1V8nMcRQbRz5YmJr1gcRpZKNY7kJLR6ks/OsCm4pnslZtN3AsDZ7q4H
         rKxA==
X-Forwarded-Encrypted: i=1; AJvYcCX4UeawLIeaTxY0T0TEYwNUUMroEzJiBgd+XtoINCnNxh3B+1XOO56UDiMHtl4RMf1wB/Vus7+d+cf4tgLWDvR9mq0R9wUxf4tH6RIumYaI7Q4cQA==
X-Gm-Message-State: AOJu0Yzl+wAMxiV8Af+pXUA76Vpc/mx6RvJi1ehcHPz2jY26qDPdXVEX
	Rs2+GBMlbt4jvDad09CQ+XkZ6R5WFafwOGc+C2lEW7zON9JEqBFifxuSSw1YW6pXXMLziYyhkeu
	BszprqenLDuqb9er4jnkrnLaajn89DaGbsnLY
X-Google-Smtp-Source: AGHT+IFHW0w+23cEWxRQdQ9i9nzl0CE9JhDT4Dih8izAVQFFjdvtpnnaKmKW0lj5aOxSe7NS6C8BNabcazoemesr9i0=
X-Received: by 2002:a05:6402:34c7:b0:58b:93:b624 with SMTP id
 4fb4d7f45d1cf-5bb98241683mr12298a12.1.1722882946512; Mon, 05 Aug 2024
 11:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-2-mic@digikod.net> <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <20240717.neaB5Aiy2zah@digikod.net> <CALmYWFt=yXpzhS=HS9FjwVMvx6U1MoR31vK79wxNLhmJm9bBoA@mail.gmail.com>
 <20240718.kaePhei9Ahm9@digikod.net> <CALmYWFto4sw-Q2+J0Gc54POhnM9C8YpnJ44wMz=fd_K3_+dWmw@mail.gmail.com>
 <20240719.shaeK6PaiSie@digikod.net> <CALmYWFsd-=pOPZZmiKvYJ8pOhACsTvW_d+pRjG_C4jD6+Li0AQ@mail.gmail.com>
 <20240719.sah7oeY9pha4@digikod.net> <CALmYWFsAZjU5sMcXTT23Mtw2Y30ewc94FAjKsnuSv1Ex=7fgLQ@mail.gmail.com>
 <20240723.beiTu0qui2ei@digikod.net>
In-Reply-To: <20240723.beiTu0qui2ei@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 5 Aug 2024 11:35:09 -0700
Message-ID: <CALmYWFtHQY41PbRwGxge1Wo=8D4ocZfQgRUO47-PF1eJCEr0Sw@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
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
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 6:15=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Fri, Jul 19, 2024 at 08:27:18AM -0700, Jeff Xu wrote:
> > On Fri, Jul 19, 2024 at 8:04=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Fri, Jul 19, 2024 at 07:16:55AM -0700, Jeff Xu wrote:
> > > > On Fri, Jul 19, 2024 at 1:45=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > >
> > > > > On Thu, Jul 18, 2024 at 06:29:54PM -0700, Jeff Xu wrote:
> > > > > > On Thu, Jul 18, 2024 at 5:24=E2=80=AFAM Micka=C3=ABl Sala=C3=BC=
n <mic@digikod.net> wrote:
> > > > > > >
> > > > > > > On Wed, Jul 17, 2024 at 07:08:17PM -0700, Jeff Xu wrote:
> > > > > > > > On Wed, Jul 17, 2024 at 3:01=E2=80=AFAM Micka=C3=ABl Sala=
=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 16, 2024 at 11:33:55PM -0700, Jeff Xu wrote:
> > > > > > > > > > On Thu, Jul 4, 2024 at 12:02=E2=80=AFPM Micka=C3=ABl Sa=
la=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > > > >
> > > > > > > > > > > Add a new AT_CHECK flag to execveat(2) to check if a =
file would be
> > > > > > > > > > > allowed for execution.  The main use case is for scri=
pt interpreters and
> > > > > > > > > > > dynamic linkers to check execution permission accordi=
ng to the kernel's
> > > > > > > > > > > security policy. Another use case is to add context t=
o access logs e.g.,
> > > > > > > > > > > which script (instead of interpreter) accessed a file=
.  As any
> > > > > > > > > > > executable code, scripts could also use this check [1=
].
> > > > > > > > > > >
> > > > > > > > > > > This is different than faccessat(2) which only checks=
 file access
> > > > > > > > > > > rights, but not the full context e.g. mount point's n=
oexec, stack limit,
> > > > > > > > > > > and all potential LSM extra checks (e.g. argv, envp, =
credentials).
> > > > > > > > > > > Since the use of AT_CHECK follows the exact kernel se=
mantic as for a
> > > > > > > > > > > real execution, user space gets the same error codes.
> > > > > > > > > > >
> > > > > > > > > > So we concluded that execveat(AT_CHECK) will be used to=
 check the
> > > > > > > > > > exec, shared object, script and config file (such as se=
ccomp config),
> > > > >
> > > > > > > > > > I think binfmt_elf.c in the kernel needs to check the l=
d.so to make
> > > > > > > > > > sure it passes AT_CHECK, before loading it into memory.
> > > > > > > > >
> > > > > > > > > All ELF dependencies are opened and checked with open_exe=
c(), which
> > > > > > > > > perform the main executability checks (with the __FMODE_E=
XEC flag).
> > > > > > > > > Did I miss something?
> > > > > > > > >
> > > > > > > > I mean the ld-linux-x86-64.so.2 which is loaded by binfmt i=
n the kernel.
> > > > > > > > The app can choose its own dynamic linker path during build=
, (maybe
> > > > > > > > even statically link one ?)  This is another reason that re=
lying on a
> > > > > > > > userspace only is not enough.
> > > > > > >
> > > > > > > The kernel calls open_exec() on all dependencies, including
> > > > > > > ld-linux-x86-64.so.2, so these files are checked for executab=
ility too.
> > > > > > >
> > > > > > This might not be entirely true. iiuc, kernel  calls open_exec =
for
> > > > > > open_exec for interpreter, but not all its dependency (e.g. lib=
c.so.6)
> > > > >
> > > > > Correct, the dynamic linker is in charge of that, which is why it=
 must
> > > > > be enlighten with execveat+AT_CHECK and securebits checks.
> > > > >
> > > > > > load_elf_binary() {
> > > > > >    interpreter =3D open_exec(elf_interpreter);
> > > > > > }
> > > > > >
> > > > > > libc.so.6 is opened and mapped by dynamic linker.
> > > > > > so the call sequence is:
> > > > > >  execve(a.out)
> > > > > >   - open exec(a.out)
> > > > > >   - security_bprm_creds(a.out)
> > > > > >   - open the exec(ld.so)
> > > > > >   - call open_exec() for interruptor (ld.so)
> > > > > >   - call execveat(AT_CHECK, ld.so) <-- do we want ld.so going t=
hrough
> > > > > > the same check and code path as libc.so below ?
> > > > >
> > > > > open_exec() checks are enough.  LSMs can use this information (op=
en +
> > > > > __FMODE_EXEC) if needed.  execveat+AT_CHECK is only a user space
> > > > > request.
> > > > >
> > > > Then the ld.so doesn't go through the same security_bprm_creds() ch=
eck
> > > > as other .so.
> > >
> > > Indeed, but...
> > >
> > My point is: we will want all the .so going through the same code
> > path, so  security_ functions are called consistently across all the
> > objects, And in the future, if we want to develop additional LSM
> > functionality based on AT_CHECK, it will be applied to all objects.
>
> I'll extend the doc to encourage LSMs to check for __FMODE_EXEC, which
> already is the common security check for all executable dependencies.
> As extra information, they can get explicit requests by looking at
> execveat+AT_CHECK call.
>
I agree that security_file_open + __FMODE_EXEC for checking all
the .so (e.g for executable memfd) is a better option  than checking at
security_bprm_creds_for_exec.

But then maybe execveat( AT_CHECK) can return after  calling alloc_bprm ?
See below call graph:

do_execveat_common (AT_CHECK)
-> alloc_bprm
->->do_open_execat
->->-> do_filp_open (__FMODE_EXEC)
->->->->->->> security_file_open
-> bprm_execve
->-> prepare_exec_creds
->->-> prepare_creds
->->->-> security_prepare_creds
->-> security_bprm_creds_for_exec

What is the consideration to mark the end at
security_bprm_creds_for_exec ? i.e. including brpm_execve,
prepare_creds, security_prepare_creds, security_bprm_creds_for_exec.

Since dynamic linker doesn't load ld.so (it is by kernel),  ld.so
won't go through those  security_prepare_creds and
security_bprm_creds_for_exec checks like other .so do.

> >
> > Another thing to consider is:  we are asking userspace to make
> > additional syscall before  loading the file into memory/get executed,
> > there is a possibility for future expansion of the mechanism, without
> > asking user space to add another syscall again.
>
> AT_CHECK is defined with a specific semantic.  Other mechanisms (e.g.
> LSM policies) could enforce other restrictions following the same
> semantic.  We need to keep in mind backward compatibility.
>
> >
> > I m still not convinced yet that execveat(AT_CHECK) fits more than
> > faccessat(AT_CHECK)
>
> faccessat2(2) is dedicated to file permission/attribute check.
> execveat(2) is dedicated to execution, which is a superset of file
> permission for executability, plus other checks (e.g. noexec).
>
That sounds reasonable, but if execveat(AT_CHECK) changes behavior of
execveat(),  someone might argue that faccessat2(EXEC_CHECK) can be
made for the executability.

I think the decision might depend on what this PATCH intended to
check, i.e. where we draw the line.

do_open_execat() seems to cover lots of checks for executability, if
we are ok with the thing that do_open_execat() checks, then
faccessat(AT_CHECK) calling do_open_execat() is an option, it  won't
have those "unrelated" calls  in execve path, e.g.  bprm_stack_limits,
copy argc/env .

However, you mentioned superset of file permission for executability,
can you elaborate on that ? Is there something not included in
do_open_execat() but still necessary for execveat(AT_CHECK)? maybe
security_bprm_creds_for_exec? (this goes back to my  question above)

Thanks
Best regards,
-Jeff











> >
> >
> > > >
> > > > As my previous email, the ChromeOS LSM restricts executable mfd
> > > > through security_bprm_creds(), the end result is that ld.so can sti=
ll
> > > > be executable memfd, but not other .so.
> > >
> > > The chromeOS LSM can check that with the security_file_open() hook an=
d
> > > the __FMODE_EXEC flag, see Landlock's implementation.  I think this
> > > should be the only hook implementation that chromeOS LSM needs to add=
.
> > >
> > > >
> > > > One way to address this is to refactor the necessary code from
> > > > execveat() code patch, and make it available to call from both kern=
el
> > > > and execveat() code paths., but if we do that, we might as well use
> > > > faccessat2(AT_CHECK)
> > >
> > > That's why I think it makes sense to rely on the existing __FMODE_EXE=
C
> > > information.
> > >
> > > >
> > > >
> > > > > >   - transfer the control to ld.so)
> > > > > >   - ld.so open (libc.so)
> > > > > >   - ld.so call execveat(AT_CHECK,libc.so) <-- proposed by this =
patch,
> > > > > > require dynamic linker change.
> > > > > >   - ld.so mmap(libc.so,rx)
> > > > >
> > > > > Explaining these steps is useful. I'll include that in the next p=
atch
> > > > > series.
> >
