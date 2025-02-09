Return-Path: <kernel-hardening-return-21930-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 96790C02199
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 10:16:43 +0000 (UTC)
Received: (qmail 7708 invoked by uid 550); 9 Feb 2025 10:16:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7688 invoked from network); 9 Feb 2025 10:16:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739096168; x=1739700968; i=markus.elfring@web.de;
	bh=F3bDdKl8eATlDg8WYVq5TTuNjlsg7scF7CmaxNIlem4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=e8KWJk7KnQ+x/X/TSMhk/eufCcaY5Dw8k2LN0Acynm5KxjdmIHZuxQFlQnOHSkhF
	 0M+vyHWXRKV3SDHtoQcZpuGaENaiCNnUaHeXktQjNP3IyjvPSFvOnufNDxxuO27fL
	 d7hNznti5Pyljzu1GDCER/JQDLwyFiErAGMPKQWK+wLupNBcg4N6Y8wslhdS5r8yB
	 dkhToCQwTBjXVesvsm5nO+pArfDj81n3fx6/U4uWwPIKKJ81V54560XQFtsMrz2GY
	 OqHV9wAMm8njp1ki85/Rxh6ANtddENq/XR5k2X6MYSCp3dduc1fa+wkHhHLX6zthL
	 pIaO9nfvz2C9Jh6LLQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Message-ID: <797c061c-7324-42e2-b4bd-fd93cf4ff0d0@web.de>
Date: Sun, 9 Feb 2025 11:15:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ethan Carter Edwards <ethan@ethancedwards.com>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.com>
References: <s6duijftssuzy34ilogc5ggfyukfqxmbflhllyzjlu4ki3xoo4@ci57esahvmxn>
Subject: Re: [PATCH] ASoC: q6dsp: q6apm: change kzalloc to kcalloc
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <s6duijftssuzy34ilogc5ggfyukfqxmbflhllyzjlu4ki3xoo4@ci57esahvmxn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9qLT0/6znlrr/UX2FzpFVqVWgiJtm9nEXtNZITfFV7q0fA3urLi
 ocRmNq9WCEz2HCQzKkoSyn47v8HjzCebI+Oj/qtjnE1FRMWmyCFf5dfO26MJbnfgAdHHFln
 2zjuGAn5UCfMW4tm07CItXxbmqYohhCD4zdFou4/hoh/3/D+Aho/Ns3Il7nnGOa3yYMxaIw
 3PcJMFAN2O6SUFKgFFUPQ==
UI-OutboundReport: notjunk:1;M01:P0:sSj4urlGScs=;aYQ2CVZDDz1kQzwhW3MloEE1199
 3bTjnrHI7d3xVZuOLLFf1VDWX062zj02hYmpGEh8PFSaH4NZSPV0L6O37cq5eA5FrpRnY6hUM
 Ses7fbc00O6fLHuruFIMZwAPXEaNOkMLntvEF/bPkzpHu17d9QVNfdQb5zWHtTLurnJcBUsQ+
 Ug2KU3fYOEdDiwkPZfXfZ5PTiaq7GiZV2FEuqUBE88JuFw2rhJdPxs/si8yqUoL6VW3BC6BV5
 /qHUsvSbyzjvWsTkk6HqiIQNV43xLtC4uFLHoCxZvQqEFp9NhfumITFGqSEIwB5mi+Fn6g91o
 G5vyAwyezRK/ED9Xa53W0JnI3ak8kxxOIaxCfDT8L375f4tsfZGJ2wTO36xQ5QRN0aY0zxqo2
 dd4hHSZk34h6Az+pZbds8+TvN/DM1YiqU61ySMGM83wlJGHijYcTk1UnBLpCCFoaM+wR7M+vI
 YwY9e1PYoQkBcU9fuhB3e2qdmAjIYKxUV9Zv9BHPcZByWQmpWmI6Fk5xsXQMI+Z8xDrAOmxaT
 wPLL6YJpmIBfyXebgUmB+SJctSZw0sdKawZPNmVh4Q8UAQ3l0tF3l8HGSmDlvo4FQky9DDHqY
 +dpPE1RRjxwkXvAiWUnw+uKWYSJi4APeLlVJzeGX0a5ZU9aF6FfgVzUCAM7my2TCtGFVWsiFd
 ap2nLz3jTA0+vIPW0Q6j6bvgg/ruXVq14NQlIwe4S0UXXlH8R18I2VIwZ1VbMoqU2qau2vAHk
 +y43sExq+zW3g2K4OXXXYmqo4y+AYuXROJhLW72Vjpun7hJUIGYtW1Kxbwz7WOT0NJ5uM8P3S
 3v0xmak90lMqOom4zR+V3PJD5rkBRnBA9Czp9b35VJ+nHqozR2uNxdlwiaNWZlwHUMfKZV1IM
 9Uy1hWtpkGoMADutt6LhzW4iUW/9ASkyZ2Ra12u3USd5u1YwiayZ6EOdkQ5Kbbf5yEIZQGdKI
 kvOzCS6yLogdSoo7b9a4K/RuPPxOsESr3lPzwbrkMY+eu87/CgeGdGUls838JJ6mlu/YSAMl0
 xF2KNIYyqHcdY0bi+BkH7du5ufBnUZ3+N9+OY02OWrwaw1pAkgAkOMDtqLRBe1kcaL7zWIYSA
 m/au2iaUvmcQdRv0O+Uc9G+1ISV85zD6eebAt6JLiIpOt7/V0lf+c2XFc6lr8qeEHKHZI7HIO
 o7YlJaegmMXffKFlK4fIW9cgdKydK/s24g38UlWDW2Nk7wq2NwgUwnsxXbLnBHMLaag/cRS+p
 p3bQNbh+onsXAtr2xyej2FeBbW1UXQtiaB6mR80NKfwT+1p32mIBSsvXjBsnCqmXl4x7UJTBO
 tp+3UUBRPCLWazFoMssAqKOFtzvpJlc4i8aTcN1pr6NPVExOWDXU06W+fuCaRDxmcvpwU6bXp
 D45YEcGOmQ3aPNw3r/OW3noIPaLCuRgukot7yICaD44BJSI0K6LSGbdOYkQ8CS0lEGMpTdBHj
 3U7JovgvjF0/MIpPWUdKJvM8Avig=

> We are replacing any instances of kzalloc(size * count, ...) with
> kcalloc(count, size, ...) due to risk of overflow [1].

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.13#n94


=E2=80=A6
> +++ b/sound/soc/qcom/qdsp6/q6apm.c
> @@ -230,7 +230,7 @@ int q6apm_map_memory_regions(struct q6apm_graph *gra=
ph, unsigned int dir, phys_a
>  		return 0;
>  	}
>
> -	buf =3D kzalloc(((sizeof(struct audio_buffer)) * periods), GFP_KERNEL)=
;
> +	buf =3D kcalloc(periods, sizeof(struct audio_buffer), GFP_KERNEL);
=E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.13#n941


How do you think about to increase the application of scope-based resource=
 management?

Regards,
Markus
