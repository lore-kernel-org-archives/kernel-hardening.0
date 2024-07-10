Return-Path: <kernel-hardening-return-21779-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2DAEEC3DA42
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Jul 2024 16:36:21 +0000 (UTC)
Received: (qmail 20317 invoked by uid 550); 10 Jul 2024 16:36:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15880 invoked from network); 10 Jul 2024 16:32:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=python.org; s=200901;
	t=1720629158; bh=h2ueXzl9+sWF3YmpYxvon1twDz2ALcDQP5/oXQTST5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=orCNdDWudCwG90M687meldIOq5/EKuuIheRaXFPgs6pRjZnOQvl0JDohh68MAjUiI
	 s4xIkd1yVurO4t3vSs1/vto/eK5p0gW0i5Yz0uvn0sdyeMtjkbfXJE5u9zsPFpqDN1
	 iXEmSBDTMNFhv/jRjzG1bSRS5+61zKFeOr4ihtow=
Message-ID: <296b11b2-5ff2-488b-ac4c-7945aabd7b3c@python.org>
Date: Wed, 10 Jul 2024 17:32:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
Content-Language: en-GB
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Jeff Xu <jeffxu@google.com>
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
 <ef3281ad-48a5-4316-b433-af285806540d@python.org>
 <CALmYWFuFE=V7sGp0_K+2Vuk6F0chzhJY88CP1CAE9jtd=rqcoQ@mail.gmail.com>
 <20240709.aech3geeMoh0@digikod.net>
 <CALmYWFuOXAiT05Pi2rZ1nUAKDGe9JyTH7fro2EYS1fh3zeGV5Q@mail.gmail.com>
 <20240710.eiKohpa4Phai@digikod.net>
From: Steve Dower <steve.dower@python.org>
In-Reply-To: <20240710.eiKohpa4Phai@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/07/2024 10:58, Mickaël Salaün wrote:
> On Tue, Jul 09, 2024 at 02:57:43PM -0700, Jeff Xu wrote:
>>> Hmm, I'm not sure this "CHECK=0, RESTRICT=1" configuration would make
>>> sense for a dynamic linker except maybe if we want to only allow static
>>> binaries?
>>>
>>> The CHECK and RESTRICT securebits are designed to make it possible a
>>> "permissive mode" and an enforcement mode with the related locked
>>> securebits.  This is why this "CHECK=0, RESTRICT=1" combination looks a
>>> bit weird.  We can replace these securebits with others but I didn't
>>> find a better (and simple) option.  I don't think this is an issue
>>> because with any security policy we can create unusable combinations.
>>> The three other combinations makes a lot of sense though.
>>>
>> If we need only handle 3  combinations,  I would think something like
>> below is easier to understand, and don't have wield state like
>> CHECK=0, RESTRICT=1
> 
> The "CHECK=0, RESTRICT=1" is useful for script interpreter instances
> that should not interpret any command from users e.g., but only execute
> script files.

I see this case as being most relevant to something that doesn't usually 
need any custom scripts, but may have it. For example, macros in a 
document, or pre/post-install scripts for a package manager.

For something whose sole purpose is to execute scripts, it doesn't make 
much sense. But there are other cases that can be reasonably controlled 
with this option.

Cheers,
Steve
