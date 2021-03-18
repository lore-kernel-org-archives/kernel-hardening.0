Return-Path: <SRS0=xPko=IQ=lists.openwall.com=kernel-hardening-return-20983-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C63C433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 23:13:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 06A9D64F24
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 23:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06A9D64F24
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20983-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30518 invoked by uid 550); 18 Mar 2021 23:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30492 invoked from network); 18 Mar 2021 23:13:31 -0000
Date: Fri, 19 Mar 2021 10:10:35 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Jann Horn <jannh@google.com>, "Serge E . Hallyn" <serge@hallyn.com>, 
    Al Viro <viro@zeniv.linux.org.uk>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Andy Lutomirski <luto@amacapital.net>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
    David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>, 
    Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
    Michael Kerrisk <mtk.manpages@gmail.com>, 
    Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
    Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
    kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, 
    x86@kernel.org, 
    =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 07/12] landlock: Support filesystem access-control
In-Reply-To: <20210316204252.427806-8-mic@digikod.net>
Message-ID: <f6fdc839-cedd-edff-3e61-cd212f4223c@namei.org>
References: <20210316204252.427806-1-mic@digikod.net> <20210316204252.427806-8-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


> This commit adds a minimal set of supported filesystem access-control
> which doesn't enable to restrict all file-related actions.

It would be great to get some more review/acks on this patch, particularly 
from VFS/FS folk.


-- 
James Morris
<jmorris@namei.org>

