Return-Path: <SRS0=D5zJ=EQ=lists.openwall.com=kernel-hardening-return-20375-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64B6C388F7
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 06:48:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D353F2065C
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 06:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D353F2065C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20375-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3802 invoked by uid 550); 10 Nov 2020 06:48:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3764 invoked from network); 10 Nov 2020 06:48:03 -0000
Date: Tue, 10 Nov 2020 17:47:14 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>, Jann Horn <jannh@google.com>,
        Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v23 00/12] Landlock LSM
In-Reply-To: <20201103182109.1014179-1-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2011101745100.9130@namei.org>
References: <20201103182109.1014179-1-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1397860341-1604990838=:9130"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1397860341-1604990838=:9130
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 3 Nov 2020, Mickaël Salaün wrote:

> Hi,
> 
> Can you please consider to merge this into the tree?
> 

I've added this to my tree:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git landlock_lsm

and merged into next-testing (which is pulled into linux-next).


Please make any further changes against the branch in my tree.


-- 
James Morris
<jmorris@namei.org>

--1665246916-1397860341-1604990838=:9130--
