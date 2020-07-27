Return-Path: <SRS0=+crq=BG=lists.openwall.com=kernel-hardening-return-19457-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2238C433EC
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 16:24:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5909620719
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 16:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5909620719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19457-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24221 invoked by uid 550); 27 Jul 2020 16:24:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24189 invoked from network); 27 Jul 2020 16:24:11 -0000
Date: Mon, 27 Jul 2020 18:23:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Eric Dumazet <edumazet@google.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
	linux-can@vger.kernel.org, dccp@vger.kernel.org,
	linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org,
	linux-s390@vger.kernel.org, mptcp@lists.01.org,
	lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-afs@lists.infradead.org,
	tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
Message-ID: <20200727162357.GA8022@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-13-hch@lst.de> <20200727150310.GA1632472@zx2c4.com> <20200727150601.GA3447@lst.de> <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2020 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> Maybe sockptr_advance should have some safety checks and sometimes
> return -EFAULT? Or you should always use the implementation where
> being a kernel address is an explicit bit of sockptr_t, rather than
> being implicit?

I already have a patch to use access_ok to check the whole range in
init_user_sockptr.
