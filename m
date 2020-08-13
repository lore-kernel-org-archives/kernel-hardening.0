Return-Path: <SRS0=S0rT=BX=lists.openwall.com=kernel-hardening-return-19617-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6321AC433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 14:15:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B76D820675
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 14:15:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B76D820675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19617-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27830 invoked by uid 550); 13 Aug 2020 14:15:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27798 invoked from network); 13 Aug 2020 14:15:32 -0000
Subject: Re: [PATCH v20 05/12] LSM: Infrastructure management of the
 superblock
To: Stephen Smalley <sds@tycho.nsa.gov>,
 Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>,
 John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, James Morris <jmorris@namei.org>,
 Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200802215903.91936-1-mic@digikod.net>
 <20200802215903.91936-6-mic@digikod.net>
 <779c290b-45f5-b86c-c573-2edb4004105d@tycho.nsa.gov>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <03f522c0-414c-434b-a0d1-57c3b17fa67f@digikod.net>
Date: Thu, 13 Aug 2020 16:15:01 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <779c290b-45f5-b86c-c573-2edb4004105d@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 12/08/2020 21:16, Stephen Smalley wrote:
> On 8/2/20 5:58 PM, Mickaël Salaün wrote:
>> From: Casey Schaufler <casey@schaufler-ca.com>
>>
>> Move management of the superblock->sb_security blob out
>> of the individual security modules and into the security
>> infrastructure. Instead of allocating the blobs from within
>> the modules the modules tell the infrastructure how much
>> space is required, and the space is allocated there.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Reviewed-by: John Johansen <john.johansen@canonical.com>
>> Reviewed-by: Stephen Smalley <sds@tycho.nsa.gov>
>> Reviewed-by: Mickaël Salaün <mic@digikod.net>
>> Link:
>> https://lore.kernel.org/r/20190829232935.7099-2-casey@schaufler-ca.com
>> ---
>>
>> Changes since v17:
>> * Rebase the original LSM stacking patch from v5.3 to v5.7: I fixed some
>>    diff conflicts caused by code moves and function renames in
>>    selinux/include/objsec.h and selinux/hooks.c .  I checked that it
>>    builds but I didn't test the changes for SELinux nor SMACK.
> 
> You shouldn't retain Signed-off-by and Reviewed-by lines from an earlier
> patch if you made non-trivial changes to it (even more so if you didn't
> test them).

I think I made trivial changes according to the original patch. But
without reply from other people with Signed-off-by or Reviewed-by
(Casey, Kees, John), I'll remove them. I guess you don't want your
Reviewed-by to be kept, so I'll remove it, except if you want to review
this patch (or the modified part).
