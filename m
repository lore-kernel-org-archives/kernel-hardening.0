Return-Path: <kernel-hardening-return-21511-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id C2BB7C433F5
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Dec 2021 09:22:41 +0000 (UTC)
Received: (qmail 5901 invoked by uid 550); 1 Dec 2021 09:22:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5881 invoked from network); 1 Dec 2021 09:22:31 -0000
Message-ID: <4a88f95b-d54d-ad70-fb49-e3c3f1d097f2@digikod.net>
Date: Wed, 1 Dec 2021 10:23:42 +0100
MIME-Version: 1.0
User-Agent:
Content-Language: en-US
To: Florian Weimer <fweimer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alejandro Colomar <alx.manpages@gmail.com>, Aleksa Sarai
 <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org
References: <20211115185304.198460-1-mic@digikod.net>
 <87sfvd8k4c.fsf@oldenburg.str.redhat.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v17 0/3] Add trusted_for(2) (was O_MAYEXEC)
In-Reply-To: <87sfvd8k4c.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 30/11/2021 21:27, Florian Weimer wrote:
> * Mickaël Salaün:
> 
>> Primary goal of trusted_for(2)
>> ==============================
>>
>> This new syscall enables user space to ask the kernel: is this file
>> descriptor's content trusted to be used for this purpose?  The set of
>> usage currently only contains execution, but other may follow (e.g.
>> configuration, sensitive data).  If the kernel identifies the file
>> descriptor as trustworthy for this usage, user space should then take
>> this information into account.  The "execution" usage means that the
>> content of the file descriptor is trusted according to the system policy
>> to be executed by user space, which means that it interprets the content
>> or (try to) maps it as executable memory.
> 
> I sketched my ideas about “IMA gadgets” here:
> 
>    IMA gadgets
>    <https://www.openwall.com/lists/oss-security/2021/11/30/1>
> 
> I still don't think the proposed trusted_for interface is sufficient.
> The example I gave is a Perl module that does nothing (on its own) when
> loaded as a Perl module (although you probably don't want to sign it
> anyway, given what it implements), but triggers an unwanted action when
> sourced (using .) as a shell script.

The fact that IMA doesn't cover all metadata, file names nor the file 
hierarchies is well known and the solution can be implemented with 
dm-verity (which has its own drawbacks).

trusted_for is a tool for interpreters to enforce a security policy 
centralized by the kernel. The kind of file confusion attacks you are 
talking about should be addressed by a system policy. If the mount point 
options are not enough to express such policy, then we need to rely on 
IMA, SELinux or IPE to reduce the scope of legitimate mapping between 
scripts and interpreters.

> 
>> @usage identifies the user space usage intended for @fd: only
>> TRUSTED_FOR_EXECUTION for now, but trusted_for_usage could be extended
>> to identify other usages (e.g. configuration, sensitive data).
> 
> We would need TRUSTED_FOR_EXECUTION_BY_BASH,
> TRUSTED_FOR_EXECUTION_BY_PERL, etc.  I'm not sure that actually works.

Well, this doesn't scale and that is the reason trusted_for usage is 
more generic. The kernel already has all the information required to 
identify scripts and interpreters types. We don't need to make the user 
space interface more complex by listing all types. The kernel only miss 
the semantic of how the intrepreter wants to interpret files, and that 
is the purpose of trusted_for. LSMs are designed to define complex 
policies and trusted_for enables them to extend such policies.

> 
> Caller process context does not work because we have this confusion
> internally between glibc's own use (for the dynamic linker
> configuration), and for loading programs/shared objects (there seems to
> be a corner case where you can execute arbitrary code even without
> executable mappings in the ELF object), and the script interpreter
> itself (the primary target for trusted_for).

The current use case for trusted_for is script interpreters, but we can 
extend the trusted_for_usage enum with new usages like TRUSTED_FOR_LINK 
and others. I'm not convinced glibc should be treated differently than 
other executable code that want to load a shared library, but it is a 
discussion we can have when trusted_for will be in mainline and someone 
will propose a new usage. ;)

> 
> But for generating auditing events, trusted_for seems is probably quite
> helpful.

Indeed, it enables to add semantic to audit events.
