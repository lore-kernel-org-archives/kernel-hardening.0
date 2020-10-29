Return-Path: <SRS0=oyEj=EE=lists.openwall.com=kernel-hardening-return-20308-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4742FC2D0A3
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 11:40:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 581E82076E
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 11:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 581E82076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20308-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28147 invoked by uid 550); 29 Oct 2020 11:40:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28115 invoked from network); 29 Oct 2020 11:40:15 -0000
Subject: Re: [PATCH v22 00/12] Landlock LSM
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
 the arch/x86 maintainers <x86@kernel.org>
References: <20201027200358.557003-1-mic@digikod.net>
 <CAG48ez31oct9c8fkgFHQVb5u-o5cmwdNe2pJnmitnKcidNgfzw@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <25f5ec87-5462-9d47-d265-ec442eb50046@digikod.net>
Date: Thu, 29 Oct 2020 12:40:02 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez31oct9c8fkgFHQVb5u-o5cmwdNe2pJnmitnKcidNgfzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 29/10/2020 02:05, Jann Horn wrote:
> On Tue, Oct 27, 2020 at 9:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>> This new patch series improves documentation, cleans up comments,
>> renames ARCH_EPHEMERAL_STATES to ARCH_EPHEMERAL_INODES and removes
>> LANDLOCK_ACCESS_FS_CHROOT.
> 
> Thanks for continuing to work on this! This is going to be really
> valuable for sandboxing.
> 
> I hadn't looked at this series for a while; but I've now read through
> it, and I don't see any major problems left. :) That said, there still
> are a couple small things...
> 

Thanks Jann, I really appreciate your reviews!
