Return-Path: <kernel-hardening-return-21932-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2522AC02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 12:04:39 +0000 (UTC)
Received: (qmail 22132 invoked by uid 550); 9 Feb 2025 12:04:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22109 invoked from network); 9 Feb 2025 12:04:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739102642; x=1739707442; i=markus.elfring@web.de;
	bh=siVsz7hJRGZRS0yW9KitiZuTjbYFxTt0vaSDpbIwgc8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=PTq1967v55YwXS566KvT/XLjTdxxQC5OeBrNXKHyuUqtFi9ou9c5uR61s3ExX3Ib
	 aWBL1NBwiWNwu+oDHsj2cFk2GzMT1Axco6wYQa55zDtjGi+EieB66OnBGksRSm2ZT
	 DwuaBku5MuQjgjXq66DoMHflXkxGDS2Y4abNCvCN5sXBFrVMB9+rI2cb85zX5FPQZ
	 RieMYmOINc3I2rjkY/VFdChSIKzSkG7cJX+gB/1uKm8f15TpcqNIR1zhGukh1JnSL
	 QBFOMK2h6uboDZoUKV1iAGwYlJGrqqqgkmEMsyxTigMZ4lXcDf6AQpEA63h5DfOV7
	 1fPu91+2Iu3olT8bOw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Message-ID: <0e014581-bb98-43c8-8170-2556ac974657@web.de>
Date: Sun, 9 Feb 2025 13:04:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ethan Carter Edwards <ethan@ethancedwards.com>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>
References: <dmv2euctawmijgffigu7qr4yn7jtby4afuy5fgymq6s35c5elu@inovmydfkaez>
Subject: Re: [PATCH v3] thermal/debugfs: change kzalloc to kcalloc
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <dmv2euctawmijgffigu7qr4yn7jtby4afuy5fgymq6s35c5elu@inovmydfkaez>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aYUPO2AWp5BBv3zQ1GB5Wvbgu8NHsMKZgI2Sbrbw9I5ep/mY+3G
 LVK9E4AQlw0TYlON89sz7c4sMPBh7JJuTzEodJcJzY5Bre4MMmqrCe/cks5HEQxoILradxz
 ZKgm8nQo9oezHcy+RQqoKoX1/WUjI5xXs0x4Nqw9IsjU1JUFJUYkFRYCSCUf2en03f4I/yb
 qWoRblFIyon+NPXVcRVSA==
UI-OutboundReport: notjunk:1;M01:P0:R1iwWSyHSvI=;cF+W21hEJHhKaxZnaZ9vTnAnQSn
 fF9VtRFP4vH7uroHKw/XAJ5FXsy3HBS9a1T+xUkUhb+eyagjw6KF/44OhNF5ipu3yejaH/0ab
 EtOhninv/xG/i4Ey0HmlQhkNeiZhHeRxFDeBVG+gwSZ7PUcQlW/M0o4hT4N19uqC4FjWpTWBK
 6IN9nTuOLP81KyJgGCch5pmVB6djFRFy6oxApF9/rDyKqZ0jwWtkxv0Mo5/iGj0DVe2Xwhx77
 XTqEqNhbmO/HqjXlaEh4/XKAo4LmkTIDQAFRZkMzvLP3vlVqFYeDwjYb6Tgzaay5AMp/DRI3J
 S6KuJjYbZ5bebrv5W7sxMdBp/ZL3ir824oOl76ekkQi9AxbzEfq3HzFa8Daud7BoFXEWp4xzL
 enJ9AA8iDiFF+ICMNFSxog41F2KSgs/lycSEAQI+xh84qqQPzGZojPubL6kGgnw32UjD+Zgz6
 gun2mLEhlN29BzxwRYDT22bNGgIQY7c62Ma3O50QATEpDvJi154FdcbcinBBhDl6dTq3ZKVsx
 pfs8iZbi2mLL+XTU+ZSef9guX9UhTxTx3dFAbYUGjZM5Ht9x6acYV1hpnQtdjjNDnt8jyF1qJ
 7ZRKGyASI99LXvp/MF0YyhqxzL0dxhQbyaWs8GdTyAXvG524tAgqHoApFQS1uxUGytQbyBfbW
 TilldQ2TU6BCG2BIC5YNWSqv60eC5ejMkwK9afrlUcZACG0Wa36tRGRJkdAuneXoadYpnrCCM
 KDpnRbszfiO2hImTdXf0v1ZCrLecY7mEVCCjst8cEiYxVFW19apvz9SYdLfEtfN4k0k6TFX48
 e6O8T5QFIbWcNVYJ1ztrKAgSMapeuYddTuozLaKt1JdoJcdDizJAWBugp7Xg8YMCGweCEatRb
 YgccJpmz+qetRCuhWjU1MuTaJrgEDlb2mnBkgDOcTkz7IHbzjqeiY1lbtpCwkcngDlPTKXh14
 2piiOUZuw2wpzGto1XQO2916LXp2we+/yplOLgvx66JtXpTewbVJ06ZEiS4bhtwHf8ymjY/0C
 gh3Fqez7kY7XTN2e6gjNWHHQwznAg6rRMvPYWR6OkQBjXMLxHB1I6tIz/gKtA6hAmQZUVW9GY
 MD8UJvYSE8Yn8zWaSYFJmIHcmdJ72VXIqEevBctXaxIcpM/Nmdq90pkOEPOnGIDvwl5Raneha
 VyLPHhWJ/6sl4f8302L0M2CX9bqYU1l/ZOQCFfpVrEMU3bYDGh8hNzZBnx1sCrC9XfTr9OX2w
 5mzwWn65P3ppa06O52QgdyqOEyOmy35/Pt88xDdvFNbrkLt/DinEOCEtNH7CanL+cNL56F+Ng
 6M9R+1PRy8VYMBvUPpHtB8uooqr5LPl5wUXM0avFp8/ikqQr9nbIL3D6watpf6/zgxBwd5eJf
 /BEv594QKJM21LZRtGkcIQLKxKt96969gs/i5+7w70IC3REiTNezNYuPGcWrktRmGhWMR3PWU
 AZ9q2mw==

> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].

* See also:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.13#n94

* Would you like to improve the summary phrase another bit?


=E2=80=A6
> +++ b/drivers/thermal/thermal_debugfs.c
> @@ -876,7 +876,7 @@ void thermal_debug_tz_add(struct thermal_zone_device=
 *tz)
>
>  	tz_dbg->tz =3D tz;
>
> -	tz_dbg->trips_crossed =3D kzalloc(sizeof(int) * tz->num_trips, GFP_KER=
NEL);
> +	tz_dbg->trips_crossed =3D kcalloc(tz->num_trips, sizeof(int), GFP_KERN=
EL);
=E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.13#n941

Regards,
Markus
