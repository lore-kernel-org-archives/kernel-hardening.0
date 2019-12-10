Return-Path: <SRS0=1E+G=2A=lists.openwall.com=kernel-hardening-return-17489-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8890C43603
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:21:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2D792053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2019 22:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="VOggNhdw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2D792053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17489-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15492 invoked by uid 550); 10 Dec 2019 22:21:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15437 invoked from network); 10 Dec 2019 22:21:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RuuieeO+IxNs+Cd1LTYV3QZT0Bw2YECA/x/7+WSUub0=;
        b=VOggNhdwRAPgnhKLz1Og5bsTtvnKiGOUK47NeqH8Oht9LIGyzTN7GkNIJWvAee8oPM
         w4UXzB4ZJ0wPAWWyzXwFhlgYsfgqKxrqzEQGDgN7/dZoemA2odSgckgjLWC/E07R0CGw
         5uTMkMSLvHvcUg7ufPMmInJkas874dvl1e5rMDN0iEwD53tGEqTAlaK0b5kIM4Z2q2mJ
         guqlPi6sRzzj8eKxgT4UINJqrmlUwTkrxnNkZ2q8Yc9DbnhMFu/CKMpvn0gNriovXi0t
         YMKDvFWOLQz2Dbk4feqmvdbGl0IGucwxWR1ALZ3w2FsdZDKXu75sIEa83irDjwJs4H0f
         xH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuuieeO+IxNs+Cd1LTYV3QZT0Bw2YECA/x/7+WSUub0=;
        b=JO21Ip31sS8nhVx+T1RBMWiukDdu7WH9nn6OYzEt/tFE6UnUkZ4jGewbZvNLV7ViRI
         yHa9Vq0D62mocCN1JbP/uuZf2uF434Y5FpSnqKdHX37SDh91tb4cjz0t6wAq3KDxQ5ni
         vpLzg+ag2cT7gK+5graErZjQ/wvQL/akv+syafKgTuj4RzrViU/36/e2Di3eFzv0Bg+u
         fUJtDTO8WDMNdWGE72DEmYF6CKIKSh5RhnULwFoFevJGS2SYlKe9jTHCLZaBCGLxqyyj
         4LTgLNOv3kxj7W3PyQm73a0JSlKj/fg/Mhd7N7TBpTbw0EuNXgkjYB0aD3D7TK79KkL/
         XEVA==
X-Gm-Message-State: APjAAAUcvy/UYDAWB/qoO0klgpqeRHbcEKnyLSOIPaaj1uQ4fdoBwJSq
	5JbI2s7UiUz+ctaWyB6fIesnBZ21rRQ=
X-Google-Smtp-Source: APXvYqwH12eD85bP+0NMosGNVzDEhevTSPWev0DU5WkTGUPiUMSssWJKkS+tJkXxxqMTFkzSH6T/hw==
X-Received: by 2002:a63:c20c:: with SMTP id b12mr378150pgd.407.1576016467631;
        Tue, 10 Dec 2019 14:21:07 -0800 (PST)
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To: Jann Horn <jannh@google.com>
Cc: io-uring <io-uring@vger.kernel.org>, Will Deacon <will@kernel.org>,
 Kees Cook <keescook@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
Date: Tue, 10 Dec 2019 15:21:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 12/10/19 3:04 PM, Jann Horn wrote:
> [context preserved for additional CCs]
> 
> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>> Recently had a regression that turned out to be because
>> CONFIG_REFCOUNT_FULL was set.
> 
> I assume "regression" here refers to a performance regression? Do you
> have more concrete numbers on this? Is one of the refcounting calls
> particularly problematic compared to the others?

Yes, a performance regression. io_uring is using io-wq now, which does
an extra get/put on the work item to make it safe against async cancel.
That get/put translates into a refcount_inc and refcount_dec per work
item, and meant that we went from 0.5% refcount CPU in the test case to
1.5%. That's a pretty substantial increase.

> I really don't like it when raw atomic_t is used for refcounting
> purposes - not only because that gets rid of the overflow checks, but
> also because it is less clear semantically.

Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
that's what I should do. But I'd prefer to just drop the refcount on the
io_uring side and keep it on for other potential useful cases.

>> Our ref count usage is really simple,
> 
> In my opinion, for a refcount to qualify as "really simple", it must
> be possible to annotate each relevant struct member and local variable
> with the (fixed) bias it carries when alive and non-NULL. This
> refcount is more complicated than that.

:-(

-- 
Jens Axboe

