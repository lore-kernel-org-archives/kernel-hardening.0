Return-Path: <SRS0=P3wb=6L=lists.openwall.com=kernel-hardening-return-18652-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3907AC54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 17:33:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8722F206D9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 17:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VDbkDiNF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8722F206D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18652-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24082 invoked by uid 550); 27 Apr 2020 17:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28344 invoked from network); 27 Apr 2020 15:26:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1588001198;
	bh=5XTyVa5Wg+vmqCB2Rcj5wWy0tF8BawuaFfCIEA3EHKk=;
	h=X-UI-Sender-Class:Date:From:To:Subject;
	b=VDbkDiNF1uWV9pYAjMHKp5+6mdVYYA54ibAeSaRACuqEX7WUR3xyb/Ju/S14pgbpm
	 QdZAasiGV2H2clqJdh6YvGmCRtm6MFm9UJ6IK+g+ds+uIjTE7cm7uSiV6FOvP5HUIC
	 2Zg9cnPtspyZ/B950bXqV9/yKJyPxarFwv+364N8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Mon, 27 Apr 2020 17:26:23 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: kernel-hardening@lists.openwall.com
Subject: Get involved
Message-ID: <20200427152623.GA3473@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:n2WnQB3BjZNR9mtLjAqEHwu5a3OFX1UpavsA+RdOrBIaKge7uDR
 EgJVfzdUbpFzirofV0O8z1XtVCfhXXtOBislLA6HtcVIpUe6K7JHbY/OC25XDVy+j0IMPsA
 R6Z//VerAXZeD0p3QUlxq0dk3NJTM2TbCsz2fCNpDsyRdBbGYCV5R0ChNmf42siSUaUuzuz
 /Qgbhf0ycR5W1t9aDvdMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GPagnm7DMaQ=:PmtaxzZ+7OJ0EYF8H+1MjA
 jcM4JMXquN6DC7W6ELNYDIqlz1ilk85I2z9DzRxKpcHzw72weKLMwxfup0J9bF0YD4xMk/jZ1
 ZQ10S/1ZUrbbJc70xAk0IY7/y3MzoBj0zM0AbqNgXIFw8uEJAc280OmyPGaeCqP2KocZXJ7lQ
 f7V4WU+lmOr0LbMKJZ8OVvfzq2z4GQVYifdrVx+LJ1E1YYVlru6ZFRBtZ9+ch91ASMImX4q/k
 sVFQg2RlVflfiRm+uamLc9r8vPSUt9TseAEWWtuHfMjlW7FJ7u2b5rSKtJxTL6gb3r9mIeDlt
 Jshf11dSQBxWtR2KGwn/SaTDP9bRTliqXpgugfZXABtQdioMS9BVyWadFH+hDV7PdEkafE3hn
 f0ezaSEj2yUSyXxw3gxbimoTKvoHyWqnyG4+0MOQelTsQ10jsqoK+Q2af9WCbFINY5LlXtvfu
 5+xUyEwaUMXBWfGA0QZcnVw3Bczg3XklFL0YOMJb1NiMVfS61PFskAVZ4kkfoFHiyeEYeqYj3
 pHiCLPl7jd2c5jSwotRXkmStnH7UM+kIh6rq3lRzbp3+vQ0RswWogSoW4VDXAC01w8z/pZ496
 zNohm5n2MPQX3mIE2OLgQ/JHbKizPTTv9LvLG8U+yxWxgqUrl4D7ZHaEBNaJu/12WlYxj9NPo
 JkTxU0khcPOIxb1FkTA/fq822VY2srFRNm7YcUPnNLD2pjwz+Olxyk5WvleEqfKuHkUEiZYtb
 zzryY8FZQpqzqmbKxeN5f53j9QWapQpDNTf9/hTl6fPVRHxJZ/uGLaaEdqVCxtRZpF8Zq9GoG
 XqU1PfCCB5yjkBa8eAzagccl8bQa+Hg/voCk5Awx96KZ91okp2L+jmaNd+gvyUtytHVdEKliP
 HaVKK7e8lvxwunwTVs7cg4l31G3v8M7Mrwa3PNNd6QqJsmZiuqWmRKRpyzMmCNU8t567ow1/d
 PNC8oyZAaJuZ73nTvrpKkaPejx5WvR4BHlT3UiuAuX20uTdAX195l5R6wy+WtCAdZyi8Xq0cb
 boerOpUDhG/V0Cb0us/Y/DL5r83Fx3oC5yDSv/jZkQjTa7pF4Uvc13V8pOHwo2425lYUrFwJA
 Cs1RzWDOR4Nc91WazLMNGQe8/f2Jg34rPQCYuI8yFqj4QLcxIXhsK107vmxJfw9Wytzg3a7pe
 gIAWFcQJrX26X+2ZU3LOTiRfAyiC/WRYLmBMEr/LtGZp7cGQT2SHv93olbaARd7oSOxCKUBF8
 aLAinNR03q9N/RLIi

Hi, my name is Oscar. I would like to get involved in the kernel self protection
project because I love the software security and I think this is one of the most
challenging fields.

I have experience in microcrontrollers and working with low level software, but
my experience with the linux kernel development is a few commits in the staging
area.

For now, and due to my low experience with the linux kernel code and software
security, I do not care about the area and task to be done. What I pretend is to
help this great community and improve my knowledge and skills in this
challenging field.

So, I would like to know if I can be assigned to some task that suits me. I've
taken a look at https://github.com/KSPP/linux/issues but I don't know which task
to choose and if something else is working on it.

Thanks,

Oscar Carter
