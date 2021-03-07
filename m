Return-Path: <SRS0=ocSZ=IF=lists.openwall.com=kernel-hardening-return-20884-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52466C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 15:19:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72574650FA
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 15:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72574650FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20884-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16065 invoked by uid 550); 7 Mar 2021 15:19:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16031 invoked from network); 7 Mar 2021 15:19:34 -0000
IronPort-SDR: 93PtAdauRMH040cn5T0gDStgl08MzsOG9Yj8BKz9tgwCLL9OQxYO268K/+deyBRUoFte5EY06G
 IaMweN3Mhf+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="167815709"
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="167815709"
IronPort-SDR: VBQ85G5YYI/WVTz2b41mxqzXqF0+ssZMx7MQbDyrg3QsWTdTEwQLosgUq9Ov6r51Cb94QFKhyQ
 E0ZQT8/IMYEw==
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="409008502"
Date: Sun, 7 Mar 2021 07:19:20 -0800
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 7/8] Documentation: Add documentation for the Brute LSM
Message-ID: <20210307151920.GR472138@tassilo.jf.intel.com>
References: <20210227153013.6747-1-john.wood@gmx.com>
 <20210227153013.6747-8-john.wood@gmx.com>
 <878s78dnrm.fsf@linux.intel.com>
 <20210302183032.GA3049@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302183032.GA3049@ubuntu>

Sorry for the late answer. I somehow missed your email earlier.

> As a mitigation method, all the offending tasks involved in the attack are
> killed. Or in other words, all the tasks that share the same statistics
> (statistics showing a fast crash rate) are killed.

So systemd will just restart the network daemon and then the attack works
again?

Or if it's a interactive login you log in again.

I think it might be useful even with these limitations, but it would
be good to spell out the limitations of the method more clearly.

I suspect to be useful it'll likely need some user space configuration
changes too.

-Andi
