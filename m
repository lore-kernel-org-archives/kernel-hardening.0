Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C85B2606A326
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Nov 2026 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=a5Kr6eEW
Received: (qmail 3942 invoked by uid 550); 7 Nov 2026 19:08:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3910 invoked from network); 7 Nov 2026 19:08:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794078528;
	bh=5/0Fcu+X0ZxN5OXC6KMesQouK+6sQsabTzvwsuAkBEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type;
	b=a5Kr6eEW1Q6HXl8oc4DN2+HVon4pxlGGVdDoVR/EAZA0HKEVC0mtwOQWXgneZ7oh7
	 luwEJzV+TPd1fUo0G9U+guM/r2F4UJw9lA8PcJt14ldBZ2C4jj0csSPsaKTV+y8ori
	 ej+Jf3ci0+GZDYkZn2sdhE/UWp9cn9/nowd2YchosO90588zsPIrSrPUDkjj/9S6TY
	 hn0NOkwnf8DexoLr7iPEGBeZeI7jO6K60Dv8PflcI1NnLMj+YoNaKAhBsFvUZPUI5I
	 9YJXFiR8v8Uu59pJbbooc908Vt5KI5WY2DPX41h2hjJY1SjdN7fTfAUsS6IAPgAPUA
	 5+y1Z6/1MPQLyw5ypdZZI6L8oO9CxfYeS7LmVlY80/oNSNsXu6tkGBgA1arRIX39A5
	 Xt8S+LVCMkWa5dpkTiRQP/M4IZ6HIBRTx6QVZxotW2/huclcHCtxha/AN95SMdFgf9
	 nN3ZFn/Zn8TkiEBu8NyeqDbuKbiOB1Bg1/5GnhtdnMBCDAtWa53MsqqYJYIzq/UfL0
	 g8EA9tPeqQeJATQoQRAr+qbKk45libGRn4h0letvbnkMq076AWGXQDPQaCUu24Icw2
	 0yoIBCCOdHD42AVAspkTOUo5XHQ9ze2aqosXY6rLERp+5qQDp3v3ASxz1P4JFgBUld
	 MpyAYQBCthU3PEa8ZugrxX2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794078527; x=1794683327;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5/0Fcu+X0ZxN5OXC6KMesQouK+6sQsabTzvwsuAkBEs=;
        b=Rtx+lIwp3oQ8SQov/Nj426d9xU6Ru/7V968jasoDNm31esRSeIC09mP3C9ztk1HdP1
         re2cKCuRqubxHQ8XmVn9HL/vDq5Yez5d6Exj8XRYGEHFSWfmZRY9qRRJoEguU8kX75lY
         M5aGSwBIHPWrRN50VXoqn3mRGgs+VYc4UjRUhTbJ5bIJXq4k04sunDW/sbczrPbVxbhT
         CDxfnsxDpgWPDwxt220oxgjJ+kfCkf/3JwVirK+V69hgy+U0qstqrz7aP3U7/2xQLPGB
         lN/51RAVL4m8ZmXm6eTAfN/kzX++dEYlFpGwc6LlLyRW0X5C0K5VJaIoU/ncLzdY+8so
         m96w==
X-Gm-Message-State: APuU4Z9DGSaD4GBcq++aATCf/o5Nr2Pxi/w/kL+C6/H7EW+Nf35pAPTt
	3cL9WHKZbQZJdxl2R5zrv89uFPt/T87cltiSfjaZA0NpoJNCUlC1HTRjy1FEgRs1+jl1odCwC8a
	AQL/Le4/dxHb/L8hAfOeI/cMvhpLutlZqG7R0FfcWjN0GxkbfKo6FBW4JNIf7ns2BYgRjcMjRA8
	eY6LP378ANgQtSz5zIlLffOu8=
X-Gm-Gg: AYBFou1tnZZYRZF0qsc0XAky9MDnHVRXZsAT7sy8MOYSQmW1L3PA5gxMZF0Q9n2t3uD
	C6/gWZgbqL6RXj40bqRYlQFFOcvVFyn1PffHKZCJJvrZHns1d8NFAz6Vuo6Ut1g4czJfc+e59MQ
	I/FpgY/imfGJoc2IaSwVe9OgM0bsKTHS0yXjgF7PkATEg95g1FUsCJeY7CmTf8oPfhf25HEJzzE
	MqyYoL+CX4wY9D+majxGOyBZitwb7ovrm/hlBWjEEGGbNwR6Kxixs2ZvJnHe46P+6TR5MHBct1s
	hTvRxDpjnQS1QNAcrerIzgabzgpBPPqhAwrUQXEbd6VJSKiKn27RxvbTHk8vLgcagelor2YQM5B
	u3gqCGDdogQES0z7tSK582nFPdRVEU+iFEYlLgK6r/TU7Tsnav75jHtnCdchp0A==
X-Received: by 2002:a17:90b:3889:b0:3ac:a521:960 with SMTP id 98e67ed59e1d1-3b0db5f1305mr6440448a91.1.1794078526750;
        Sat, 07 Nov 2026 11:08:46 -0800 (PST)
X-Received: by 2002:a17:90b:3889:b0:3ac:a521:960 with SMTP id 98e67ed59e1d1-3b0db5f1305mr6440437a91.1.1794078526352;
        Sat, 07 Nov 2026 11:08:46 -0800 (PST)
Message-ID: <9417ef01-a367-43c7-85f2-1b02c446c160@canonical.com>
Date: Sat, 7 Nov 2026 11:08:44 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
To: kernel-hardening@lists.openwall.com
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
 <2026110611-tassel-bubble-dc09@gregkh>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <2026110611-tassel-bubble-dc09@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 09:08, Greg KH wrote:
> On Fri, Nov 06, 2026 at 08:15:26PM +0900, Nakashima Seiichi wrote:
>> Users are left with three bad choices:
>> a) Wait indefinitely for distro patches
> 
> Pick a better distro.  Seriously, if the distro you are paying for isn't
> keeping it up to date and secure, what are you paying them for?  Seems

no argument there

> like an odd choice to stick with them given you have a contract saying
> they need to abide by it...
> 
the "wait for ever" is an exaggeration, at least on the Ubuntu side. There
is a new kernel every week, rebased on current upstream kernels.

Where it can take longer if you make the choice to stay on a kernel no
longer supported by upstream, and then you have to wait for some of the
patches to be backported.

