Return-Path: <SRS0=8aNJ=IR=lists.openwall.com=kernel-hardening-return-20985-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D22DC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 15:52:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31DDE6195D
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 15:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31DDE6195D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20985-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5919 invoked by uid 550); 19 Mar 2021 15:52:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5896 invoked from network); 19 Mar 2021 15:52:01 -0000
Subject: Re: [PATCH v30 00/12] Landlock LSM
To: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger
 <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, Dmitry Vyukov <dvyukov@google.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <651a1034-c59f-1085-d3f6-c5a41f6fbbb@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <39a58eb2-7cd8-9cc9-cbf1-829b6ee59f6b@digikod.net>
Date: Fri, 19 Mar 2021 16:52:02 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <651a1034-c59f-1085-d3f6-c5a41f6fbbb@namei.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit


On 19/03/2021 00:26, James Morris wrote:
> I've queued this patchset here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git landlock_lsm
> 
> and pulled it into next-testing, which will get it coverage in linux-next.
> 
> All going well, I'll aim to push this to Linus in the next merge window. 
> More review and testing during that time will be helpful.

Good, thanks! The syzkaller changes are now merged and up-to-date with
linux-next:
https://github.com/google/syzkaller/commits/3d01c4de549b4e4bddba6102715c212bbcff2fbb
