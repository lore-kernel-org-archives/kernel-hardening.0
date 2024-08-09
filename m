Return-Path: <kernel-hardening-return-21830-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A6489C3DA4A
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2024 16:16:49 +0000 (UTC)
Received: (qmail 5923 invoked by uid 550); 9 Aug 2024 16:16:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5890 invoked from network); 9 Aug 2024 16:16:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723220189; x=1723824989; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZYpvg30KBqeml0aLfdzOyX6A2jzs5hukakJb6/9ItY=;
        b=otsxVKZe4eYswv6kufMJzBlGTbRBUidGuZxtqQUe/waoHxvKa2aasiIqavJj/n7ii5
         i88Fok/SiAU9l5cwxLfjRUXQPVA3+YEIKXDs5tPDQTVTGiDt5yWxeEgTOFPj33WUnkpN
         1HDeRifW9FNaK0s4foofFdyKN/1Oh/g/w+F+4iax7j1UdKD8LPOrskd/wKRxz8mnSiu1
         D7TuuARrbXK62ZLoTeM3CEbA+C3dFqQZvRNDhiUaqJtcertuKC0IXUw6r6np0p1U8XYU
         0zIX55Ubv9BFTDDe2sDOmCZznCIT2UXZKzY91/H+fLikn1BJldR1K/zedPMKPvUNtQ0P
         9jWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723220189; x=1723824989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZYpvg30KBqeml0aLfdzOyX6A2jzs5hukakJb6/9ItY=;
        b=cU/BdSwtGOdWdbYl3arTRSgWlozVsnOHLnfz2jX+t5llRkNRTQzbpFtYERfzzZ5Ye6
         3ue9FjYsgExW38asCWYeONASixleU/jUsr+cCj0u0raRFrWwpoPxjw3xH2WLEz5ufpGG
         Z6k5c2+vsf3RfGzh9+mq7ULU6CRwcBlcdxdY5HsfAiGVsX/0IM+TmWTcKGXpUJxVNXd6
         B7VBFrGBgOychdBFazlSGCuKjgWxqZT9RVVdkv3m2ALOvDDAtmK1qHurO+xmuzZikm+z
         TKOadvecyv1/I1UPSlAhj9OClKJJ8wx3JDPUmwwdFXhubL4GUWL8HhLtGBucEC4032w3
         90vA==
X-Forwarded-Encrypted: i=1; AJvYcCW29xPVHIamnJL7Jhs12ditwmjwJCWFr+rafWPseJINpu5aS5JKv2xEXJgkcOYp9MLvDx9HBU9ZcCkjNCcOBmxT2xM6WsmYw7Ra72w+Ex1+viu1Bw==
X-Gm-Message-State: AOJu0Ywba6wNbnV4+nrPqDp+PvMPO4mD+2hOxrNMMLzBJ24EYY21oE38
	G3AaZgVuiSb7QekHZEfgYJ3t1gtZsam8FdEfjk9BTzBQgt1TVhQ+428UdALC8V5thgiDhfxd/O4
	twaFhoUnsqFuJ+rveh0+fjrRfVX6PVKuqzHWJ
X-Google-Smtp-Source: AGHT+IGLV2f7xz3HiASPgoXucNkkjSY0HlUpcr+1pRB8vDlxtZCp/4YEgM5Ck/9IgOs88u6eub6Gmvxv+P8wO7+gNTA=
X-Received: by 2002:a05:6402:40cc:b0:5a7:7f0f:b70b with SMTP id
 4fb4d7f45d1cf-5bbbc38adbemr223144a12.0.1723220188246; Fri, 09 Aug 2024
 09:16:28 -0700 (PDT)
MIME-Version: 1.0
References: <20240717.neaB5Aiy2zah@digikod.net> <CALmYWFt=yXpzhS=HS9FjwVMvx6U1MoR31vK79wxNLhmJm9bBoA@mail.gmail.com>
 <20240718.kaePhei9Ahm9@digikod.net> <CALmYWFto4sw-Q2+J0Gc54POhnM9C8YpnJ44wMz=fd_K3_+dWmw@mail.gmail.com>
 <20240719.shaeK6PaiSie@digikod.net> <CALmYWFsd-=pOPZZmiKvYJ8pOhACsTvW_d+pRjG_C4jD6+Li0AQ@mail.gmail.com>
 <20240719.sah7oeY9pha4@digikod.net> <CALmYWFsAZjU5sMcXTT23Mtw2Y30ewc94FAjKsnuSv1Ex=7fgLQ@mail.gmail.com>
 <20240723.beiTu0qui2ei@digikod.net> <CALmYWFtHQY41PbRwGxge1Wo=8D4ocZfQgRUO47-PF1eJCEr0Sw@mail.gmail.com>
 <20240809.Taiyah0ii7ph@digikod.net>
In-Reply-To: <20240809.Taiyah0ii7ph@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Fri, 9 Aug 2024 09:15:49 -0700
Message-ID: <CALmYWFvPxWyYdGvCcTPYrUtC0DVMGcmM+JsAe0KGE+3p2Jb=Ug@mail.gmail.com>
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

On Fri, Aug 9, 2024 at 1:45=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> On Mon, Aug 05, 2024 at 11:35:09AM -0700, Jeff Xu wrote:
> > On Tue, Jul 23, 2024 at 6:15=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Fri, Jul 19, 2024 at 08:27:18AM -0700, Jeff Xu wrote:
> > > > On Fri, Jul 19, 2024 at 8:04=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > >
> > > > > On Fri, Jul 19, 2024 at 07:16:55AM -0700, Jeff Xu wrote:
> > > > > > On Fri, Jul 19, 2024 at 1:45=E2=80=AFAM Micka=C3=ABl Sala=C3=BC=
n <mic@digikod.net> wrote:
> > > > > > >
> > > > > > > On Thu, Jul 18, 2024 at 06:29:54PM -0700, Jeff Xu wrote:
> > > > > > > > On Thu, Jul 18, 2024 at 5:24=E2=80=AFAM Micka=C3=ABl Sala=
=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Jul 17, 2024 at 07:08:17PM -0700, Jeff Xu wrote:
> > > > > > > > > > On Wed, Jul 17, 2024 at 3:01=E2=80=AFAM Micka=C3=ABl Sa=
la=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Tue, Jul 16, 2024 at 11:33:55PM -0700, Jeff Xu wro=
te:
> > > > > > > > > > > > On Thu, Jul 4, 2024 at 12:02=E2=80=AFPM Micka=C3=AB=
l Sala=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > Add a new AT_CHECK flag to execveat(2) to check i=
f a file would be
> > > > > > > > > > > > > allowed for execution.  The main use case is for =
script interpreters and
> > > > > > > > > > > > > dynamic linkers to check execution permission acc=
ording to the kernel's
> > > > > > > > > > > > > security policy. Another use case is to add conte=
xt to access logs e.g.,
> > > > > > > > > > > > > which script (instead of interpreter) accessed a =
file.  As any
> > > > > > > > > > > > > executable code, scripts could also use this chec=
k [1].
> > > > > > > > > > > > >
> > > > > > > > > > > > > This is different than faccessat(2) which only ch=
ecks file access
> > > > > > > > > > > > > rights, but not the full context e.g. mount point=
's noexec, stack limit,
> > > > > > > > > > > > > and all potential LSM extra checks (e.g. argv, en=
vp, credentials).
> > > > > > > > > > > > > Since the use of AT_CHECK follows the exact kerne=
l semantic as for a
> > > > > > > > > > > > > real execution, user space gets the same error co=
des.
> > > > > > > > > > > > >
> > > > > > > > > > > > So we concluded that execveat(AT_CHECK) will be use=
d to check the
> > > > > > > > > > > > exec, shared object, script and config file (such a=
s seccomp config),
> > > > > > >
> > > > > > > > > > > > I think binfmt_elf.c in the kernel needs to check t=
he ld.so to make
> > > > > > > > > > > > sure it passes AT_CHECK, before loading it into mem=
ory.
> > > > > > > > > > >
> > > > > > > > > > > All ELF dependencies are opened and checked with open=
_exec(), which
> > > > > > > > > > > perform the main executability checks (with the __FMO=
DE_EXEC flag).
> > > > > > > > > > > Did I miss something?
> > > > > > > > > > >
> > > > > > > > > > I mean the ld-linux-x86-64.so.2 which is loaded by binf=
mt in the kernel.
> > > > > > > > > > The app can choose its own dynamic linker path during b=
uild, (maybe
> > > > > > > > > > even statically link one ?)  This is another reason tha=
t relying on a
> > > > > > > > > > userspace only is not enough.
> > > > > > > > >
> > > > > > > > > The kernel calls open_exec() on all dependencies, includi=
ng
> > > > > > > > > ld-linux-x86-64.so.2, so these files are checked for exec=
utability too.
> > > > > > > > >
> > > > > > > > This might not be entirely true. iiuc, kernel  calls open_e=
xec for
> > > > > > > > open_exec for interpreter, but not all its dependency (e.g.=
 libc.so.6)
> > > > > > >
> > > > > > > Correct, the dynamic linker is in charge of that, which is wh=
y it must
> > > > > > > be enlighten with execveat+AT_CHECK and securebits checks.
> > > > > > >
> > > > > > > > load_elf_binary() {
> > > > > > > >    interpreter =3D open_exec(elf_interpreter);
> > > > > > > > }
> > > > > > > >
> > > > > > > > libc.so.6 is opened and mapped by dynamic linker.
> > > > > > > > so the call sequence is:
> > > > > > > >  execve(a.out)
> > > > > > > >   - open exec(a.out)
> > > > > > > >   - security_bprm_creds(a.out)
> > > > > > > >   - open the exec(ld.so)
> > > > > > > >   - call open_exec() for interruptor (ld.so)
> > > > > > > >   - call execveat(AT_CHECK, ld.so) <-- do we want ld.so goi=
ng through
> > > > > > > > the same check and code path as libc.so below ?
> > > > > > >
> > > > > > > open_exec() checks are enough.  LSMs can use this information=
 (open +
> > > > > > > __FMODE_EXEC) if needed.  execveat+AT_CHECK is only a user sp=
ace
> > > > > > > request.
> > > > > > >
> > > > > > Then the ld.so doesn't go through the same security_bprm_creds(=
) check
> > > > > > as other .so.
> > > > >
> > > > > Indeed, but...
> > > > >
> > > > My point is: we will want all the .so going through the same code
> > > > path, so  security_ functions are called consistently across all th=
e
> > > > objects, And in the future, if we want to develop additional LSM
> > > > functionality based on AT_CHECK, it will be applied to all objects.
> > >
> > > I'll extend the doc to encourage LSMs to check for __FMODE_EXEC, whic=
h
> > > already is the common security check for all executable dependencies.
> > > As extra information, they can get explicit requests by looking at
> > > execveat+AT_CHECK call.
> > >
> > I agree that security_file_open + __FMODE_EXEC for checking all
> > the .so (e.g for executable memfd) is a better option  than checking at
> > security_bprm_creds_for_exec.
> >
> > But then maybe execveat( AT_CHECK) can return after  calling alloc_bprm=
 ?
> > See below call graph:
> >
> > do_execveat_common (AT_CHECK)
> > -> alloc_bprm
> > ->->do_open_execat
> > ->->-> do_filp_open (__FMODE_EXEC)
> > ->->->->->->> security_file_open
> > -> bprm_execve
> > ->-> prepare_exec_creds
> > ->->-> prepare_creds
> > ->->->-> security_prepare_creds
> > ->-> security_bprm_creds_for_exec
> >
> > What is the consideration to mark the end at
> > security_bprm_creds_for_exec ? i.e. including brpm_execve,
> > prepare_creds, security_prepare_creds, security_bprm_creds_for_exec.
>
> This enables LSMs to know/log an explicit execution request, including
> context with argv and envp.
>
> >
> > Since dynamic linker doesn't load ld.so (it is by kernel),  ld.so
> > won't go through those  security_prepare_creds and
> > security_bprm_creds_for_exec checks like other .so do.
>
> Yes, but this is not an issue nor an explicit request. ld.so is only one
> case of this patch series.
>
> >
> > > >
> > > > Another thing to consider is:  we are asking userspace to make
> > > > additional syscall before  loading the file into memory/get execute=
d,
> > > > there is a possibility for future expansion of the mechanism, witho=
ut
> > > > asking user space to add another syscall again.
> > >
> > > AT_CHECK is defined with a specific semantic.  Other mechanisms (e.g.
> > > LSM policies) could enforce other restrictions following the same
> > > semantic.  We need to keep in mind backward compatibility.
> > >
> > > >
> > > > I m still not convinced yet that execveat(AT_CHECK) fits more than
> > > > faccessat(AT_CHECK)
> > >
> > > faccessat2(2) is dedicated to file permission/attribute check.
> > > execveat(2) is dedicated to execution, which is a superset of file
> > > permission for executability, plus other checks (e.g. noexec).
> > >
> > That sounds reasonable, but if execveat(AT_CHECK) changes behavior of
> > execveat(),  someone might argue that faccessat2(EXEC_CHECK) can be
> > made for the executability.
>
> AT_CHECK, as any other syscall flags, changes the behavior of execveat,
> but the overall semantic is clearly defined.
>
> Again, faccessat2 is only dedicated to file attributes/permissions, not
> file executability.
>
> >
> > I think the decision might depend on what this PATCH intended to
> > check, i.e. where we draw the line.
>
> The goal is clearly defined in the cover letter and patches: makes it
> possible to control (or log) script execution.
>
> >
> > do_open_execat() seems to cover lots of checks for executability, if
> > we are ok with the thing that do_open_execat() checks, then
> > faccessat(AT_CHECK) calling do_open_execat() is an option, it  won't
> > have those "unrelated" calls  in execve path, e.g.  bprm_stack_limits,
> > copy argc/env .
>
> I don't thing there is any unrelated calls in execve path, quite the
> contrary, it follows the same semantic as for a full execution, and
> that's another argument to use the execveat interface.  Otherwise, we
> couldn't argue that `./script.sh` can be the same as `sh script.sh`
>
It is a good point from the  "scrip.sh/exec" perspective that we want
it to go through the same execve path.
The reasoning is not obvious from the ".so" which doesn't go through
stack/env check.
Since execveat(AT_CHECK) wants to cover both cases, it is fine.

> The only difference is that user space is in charge of parsing and
> interpreting the file's content.
>
> >
> > However, you mentioned superset of file permission for executability,
> > can you elaborate on that ? Is there something not included in
> > do_open_execat() but still necessary for execveat(AT_CHECK)? maybe
> > security_bprm_creds_for_exec? (this goes back to my  question above)
>
> As explained above, the goal is to have the same semantic as a full
> execveat call, taking into account all the checks (e.g. stack limit,
> argv/envp...).
>
I'm fine with this, thanks for taking time to explain the design.

Regarding the future LSM based on this patch series:
For .so,  security_file_open is recommended for LSM.
For scripts/exec (that needs a full exec code path),
security_file_open and security_bprm_creds_for_exec can both be used.

Thanks
Best regards,
-Jeff
