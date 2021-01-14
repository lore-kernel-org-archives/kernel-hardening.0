Return-Path: <SRS0=2AVq=GR=lists.openwall.com=kernel-hardening-return-20646-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEABC433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 19:00:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 430DA23B6B
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 19:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 430DA23B6B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20646-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7441 invoked by uid 550); 14 Jan 2021 19:00:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7408 invoked from network); 14 Jan 2021 19:00:00 -0000
Subject: Re: [PATCH v26 11/12] samples/landlock: Add a sandbox manager example
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
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
References: <20201209192839.1396820-1-mic@digikod.net>
 <20201209192839.1396820-12-mic@digikod.net>
 <CAG48ez2yQNvcCrmCCBZKy_cxoZzNgremxWMia1YHsgaj4edqrA@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <f3ca5fb2-64c6-b525-0f16-5353f1f7eddb@digikod.net>
Date: Thu, 14 Jan 2021 19:59:57 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez2yQNvcCrmCCBZKy_cxoZzNgremxWMia1YHsgaj4edqrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 14/01/2021 04:21, Jann Horn wrote:
> On Wed, Dec 9, 2020 at 8:29 PM Mickaël Salaün <mic@digikod.net> wrote:
>> Add a basic sandbox tool to launch a command which can only access a
>> whitelist of file hierarchies in a read-only or read-write way.
> 
> I have to admit that I didn't really look at this closely before
> because it's just sample code... but I guess I should. You can add
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> 
> if you fix the following nits:

OK, I will!

> 
> [...]
>> diff --git a/samples/Kconfig b/samples/Kconfig
> [...]
>> +config SAMPLE_LANDLOCK
>> +       bool "Build Landlock sample code"
>> +       depends on HEADERS_INSTALL
>> +       help
>> +         Build a simple Landlock sandbox manager able to launch a process
>> +         restricted by a user-defined filesystem access control.
> 
> nit: s/filesystem access control/filesystem access control policy/
> 
> [...]
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> [...]
>> +/*
>> + * Simple Landlock sandbox manager able to launch a process restricted by a
>> + * user-defined filesystem access control.
> 
> nit: s/filesystem access control/filesystem access control policy/
> 
> [...]
>> +int main(const int argc, char *const argv[], char *const *const envp)
>> +{
> [...]
>> +       if (argc < 2) {
> [...]
>> +               fprintf(stderr, "* %s: list of paths allowed to be used in a read-only way.\n",
>> +                               ENV_FS_RO_NAME);
>> +               fprintf(stderr, "* %s: list of paths allowed to be used in a read-write way.\n",
>> +                               ENV_FS_RO_NAME);
> 
> s/ENV_FS_RO_NAME/ENV_FS_RW_NAME/
> 
>> +               fprintf(stderr, "\nexample:\n"
>> +                               "%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
>> +                               "%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>> +                               "%s bash -i\n",
>> +                               ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +               return 1;
>> +       }
>> +
>> +       ruleset_fd = landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +       if (ruleset_fd < 0) {
>> +               perror("Failed to create a ruleset");
>> +               switch (errno) {
> 
> (Just as a note: In theory perror() can change the value of errno, as
> far as I know - so AFAIK you'd theoretically have to do something
> like:
> 
> int errno_ = errno;
> perror("...");
> switch (errno_) {
>  ...
> }

Indeed :)

> 
> I'll almost certainly work fine as-is in practice though.)
> 
