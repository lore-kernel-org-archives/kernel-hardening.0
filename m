Return-Path: <kernel-hardening-return-21765-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 4A300C3DA41
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 21:40:52 +0000 (UTC)
Received: (qmail 32273 invoked by uid 550); 8 Jul 2024 21:40:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13642 invoked from network); 8 Jul 2024 21:25:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=python.org; s=200901;
	t=1720473943; bh=qP9JJjp2wwtgqNEqstI/ReNHBLe0F8Tj7JsMZZjC+tY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fRvlg0QXwIJAkXyrCKhMDJxtPyAXB0mjii1640HG3xWRb2W5P+42eQTBJPTIuhKpt
	 W7kH1zP794uZGf0rnntp5p+gP5s1k2YsFyKXYqxePPc8Ng44leBwaQk7RKeO5U7X6v
	 HzB8cs5L4tQul4iZaKKGJIvbQF7weKnmuCGRaspc=
Message-ID: <ef3281ad-48a5-4316-b433-af285806540d@python.org>
Date: Mon, 8 Jul 2024 22:25:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
Content-Language: en-GB
To: Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>,
 Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>,
 Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Jordan R Abrahams <ajordanr@google.com>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matt Bobrowski <mattbobrowski@google.com>,
 Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-3-mic@digikod.net>
 <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
 <CALmYWFsLUhkU5u1NKH8XWvSxbFKFOEq+A_eqLeDsN29xOEAYgg@mail.gmail.com>
 <20240708.quoe8aeSaeRi@digikod.net>
 <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
From: Steve Dower <steve.dower@python.org>
In-Reply-To: <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/07/2024 22:15, Jeff Xu wrote:
> IIUC:
> CHECK=0, RESTRICT=0: do nothing, current behavior
> CHECK=1, RESTRICT=0: permissive mode - ignore AT_CHECK results.
> CHECK=0, RESTRICT=1: call AT_CHECK, deny if AT_CHECK failed, no exception.
> CHECK=1, RESTRICT=1: call AT_CHECK, deny if AT_CHECK failed, except
> those in the "checked-and-allowed" list.

I had much the same question for Mickaël while working on this.

Essentially, "CHECK=0, RESTRICT=1" means to restrict without checking. 
In the context of a script or macro interpreter, this just means it will 
never interpret any scripts. Non-binary code execution is fully disabled 
in any part of the process that respects these bits.

"CHECK=1, RESTRICT=1" means to restrict unless AT_CHECK passes. This 
case is the allow list (or whatever mechanism is being used to determine 
the result of an AT_CHECK check). The actual mechanism isn't the 
business of the script interpreter at all, it just has to refuse to 
execute anything that doesn't pass the check. So a generic interpreter 
can implement a generic mechanism and leave the specifics to whoever 
configures the machine.

The other two case are more obvious. "CHECK=0, RESTRICT=0" is the 
zero-overhead case, while "CHECK=1, RESTRICT=0" might log, warn, or 
otherwise audit the result of the check, but it won't restrict execution.

Cheers,
Steve
