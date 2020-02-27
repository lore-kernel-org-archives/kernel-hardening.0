Return-Path: <SRS0=ctzm=4P=lists.openwall.com=kernel-hardening-return-17974-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB49C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 16:51:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C978B20801
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 16:51:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C978B20801
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17974-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17960 invoked by uid 550); 27 Feb 2020 16:51:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17928 invoked from network); 27 Feb 2020 16:51:02 -0000
Subject: Re: [RFC PATCH v14 05/10] fs,landlock: Support filesystem
 access-control
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
References: <20200224160215.4136-1-mic@digikod.net>
 <20200224160215.4136-6-mic@digikod.net>
 <CAG48ez36SMrPPgsj0omcVukRLwOzBzqWOQjuGCmmmrmsGiNukw@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <34319b76-44bd-8915-fd7c-5147f901615e@digikod.net>
Date: Thu, 27 Feb 2020 17:50:31 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez36SMrPPgsj0omcVukRLwOzBzqWOQjuGCmmmrmsGiNukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000



On 26/02/2020 21:29, Jann Horn wrote:
> On Mon, Feb 24, 2020 at 5:03 PM Mickaël Salaün <mic@digikod.net> wrote:
>> +static inline u32 get_mem_access(unsigned long prot, bool private)
>> +{
>> +       u32 access = LANDLOCK_ACCESS_FS_MAP;
>> +
>> +       /* Private mapping do not write to files. */
>> +       if (!private && (prot & PROT_WRITE))
>> +               access |= LANDLOCK_ACCESS_FS_WRITE;
>> +       if (prot & PROT_READ)
>> +               access |= LANDLOCK_ACCESS_FS_READ;
>> +       if (prot & PROT_EXEC)
>> +               access |= LANDLOCK_ACCESS_FS_EXECUTE;
>> +       return access;
>> +}
> 
> When I do the following, is landlock going to detect that the mmap()
> is a read access, or is it incorrectly going to think that it's
> neither read nor write?
> 
> $ cat write-only.c
> #include <fcntl.h>
> #include <sys/mman.h>
> #include <stdio.h>
> int main(void) {
>   int fd = open("/etc/passwd", O_RDONLY);
>   char *ptr = mmap(NULL, 0x1000, PROT_WRITE, MAP_PRIVATE, fd, 0);
>   printf("'%.*s'\n", 4, ptr);
> }
> $ gcc -o write-only write-only.c -Wall
> $ ./write-only
> 'root'
> $
> 

Thanks to the "if (!private && (prot & PROT_WRITE))", Landlock allows
this private mmap (as intended) even if there is no write access to this
file, but not with a shared mmap (and a file opened with O_RDWR). I just
added a test for this to be sure.

However, I'm not sure this hook is useful for now. Indeed, the process
still need to have a file descriptor open with the right accesses.
