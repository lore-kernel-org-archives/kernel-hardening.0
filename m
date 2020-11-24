Return-Path: <SRS0=BM+W=E6=lists.openwall.com=kernel-hardening-return-20459-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7678C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Nov 2020 02:38:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0924020719
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Nov 2020 02:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0924020719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20459-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9524 invoked by uid 550); 24 Nov 2020 02:38:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9485 invoked from network); 24 Nov 2020 02:38:42 -0000
Date: Tue, 24 Nov 2020 13:38:00 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Jann Horn <jannh@google.com>
cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
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
        the arch/x86 maintainers <x86@kernel.org>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v24 12/12] landlock: Add user and kernel documentation
In-Reply-To: <CAG48ez0S1_jd0YzXZ9tx94gU0sw-WeXgG336d=3YP7+iZvRgaA@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2011241337530.26713@namei.org>
References: <20201112205141.775752-1-mic@digikod.net> <20201112205141.775752-13-mic@digikod.net> <CAG48ez0S1_jd0YzXZ9tx94gU0sw-WeXgG336d=3YP7+iZvRgaA@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1736655908-1606185482=:26713"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1736655908-1606185482=:26713
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 21 Nov 2020, Jann Horn wrote:

> On Thu, Nov 12, 2020 at 9:52 PM Mickaël Salaün <mic@digikod.net> wrote:
> > This documentation can be built with the Sphinx framework.
> >
> > Cc: James Morris <jmorris@namei.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Serge E. Hallyn <serge@hallyn.com>
> > Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> > Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> 

Thanks, Jann!

-- 
James Morris
<jmorris@namei.org>

--1665246916-1736655908-1606185482=:26713--
