Return-Path: <SRS0=d9Um=CE=lists.openwall.com=kernel-hardening-return-19665-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B76C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 16:48:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5647D2078B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 16:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="zSSLNQs+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5647D2078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19665-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3532 invoked by uid 550); 26 Aug 2020 16:47:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3510 invoked from network); 26 Aug 2020 16:47:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=knubijAt0jlcEgyfGnp3DjNef2Zkl9PnsPdwfFoIfEE=;
        b=zSSLNQs+V1I4LENOdushsj3nmnFYyqaQdhtY5oY/Xt286k3qGUQkI26czvfppN49LX
         o3Tp4yTmeV5j/D62zFr+TZuZSAvYv005z7/th9LrEbutQHP1CwTihB/xVI7k6JoZyaHp
         lWDxEUGFmqx3gxPUDHBKylXtpbMwlh+un+m7DU0q3tJFNZofLUWtXKiZ9GZET0F5tVTY
         fYDAShfuEIZPjMnRUBcpC8JYIDOljcBdpY5bi4kGbq9JOcHt1TSgVWnjjmPKuQXIJMXe
         PSBxzsnrt7YBgW5E6P92+1x5UVOk2AELav7ofZ3IFlYkZ/pTRhRCbbBFCZOLrK7oMuDQ
         TdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knubijAt0jlcEgyfGnp3DjNef2Zkl9PnsPdwfFoIfEE=;
        b=knmiI6cALOZ0w1zCVZwK1NuQ9ZQLi6WpW+3/nezHfZcPMXvFuLpkiNqKWpplINSO0T
         uJHoSvKWAa3yAhu0GyJjqNBMotTdUBAlu0KDYufSLn/mFF4Z3twY5w8Y4cwj8tq8udm4
         oJ01PqlaXuwL2y9M23Up2be0iP48CSjrJbQLAZXBp5qyEskRkit0XeOBjUWxfO9yo1a+
         eAeOgL3Y5D+oLmcG3+f9gy/HLtzm84H0b9wrKBRQGeyycwFTo5UHlJHx8jA8PQd7751Y
         h34DPWw7AKPhbcb4kp+MI/pc9joQ7TmRz50bBLUf3IxIrNuKq1wXwhQB9QD9w5owTG2n
         Ut6Q==
X-Gm-Message-State: AOAM532gt4mTJJCGszvXXe4+KRRgv9eM6d0Xk8aVBF1YlNRRP5NSTopg
	iCl8pxEbyaZSwX73qYB5r+nDCQ==
X-Google-Smtp-Source: ABdhPJw6tqipY5aYgIN5ObL9GNtF7hYUHQ1OYqLEU+5VRRsLKuPz0AHe/fnvaAJIPrska52FeW4ZcQ==
X-Received: by 2002:a05:6638:248e:: with SMTP id x14mr15661824jat.135.1598460458830;
        Wed, 26 Aug 2020 09:47:38 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
 Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 kernel list <linux-kernel@vger.kernel.org>, Aleksa Sarai <asarai@suse.de>,
 io-uring <io-uring@vger.kernel.org>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
Date: Wed, 26 Aug 2020 10:47:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/25/20 9:20 AM, Stefano Garzarella wrote:
> Hi Jens,
> this is a gentle ping.
> 
> I'll respin, using memdup_user() for restriction registration.
> I'd like to get some feedback to see if I should change anything else.
> 
> Do you think it's in good shape?

As far as I'm concerned, this is fine. But I want to make sure that Kees
is happy with it, as he's the one that's been making noise on this front.

-- 
Jens Axboe

