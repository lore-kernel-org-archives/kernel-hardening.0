Return-Path: <SRS0=Ds97=A3=lists.openwall.com=kernel-hardening-return-19352-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19832C433E7
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 14:41:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72768206F4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 14:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72768206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19352-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24567 invoked by uid 550); 16 Jul 2020 14:41:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24544 invoked from network); 16 Jul 2020 14:41:12 -0000
Subject: Re: [PATCH v6 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
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
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-6-mic@digikod.net>
 <038639b1-92da-13c1-b3e5-8f13639a815e@infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <67fe6c17-a0b3-5c7e-a7c8-4c2b6e0c0592@digikod.net>
Date: Thu, 16 Jul 2020 16:40:56 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <038639b1-92da-13c1-b3e5-8f13639a815e@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 14/07/2020 20:40, Randy Dunlap wrote:
> Hi,
> 
> On 7/14/20 11:16 AM, Mickaël Salaün wrote:
> 
>> ---
>>  Documentation/admin-guide/sysctl/fs.rst | 45 +++++++++++++++++++++++++
>>  fs/namei.c                              | 29 +++++++++++++---
>>  include/linux/fs.h                      |  1 +
>>  kernel/sysctl.c                         | 12 +++++--
>>  4 files changed, 80 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
>> index 2a45119e3331..02ec384b8bbf 100644
>> --- a/Documentation/admin-guide/sysctl/fs.rst
>> +++ b/Documentation/admin-guide/sysctl/fs.rst
> 
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> 
> with one tiny nit:
> 
>> @@ -165,6 +166,50 @@ system needs to prune the inode list instead of allocating
>> +The ability to restrict code execution must be thought as a system-wide policy,
>> +which first starts by restricting mount points with the ``noexec`` option.
>> +This option is also automatically applied to special filesystems such as /proc
>> +.  This prevents files on such mount points to be directly executed by the
> 
> Can you move that period from the beginning of the line to the end of the
> previous line?

OK, done. Thanks!

> 
>> +kernel or mapped as executable memory (e.g. libraries).  With script
>> +interpreters using the ``O_MAYEXEC`` flag, the executable permission can then
>> +be checked before reading commands from files. This makes it possible to
>> +enforce the ``noexec`` at the interpreter level, and thus propagates this
>> +security policy to scripts.  To be fully effective, these interpreters also
>> +need to handle the other ways to execute code: command line parameters (e.g.,
>> +option ``-e`` for Perl), module loading (e.g., option ``-m`` for Python),
>> +stdin, file sourcing, environment variables, configuration files, etc.
>> +According to the threat model, it may be acceptable to allow some script
>> +interpreters (e.g. Bash) to interpret commands from stdin, may it be a TTY or a
>> +pipe, because it may not be enough to (directly) perform syscalls.
> 
> thanks.
> 
