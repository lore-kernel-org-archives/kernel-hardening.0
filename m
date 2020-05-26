Return-Path: <SRS0=nJlg=7I=lists.openwall.com=kernel-hardening-return-18876-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DEFC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 May 2020 17:32:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C74D02053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 May 2020 17:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kBXXCBcL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74D02053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18876-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23627 invoked by uid 550); 26 May 2020 17:32:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23595 invoked from network); 26 May 2020 17:32:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590514331;
	bh=v+se7q0+LikyF3av6WnzSfglVjV4fMikUz5BHTennYg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kBXXCBcLWCENwqtr1rZkQ3bzFW/xDjNUS7A9JbQ1ZJs4Vk2SQQW7zH+i3lQu9Ad8F
	 L9giJMSUvY8D4vrRj8Nm+aF8p0ETDoxTg2DIZ0U9VejPNPlDASER2BmllWGI+OUSzX
	 1yOmWjusRjJ5eRxmG3nbnUut6AiEMwK0FyippSxY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Tue, 26 May 2020 19:32:09 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/irqchip: Remove function callback casts
Message-ID: <20200526173209.GB3465@ubuntu>
References: <20200524080910.13087-1-oscar.carter@gmx.com>
 <20200524124634.113203f6@why>
 <20200524160626.GA30346@ubuntu>
 <b0bd9442c1ba63c38d25ade479885cbd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0bd9442c1ba63c38d25ade479885cbd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:iNdNR4sTDw7qTbU62ih1eX/BUToBxQ2ATmT8kjgx+/N7qFc5rrB
 X+AHZ4uhqjPH/DzJKPNeHAc+w7SLpDWl1pkhxvL2oJlIt2YILfO0AHp5nqlmNTuK8SP4FTP
 ggadpomzk3G5yZ3tOQo3nOer1WIe0Gf9EJJIDi79u6v/rGgfGtfZgBpYdi6dmfTq+hEYh5P
 ltArOCrPprMLQkDc2V5eQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:If9ilkEJEk8=:VYXBYGxO3VBH6Z5GmS2/pT
 0efZ3fi4jyDmY6hbIqUYjOhl7E9KWyCHoMzSGd/zgRwWXiIdDFf2PpJRiAxAmDS6GDekP2AxQ
 dLrDwYDLSIQ6V87Il6SSIV3w40gMdYlbDFKo5ukMU4+m8Ri5s73YKyqjm3gD6DrKv0/ijamVf
 k7ifhWUaPg/qvdu7t8hSc6R7/rPOPqYfrWiVRU/Bp8rgvkwX7k/Bbn3kGxrQOvwMRemv3dust
 pyD9/Izjt+CjQAVTJleGCcpoKdY1CNB6P3S6S3J2P+2iEN5sycaXZlrjHEgpkYfuXLUDk2CiE
 IyBWvoySxL+LS+9J85M/Ow3s32czrOJhRqb90jmsRRMAJovyAqvJL5ZD9ukfrWoxSo4nMufPQ
 wmNVMgE9SbdWUpR6WwmcMlzP7Er9qpOoCPZE7z1ewgPNbxN7kvid5LBavJs5NyiKZC4RVGmO1
 Ovlqs6TmFXt3sd7gVxOVnmA4ANpcScoJL1my4tLc+qnxqIgNjfZsss5dvJ5VxlzHhiTPSeCiT
 GJecj8AQcJK6giMu4Orn1/AtRnho6+W/Hx83tzxD5lEGR9fZsT1WYOgxevSn1UM6WI7lL2WMF
 fjtrfe27aSD7g2AClD8xTiqCW3BU8C4s1hn1AzDcUKzEBDnRyBxJS/q50tjooH2C56djxVIDn
 uLryDTroI/SPmxg7mf/OP58pnS1iK0DY8u5r2VvsEVoFW+eZ1omls1vyRYdVzqA+IVFaliXZz
 tLStrAuQHp1UtyjeAC0wcuNr3fQHJ0sBU1DwUlS91gFObB22DhaSxCYc6HQMEmodl5lu5KQvA
 D7nLtZWSly+BV26Ykhee2i6ugocyQcxMa1mTc/FdWDXNiLXXuH37JoH9xEtM0rsK05tTzeiES
 T/5SteYf9A+pyCk8Q5q7L4bW18k3Z8GVtlT3s+Q8MKYG00/9kgp+xgF3OT3SdXWgi8x0xm6ub
 a388VT/UElNyQ0/zBpvrNesP3RO2mNXijkiV3mkUyq6OwzzRmoLb3X/YWLD4PWwdjxIb3d1NZ
 PPuOEca1i6ZKvd6d78FmPgcgcV255z+Ab/+u1MH/XiyFPEiMog88dzbGWtPatGREOIYXUeRqB
 cVK+zJJ6iTDvgK73R1Puo/z2ttG9YgEr3JzpFQ1+hXzO0HlMNW0CURNPz7bbipQGuyvYiXKtE
 C+BhOzHLB1rc7Dau0RkRY9qcLke+BwrJSX+FM1zJlQlpfcYjALAgbVSxGa3sy3inoeB5cCWo/
 +G7Pu4G2KP/p/qdQ3
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, May 24, 2020 at 05:16:41PM +0100, Marc Zyngier wrote:
> On 2020-05-24 17:06, Oscar Carter wrote:
>
> > Ok, I will do the changes you suggested and I will resend a new versio=
n.
> > Later, I will also send a series to clean up the checkpatch warnings a=
nd
> > errors for the acpi.h header.
>
> Not necessarily a good idea. Churn for the sake of keeping checkpatch
> at bay is pretty pointless. Do fix bugs if you spot any, but please
> exercise judgement.

Ok, thanks for your advise. For now I will only fix the part related to th=
is
patch.

> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...

Thanks,
Oscar
