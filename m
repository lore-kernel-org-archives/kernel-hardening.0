Return-Path: <SRS0=VxqR=DA=lists.openwall.com=kernel-hardening-return-19986-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82D1C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:21:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFEE02220D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFEE02220D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19986-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28507 invoked by uid 550); 23 Sep 2020 18:21:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28047 invoked from network); 23 Sep 2020 18:21:41 -0000
Date: Wed, 23 Sep 2020 20:21:34 +0200
From: Solar Designer <solar@openwall.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	oleg@redhat.com, x86@kernel.org, luto@kernel.org,
	David.Laight@ACULAB.COM, fweimer@redhat.com, mark.rutland@arm.com,
	mic@digikod.net, Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923182134.GA8990@openwall.com>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com> <20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com> <20200923141102.GA7142@openwall.com> <20200923151835.GA32555@duo.ucw.cz> <20200923180007.GA8646@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923180007.GA8646@openwall.com>
User-Agent: Mutt/1.4.2.3i

On Wed, Sep 23, 2020 at 08:00:07PM +0200, Solar Designer wrote:
> A couple of other things Brad kindly pointed out:
> 
> SELinux already has similar protections (execmem, execmod):
> 
> http://lkml.iu.edu/hypermail/linux/kernel/0508.2/0194.html
> https://danwalsh.livejournal.com/6117.html

Actually, that's right in Madhavan's "Introduction": "LSMs such as
SELinux implement W^X" and "The W^X implementation today is not
complete."  I'm sorry I jumped into this thread out of context.

Alexander
