Return-Path: <SRS0=TGzI=CP=lists.openwall.com=kernel-hardening-return-19792-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90913C433E2
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 20:03:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E6CA020C09
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Sep 2020 20:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KK+thRoY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6CA020C09
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19792-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26307 invoked by uid 550); 6 Sep 2020 20:03:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31850 invoked from network); 6 Sep 2020 13:52:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1599400353;
	bh=XtEkzZAbX88+hw98R1oKITl4y2bipGlrPkgbDraaFQo=;
	h=X-UI-Sender-Class:Date:From:To:Subject:In-Reply-To;
	b=KK+thRoYlr36Wno0uDaGacT9Z0/DANFtmNmrydj/0ITO8CE5Dn8B/+tPSa2QmRT+x
	 YIQvlK1TH56e6GXA5BLtXsxaVpuJaRbF+qfNI4TacrpVQ4v4MzqcCUXcus/AmQjH5n
	 s7llIEL7VGnMVyayobM58RFzRCxSb4ZeISS9jNDs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sun, 6 Sep 2020 15:52:31 +0200
From: John Wood <john.wood@gmx.com>
To: kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 0/9] Fork brute force attack mitigation (fbfam)
Message-ID: <20200906135231.GC4823@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906121544.4204-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:fP7NrOumBfEOCn3x32piySXDMdOYS59kCZ3WCaumisdvvVJftH8
 n3EMVmkVBqvD0nxeeng6zXaSTrTo1LXQo9z78bC/nfRQwVX21+IFhJa+T/6l5ItLNb1t2Fx
 XRzHk0s3etl17F4Rw7SMmQmrvcqP++zOr1D0bBAyH8QeEYC3VDjhj9YVA+I2QenaIcEADuB
 YQ0cZCC2s+OLZeBn4sFEg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1KOfpSNfcGM=:RdZlFIolHSujmql4gmY5g0
 kKkvak9wN7lExNkDZl5pYoXjSkYz+hlZ+maPwk9hGIJ1wkdJ1qfVGXeh53QAwAmUSEkpfs1YC
 hSRhktlPwe9klpp0ImGb7lDsS0Wkono8XXM60oQWuLgSDuC3mVPdCW4wNYNKNCVZK6wvMZHTN
 IciLBefEFvw79w2GSlj4/CtC+Pa6O3VeThXnz8HdUuYFBYqGUhD9JQeV4foVWao6rAPm7Dqeq
 dn2v6+W3ADTf0AT8lBlHSeWSgiP6GohSxjEyr7wphk5DLHGSUR6pVG8sxctWyd8c/MeDh5uMn
 s5As3VXGsPb1GOsU1ssojsqWfXfEUubC+aSHWqPhI4fzTaQ5UzCs4XfFSu64crFBPhNm0Yl0+
 1hN4BQnUZJ8jSxRcDsxq+myAOnvtherBp3dcKe1fCJxa+OuE+Nvjpm0B89Z3EXyFltuvhHNhv
 vBArZ5gy9NvJ5hLgAJb/EeX36wSMPC/AlYqxDDzqIvp8ixeg5mhv2erZq36kiyfWFsnDDPpqU
 RdlE40UsfCl98hc5x1pcoe6+f1SuhU6nvBEPa1ti+ALyGL6lF/9j8sD+ldEfQTgCu2TweDAOr
 tHSKLpYL24DDWU5Z5eAKbH3teZOVhssckNJ6ozJNYJO7E8TaJxbAOTqkGtfys/XMqs12k3zbW
 hYTkXyTDEJspxBKEyUbuK1/4CaybmTBQBegj2xcxz+70tAXJWULd2FJIl9s29NF/2F702i+Xt
 quFoes3ZfMlQtAqCAigKS5P9/ooe9mi0TMt3G+QbB6uLdGijAH1k2SsfQi1q6Zkx7t11yQ9Es
 EWFXWd6JWr8DNkkQ5nmGxA+3tBaJZ3WFw9lp51grWPlMTBxYr23oUxwM55uVdhAcwokz0jLnH
 HPRW4qkbIxXeZTvaqZIXI1+TS4jPLytvhqXUVXyJLQJz1n7DIf53O1+zUrhuSf3+3tazCbSZM
 51BarUcgVt+M0tgDk6SY5AWg+TUMymabk8XLxfgc2T3n92uO3eeXTKrfkuExVlMbJOKky7Wd7
 Q42gIS6am5SZMz8wnq8XjDsQKGoF3pRDaLjd9EVydezpgZ3W0zYZWbDnmtaeALTK/w5UsP7Ap
 X4qtTmMxCn3pEvgdQ4NZ4xS4/asWFZrk6vnB3Mhugq/VKVC8zVn6HZcVj4C+J5uDTQeQ/fEfD
 F0TNng6CBMTA8l6Gbnq+JNlGrkm8Z3WrgqCSU56xysrQAMNgr1kEDf5HV9/JeQ8B3LHmGdGD1
 bKjkS5GehIwwhZvOJR+s6AnGIM0I0XfLdHiE99g==
Content-Transfer-Encoding: quoted-printable

Hi. I have problems with my email account to send the patch serie  [1] to
all the recipients. My account blocks if I send an email to a big amount o=
f
recipients.

Please don't reply to this message.
Thank's

[1] https://lore.kernel.org/kernel-hardening/20200906121544.4204-1-john.wo=
od@gmx.com/

