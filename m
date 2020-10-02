Return-Path: <SRS0=VtsP=DJ=lists.openwall.com=kernel-hardening-return-20087-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A7FC4363C
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 15:22:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6DC74206DC
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 15:22:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DC74206DC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20087-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25910 invoked by uid 550); 2 Oct 2020 15:22:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25878 invoked from network); 2 Oct 2020 15:22:40 -0000
Date: Fri, 2 Oct 2020 17:22:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <20201002152219.GB3875@1wt.eu>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
User-Agent: Mutt/1.6.1 (2016-04-27)

On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> and activity") broke compilation and was temporarily fixed by Linus in
> 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> gcc plugin") by entirely moving net_rand_state out of the things handled
> by the latent_entropy GCC plugin.
> 
> From what I understand when reading the plugin code, using the
> __latent_entropy attribute on a declaration was the wrong part and
> simply keeping the __latent_entropy attribute on the variable definition
> was the correct fix.

Ah thank you, this is what I tried to figure and failed to! Spender
mentioned that a one-liner was all that was needed to fix this but
never responded to my request asking about it.

Willy
