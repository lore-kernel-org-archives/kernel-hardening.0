Return-Path: <SRS0=CC9g=XQ=lists.openwall.com=kernel-hardening-return-16906-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB5EC49ED7
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Sep 2019 11:00:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2F94E217F5
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Sep 2019 11:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="FEF6gSqF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F94E217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16906-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32614 invoked by uid 550); 21 Sep 2019 11:00:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14062 invoked from network); 20 Sep 2019 19:00:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:mime-version:subject:message-id:date:to;
        bh=OyWPuerzbn+8eMuy7sHJxJavjzKRmhjIHbdMeRbSYI8=;
        b=FEF6gSqFe6pIId9c+w5V27s5aKx4LkbShk75BDCvL9gg/3Lmdd4qgykJAtwDYjdxUT
         VVZoJPKfPf+SZiBUAvZTUUH2OYq6Nms4GpGtqVDcp5vTMWsMRP8TjCh3Vy0mYGMhTGDu
         F+2tI++Uu+LFeDI3CnJ0F65Tzz+4rTV9BKbRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:subject:message-id:date:to;
        bh=OyWPuerzbn+8eMuy7sHJxJavjzKRmhjIHbdMeRbSYI8=;
        b=ZwTJEF+7dFCzs6VH1fa8GuqzLdhhOkxdfYPJrYi3pQ6tDIwQDgoxDRnqQiVf80xFek
         oiMUDeHoYmVwiVu76mZTNmTSoaaHQIDX88Dci0LdVDed11eyzUxA9oGMtPia9tvc9BdM
         JLur6rgdT/CgL1o9f6Guw/U+6zDleQOT/ZHNGlX4DWp4PMRU4P+6rk/Rhd3ZwwaCXSnL
         8hgFPbCl9/kysgF32jW92ZefmNtCoz+LunZYyjZ9lrWSXHZjuK2ii3VqkzixIbMw2gad
         KOpDqrKmlCJQTVWYp9PQz4JdebKgM4KzCPc7cmLiwVBRGwb+bNzcmsfg2uemDC5Cdkte
         oBiA==
X-Gm-Message-State: APjAAAVGW8uUoSPzjJCn5gmbECNzx8MQJhu3999Hxj1PhALNBnr07yCG
	sMTXGEFljSBQfJPkRrcnj3yQ41OJzw==
X-Google-Smtp-Source: APXvYqx+Qf0jk55KxGzLZRs/h41twRrqogR/+2YMt0fbHymXKERM1tHvYj9NbCTBCZiGpIeSTN6Caw==
X-Received: by 2002:a63:2744:: with SMTP id n65mr16592851pgn.277.1569005999114;
        Fri, 20 Sep 2019 11:59:59 -0700 (PDT)
From: Tianlin Li <tli@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_A19136EC-12E1-4E54-AD53-A362D8B628C5"
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Introduction and get involved
Message-Id: <19962016-19D9-40F8-A2A0-B7188614A263@digitalocean.com>
Date: Fri, 20 Sep 2019 13:59:57 -0500
To: kernel-hardening@lists.openwall.com
X-Mailer: Apple Mail (2.3445.104.11)


--Apple-Mail=_A19136EC-12E1-4E54-AD53-A362D8B628C5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello everyone,
My name is Tina. I am working at DigitalOcean Systems/kernel team, =
focusing on kernel security. I would like to get involved with Kernel =
Self Protection Project.=20
As a new hire, I don=E2=80=99t have much industry experience yet. But I =
have some research experience about memory virtualization.=20

Is there any initial task that I can start with?=20
It is going to be a learning exercise for me at the beginning, but I =
will learn fast and start contributing value to the project.=20

Look forward to hearing from you.=20

Best regards,
Tina=

--Apple-Mail=_A19136EC-12E1-4E54-AD53-A362D8B628C5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><div =
style=3D"margin: 0px; font-stretch: normal; line-height: normal; =
font-family: &quot;Helvetica Neue&quot;;" class=3D""><span =
style=3D"-webkit-font-kerning: none;" class=3D"">Hello =
everyone,</span></div><div style=3D"margin: 0px; font-stretch: normal; =
line-height: normal; font-family: &quot;Helvetica Neue&quot;;" =
class=3D""><span style=3D"font-kerning: none" class=3D"">My name is =
Tina. I am working at DigitalOcean Systems/kernel team, focusing on =
kernel security. I would like to get involved with Kernel Self =
Protection Project.&nbsp;</span></div><div style=3D"margin: 0px; =
font-stretch: normal; line-height: normal; font-family: &quot;Helvetica =
Neue&quot;;" class=3D""><span style=3D"font-kerning: none" class=3D"">As =
a new hire, I don=E2=80=99t have much industry experience yet. But I =
have some research experience about memory =
virtualization.&nbsp;</span></div><div style=3D"margin: 0px; =
font-stretch: normal; line-height: normal; font-family: &quot;Helvetica =
Neue&quot;; min-height: 12px;" class=3D""><span style=3D"font-kerning: =
none" class=3D""></span><br class=3D""></div><div style=3D"margin: 0px; =
font-stretch: normal; line-height: normal; font-family: &quot;Helvetica =
Neue&quot;;" class=3D""><span style=3D"font-kerning: none" class=3D"">Is =
there any initial task that I can start with?&nbsp;</span></div><div =
style=3D"margin: 0px; font-stretch: normal; line-height: normal; =
font-family: &quot;Helvetica Neue&quot;;" class=3D""><span =
style=3D"font-kerning: none" class=3D"">It is going to be a learning =
exercise for me at the beginning, but I will learn fast and start =
contributing value to the project.&nbsp;</span></div><div style=3D"margin:=
 0px; font-stretch: normal; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; min-height: 12px;" class=3D""><span =
style=3D"font-kerning: none" class=3D""></span><br class=3D""></div><div =
style=3D"margin: 0px; font-stretch: normal; line-height: normal; =
font-family: &quot;Helvetica Neue&quot;;" class=3D""><span =
style=3D"-webkit-font-kerning: none;" class=3D"">Look forward to hearing =
from you.&nbsp;</span></div><div style=3D"margin: 0px; font-stretch: =
normal; line-height: normal; font-family: &quot;Helvetica Neue&quot;;" =
class=3D""><span style=3D"-webkit-font-kerning: none;" class=3D""><br =
class=3D""></span></div><div style=3D"margin: 0px; font-stretch: normal; =
line-height: normal; font-family: &quot;Helvetica Neue&quot;;" =
class=3D"">Best regards,</div><div style=3D"margin: 0px; font-stretch: =
normal; line-height: normal; font-family: &quot;Helvetica Neue&quot;;" =
class=3D"">Tina</div></body></html>=

--Apple-Mail=_A19136EC-12E1-4E54-AD53-A362D8B628C5--
