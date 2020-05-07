Return-Path: <SRS0=4RDS=6V=lists.openwall.com=kernel-hardening-return-18732-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8911BC38A24
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 08:37:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DEF8D2078C
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 08:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEF8D2078C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18732-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7420 invoked by uid 550); 7 May 2020 08:36:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7400 invoked from network); 7 May 2020 08:36:55 -0000
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
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
Date: Thu, 7 May 2020 10:36:41 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 07/05/2020 10:05, David Laight wrote:
> From: Mickaël Salaün
>> Sent: 05 May 2020 16:32
>>
>> This fifth patch series add new kernel configurations (OMAYEXEC_STATIC,
>> OMAYEXEC_ENFORCE_MOUNT, and OMAYEXEC_ENFORCE_FILE) to enable to
>> configure the security policy at kernel build time.  As requested by
>> Mimi Zohar, I completed the series with one of her patches for IMA.
>>
>> The goal of this patch series is to enable to control script execution
>> with interpreters help.  A new O_MAYEXEC flag, usable through
>> openat2(2), is added to enable userspace script interpreter to delegate
>> to the kernel (and thus the system security policy) the permission to
>> interpret/execute scripts or other files containing what can be seen as
>> commands.
>>
>> A simple system-wide security policy can be enforced by the system
>> administrator through a sysctl configuration consistent with the mount
>> points or the file access rights.  The documentation patch explains the
>> prerequisites.
>>
>> Furthermore, the security policy can also be delegated to an LSM, either
>> a MAC system or an integrity system.  For instance, the new kernel
>> MAY_OPENEXEC flag closes a major IMA measurement/appraisal interpreter
>> integrity gap by bringing the ability to check the use of scripts [1].
>> Other uses are expected, such as for openat2(2) [2], SGX integration
>> [3], bpffs [4] or IPE [5].
>>
>> Userspace needs to adapt to take advantage of this new feature.  For
>> example, the PEP 578 [6] (Runtime Audit Hooks) enables Python 3.8 to be
>> extended with policy enforcement points related to code interpretation,
>> which can be used to align with the PowerShell audit features.
>> Additional Python security improvements (e.g. a limited interpreter
>> withou -c, stdin piping of code) are on their way.
>>
>> The initial idea come from CLIP OS 4 and the original implementation has
>> been used for more than 12 years:
>> https://github.com/clipos-archive/clipos4_doc
>>
>> An introduction to O_MAYEXEC was given at the Linux Security Summit
>> Europe 2018 - Linux Kernel Security Contributions by ANSSI:
>> https://www.youtube.com/watch?v=chNjCRtPKQY&t=17m15s
>> The "write xor execute" principle was explained at Kernel Recipes 2018 -
>> CLIP OS: a defense-in-depth OS:
>> https://www.youtube.com/watch?v=PjRE0uBtkHU&t=11m14s
>>
>> This patch series can be applied on top of v5.7-rc4.  This can be tested
>> with CONFIG_SYSCTL.  I would really appreciate constructive comments on
>> this patch series.
> 
> None of that description actually says what the patch actually does.

"Add support for O_MAYEXEC" "to enable to control script execution".
What is not clear here? This seems well understood by other commenters.
The documentation patch and the talks can also help.
