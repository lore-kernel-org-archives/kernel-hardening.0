Return-Path: <SRS0=caNu=LC=lists.openwall.com=kernel-hardening-return-21291-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5958BC4743E
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 08:46:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6227C6124B
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 08:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6227C6124B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21291-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20161 invoked by uid 550); 8 Jun 2021 08:46:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20129 invoked from network); 8 Jun 2021 08:46:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=O
	cJGuks2BsIJ9Z1Uvy/YBynhz/rsZ2UduAezquC86NI=; b=Av6caqxi5rTeJuJHw
	NWZllbrLTXvWa6MpjlijpjX11gb55Q9azwW9YidOA7pOaoaBZSbY9Er5dQF3lAwH
	XRCYFjQQkWNjX09zfqB2bbyTZ2mYtyx2iNJu1VVlM/KfyAN6Tnjugvlkl6cKwKrF
	v5Q4Stz39wCAJcxFC3HftStWE/BMDI9JOUeza2CR4jQFVcJlT+N3QezxzhJe2yIB
	S3QXGkKjZ7jcy1uCy+7X53oQC0v2UeKU+K61lSBBZrBzNm4bUcg9wC8QCa5ErgDI
	2c+8ZfMRSyHtP9PSb0qUczFUy5Fqcr7m9/I999kyu60xVMk94hj+0wYvV7Y1Yvfl
	dSSWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; bh=OcJGuks2BsIJ9Z1Uvy/YBynhz/rsZ2UduAezquC86
	NI=; b=LQ3VVl0vrlrnC1fH8a6CIwcGKSaKfX0uKUPPrFAxMAoczlzylddAm1zFD
	rYqKAwYGUWA/3OAg2hMIW9NFlRfDq7MZTwuuEqBL226S/F/OSkbV31O/L3ZudGdN
	xIv+0nG+5SjqmHYHjrZXqM6E72EZ8DcfQig6lt4AVp+Yan/a2FE3fusNCm0/TnYE
	rEUdURyDrdJdZzWXpPKA7bHeyZoilks79sJa8CquafC8YfJHuVXf0ibgmvQLTr1i
	XC3auMTnQ6ebbQDZd0RxdXliO92ysTZJ3e/teU8uNtYzNWOtwuCxWbJvchXXkuG/
	bESeHmPi1hLl9C76I1WnQkySvf12Q==
X-ME-Sender: <xms:TS6_YIUQMV85vYceE_lEfts11O3sw_pzt-ANcNmNvDlGmb4-zWcgpQ>
    <xme:TS6_YMmiTXVRcc3dMiyofq3ut_wU-7FvwJ7wa7jYb8bZoSlbYoLjrMtumMsY2oU2Z
    lmyh9f1u44CKw>
X-ME-Received: <xmr:TS6_YMY9-whsuVEzWq1Bp1BSfff-rqAZsKkvlLrs-jk_6INBXZz8KoY_ZE7TZO3TWk_spwo0adZE16jkQr7Ag6vv3SjhsTPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:TS6_YHWd5HfNLAvh7lnUeqIL8D5jGoHawtStOpDi8ll8GN3zLPjDag>
    <xmx:TS6_YCnt7Uu46jz_WR3dWUz52tJNSV5gJXuTALwt-yUAhUW-zsoxqg>
    <xmx:TS6_YMdsE8gWbnV1WaLsXIEZv-twskMgkpCqAI_AQWZy05m4peZpYw>
    <xmx:Ty6_YEXRGZbV09VfuUGJhNrBV6JF7eva0271Y_yYabrH33rJJ0R8ng>
Date: Tue, 8 Jun 2021 10:46:04 +0200
From: Greg KH <greg@kroah.com>
To: SyzScope <syzscope@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
	davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	marcel@holtmann.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL8uTH9Ey3U38yPr@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
 <YL4BAKHPZqH6iPdP@kroah.com>
 <dd3094fa-9cb8-91c2-7631-a69c34eac387@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd3094fa-9cb8-91c2-7631-a69c34eac387@gmail.com>

On Mon, Jun 07, 2021 at 11:26:26AM -0700, SyzScope wrote:
> Hi all,
> We are really thankful for all the suggestions and concerns. We are
> definitely interested in continuing this line of research.
> 
> Just to clarify:  SyzScope is an ongoing research project that is currently
> under submission, which has an anonymity requirement.

As documented, we can not accept anonymous contributions to the kernel,
so perhaps just wait until your paper is accepted?  However, we take
patches from researchers all the time under their real names while their
papers are being reviewed, so this "requirement" seems odd to me, who is
requiring this?

> Therefore we chose to
> use a gmail address initially in the public channel. Since Greg asked, we
> did reveal our university affiliation and email address, as well as
> cross-referenced a private email (again using university address) to
> security@kernel.org.

security@kernel.org is for fixing bugs reported to them that are not
public, it is not for any sort of "notification of affiliation".  See
the documentation for the details about what this alias is to be used
for please.

> We are sorry for the chaos of using several different
> email addresses. In the future, we will try to use our university address
> directly (we checked with other researchers and it seems to be okay).

That would be best, as obviously, and again, as documented, we can not
accept anonymous contributions to the kernel.

greg k-h
