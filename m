Return-Path: <kernel-hardening-return-21804-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B406AC3DA60
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jul 2024 13:04:06 +0000 (UTC)
Received: (qmail 22442 invoked by uid 550); 18 Jul 2024 13:03:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22414 invoked from network); 18 Jul 2024 13:03:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1721307822;
	bh=1NFy46Q+LfOG35rBQJkuAv005voWnmcHap9tVgP7KOQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=EqxwmTOSRNJtFtk5AwJ0Z5qBMyhy2NCOkOXeXW8HUVkR3ovqW8rbWtWaqwMtaIy/8
	 lLuTY30entp2kvumD8WEYbMnX4y6lomypkHh1avo/Yt7vExEf+M4GpOdoC436vCVsL
	 v+nmdCbT0+VAkA5gkP6x+DVwJgzlz3DaB4sxzXh4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1721307822;
	bh=1NFy46Q+LfOG35rBQJkuAv005voWnmcHap9tVgP7KOQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=EqxwmTOSRNJtFtk5AwJ0Z5qBMyhy2NCOkOXeXW8HUVkR3ovqW8rbWtWaqwMtaIy/8
	 lLuTY30entp2kvumD8WEYbMnX4y6lomypkHh1avo/Yt7vExEf+M4GpOdoC436vCVsL
	 v+nmdCbT0+VAkA5gkP6x+DVwJgzlz3DaB4sxzXh4=
Message-ID: <544d08f5b55a0fbb1dc883bce6cf94c78cf46e42.camel@HansenPartnership.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Jeff Xu
	 <jeffxu@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>,  Kees Cook <keescook@chromium.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore
 Ts'o <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, Aleksa Sarai
 <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, Andy
 Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey
 Schaufler <casey@schaufler-ca.com>, Christian Heimes
 <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, Eric Biggers
 <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, Fan Wu
 <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, Geert
 Uytterhoeven <geert@linux-m68k.org>, James Morris
 <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams
 <ajordanr@google.com>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, Luis
 Chamberlain <mcgrof@kernel.org>,  "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
 Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox
 <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>,  Mimi Zohar
 <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, Stephen
 Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, Yin
 Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Date: Thu, 18 Jul 2024 09:03:36 -0400
In-Reply-To: <20240718.kaePhei9Ahm9@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
	 <20240704190137.696169-2-mic@digikod.net>
	 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
	 <20240717.neaB5Aiy2zah@digikod.net>
	 <CALmYWFt=yXpzhS=HS9FjwVMvx6U1MoR31vK79wxNLhmJm9bBoA@mail.gmail.com>
	 <20240718.kaePhei9Ahm9@digikod.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-07-18 at 14:24 +0200, Mickaël Salaün wrote:
> On Wed, Jul 17, 2024 at 07:08:17PM -0700, Jeff Xu wrote:
> > On Wed, Jul 17, 2024 at 3:01 AM Mickaël Salaün <mic@digikod.net>
> > wrote:
> > > On Tue, Jul 16, 2024 at 11:33:55PM -0700, Jeff Xu wrote:
[...]
> > > > I'm still thinking  execveat(AT_CHECK) vs faccessat(AT_CHECK)
> > > > in different use cases:
> > > > 
> > > > execveat clearly has less code change, but that also means: we
> > > > can't add logic specific to exec (i.e. logic that can't be
> > > > applied to config) for this part (from do_execveat_common to
> > > > security_bprm_creds_for_exec) in future.  This would require
> > > > some agreement/sign-off, I'm not sure from whom.
> > > 
> > > I'm not sure to follow. We could still add new flags, but for now
> > > I don't see use cases.  This patch series is not meant to handle
> > > all possible "trust checks", only executable code, which makes
> > > sense for the kernel.
> > > 
> > I guess the "configfile" discussion is where I get confused, at one
> > point, I think this would become a generic "trust checks" api for
> > everything related to "generating executable code", e.g.
> > javascript, java code, and more. We will want to clearly define the
> > scope of execveat(AT_CHECK)
> 
> The line between data and code is blurry.  For instance, a
> configuration file can impact the execution flow of a program.  So,
> where to draw the line?

Having a way to have config files part of the trusted envelope, either
by signing or measurement would be really useful.  The current standard
distro IMA deployment is signed executables, but not signed config
because it's hard to construct a policy that doesn't force the signing
of too many extraneous files (and files which might change often).

> It might makes sense to follow the kernel and interpreter semantic:
> if a file can be executed by the kernel (e.g. ELF binary, file
> containing a shebang, or just configured with binfmt_misc), then this
> should be considered as executable code.  This applies to Bash,
> Python, Javascript, NodeJS, PE, PHP...  However, we can also make a
> picture executable with binfmt_misc.  So, again, where to draw the
> line?

Possibly by making open for config an indication executables can give?
I'm not advocating doing it in this patch, but if we had an open for
config indication, the LSMs could do much finer grained policy,
especially if they knew which executable was trying to open the config
file.  It would allow things like an IMA policy saying if a signed
executable is opening a config file, then that file must also be
signed.

James

