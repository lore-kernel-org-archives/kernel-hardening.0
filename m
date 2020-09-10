Return-Path: <SRS0=3L9I=CT=lists.openwall.com=kernel-hardening-return-19852-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7053C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 18:38:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F8E1214F1
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 18:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F8E1214F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19852-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1741 invoked by uid 550); 10 Sep 2020 18:38:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1711 invoked from network); 10 Sep 2020 18:38:36 -0000
Subject: Re: [RFC PATCH v9 0/3] Add introspect_access(2) (was O_MAYEXEC)
To: Mimi Zohar <zohar@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Michael Kerrisk
 <mtk.manpages@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200910164612.114215-1-mic@digikod.net>
 <20200910170424.GU6583@casper.infradead.org>
 <f6e2358c-8e5e-e688-3e66-2cdd943e360e@digikod.net>
 <a48145770780d36e90f28f1526805a7292eb74f6.camel@linux.ibm.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <880bb4ee-89a2-b9b0-747b-0f779ceda995@digikod.net>
Date: Thu, 10 Sep 2020 20:38:21 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <a48145770780d36e90f28f1526805a7292eb74f6.camel@linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 10/09/2020 20:08, Mimi Zohar wrote:
> On Thu, 2020-09-10 at 19:21 +0200, Mickaël Salaün wrote:
>> On 10/09/2020 19:04, Matthew Wilcox wrote:
>>> On Thu, Sep 10, 2020 at 06:46:09PM +0200, Mickaël Salaün wrote:
>>>> This ninth patch series rework the previous AT_INTERPRETED and O_MAYEXEC
>>>> series with a new syscall: introspect_access(2) .  Access check are now
>>>> only possible on a file descriptor, which enable to avoid possible race
>>>> conditions in user space.
>>>
>>> But introspection is about examining _yourself_.  This isn't about
>>> doing that.  It's about doing ... something ... to a script that you're
>>> going to execute.  If the script were going to call the syscall, then
>>> it might be introspection.  Or if the interpreter were measuring itself,
>>> that would be introspection.  But neither of those would be useful things
>>> to do, because an attacker could simply avoid doing them.
>>
> 
> Michael, is the confusion here that IMA isn't measuring anything, but
> verifying the integrity of the file?   The usecase, from an IMA
> perspective, is enforcing a system wide policy requiring everything
> executed to be signed.  In this particular use case, the interpreter is
> asking the kernel if the script is signed with a permitted key.  The
> signature may be an IMA signature or an EVM portable and immutable
> signature, based on policy.

There is also the use case of noexec mounts and file permissions. From
user space point of view, it doesn't matter which kernel component is in
charge of defining the policy. The syscall should then not be tied with
a verification/integrity/signature/appraisal vocabulary, but simply an
access control one.

> 
>> Picking a good name other than "access" (or faccessat2) is not easy. The
>> idea with introspect_access() is for the calling task to ask the kernel
>> if this task should allows to do give access to a kernel resource which
>> is already available to this task. In this sense, we think that
>> introspection makes sense because it is the choice of the task to allow
>> or deny an access.
>>
>>>
>>> So, bad name.  What might be better?  sys_security_check()?
>>> sys_measure()?  sys_verify_fd()?  I don't know.
>>>
>>
>> "security_check" looks quite broad, "measure" doesn't make sense here,
>> "verify_fd" doesn't reflect that it is an access check. Yes, not easy,
>> but if this is the only concern we are on the good track. :)
> 
> Maybe replacing the term "measure" with "integrity", but rather than
> "integrity_check", something along the lines of fgetintegrity,
> freadintegrity, fcheckintegrity.

What about entrusted_access(2)? It reflects the fact that the kernel
delegate to (trusted) user space tasks some access enforcements.

> 
> Mimi
> 
>>
>>
>> Other ideas:
>> - interpret_access (mainly, but not only, for interpreters)
>> - indirect_access
>> - may_access
>> - faccessat3
> 
> 
