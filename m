Return-Path: <SRS0=oFW7=JU=lists.openwall.com=kernel-hardening-return-21221-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B547C433ED
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Apr 2021 15:22:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 596F1613D5
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Apr 2021 15:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 596F1613D5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21221-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31924 invoked by uid 550); 23 Apr 2021 15:22:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31904 invoked from network); 23 Apr 2021 15:22:37 -0000
Subject: Re: [PATCH v34 00/13] Landlock LSM
To: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
 "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org
References: <20210422154123.13086-1-mic@digikod.net>
 <9c775578-627c-e682-873a-ec7b763a7fcd@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <ac26af3b-067b-de01-8c99-687c5de432e5@digikod.net>
Date: Fri, 23 Apr 2021 17:22:11 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <9c775578-627c-e682-873a-ec7b763a7fcd@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 22/04/2021 21:31, James Morris wrote:
> On Thu, 22 Apr 2021, Mickaël Salaün wrote:
> 
>> Hi,
>>
>> This updated patch series adds a new patch on top of the previous ones.
>> It brings a new flag to landlock_create_ruleset(2) that enables
>> efficient and simple backward compatibility checks for future evolutions
>> of Landlock (e.g. new access-control rights).
> 
> Applied to git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git 
> landlock_lsm_v34
> 
> and it replaces the v33 branch in next-testing.

Thanks! It is now in next:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/?h=next-20210423
