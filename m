Return-Path: <SRS0=Z13K=64=lists.openwall.com=kernel-hardening-return-18799-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD938C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 17:32:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 046C7206DC
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 17:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 046C7206DC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18799-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10089 invoked by uid 550); 14 May 2020 17:32:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10054 invoked from network); 14 May 2020 17:32:05 -0000
Date: Fri, 15 May 2020 03:31:38 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v17 05/10] fs,landlock: Support filesystem
 access-control
In-Reply-To: <c159d845-6108-4b67-6527-405589fa5382@digikod.net>
Message-ID: <alpine.LRH.2.21.2005150329580.26489@namei.org>
References: <20200511192156.1618284-1-mic@digikod.net> <20200511192156.1618284-6-mic@digikod.net> <alpine.LRH.2.21.2005141335280.30052@namei.org> <c159d845-6108-4b67-6527-405589fa5382@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-621977297-1589477498=:26489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-621977297-1589477498=:26489
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 May 2020, Mickaël Salaün wrote:

> > This needs to be converted to the LSM API via superblock blob stacking.
> > 
> > See Casey's old patch: 
> > https://lore.kernel.org/linux-security-module/20190829232935.7099-2-casey@schaufler-ca.com/
> 
> s_landlock_inode_refs is quite similar to s_fsnotify_inode_refs, but I
> can do it once the superblock security blob patch is upstream. Is it a
> blocker for now? What is the current status of lbs_superblock?

Yes it is a blocker. Landlock should not be adding its own functions in 
core code, it should be using the LSM API (and extending that as needed).

> Anyway, we also need to have a call to landlock_release_inodes() in
> generic_shutdown_super(), which does not fit the LSM framework, and I
> think it is not an issue. Landlock handling of inodes is quite similar
> to fsnotify.

fsnotify is not an LSM.

-- 
James Morris
<jmorris@namei.org>

--1665246916-621977297-1589477498=:26489--
