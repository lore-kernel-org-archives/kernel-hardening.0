Return-Path: <SRS0=4rD+=EF=lists.openwall.com=kernel-hardening-return-20311-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0E3C4363A
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Oct 2020 12:42:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 08E1920719
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Oct 2020 12:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08E1920719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20311-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30710 invoked by uid 550); 30 Oct 2020 12:41:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30627 invoked from network); 30 Oct 2020 12:41:42 -0000
Subject: Re: [PATCH v22 08/12] landlock: Add syscall implementations
To: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger
 <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-9-mic@digikod.net>
 <CAG48ez1San538w=+He309vHg4pBSCvAf7e5xeHdqeOHA6qwitw@mail.gmail.com>
 <de287149-ff42-40ca-5bd1-f48969880a06@digikod.net>
 <CAG48ez1FQVkt78129WozBwFbVhAPyAr9oJAHFHAbbNxEBr9h1g@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <163f298b-b492-fee0-b475-102ae8170419@digikod.net>
Date: Fri, 30 Oct 2020 13:41:29 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez1FQVkt78129WozBwFbVhAPyAr9oJAHFHAbbNxEBr9h1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 30/10/2020 04:07, Jann Horn wrote:
> On Thu, Oct 29, 2020 at 12:30 PM Mickaël Salaün <mic@digikod.net> wrote:
>> On 29/10/2020 02:06, Jann Horn wrote:
>>> On Tue, Oct 27, 2020 at 9:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>>>> These 3 system calls are designed to be used by unprivileged processes
>>>> to sandbox themselves:
> [...]
>>>> +       /*
>>>> +        * Similar checks as for seccomp(2), except that an -EPERM may be
>>>> +        * returned.
>>>> +        */
>>>> +       if (!task_no_new_privs(current)) {
>>>> +               err = security_capable(current_cred(), current_user_ns(),
>>>> +                               CAP_SYS_ADMIN, CAP_OPT_NOAUDIT);
>>>
>>> I think this should be ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN)?
>>
>> Right. The main difference is that ns_capable*() set PF_SUPERPRIV in
>> current->flags. I guess seccomp should use ns_capable_noaudit() as well?
> 
> Yeah. That seccomp code is from commit e2cfabdfd0756, with commit date
> in April 2012, while ns_capable_noaudit() was introduced in commit
> 98f368e9e263, with commit date in June 2016; the seccomp code predates
> the availability of that API.
> 
> Do you want to send a patch to Kees for that, or should I?
> 

I found another case of this inconsistency in ptrace. I sent patches:
https://lore.kernel.org/lkml/20201030123849.770769-1-mic@digikod.net/
