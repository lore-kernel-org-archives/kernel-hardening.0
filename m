Return-Path: <kernel-hardening-return-21773-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2566DC2BD09
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jul 2024 20:43:13 +0000 (UTC)
Received: (qmail 32438 invoked by uid 550); 9 Jul 2024 20:42:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32411 invoked from network); 9 Jul 2024 20:42:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1720557769;
	bh=nDu9N6iZS4Lyv2hlEEUB0oUIC/M/y2uYLqX0goXo3sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1FMlMQ54mh76md4zMT3d84xYnJsItu6is9Hwa+GWCVdZd10AKJNNKloZ4aD2LRmHd
	 0IQG9slNgks/siDVdV7BybKWU9uNwJoe3tpWWxv7l0COEL+eblgknoRpVzWrJ3voPi
	 FaYe8+CubLSlDuo6ztOcihY/B53HBeoCu2doqr5w=
Date: Tue, 9 Jul 2024 22:42:45 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 5/5] samples/should-exec: Add set-should-exec
Message-ID: <20240709.chait2ahKeos@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-6-mic@digikod.net>
 <968619d912ee5a57aed6c73218221ef445a0766e.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <968619d912ee5a57aed6c73218221ef445a0766e.camel@linux.ibm.com>
X-Infomaniak-Routing: alpha

On Mon, Jul 08, 2024 at 03:40:42PM -0400, Mimi Zohar wrote:
> Hi Mickaël,
> 
> On Thu, 2024-07-04 at 21:01 +0200, Mickaël Salaün wrote:
> > Add a simple tool to set SECBIT_SHOULD_EXEC_CHECK,
> > SECBIT_SHOULD_EXEC_RESTRICT, and their lock counterparts before
> > executing a command.  This should be useful to easily test against
> > script interpreters.
> 
> The print_usage() provides the calling syntax.  Could you provide an example of
> how to use it and what to expect?

To set SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT, and lock
them on a new shell (session) we can use this:

./set-should-exec -crl -- bash -i

This would have no impact unless Bash, ld.so, or one of its child code
is patched to restrict execution (e.g. with execveat+AT_CHECK check).
Script interpreters and dynamic linkers need to be patch on a secure
sysetm.  Steve is enlightening Python, and we'll need more similar
changes for common user space code.  This can be an incremental work and
only enforced on some user sessions or containers for instance.

> 
> thanks,
> 
> Mimi
> 
> 
