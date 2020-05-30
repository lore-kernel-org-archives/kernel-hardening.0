Return-Path: <SRS0=uVtE=7M=lists.openwall.com=kernel-hardening-return-18903-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5E4C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:19:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AF06A20723
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="b1UF9B0Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF06A20723
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18903-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19619 invoked by uid 550); 30 May 2020 14:18:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19581 invoked from network); 30 May 2020 14:18:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590848325;
	bh=vx9kwtXTwi3wRgMYRbmKGoNI6YGmyghJpf9MVlgEPlo=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b1UF9B0YChZuW6q/eBn6HeM8/j0W1NrEtEVTpXm3gwOU8eTaKVQ2oGBiI5MYhA5Mc
	 2Cr3R4JOmbrCOST680/o0NVxfebshs4RgfYuynUSGcbr5wdw2qanPo0JgaKVut15LI
	 s4Mwju/78EOJUJGWFMAEzRjopaxb5conS9gi3UZo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 30 May 2020 16:18:42 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>, Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] drivers/acpi: Remove function callback casts
Message-ID: <20200530141842.GB29479@ubuntu>
References: <20200530141218.4690-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530141218.4690-1-oscar.carter@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:u629PpDXc+ztQh5Z5iHJpAjTMoWmzq6Njl+1xB0m7OWb4UR8ZoK
 pf7UN6lmJMjuXU7CCsMQLvuSjg/A5rn6Ik/+bAeiSW1xfQYeugAh83iTOujOrS582GL9LKl
 8Tte2a0HzmLP2ySsM5c8HiEv8F4sypRl3Sl3I0aK3m1y/bGu3c3Q8Kk//f2hbppNTyKbc6c
 nQjYDFY5kb+qjvdbr+sxg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X3kz7Ce+Bkg=:blObYrqrW2xwBXhWyhq2n0
 eoq+kC4POVZ3DCf3dnxulMcZnVxCU3NgWuJjDj10tHfQqkQXCmmo1FKfnTgIjC2AeLnd1GDVG
 oeAefUY6asb9AA2vrxLRdMWsHpzcwLsf6/Zb3/RBR4W2VxOBFQKC6nMmvzmmGnnxH+mqpyZ/t
 910tgrOas6odBjzaZ4n8jeO5LUgJ27kcMU4SLpNTQ011EHG+kQOfeFPIFgIcmIqPI5QFitIJ6
 Ld5P2jELp+Ai7kgmVDH/YovZK+JWVP8JGpspYq2Q9A0viqwb3QvmQr/Lr+6BHo3258Irqq9P/
 YPr/u+fn2CbXizsaimuiTFcN8QcxrvC2QEiih/pXg5n6v3Bt6EyidUQO2X6iyifDS2npRVEN/
 7HADbTTY+rljCkBbolITPOxHXC4cuhoFWdE2KqW6RlWCg2NNSr+cFxXjI+BxyCgmZBmizgkps
 uPDwdTwEnCqGld2OJFBXcRN5CVr/wsNRiaEbe5VIBVJP9W+W3z5YWFn5FE38dFMhkNiS04PcQ
 k0CFSUw8yqqK7EPKfhsWcrBio50ZyA3H+LojeILwtQOQiWqMg8amN9XEQ8hKQfLn/0ZPBTUh3
 zc42eEW+ZCvRTetB9H1Za/E5NeF7XyuzxNQ8n5OztuQKCtbO2APCh0TtiPHjU2vYWLVx+lPY1
 s3mFQwGW5XwdMHiKyYVgLWQaeDT9j6bdTknKT5QCKy6/WyI8WTIsJoGvSNIzo1vIF/xJnT7ms
 7PkNLB86Volq/RIMGgAPqBMcz53ktgOqPjRi3ihRHmbtWO0h6ifAvy1mphCcYCclfRig8oaFW
 012B6zqacWW2hp6OyAJi8QfJkim3/7kMvwmE14DJFasTaqiGShuyt1NkYrsTf+t9U/79bHtFw
 4ff7WauhAAcAnzLY6XH6y+VWDb4Q2LN59BjK+Vdh5f2lZEnb4VXWufRqomMgMNfk5iC030T9z
 rGobIZWts1WX/8Ej/KFTgZzaYESsGsJAcuk7EzB71o3iIL2fCL1xV8lsMiJ48HEe36bKNEDM1
 EOAzp43WLAZMGC3QIU7qo9FGSFBZAA8s0BefkeXtv0sbhkankncht1MLpKbbqE3xrPbWYg5VF
 uAecUVR65BDH8JN5mBEmSjg+pZDUKuUq+5sVLfwjic2D2fLRVY1Oo6YkolcAHb+68qZEEIeUL
 /PeA5FwsdufLSg/tPpYDX49NmVMUkQNcgBgTh7NA+SjjOOFg/6X61tnob1MC5S8/Q3LdJ63T+
 p+0a7yxvHptkGKZfV

Hi,
Drop this patch because it has errors. I will send a v5.
Sorry.

Thanks,
Oscar Carter
