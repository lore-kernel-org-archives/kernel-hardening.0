Return-Path: <SRS0=5ZLb=JT=lists.openwall.com=kernel-hardening-return-21217-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BB3C433ED
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Apr 2021 19:13:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3134561424
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Apr 2021 19:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3134561424
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21217-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20103 invoked by uid 550); 22 Apr 2021 19:12:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20083 invoked from network); 22 Apr 2021 19:12:53 -0000
Date: Fri, 23 Apr 2021 05:08:46 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
    "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, 
    Andy Lutomirski <luto@amacapital.net>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
    David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>, 
    Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, 
    Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
    Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
    kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
    x86@kernel.org, 
    =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v34 08/13] landlock: Add syscall implementations
In-Reply-To: <20210422154123.13086-9-mic@digikod.net>
Message-ID: <d4684742-452b-6e88-dd51-f1e9c29cb34d@namei.org>
References: <20210422154123.13086-1-mic@digikod.net> <20210422154123.13086-9-mic@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-299225943-1619118527=:394812"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-299225943-1619118527=:394812
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 22 Apr 2021, Mickaël Salaün wrote:

> +
> +	/* No flag for now. */
> +	if (flags)
> +		return -EINVAL;

Good, returning an error here instead of ignoring it is the right 
approach, so apps don't start using this and then break later.


-- 
James Morris
<jmorris@namei.org>

--1665246916-299225943-1619118527=:394812--
