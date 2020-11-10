Return-Path: <SRS0=pWg6=EQ=lists.openwall.com=kernel-hardening-return-20371-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AEDC4741F
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 00:09:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3B8520789
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 00:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PeY6e3zO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3B8520789
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20371-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9920 invoked by uid 550); 10 Nov 2020 00:09:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9885 invoked from network); 10 Nov 2020 00:09:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=rzp6w6LtmUWYCvcLAbZq+3lrgpo1QeVmRmbMbPfRlA4=; b=PeY6e3zOfq5yS87w5dYJX/bGHU
	0REP48EkwsDG5m7klT2SuoL4SXj5mtINLieWT2kOXu6cJloGAgN8NfBRdfXPfJqI5on3Z93hqhNLG
	XoP6pB92jSfHtSjTjpPb76VEkGhBctEK9wofFyjmKDJnCHfNagS3jkiK1fwvrZZ8wGNG6t0QsaTDA
	KqLwapDqkD41gHfNybnPHfi+o+7N+deUWW6Chv5AtCJWsLeNvmhYgiGwo85CsY+y70Gc8ZLGGpqjs
	MQhX9+BMCIWGJVFDn7WLAyysztTMmp4xiRl47fTxGBLkvqUJc+WwFvh5xHcgA05u0wQsR/RLk1xY0
	vs2Wj6Qw==;
Subject: Re: [PATCH v2 7/8] Documentation: Add documentation for the Brute LSM
To: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <20201025134540.3770-1-john.wood@gmx.com>
 <20201025134540.3770-8-john.wood@gmx.com>
 <2ab35578-832a-6b92-ca9b-2f7d42bc0792@infradead.org>
 <20201109182348.GA3110@ubuntu>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e6e04af7-5445-bda9-6665-b52c72735b63@infradead.org>
Date: Mon, 9 Nov 2020 16:09:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109182348.GA3110@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 11/9/20 10:23 AM, John Wood wrote:
> Hi,
> Thanks for the typos corrections. Will be corrected in the next patch
> version.
> 
> On Sun, Nov 08, 2020 at 08:31:13PM -0800, Randy Dunlap wrote:
>>
>> So an app could read crash_period_threshold and just do a new fork every
>> threshold + 1 time units, right? and not be caught?
> 
> Yes, you are right. But we must set a crash_period_threshold that does not
> make an attack feasible. For example, with the default value of 30000 ms,
> an attacker can break the app only once every 30 seconds. So, to guess
> canaries or break ASLR, the attack needs a big amount of time. But it is
> possible.
> 
> So, I think that to avoid this scenario we can add a maximum number of
> faults per fork hierarchy. Then, the mitigation will be triggered if the
> application crash period falls under the period threshold or if the number
> of faults exceed the maximum commented.
> 
> This way, if an attack is of long duration, it will also be detected and
> mitigated.
> 
> What do you think?

Hi,
That sounds reasonable to me.

thanks.
-- 
~Randy

