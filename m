Return-Path: <kernel-hardening-return-21989-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AC28DCA0FED
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Aug 2025 20:35:45 +0000 (UTC)
Received: (qmail 11540 invoked by uid 550); 27 Aug 2025 20:35:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11514 invoked from network); 27 Aug 2025 20:35:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1756326925; x=1756931725; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wl0ljXkPyLBoAJTX9TjDS8ZEVo6BAT27dTBeN90CXWg=;
        b=Di1QtDMWPCLfll9qsmZXUtUaDc8ZAWy+Gh3CCrDNlAVXQko91/0l4tC96QiksP0ztU
         W3OXjTLFShMo4IeTZmb/mlLJwGnt2W82PpcjUhpdUYOblSD+5eXxpAgUJ3Cbu/NKlTJG
         NG0FrnOQDxHIKLIlfdgHszrASqqLnBMTyU8WsdPOwu1szDstq00vqRZ8dkzbT+yX8CUp
         hzN+bY9BC3tgqCc1NOBO2d/JrWLu4OrPtZKNc1YO+L8KPDgpXmvBAUbl7NAPC6VJaQNG
         iQlwdk5C2l8T6EAnQZfMXGldFPUq2wyrGGoX2fH1irMktshf6igQZildGc88eCVPWxPp
         Lz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756326925; x=1756931725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wl0ljXkPyLBoAJTX9TjDS8ZEVo6BAT27dTBeN90CXWg=;
        b=cEw3WWXgrD7Ad7ONyBIJIzOYhiLydOvBm0GaUB6k9rl2oT7O7vQAJz1p4iSBEEH2Cp
         +tATfWQGkmVfk7OWQotkPjjvl072juUX2v4AhTXN7HXx2WuXiYCdPZrMiar/reJV2xNB
         0LlodpSFULLCnWNXnUFhS+9OHfgVRP3nQCn6Topw1ERoslwA6ewWluHwH3KHbJEskfef
         AeSS2/5mUXmgPfXQjf7Lly61PjZOdW8G3aTgCc+ptheE2H1vWuNI6qkczppqSSexkvB/
         HJLAF8phpO4ux60AAtx+eimLbbXyb2MYEfSo6FvgYTXbLzofUth6Dv9LwOm3enxzAIrt
         dLeA==
X-Forwarded-Encrypted: i=1; AJvYcCU3iJhreGFAPOV8D9zcWhtHVjN1Tmrc0ZhmnrQe7vegy9G5O9bGNdSdaPNzwhHdv15EuExOHlkkA2eP9MSdgyQN@lists.openwall.com
X-Gm-Message-State: AOJu0Yx0C3i50d5UIj04wdnygHjpqfBawcjnuKfMoKeGUd7aqymPfa1o
	G5KKEehVs/fUTb1yk2RcPXdB7AZBa0S54BT68VMgf/p4BG1Uny1+sIGmkIyr0w2ZR0nJkhBewRW
	cYRH5UFN4M8ji+d2/T3SPtHPaxq2hZcDX1v4JhFQA
X-Gm-Gg: ASbGnct5tF4FvUIjZxMz3inaZo2r9dr8AKgZEIei9XgZ3g8+9HzuDJS6GY6/Mn1VVhF
	PUA05SiXh4HDkOe9FisDk3c2+GZ6VuGbuWHka1rkfZ6oX8t1O2xnp3SOWR8ljvbMNgcTrO5OCGW
	7k/oZh1zlCClvcZbOJpJP3Ty96Z7t0UNLyRuS99qN3jL+d94kfdn50w8oI4ldpEVdA8zM6GQu69
	IMKMnyc/L+CXpswb7Y=
X-Google-Smtp-Source: AGHT+IGjsa20oKobGhO2nM0A+5O9r9SpySfPXdDwEkZvs/Q/UX/cGwHkgk6K1CRbBEum5T5gJOenn7JtwIEd8EnKFq0=
X-Received: by 2002:a05:651c:41cf:b0:335:4d0e:9493 with SMTP id
 38308e7fff4ca-33650f997d5mr58918271fa.28.1756326925222; Wed, 27 Aug 2025
 13:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <20250826123041.GB1603531@mit.edu>
 <20250826.iewie7Et5aiw@digikod.net> <CALCETrW=V9vst_ho2Q4sQUJ5uZECY5h7TnF==sG4JWq8PsWb8Q@mail.gmail.com>
 <20250827.Fuo1Iel1pa7i@digikod.net>
In-Reply-To: <20250827.Fuo1Iel1pa7i@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 27 Aug 2025 13:35:13 -0700
X-Gm-Features: Ac12FXyp51op4OQBdoTDCrgv2p90HecB5l5_GBOrhFfKRX5VCL-77MvuK466l-o
Message-ID: <CALCETrVDJYK+vWOe+-NACAqQ9i4nhCz-7rMMdkRuxexgnpzZow@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 12:07=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>
> On Wed, Aug 27, 2025 at 10:35:28AM -0700, Andy Lutomirski wrote:
> > On Tue, Aug 26, 2025 at 10:47=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@=
digikod.net> wrote:
> > >
> > > On Tue, Aug 26, 2025 at 08:30:41AM -0400, Theodore Ts'o wrote:
> > > > Is there a single, unified design and requirements document that
> > > > describes the threat model, and what you are trying to achieve with
> > > > AT_EXECVE_CHECK and O_DENY_WRITE?  I've been looking at the cover
> > > > letters for AT_EXECVE_CHECK and O_DENY_WRITE, and the documentation
> > > > that has landed for AT_EXECVE_CHECK and it really doesn't describe
> > > > what *are* the checks that AT_EXECVE_CHECK is trying to achieve:
> > > >
> > > >    "The AT_EXECVE_CHECK execveat(2) flag, and the
> > > >    SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
> > > >    securebits are intended for script interpreters and dynamic link=
ers
> > > >    to enforce a consistent execution security policy handled by the
> > > >    kernel."
> > >
> > > From the documentation:
> > >
> > >   Passing the AT_EXECVE_CHECK flag to execveat(2) only performs a che=
ck
> > >   on a regular file and returns 0 if execution of this file would be
> > >   allowed, ignoring the file format and then the related interpreter
> > >   dependencies (e.g. ELF libraries, script=E2=80=99s shebang).
> > >
> > > >
> > > > Um, what security policy?
> > >
> > > Whether the file is allowed to be executed.  This includes file
> > > permission, mount point option, ACL, LSM policies...
> >
> > This needs *waaaaay* more detail for any sort of useful evaluation.
> > Is an actual credible security policy rolling dice?  Asking ChatGPT?
> > Looking at security labels?  Does it care who can write to the file,
> > or who owns the file, or what the file's hash is, or what filesystem
> > it's on, or where it came from?  Does it dynamically inspect the
> > contents?  Is it controlled by an unprivileged process?
>
> AT_EXECVE_CHECK only does the same checks as done by other execveat(2)
> calls, but without actually executing the file/fd.
>

okay... but see below.

> >
> > I can easily come up with security policies for which DENYWRITE is
> > completely useless.  I can come up with convoluted and
> > not-really-credible policies where DENYWRITE is important, but I'm
> > honestly not sure that those policies are actually useful.  I'm
> > honestly a bit concerned that AT_EXECVE_CHECK is fundamentally busted
> > because it should have been parametrized by *what format is expected*
> > -- it might be possible to bypass a policy by executing a perfectly
> > fine Python script using bash, for example.
>
> There have been a lot of bikesheding for the AT_EXECVE_CHECK patch
> series, and a lot of discussions too (you where part of them).  We ended
> up with this design, which is simple and follows the kernel semantic
> (requested by Linus).

I recall this.  That doesn't mean I totally love AT_EXECVE_CHECK.  And
it especially doesn't mean that I believe that it usefully does
something that justifies anything like DENYWRITE.

>
> >
> > I genuinely have not come up with a security policy that I believe
> > makes sense that needs AT_EXECVE_CHECK and DENYWRITE.  I'm not saying
> > that such a policy does not exist -- I'm saying that I have not
> > thought of such a thing after a few minutes of thought and reading
> > these threads.
>
> A simple use case is for systems that wants to enforce a
> write-xor-execute policy e.g., thanks to mount point options.

Sure, but I'm contemplating DENYWRITE, and this thread is about
DENYWRITE.  If the kernel is enforcing W^X, then there are really two
almost unrelated things going on:

1. LSM policy that enforces W^X for memory mappings.  This is to
enforce that applications don't do nasty things like having executable
stacks, and it's a mess because no one has really figured out how JITs
are supposed to work in this world.  It has almost nothing to do with
execve except incidentally.

2. LSM policy that enforces that someone doesn't execve (or similar)
something that *that user* can write.  Or that non-root can write.  Or
that anyone at all can write, etc.

I think, but I'm not sure, that you're talking about #2.  So maybe
there's a policy that says that one may only exec things that are on
an fs with the 'exec' mount option.  Or maybe there's a policy that
says that one may only exec things that are on a readonly fs.  In
these specific cases, I believe in AT_EXECVE_CHECK.  *But* I don't
believe in DENYWRITE: in the 'exec' case, if an fs has the exec option
set, that doesn't change if the file is subsequently modified.  And if
an fs is readonly, then the file is quite unlikely to be modified at
all and will certainly not be modified via the mount through which
it's being executed.  And you don't need DENYWRITE.

So I think my question still stands: is there a credible security
policy *that actually benefits from DENYWRITE*?  If so, can you give
an example?

> >
> > Seriously, consider all the unending recent attacks on LLMs an
> > inspiration.  The implications of viewing an image, downscaling the
> > image, possibly interpreting the image as something containing text,
> > possibly following instructions in a given language contained in the
> > image, etc are all wildly different.  A mechanism for asking for
> > general permission to "consume this image" is COMPLETELY MISSING THE
> > POINT.  (Never mind that the current crop of LLMs seem entirely
> > incapable of constraining their own use of some piece of input, but
> > that's a different issue and is besides the point here.)
>
> You're asking about what should we consider executable.  This is a good
> question, but AT_EXECVE_CHECK is there to answer another question: would
> the kernel execute it or not?
>

That's a sort of odd way of putting it.  The kernel won't execute it
because the kernel doesn't know how to :)  But I think I understand
what you're saying.
