Return-Path: <SRS0=tuMM=E2=lists.openwall.com=kernel-hardening-return-20428-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9333C388F9
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 01:53:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A8FC52145D
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 01:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8FC52145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20428-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1872 invoked by uid 550); 20 Nov 2020 01:53:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1837 invoked from network); 20 Nov 2020 01:53:15 -0000
Date: Fri, 20 Nov 2020 12:52:38 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Jann Horn <jannh@google.com>
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
        x86@kernel.org,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v24 02/12] landlock: Add ruleset and domain management
In-Reply-To: <20201112205141.775752-3-mic@digikod.net>
Message-ID: <alpine.LRH.2.21.2011201251010.15634@namei.org>
References: <20201112205141.775752-1-mic@digikod.net> <20201112205141.775752-3-mic@digikod.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1401825409-1605837159=:15634"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1401825409-1605837159=:15634
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Nov 2020, Mickaël Salaün wrote:

> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> ---
> 
> Changes since v23:
> * Always intersect access rights.  Following the filesystem change
>   logic, make ruleset updates more consistent by always intersecting
>   access rights (boolean AND) instead of combining them (boolean OR) for
>   the same layer.  This defensive approach could also help avoid user
>   space to inadvertently allow multiple access rights for the same
>   object (e.g.  write and execute access on a path hierarchy) instead of
>   dealing with such inconsistency.  This can happen when there is no
>   deduplication of objects (e.g. paths and underlying inodes) whereas
>   they get different access rights with landlock_add_rule(2).
> * Add extra checks to make sure that:
>   - there is always an (allocated) object in each used rules;
>   - when updating a ruleset with a new rule (i.e. not merging two
>     rulesets), the ruleset doesn't contain multiple layers.
> * Hide merge parameter from the public landlock_insert_rule() API.  This
>   helps avoid misuse of this function.
> * Replace a remaining hardcoded 1 with SINGLE_DEPTH_NESTING.

Jann: any chance you could review this patch again given the changes 
above?

Thanks.


-- 
James Morris
<jmorris@namei.org>

--1665246916-1401825409-1605837159=:15634--
