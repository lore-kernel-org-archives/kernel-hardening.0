Return-Path: <kernel-hardening-return-21931-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AB00CC02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 11:00:40 +0000 (UTC)
Received: (qmail 15818 invoked by uid 550); 9 Feb 2025 11:00:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15780 invoked from network); 9 Feb 2025 11:00:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739098812; x=1739703612; i=markus.elfring@web.de;
	bh=zTTFXhhuzuAGcnouAfDibr4bNX81x1TGXC62o0Kjysk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JkUbwCqHQaAXl52/EVdi1ljGmh9spZiC/zg49giAScmn8Lmbgj5UzIriGtVfn+0A
	 3AKLn5pRNeBX51sfSYVsyoKFfBj9CeJRo8f9ewaLC4OfxRjeTKXzPlxMRojt2emgq
	 69chWMz6JBmfsxlbYLqnTjUn3T2XSsc84XwdRFw2GCVnYawwR7C6WwLUEvijdtIZs
	 g3vnXyP+WNBn+Lk8YObabbgbU/16Pgu7hJEmDG0wKDwJD/feoPFEjv31evWBcBBon
	 VYbppIuN9cUyr5zJksMJLXUOFDvrIJk6aS5/LExbor9DOVayPKQYURkVwZNtrOsLx
	 wqkx6maeta8BBPa9CQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Message-ID: <df74c693-45fb-4c02-bc75-32f70633706a@web.de>
Date: Sun, 9 Feb 2025 12:00:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ethan Carter Edwards <ethan@ethancedwards.com>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>
References: <wayfdq456uccu2kzujdokp5kklbl7evp432rmnxcdh2222wwlp@67idbpxoy32u>
Subject: Re: [PATCH v2] sched/topology: change kzalloc to kcalloc
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <wayfdq456uccu2kzujdokp5kklbl7evp432rmnxcdh2222wwlp@67idbpxoy32u>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6VLn2NDmUxJaetn9zKEBY3t2zlEqmfbtGelOKPrXuClPkOEyi+X
 gGMkbre9CTAauYoztqdq8j0ciqgbRHSb2VMz/dzBGjxM9KuAiJ+D6PGUXsTAspq6XmxWC0z
 ILl5jdCg4zfYUBMgFTPCMUuYYXm2QFSvV68ii9VKJfkhqv4DGIxeHCZWo7vOcM2y4cHDVyY
 RqXPUyXtxL9ANVHzJbhug==
UI-OutboundReport: notjunk:1;M01:P0:8oCHxsTpdIs=;dwECqzLvlQ2np28+V4Z733uGZsX
 3jqs8Nme6dbgp/a94OcBg2dAA9cF2PE7/3e63RwGDWL7JbsjWOjvglE3HRBmyGx9Ym4HQLife
 HDK7wjKQ8/NpT1uf8iAmVHnwZ4k+ppsF4JMkRMLyKRxU7c1v1Z6Kw1wUFdj/BL3bZ2kaYiuov
 0fxuhFdsxoBUfslAWm0zWhaeZrJAg4V9DhJcF29Qs5fV1YPJ6rD+yyKyDyczJOt9E8TFdtmXy
 qF8CTrXAQW6BpMUivtx7WOjb1MNddSuhBII+bqNYaoKnbbjEaS0yohw51PjGu79BGQgCSMH8y
 DzuaIhE3KlU16manOVrCi+0CdcYZIBzVL1fEXnoFXNYgzrPQPWjcu79nCmvuEV45019FXHZYa
 TFe6XrB6EO37yp6nav75vxluw4AONOBg4kSLEEiFS1LJGpRehXme8RqFscOia+rvDcJvFCnvC
 a25hRIf01l+R3k+m8zQAb5/t6AWbv03THfbmVG+Ddc5KlnWg7Lr7xpaIJFCi0J4yeXvx9uCc2
 NKUYOmjr0iA942zInzddqXxHJiCazjQ0pCQCPEEoNe8mi0dlN3jY/4jXeb5Z56h4kVaWgvrVY
 pzqHOGwdZbCE+JzNlfq3Pn5ZRq3jDfHzV39m/W92TT3MNBEgLAfBtpPhsjS+8knTrNl99ZXR0
 abVtV12V1SfIHidBBvc/yvsld/dqTXu7+aey+7FXlyBG2TxjEiACjkfTee7e6VuaNfeu9kqAD
 Yv/zK2eWuDCQYKRPAH12nda7rn7bEHr3NDypkIqVMfL4HBir5Mo4iPnasiusWQbqu3JvwM902
 NCU9AQZ1FvyKbXDg4gBnFVpujUYF3MiYzJcnctIYo2Mn/304CCgCp7czrsGJ2Djw8wEF5w+CJ
 3Pu+w0RJfYBK1gs8z3EkTD/h6eF0SE2a7y1DxegNLglWrDAgLGHHrvMN9lEaVRCH6J5XRxDLU
 o1/Qcjz5hf1RD6A5+1WoAArxwQSMVS6xmi8Qc3mX0VHJa3+vgjf1N5YbdXliSV5QLpZCRBomh
 s4Gef0CEOxZKEN/Z+vCedFLFCFoSt5tlhknGcS8IUAxXCKECmY6Z6vVV2/ns4l/4U2AkAxbJB
 kzJGhaoxU28PXB8EvuBHY/chblWxDj6mQ9UWVDSJKSMTjLdQpA3NdghHj7erkILT1VHRDkaak
 4HJ5Y/RX5KIai6jt7tPFsrGUhVYrcEulGsJtTGUy6mfaXkrhkArZkl0W38Zc8cOQrDXIpp5qA
 1jy1xFUzwSW9nSqSrvw6332k83VSOfyqB/WFC4UHSonT/ZqQQOHzlFfbk7JmEaoxyDIXNNCXb
 eUd971cZBygRXO3hCVja7trd+/KjqsoaZT1DqZrvP9MN9Pkbf038QKRIPFwCp0lRuHhKch2Pi
 Sa0HixxWxwzZGo+C4q9c5Z4isp9hihrwpoeKOWr++54Zfw4Pkm6g0j8SVTYuHVdAdpBKfa8Xn
 ZqEz9yDNTvnY2IaxU8vJ/olgmO0E=

> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].

* See also:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.13#n94

* How do you think about to use a summary phrase like =E2=80=9CReplace two=
 kzalloc() calls
  by kcalloc() in sched_init_numa()=E2=80=9D?

* Would you be looking for any coccicheck extensions accordingly?

Regards,
Markus
