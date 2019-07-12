Return-Path: <SRS0=zgl8=VJ=lists.openwall.com=kernel-hardening-return-16445-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E92C742D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 23:37:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73967208E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 23:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73967208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16445-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11859 invoked by uid 550); 12 Jul 2019 23:37:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11824 invoked from network); 12 Jul 2019 23:37:20 -0000
Date: Sat, 13 Jul 2019 09:35:53 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Brad Spengler <spender@grsecurity.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 03/12] S.A.R.A.: cred blob management
In-Reply-To: <1562410493-8661-4-git-send-email-s.mesoraca16@gmail.com>
Message-ID: <alpine.LRH.2.21.1907130921580.21853@namei.org>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com> <1562410493-8661-4-git-send-email-s.mesoraca16@gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 6 Jul 2019, Salvatore Mesoraca wrote:

> Creation of the S.A.R.A. cred blob management "API".
> In order to allow S.A.R.A. to be stackable with other LSMs, it doesn't use
> the "security" field of struct cred, instead it uses an ad hoc field named
> security_sara.
> This solution is probably not acceptable for upstream, so this part will
> be modified as soon as the LSM stackable cred blob management will be
> available.

This description is out of date wrt cred blob sharing.

> +	if (sara_data_init()) {
> +		pr_crit("impossible to initialize creds.\n");
> +		goto error;
> +	}
> +

> +int __init sara_data_init(void)
> +{
> +	security_add_hooks(data_hooks, ARRAY_SIZE(data_hooks), "sara");
> +	return 0;
> +}

This can't fail so make it return void and simplify the caller.



-- 
James Morris
<jmorris@namei.org>

