Return-Path: <kernel-hardening-return-21801-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A0398C3DA49
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jul 2024 12:23:43 +0000 (UTC)
Received: (qmail 23597 invoked by uid 550); 18 Jul 2024 12:23:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23571 invoked from network); 18 Jul 2024 12:23:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721305402;
	bh=2miiI/5j4wTJs9zVbOsNd+rOxv6jp8fs/L7lmo5Xt3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gy83JArLMq864jKTREMY1Kn2Kfo3QT5j03SQkLmXwJryYVvObFoTAR0tvHMpGFGPN
	 URCOIjHWu2cVo1uWWxNDPbO0VqEVGtxcbbezzRaNyXizzRIpp/q6ln8nyKGU/scq+u
	 fBbAw+t6lcv38UVvqf0UWNtLJfRnqBjQr2qzl5lM=
Date: Thu, 18 Jul 2024 14:23:19 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Steve Dower <steve.dower@python.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20240718.ahph4che5Shi@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org>
 <20240717.AGh2shahc9ee@digikod.net>
 <CALmYWFvxJSyi=BT5BKDiKCNanmbhLuZ6=iAMvv1ibnP24SC7fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFvxJSyi=BT5BKDiKCNanmbhLuZ6=iAMvv1ibnP24SC7fA@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Wed, Jul 17, 2024 at 06:51:11PM -0700, Jeff Xu wrote:
> On Wed, Jul 17, 2024 at 3:00 AM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
> > > On 17/07/2024 07:33, Jeff Xu wrote:
> > > > Consider those cases: I think:
> > > > a> relying purely on userspace for enforcement does't seem to be
> > > > effective,  e.g. it is trivial  to call open(), then mmap() it into
> > > > executable memory.
> > >
> > > If there's a way to do this without running executable code that had to pass
> > > a previous execveat() check, then yeah, it's not effective (e.g. a Python
> > > interpreter that *doesn't* enforce execveat() is a trivial way to do it).
> > >
> > > Once arbitrary code is running, all bets are off. So long as all arbitrary
> > > code is being checked itself, it's allowed to do things that would bypass
> > > later checks (and it's up to whoever audited it in the first place to
> > > prevent this by not giving it the special mark that allows it to pass the
> > > check).
> >
> We will want to define what is considered as "arbitrary code is running"
> 
> Using an example of ROP, attackers change the return address in stack,
> e.g. direct the execution flow to a gauge to call "ld.so /tmp/a.out",
> do you consider "arbitrary code is running" when stack is overwritten
> ? or after execve() is called.

Yes, ROP is arbitrary code execution (which can be mitigated with CFI).
ROP could be enough to interpret custom commands and create a small
interpreter/VM.

> If it is later, this patch can prevent "ld.so /tmp/a.out".
> 
> > Exactly.  As explained in the patches, one crucial prerequisite is that
> > the executable code is trusted, and the system must provide integrity
> > guarantees.  We cannot do anything without that.  This patches series is
> > a building block to fix a blind spot on Linux systems to be able to
> > fully control executability.
> 
> Even trusted executable can have a bug.

Definitely, but this patch series is dedicated to script execution
control.

> 
> I'm thinking in the context of ChromeOS, where all its system services
> are from trusted partitions, and legit code won't load .so from a
> non-exec mount.  But we want to sandbox those services, so even under
> some kind of ROP attack, the service still won't be able to load .so
> from /tmp. Of course, if an attacker can already write arbitrary
> length of data into the stack, it is probably already a game over.
> 

OK, you want to tie executable file permission to mmap.  That makes
sense if you have a consistent execution model.  This can be enforced by
LSMs.  Contrary to script interpretation which is a full user space
implementation (and then controlled by user space), mmap restrictions
should indeed be enforced by the kernel.
