Return-Path: <kernel-hardening-return-21908-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B6074E77184
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Dec 2024 07:45:21 +0000 (UTC)
Received: (qmail 7368 invoked by uid 550); 19 Dec 2024 07:45:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7340 invoked from network); 19 Dec 2024 07:45:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1734594302;
	bh=oKhFkfeKlHLMteV17dJwPYDJMj25IWwSaNtedn4t5og=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0PaeD2mZXMVXSB0s3zaJLGesGRhVGJwjco61VkN0AtFjed07nbQSnjPZq0OMG4Uiu
	 6GGqjloRLZ+q2vtgOzexlRTyqCRQmT7TjrWl+anvbdbs6ryn0zJs5ggkQ/7y6qXsl9
	 4EbXr0LzwyzvuSLNxj4fMgTNVxzVW43NV/jKyqCA=
Date: Thu, 19 Dec 2024 08:44:56 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Kees Cook <kees@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Theodore Ts'o <tytso@mit.edu>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v23 0/8] Script execution control (was O_MAYEXEC)
Message-ID: <20241219.CaiVie9caNge@digikod.net>
References: <20241212174223.389435-1-mic@digikod.net>
 <20241218.aBaituy0veK7@digikod.net>
 <202412181130.84A2FCF2@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202412181130.84A2FCF2@keescook>
X-Infomaniak-Routing: alpha

On Wed, Dec 18, 2024 at 11:31:57AM -0800, Kees Cook wrote:
> On Wed, Dec 18, 2024 at 11:40:59AM +0100, Mickaël Salaün wrote:
> > In the meantime I've pushed it in my tree, it should appear in -next
> > tomorrow.  Please, let me know when you take it, I'll remove it from my
> > tree.
> 
> Thanks! Yeah, I was just finally getting through my email after my
> pre-holiday holiday. ;)
> 
> I'll get this into my -next tree now.

Thanks, I just removed mine.

> 
> -Kees
> 
> -- 
> Kees Cook
