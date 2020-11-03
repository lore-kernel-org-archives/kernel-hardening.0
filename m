Return-Path: <SRS0=YwBu=EJ=lists.openwall.com=kernel-hardening-return-20332-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36078C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 16:04:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 22E8A223EA
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 16:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22E8A223EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20332-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9987 invoked by uid 550); 3 Nov 2020 16:04:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9952 invoked from network); 3 Nov 2020 16:03:59 -0000
Subject: Re: [PATCH v22 07/12] landlock: Support filesystem access-control
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
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-8-mic@digikod.net>
 <CAG48ez1xMfxkwhXK4b1BB4GrTVauNzfwPoCutn9axKt_PFRSVQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <056d8f1a-b45f-379f-d81a-8c13a1536c3f@digikod.net>
Date: Tue, 3 Nov 2020 17:03:45 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez1xMfxkwhXK4b1BB4GrTVauNzfwPoCutn9axKt_PFRSVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 29/10/2020 02:06, Jann Horn wrote:
> (On Tue, Oct 27, 2020 at 9:04 PM Mickaël Salaün <mic@digikod.net> wrote:

>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> [...]
>> +static inline u32 get_file_access(const struct file *const file)
>> +{
>> +       u32 access = 0;
>> +
>> +       if (file->f_mode & FMODE_READ) {
>> +               /* A directory can only be opened in read mode. */
>> +               if (S_ISDIR(file_inode(file)->i_mode))
>> +                       return LANDLOCK_ACCESS_FS_READ_DIR;
>> +               access = LANDLOCK_ACCESS_FS_READ_FILE;
>> +       }
>> +       /*
>> +        * A LANDLOCK_ACCESS_FS_APPEND could be added but we also need to check
>> +        * fcntl(2).
>> +        */
> 
> Once https://lore.kernel.org/linux-api/20200831153207.GO3265@brightrain.aerifal.cx/
> lands, pwritev2() with RWF_NOAPPEND will also be problematic for
> classifying "write" vs "append"; you may want to include that in the
> comment. (Or delete the comment.)

Contrary to fcntl(2), pwritev2(2) doesn't seems to modify the file
description. Otherwise, other LSMs would need to be patched.
I'll remove this comment anyway.

> 
>> +       if (file->f_mode & FMODE_WRITE)
>> +               access |= LANDLOCK_ACCESS_FS_WRITE_FILE;
>> +       /* __FMODE_EXEC is indeed part of f_flags, not f_mode. */
>> +       if (file->f_flags & __FMODE_EXEC)
>> +               access |= LANDLOCK_ACCESS_FS_EXECUTE;
>> +       return access;
>> +}
> [...]
> 
