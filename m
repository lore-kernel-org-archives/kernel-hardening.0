Return-Path: <kernel-hardening-return-21987-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7234FCA0EFF
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Aug 2025 17:36:04 +0000 (UTC)
Received: (qmail 14328 invoked by uid 550); 27 Aug 2025 17:35:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14295 invoked from network); 27 Aug 2025 17:35:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756316142;
	bh=FIed+i9mU8QVyJwJUuYJhiPLw4w7Z4LZFu4tEeKK2tQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rxcM90Mr7RLpuUh7uleG8dKJQyT7RaI0Xnq+WTZK+85Dx6J+7v5UhTymmilOudGvS
	 ENBzUWXBQnykk4ork6goPhQrsRxhXqB2KsqXdzcG4yroDdvgKUquOIKsCddJcgFMWb
	 /REcfpuedCSwUMesMYQ7NwIBx5iJocUbOmIc7TKXfVe13ej6qwy+8GoE635+Gqfbjb
	 u/KG7s55NH8OQP7pfd7isrbxhlS9N9DX51mGcNacb5BE6piKCAhMfeEN0RU0kMkA5o
	 m+XoPDLBkZocfzA+N2LEXxhOhcKzsaqUVALdAf/aFRL5emh1HAiw3MHPPEip45MW+E
	 g6Gi4J1spr58w==
X-Forwarded-Encrypted: i=1; AJvYcCWTjJxiEWTzBKrj6+nElIjbzsOi2wS4snOK48rBT6IuY2S6iKXBUG3+oSjvy7ZmOWPXjcB6v5iAzUsVFNP4ko/C@lists.openwall.com
X-Gm-Message-State: AOJu0YyxuxFVS/p35rZ4lP4OkRQ83UH9egZ7DWmliGLai91ANrpoZP46
	08iq1y4DAuICtz5gd/heqCCMOnqcBC4xvLA82+W5gr/plRpUR9nHu8XntXlbI2lDm0Ni5WTPYCX
	pnckMggY5OPj5GrnjcHUvLQFXx+sklHG2wjzHD5PD
X-Google-Smtp-Source: AGHT+IHUn8MO0aESC/OldXVkEKhuKEEb6fGxgOuf4xrzSp6WeZVtALeUAoQkfV5FV3cUoazA0fJyWvYRcGm5SnNCYls=
X-Received: by 2002:a05:651c:23d2:10b0:333:f086:3092 with SMTP id
 38308e7fff4ca-33650e704femr46730461fa.11.1756316140285; Wed, 27 Aug 2025
 10:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <20250826123041.GB1603531@mit.edu> <20250826.iewie7Et5aiw@digikod.net>
In-Reply-To: <20250826.iewie7Et5aiw@digikod.net>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 27 Aug 2025 10:35:28 -0700
X-Gmail-Original-Message-ID: <CALCETrW=V9vst_ho2Q4sQUJ5uZECY5h7TnF==sG4JWq8PsWb8Q@mail.gmail.com>
X-Gm-Features: Ac12FXxYtvycqmWfxuJptxMotttRmHwSaZZf5AQ5i4iJuwxj-1Y4BGUYtJz7etM
Message-ID: <CALCETrW=V9vst_ho2Q4sQUJ5uZECY5h7TnF==sG4JWq8PsWb8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
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

On Tue, Aug 26, 2025 at 10:47=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>
> On Tue, Aug 26, 2025 at 08:30:41AM -0400, Theodore Ts'o wrote:
> > Is there a single, unified design and requirements document that
> > describes the threat model, and what you are trying to achieve with
> > AT_EXECVE_CHECK and O_DENY_WRITE?  I've been looking at the cover
> > letters for AT_EXECVE_CHECK and O_DENY_WRITE, and the documentation
> > that has landed for AT_EXECVE_CHECK and it really doesn't describe
> > what *are* the checks that AT_EXECVE_CHECK is trying to achieve:
> >
> >    "The AT_EXECVE_CHECK execveat(2) flag, and the
> >    SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
> >    securebits are intended for script interpreters and dynamic linkers
> >    to enforce a consistent execution security policy handled by the
> >    kernel."
>
> From the documentation:
>
>   Passing the AT_EXECVE_CHECK flag to execveat(2) only performs a check
>   on a regular file and returns 0 if execution of this file would be
>   allowed, ignoring the file format and then the related interpreter
>   dependencies (e.g. ELF libraries, script=E2=80=99s shebang).
>
> >
> > Um, what security policy?
>
> Whether the file is allowed to be executed.  This includes file
> permission, mount point option, ACL, LSM policies...

This needs *waaaaay* more detail for any sort of useful evaluation.
Is an actual credible security policy rolling dice?  Asking ChatGPT?
Looking at security labels?  Does it care who can write to the file,
or who owns the file, or what the file's hash is, or what filesystem
it's on, or where it came from?  Does it dynamically inspect the
contents?  Is it controlled by an unprivileged process?

I can easily come up with security policies for which DENYWRITE is
completely useless.  I can come up with convoluted and
not-really-credible policies where DENYWRITE is important, but I'm
honestly not sure that those policies are actually useful.  I'm
honestly a bit concerned that AT_EXECVE_CHECK is fundamentally busted
because it should have been parametrized by *what format is expected*
-- it might be possible to bypass a policy by executing a perfectly
fine Python script using bash, for example.

I genuinely have not come up with a security policy that I believe
makes sense that needs AT_EXECVE_CHECK and DENYWRITE.  I'm not saying
that such a policy does not exist -- I'm saying that I have not
thought of such a thing after a few minutes of thought and reading
these threads.


> > And then on top of it, why can't you do these checks by modifying the
> > script interpreters?
>
> The script interpreter requires modification to use AT_EXECVE_CHECK.
>
> There is no other way for user space to reliably check executability of
> files (taking into account all enforced security
> policies/configurations).
>

As mentioned above, even AT_EXECVE_CHECK does not obviously accomplish
this goal.  If it were genuinely useful, I would much, much prefer a
totally different API: a *syscall* that takes, as input, a file
descriptor of something that an interpreter wants to execute and a
whole lot of context as to what that interpreter wants to do with it.
And I admit I'm *still* not convinced.

Seriously, consider all the unending recent attacks on LLMs an
inspiration.  The implications of viewing an image, downscaling the
image, possibly interpreting the image as something containing text,
possibly following instructions in a given language contained in the
image, etc are all wildly different.  A mechanism for asking for
general permission to "consume this image" is COMPLETELY MISSING THE
POINT.  (Never mind that the current crop of LLMs seem entirely
incapable of constraining their own use of some piece of input, but
that's a different issue and is besides the point here.)
