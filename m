Return-Path: <SRS0=Ahx9=LC=lists.openwall.com=kernel-hardening-return-21292-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F888C4743D
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 08:53:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3B56610C7
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 08:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3B56610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21292-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24477 invoked by uid 550); 8 Jun 2021 08:53:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24443 invoked from network); 8 Jun 2021 08:53:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uXsfBS09h5r8atqX2PNh5Ig45l4lwTr4pwZjL/r3r08=;
 b=rIHqGiszTwgFXYU/29HrTXFSuOgR9+nwuryBFW68Xibj9DLPsIar+VXv/BI9MdswqoYW
 2qR4lyled93+VhADteVmUs9HeKBOAQyMh8qnNO8Fr5XK8r1U1S4AZ0uFyUc4sgJY9EIf
 +XrbhyeczsMbcIjlnA9yYyf/LrrpIKgiANecaz/VPhzenvG0jKqlG1h1YvJYHJEEt7RH
 mscM9rM8T6aLdp334Non989aCGXV6XRsWAl6PMNBuuz3mBtdfATRf1MNq5iz+iZ0jnLw
 MwQZc+pA5q0zFWnC/kVAdl3hiEU70Or7jAUNXolAmXEZy+puOr+cvoJseSgdfyJFalN6 Vw== 
Date: Tue, 8 Jun 2021 11:53:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: SyzScope <syzscope@gmail.com>,
        syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <20210608085310.GA1955@kadam>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL3zGGMRwmD7fNK+@zx2c4.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: 9xkxAKvdty5E81yk4zbMACfpHhdkZeVE
X-Proofpoint-ORIG-GUID: 9xkxAKvdty5E81yk4zbMACfpHhdkZeVE

This SyzScope stuff could be good in theory and it could be something
useful with more work.  But in real life terms do you know anyone who
looked at "use-after-free Read in hci_chan_del" and thought, "Oh that
sounds totally harmless."

regards,
dan carpenter

