Return-Path: <SRS0=u08b=6V=lists.openwall.com=kernel-hardening-return-18737-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88408C38A24
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 13:38:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E500220643
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 13:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E500220643
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18737-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31896 invoked by uid 550); 7 May 2020 13:38:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31866 invoked from network); 7 May 2020 13:38:34 -0000
Subject: Re: [PATCH v5 0/6] Add support for O_MAYEXEC
To: David Laight <David.Laight@ACULAB.COM>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20200505153156.925111-1-mic@digikod.net>
 <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
 <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
 <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
 <64426377-7fc4-6f37-7371-2e2a584e3032@digikod.net>
 <635df0655b644408ac4822def8900383@AcuMS.aculab.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <1ced6f5f-7181-1dc5-2da7-abf4abd5ad23@digikod.net>
Date: Thu, 7 May 2020 15:38:19 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <635df0655b644408ac4822def8900383@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 07/05/2020 11:44, David Laight wrote:
> From: Mickaël Salaün <mic@digikod.net>
>> Sent: 07 May 2020 10:30
>> On 07/05/2020 11:00, David Laight wrote:
>>> From: Mickaël Salaün
>>>> Sent: 07 May 2020 09:37
>>> ...
>>>>> None of that description actually says what the patch actually does.
>>>>
>>>> "Add support for O_MAYEXEC" "to enable to control script execution".
>>>> What is not clear here? This seems well understood by other commenters.
>>>> The documentation patch and the talks can also help.
>>>
>>> I'm guessing that passing O_MAYEXEC to open() requests the kernel
>>> check for execute 'x' permissions (as well as read).
>>
>> Yes, but only with openat2().
> 
> It can't matter if the flag is ignored.
> It just means the kernel isn't enforcing the policy.
> If openat2() fail because the flag is unsupported then
> the application will need to retry without the flag.

I don't get what you want to prove. Please read carefully the cover
letter, the use case and the threat model.

> 
> So if the user has any ability create executable files this
> is all pointless (from a security point of view).
> The user can either copy the file or copy in an interpreter
> that doesn't request O_MAYEXEC.>
> It might stop accidental issues, but nothing malicious.

The execute permission (like the write permission) does not only depends
on the permission set on files, but it also depends on the
options/permission of their mount points, the MAC policy, etc. The
initial use case to enforce O_MAYEXEC is to rely on the noexec mount option.

If you want a consistent policy, you need to make one. Only dealing with
file properties may not be enough. This is explain in the cover letter
and the patches. If you allow all users to write and execute their
files, then there is no point in enforcing anything with O_MAYEXEC.

> 
>>> Then kernel policy determines whether 'read' access is actually enough,
>>> or whether 'x' access (possibly masked by mount permissions) is needed.
>>>
>>> If that is true, two lines say what is does.
>>
>> The "A simple system-wide security policy" paragraph introduce that, but
>> I'll highlight it in the next cover letter.
> 
> No it doesn't.
> It just says there is some kind of policy that some flags change.
> It doesn't say what is being checked for.

It said "the mount points or the file access rights". Please take a look
at the documentation patch.

> 
>> The most important point is
>> to understand why it is required, before getting to how it will be
>> implemented.
> 
> But you don't say what is required.

A consistent policy. Please take a look at the documentation patch which
explains the remaining prerequisites. You can also take a look at the
talks for further details.

> Just a load of buzzword ramblings.

It is a summary. Can you please suggest something better?
