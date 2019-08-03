Return-Path: <SRS0=a9H3=V7=lists.openwall.com=kernel-hardening-return-16696-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB21FC31E40
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Aug 2019 19:04:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1EC7F214AE
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Aug 2019 19:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EC7F214AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16696-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11327 invoked by uid 550); 3 Aug 2019 19:04:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11292 invoked from network); 3 Aug 2019 19:04:15 -0000
Date: Sat, 3 Aug 2019 14:04:02 -0500 (CDT)
From: Christopher M Riedl <cmr@informatik.wtf>
To: Daniel Axtens <dja@axtens.net>, Andrew Donnellan <ajd@linux.ibm.com>,
	linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: mjg59@google.com
Message-ID: <1642733335.91438.1564859043089@privateemail.com>
In-Reply-To: <87ef29gwa1.fsf@dja-thinkpad.axtens.net>
References: <20190524123816.1773-1-cmr@informatik.wtf>
 <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com>
 <1146575236.484635.1559617524880@privateemail.com>
 <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
 <87h88m2iu4.fsf@dja-thinkpad.axtens.net>
 <87ef29gwa1.fsf@dja-thinkpad.axtens.net>
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked
 down
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev59
X-Originating-Client: open-xchange-appsuite
X-Virus-Scanned: ClamAV using ClamSMTP

> On July 29, 2019 at 2:00 AM Daniel Axtens <dja@axtens.net> wrote:
> 
> Would you be able to send a v2 with these changes? (that is, not purging
> breakpoints when entering integrity mode)
> 

Just sent out a v3 with that change among a few others and a rebase.

Thanks,
Chris R.
