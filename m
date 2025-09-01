Return-Path: <kernel-hardening-return-21999-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 75EA9CA0FFF
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Sep 2025 16:25:42 +0000 (UTC)
Received: (qmail 5404 invoked by uid 550); 1 Sep 2025 16:25:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5344 invoked from network); 1 Sep 2025 16:25:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756743923;
	bh=Xy9c0RnED3HT39yD+fhi1E7AHRKldhfJxdRE7gKyi/E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Z7IU2/FsWPS2YWB0kzeYM2ObtiwET9Kra0CYZYw06ild8oKNLCkxWc7Vfsm9bVuQe
	 4ZzPUt4sqB2bDQ+SI3eAssF/kmXIB0Y93UTATCsPHb5bGk1BvbNvXgMO3iYCBTXLLs
	 8c7e+7i1hw/nfIVNVge3CR/QjSNdpGWvLuaCuXYIbWk6PLSrrLq6JyYopyxuqgCZrN
	 Zmkgq+utnmXu+vCfB1DRCRZ1kVm7edWVi9ifrqSx0PAq/TsjN6omcEtXW6BUWSBlAz
	 vfW8gEZO7B/KKnMedjJbfDn/aXGDweWBmAuE1REQj04J8I9H9uv0be/+OS0n+iCF1Y
	 2JunIyl9GjxiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtAIcvNKROt1uQXO9UtPpQeMtNHhWqB+elR0PuC7mgfJNIw9gkIt+OSDltwGrA6oEDvs1nTwZjirPxuWkLtgB1@lists.openwall.com
X-Gm-Message-State: AOJu0YwSgsoNzOXUMIpDda36AGR7xoVEDOWtWKuGbbPLF9eiHAZkTH0W
	0pCmlKsHxlfm8xUam8Y5b2Kta6BdcNKyWhM0W5Gf0cxkax4Tlf3KX0QgMlbl/0grNgGAIA/KA2w
	Ww9lOF4F6bJQfssQjPpPWIf2Jb+zzBZFpi4eDTlGp
X-Google-Smtp-Source: AGHT+IHQaKnUNWLNFQYNtSQSa47g2pu7CpYY6T/b9pUgP8BH0aybd+qYJdHgPCMppjygHDMCLF/KHVs2OD16WVL33oA=
X-Received: by 2002:a05:651c:1543:b0:336:e1c4:6c6f with SMTP id
 38308e7fff4ca-336e1c47336mr14179671fa.19.1756743920925; Mon, 01 Sep 2025
 09:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250822170800.2116980-1-mic@digikod.net> <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net> <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
 <54e27d05bae55749a975bc7cbe109b237b2b1323.camel@huaweicloud.com>
In-Reply-To: <54e27d05bae55749a975bc7cbe109b237b2b1323.camel@huaweicloud.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 1 Sep 2025 09:25:09 -0700
X-Gmail-Original-Message-ID: <CALCETrUtJmWxKYSi6QQAGpQR_ETNfoBidCu_VEq8Lx9iJAOyEw@mail.gmail.com>
X-Gm-Features: Ac12FXxyw6xiBo675X_GNr-mU7ryRcDYbQiEmCEhhXrRzSi1-YYVHnkbnMyWAA0
Message-ID: <CALCETrUtJmWxKYSi6QQAGpQR_ETNfoBidCu_VEq8Lx9iJAOyEw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
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

Can you clarify this a bit for those of us who are not well-versed in
exactly what "measurement" does?

On Mon, Sep 1, 2025 at 2:42=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> > Now, in cases where you have IMA or something and you only permit signe=
d
> > binaries to execute, you could argue there is a different race here (an
> > attacker creates a malicious script, runs it, and then replaces it with
> > a valid script's contents and metadata after the fact to get
> > AT_EXECVE_CHECK to permit the execution). However, I'm not sure that
>
> Uhm, let's consider measurement, I'm more familiar with.
>
> I think the race you wanted to express was that the attacker replaces
> the good script, verified with AT_EXECVE_CHECK, with the bad script
> after the IMA verification but before the interpreter reads it.
>
> Fortunately, IMA is able to cope with this situation, since this race
> can happen for any file open, where of course a file can be not read-
> locked.

I assume you mean that this has nothing specifically to do with
scripts, as IMA tries to protect ordinary (non-"execute" file access)
as well.  Am I right?

>
> If the attacker tries to concurrently open the script for write in this
> race window, IMA will report this event (called violation) in the
> measurement list, and during remote attestation it will be clear that
> the interpreter did not read what was measured.
>
> We just need to run the violation check for the BPRM_CHECK hook too
> (then, probably for us the O_DENY_WRITE flag or alternative solution
> would not be needed, for measurement).

This seems consistent with my interpretation above, but ...

>
> Please, let us know when you apply patches like 2a010c412853 ("fs:
> don't block i_writecount during exec"). We had a discussion [1], but
> probably I missed when it was decided to be applied (I saw now it was
> in the same thread, but didn't get that at the time). We would have
> needed to update our code accordingly. In the future, we will try to
> clarify better our expectations from the VFS.

... I didn't follow this.

Suppose there's some valid contents of /bin/sleep.  I execute
/bin/sleep 1m.  While it's running, I modify /bin/sleep (by opening it
for write, not by replacing it), and the kernel in question doesn't do
ETXTBSY.  Then the sleep process reads (and executes) the modified
contents.  Wouldn't a subsequent attestation fail?  Why is ETXTBSY
needed?
