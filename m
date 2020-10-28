Return-Path: <SRS0=ZEP3=ED=lists.openwall.com=kernel-hardening-return-20291-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF57C388F7
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Oct 2020 05:30:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 677AC2224E
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Oct 2020 05:30:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 677AC2224E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20291-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31798 invoked by uid 550); 28 Oct 2020 05:30:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31763 invoked from network); 28 Oct 2020 05:30:25 -0000
Date: Wed, 28 Oct 2020 16:29:35 +1100 (AEDT)
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
        x86@kernel.org, John Johansen <john.johansen@canonical.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Subject: Re: [PATCH v22 05/12] LSM: Infrastructure management of the
 superblock
In-Reply-To: <20201027200358.557003-6-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2010281628570.25689@namei.org>
References: <20201027200358.557003-1-mic@digikod.net> <20201027200358.557003-6-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-514386363-1603862978=:25689"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-514386363-1603862978=:25689
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 27 Oct 2020, Mickaël Salaün wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Move management of the superblock->sb_security blob out of the
> individual security modules and into the security infrastructure.
> Instead of allocating the blobs from within the modules, the modules
> tell the infrastructure how much space is required, and the space is
> allocated there.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: John Johansen <john.johansen@canonical.com>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>

It would be good to see review from JJ here.

-- 
James Morris
<jmorris@namei.org>

--1665246916-514386363-1603862978=:25689--
