Return-Path: <kernel-hardening-return-21819-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 979B7C3DA59
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Jul 2024 17:37:03 +0000 (UTC)
Received: (qmail 28640 invoked by uid 550); 19 Jul 2024 17:36:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28615 invoked from network); 19 Jul 2024 17:36:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721410600; x=1722015400; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQxa6F8cq8HJ6XeW+Qq3Pxl6kdGNSanFrttFIpHCBuk=;
        b=quhsYeeq2TbJCckkTRM6/taje4j7B45TB6Lbhvyrfj/VsPnRYmiySQWV0h/XSTPbQb
         XrZwatM1PS0lmNJlhTK7iB4q2ziKw3hgMwtzpF2m0oPIy2oJcnfE5PCSvSX1ll/dRWHw
         NIyhN6fQJGK5mqkmKiPq8xW6/NRJdQgBerelrFwAVndZWep5nTuqnXhGxRTaJvIAST5L
         JiyN8gYkz8bA4++cMnCnSVkDolZ8Ir0o0qreDbu6rcbavqPtgjjp2gOKlwXdXfA8EwOh
         gL0gYgwIp0+7OyKoFjM9amJKuh8dPHQBEjyM84daiOpQQPwLqnAiKCIlsHen6eXTeh58
         FT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721410600; x=1722015400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQxa6F8cq8HJ6XeW+Qq3Pxl6kdGNSanFrttFIpHCBuk=;
        b=hhvTkFN5CK/OebZh194yGdZ7ram39vSDn4Fckp4Z05eUV0UoLU0RusY0lzc9VBIk/B
         9RvRPj29OWCKuA/s/GHCdTOuWu/Ajhmr71YiWMixz2c3RKLwqn6+8Ic22FjHAczyQ/DX
         bgbcIYiiLsP0a9xu7f2tyyDXoe7N49VjlkGYDTfRr5Wgp+Lj/EQkk179yXUhsmj7DNUp
         ykqW9zG2keDql/6E0MstvypmEwYVHv8xfRZLyW3/LchHXjlynsgPk5+9PZ6L/Y+tEsZm
         Hney4YjfdWwZcey4OUOqi2axo+z7KpihIf1GPbGhXIeRUC4z+ozEcfEP87Vt55JbX1Lu
         Rjzg==
X-Forwarded-Encrypted: i=1; AJvYcCVfdLzhJY79eG43AHchJPjhlvVk04bE7QjjlW+Q2o0wtx2WEbL0fJOb+YNgqaTy6TKjn40MO9OizKPmKSi2rPccw5O2TtL93NwaYVz654Zz+GRYbQ==
X-Gm-Message-State: AOJu0YyRi3UXoxIvbSKAQKQ9nZyu9+snQKKqwoX52mRM8yWBfTHVDOl3
	Hqgtx31xqLTbZbTJwNIZNYgfkTUo7GUq+vdPtI7ASnuvD2VGqmfRRnbBKO+mj/S3NQyca0a9uFK
	2OlS8MMIrFwV1FaXsnle9JKUETNwet1G439Tv
X-Google-Smtp-Source: AGHT+IFr4UIuqcny8oT4n2XXdl09/DOiKufPDz2G3bvU5/ew23N51/0PqyyCDErT88IT6yxGc42B0HWdEq3lgXzUvuc=
X-Received: by 2002:a05:6402:51cd:b0:57d:32ff:73ef with SMTP id
 4fb4d7f45d1cf-5a2cae572bbmr285073a12.6.1721410599538; Fri, 19 Jul 2024
 10:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <20240717.neaB5Aiy2zah@digikod.net> <CALmYWFt=yXpzhS=HS9FjwVMvx6U1MoR31vK79wxNLhmJm9bBoA@mail.gmail.com>
 <20240718.kaePhei9Ahm9@digikod.net> <CALmYWFupWw2_BKu1FF=ooXFpA=GtJr1ehZSK3p+1+1WH34eX=w@mail.gmail.com>
 <20240719.Ooxeithah8Sh@digikod.net>
In-Reply-To: <20240719.Ooxeithah8Sh@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Fri, 19 Jul 2024 10:36:01 -0700
Message-ID: <CALmYWFsR+fWVuPLCoNhisTV5Lviv_dzb=5ajoKs0LaHsei9qTQ@mail.gmail.com>
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

On Fri, Jul 19, 2024 at 8:31=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Fri, Jul 19, 2024 at 08:12:37AM -0700, Jeff Xu wrote:
> > On Thu, Jul 18, 2024 at 5:24=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Wed, Jul 17, 2024 at 07:08:17PM -0700, Jeff Xu wrote:
> > > > On Wed, Jul 17, 2024 at 3:01=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > >
> > > > > On Tue, Jul 16, 2024 at 11:33:55PM -0700, Jeff Xu wrote:
> > > > > > On Thu, Jul 4, 2024 at 12:02=E2=80=AFPM Micka=C3=ABl Sala=C3=BC=
n <mic@digikod.net> wrote:
> > > > > > >
> > > > > > > Add a new AT_CHECK flag to execveat(2) to check if a file wou=
ld be
> > > > > > > allowed for execution.  The main use case is for script inter=
preters and
> > > > > > > dynamic linkers to check execution permission according to th=
e kernel's
> > > > > > > security policy. Another use case is to add context to access=
 logs e.g.,
> > > > > > > which script (instead of interpreter) accessed a file.  As an=
y
> > > > > > > executable code, scripts could also use this check [1].
> > > > > > >
> > > > > > > This is different than faccessat(2) which only checks file ac=
cess
> > > > > > > rights, but not the full context e.g. mount point's noexec, s=
tack limit,
> > > > > > > and all potential LSM extra checks (e.g. argv, envp, credenti=
als).
> > > > > > > Since the use of AT_CHECK follows the exact kernel semantic a=
s for a
> > > > > > > real execution, user space gets the same error codes.
> > > > > > >
> > > > > > So we concluded that execveat(AT_CHECK) will be used to check t=
he
> > > > > > exec, shared object, script and config file (such as seccomp co=
nfig),
> > > > >
> > > > > "config file" that contains executable code.
> > > > >
> > > > Is seccomp config  considered as "contains executable code", seccom=
p
> > > > config is translated into bpf, so maybe yes ? but bpf is running in
> > > > the kernel.
> > >
> > > Because seccomp filters alter syscalls, they are similar to code
> > > injection.
> > >
> > > >
> > > > > > I'm still thinking  execveat(AT_CHECK) vs faccessat(AT_CHECK) i=
n
> > > > > > different use cases:
> > > > > >
> > > > > > execveat clearly has less code change, but that also means: we =
can't
> > > > > > add logic specific to exec (i.e. logic that can't be applied to
> > > > > > config) for this part (from do_execveat_common to
> > > > > > security_bprm_creds_for_exec) in future.  This would require so=
me
> > > > > > agreement/sign-off, I'm not sure from whom.
> > > > >
> > > > > I'm not sure to follow. We could still add new flags, but for now=
 I
> > > > > don't see use cases.  This patch series is not meant to handle al=
l
> > > > > possible "trust checks", only executable code, which makes sense =
for the
> > > > > kernel.
> > > > >
> > > > I guess the "configfile" discussion is where I get confused, at one
> > > > point, I think this would become a generic "trust checks" api for
> > > > everything related to "generating executable code", e.g. javascript=
,
> > > > java code, and more.
> > > > We will want to clearly define the scope of execveat(AT_CHECK)
> > >
> > > The line between data and code is blurry.  For instance, a configurat=
ion
> > > file can impact the execution flow of a program.  So, where to draw t=
he
> > > line?
> > >
> > > It might makes sense to follow the kernel and interpreter semantic: i=
f a
> > > file can be executed by the kernel (e.g. ELF binary, file containing =
a
> > > shebang, or just configured with binfmt_misc), then this should be
> > > considered as executable code.  This applies to Bash, Python,
> > > Javascript, NodeJS, PE, PHP...  However, we can also make a picture
> > > executable with binfmt_misc.  So, again, where to draw the line?
> > >
> > > I'd recommend to think about interaction with the outside, through
> > > function calls, IPCs, syscalls...  For instance, "running" an image
> > > should not lead to reading or writing to arbitrary files, or accessin=
g
> > > the network, but in practice it is legitimate for some file formats..=
.
> > > PostScript is a programming language, but mostly used to draw picture=
s.
> > > So, again, where to draw the line?
> > >
> > The javascript is run by browser and java code by java runtime, do
> > they meet the criteria? they do not interact with the kernel directly,
> > however they might have the same "executable" characteristics and the
> > app might not want them to be put into non-exec mount.
> >
> > If the answer is yes, they can also use execveat(AT_CHECK),  the next
> > question is: does it make sense for javacript/java code to go through
> > execveat() code path, allocate bprm, etc ? (I don't have answer, maybe
> > it is)
>
> Java and NodeJS can do arbitrary syscalls (through their runtime) and
> they can access arbitrary files, so according to my below comment, yes
> they should be managed as potentially dangerous executable code.
>
> The question should be: is this code trusted? Most of the time it is
> not, hence the security model of web browser and their heavy use of
> sandboxing.  So no, I don't think it would make sense to check this kind
> of code more than what the browser already do.
>

If I understand you correctly, Java/NodeJS won't use
execveat(AT_CHECK), we will leave that work to the web browser/java
runtime's sandboxer.
This is good because the scope is more narrow/clear.

Thanks
-Jeff

> I'll talk about this use case in the next patch series.
>
> >
> > > We should follow the principle of least astonishment.  What most user=
s
> > > would expect?  This should follow the *common usage* of executable
> > > files.  At the end, the script interpreters will be patched by securi=
ty
> > > folks for security reasons.  I think the right question to ask should
> > > be: could this file format be (ab)used to leak or modify arbitrary
> > > files, or to perform arbitrary syscalls?  If the answer is yes, then =
it
> > > should be checked for executability.  Of course, this excludes bugs
> > > exploited in the file format parser.
> > >
> > > I'll extend the next patch series with this rationale.
> > >
> >
