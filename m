Return-Path: <SRS0=yvXn=4O=lists.openwall.com=kernel-hardening-return-17960-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24853C4BA12
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 15:35:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8394624680
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 15:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8394624680
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17960-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1321 invoked by uid 550); 26 Feb 2020 15:35:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1289 invoked from network); 26 Feb 2020 15:35:28 -0000
Subject: Re: [RFC PATCH v14 00/10] Landlock LSM
To: J Freyensee <why2jjj.linux@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200224160215.4136-1-mic@digikod.net>
 <6df3e6b1-ffd1-dacf-2f2d-7df8e5aca668@gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <5ec24e38-1a6f-590a-3b30-50caae177e9b@digikod.net>
Date: Wed, 26 Feb 2020 16:34:59 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <6df3e6b1-ffd1-dacf-2f2d-7df8e5aca668@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 25/02/2020 19:49, J Freyensee wrote:
> 
> 
> On 2/24/20 8:02 AM, Mickaël Salaün wrote:
> 
>> ## Syscall
>>
>> Because it is only tested on x86_64, the syscall is only wired up for
>> this architecture.  The whole x86 family (and probably all the others)
>> will be supported in the next patch series.
> General question for u.  What is it meant "whole x86 family will be
> supported".  32-bit x86 will be supported?

Yes, I was referring to x86_32, x86_64 and x32, but all architectures
should be supported.
