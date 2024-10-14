Return-Path: <kernel-hardening-return-21842-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 65E77CFC501
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2024 07:40:17 +0000 (UTC)
Received: (qmail 11282 invoked by uid 550); 14 Oct 2024 07:40:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10234 invoked from network); 14 Oct 2024 07:40:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1728891596;
	bh=IK21ziFHzeZTWewfpsK1ouln6YyY8LRReKv9clTkIaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MjihJLQ7ZELqcL/G/6u3K+i36UXfZ4tGFKcErgGdZmintyw0hzKJDN1KBSwjxEY22
	 tuqaaFGJ1p9oOkqQRv2T1BPWhR5ARSffT78kVukyLG0h2AW+h6+dyIbLXadW4iuYzw
	 XQXfFasFeo2Y6UcTuWQ8sHMu0Ev3sW8kffRMZHr8=
Date: Mon, 14 Oct 2024 09:39:52 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v20 1/6] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20241014.ke5eeKoo6doh@digikod.net>
References: <20241011184422.977903-1-mic@digikod.net>
 <20241011184422.977903-2-mic@digikod.net>
 <20241013030416.GA1056921@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241013030416.GA1056921@mail.hallyn.com>
X-Infomaniak-Routing: alpha

On Sat, Oct 12, 2024 at 10:04:16PM -0500, Serge E. Hallyn wrote:
> On Fri, Oct 11, 2024 at 08:44:17PM +0200, Mickaël Salaün wrote:
> > Add a new AT_CHECK flag to execveat(2) to check if a file would be
> 
> Apologies for both bikeshedding and missing earlier discussions.
> 
> But AT_CHECK sounds quite generic.  How about AT_EXEC_CHECK, or
> AT_CHECK_EXEC_CREDS?  (I would suggest just AT_CHECK_CREDS since
> it's for use in execveat(2), but as it's an AT_ flag, it's
> probably worth being more precise).

As Amir pointed out, we need at least to use the AT_EXECVE_CHECK_
prefix, and I agree with the AT_EXECVE_CHECK name because it's about
checking the whole execve request, not sepcifically a "creds" part.
