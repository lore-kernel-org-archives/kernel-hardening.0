Return-Path: <SRS0=if/P=DV=lists.openwall.com=kernel-hardening-return-20203-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEAFC433E7
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 18:52:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C91C22246
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 18:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C91C22246
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20203-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15435 invoked by uid 550); 14 Oct 2020 18:52:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15400 invoked from network); 14 Oct 2020 18:52:23 -0000
Subject: Re: [PATCH v21 07/12] landlock: Support filesystem access-control
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20201008153103.1155388-1-mic@digikod.net>
 <20201008153103.1155388-8-mic@digikod.net>
 <alpine.LRH.2.21.2010150504360.26012@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <77ea263c-4200-eb74-24b2-9a8155aff9b5@digikod.net>
Date: Wed, 14 Oct 2020 20:52:08 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2010150504360.26012@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 14/10/2020 20:07, James Morris wrote:
> On Thu, 8 Oct 2020, Mickaël Salaün wrote:
> 
>> +config ARCH_EPHEMERAL_STATES
>> +	def_bool n
>> +	help
>> +	  An arch should select this symbol if it does not keep an internal kernel
>> +	  state for kernel objects such as inodes, but instead relies on something
>> +	  else (e.g. the host kernel for an UML kernel).
>> +
> 
> This is used to disable Landlock for UML, correct?

Yes

> I wonder if it could be 
> more specific: "ephemeral states" is a very broad term.
> 
> How about something like ARCH_OWN_INODES ?

Sounds good. We may need add new ones (e.g. for network socket, UID,
etc.) in the future though.
