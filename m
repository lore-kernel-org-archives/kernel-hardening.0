Return-Path: <SRS0=Ng3D=CK=lists.openwall.com=kernel-hardening-return-19717-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA216C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 15:42:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 01FC9206EF
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 15:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01FC9206EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19717-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1564 invoked by uid 550); 1 Sep 2020 15:42:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1541 invoked from network); 1 Sep 2020 15:42:34 -0000
Date: Tue, 1 Sep 2020 16:42:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200901154217.GD95447@C02TD0UTHF1T.local>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200731180955.GC67415@C02TD0UTHF1T.local>
 <6236adf7-4bed-534e-0956-fddab4fd96b6@linux.microsoft.com>
 <20200804143018.GB7440@C02TD0UTHF1T.local>
 <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
 <20200812100650.GB28154@C02TD0UTHF1T.local>
 <41c4de64-68d0-6fcb-e5c3-63ebd459262e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41c4de64-68d0-6fcb-e5c3-63ebd459262e@digikod.net>

On Wed, Aug 19, 2020 at 08:53:42PM +0200, Mickaël Salaün wrote:
> On 12/08/2020 12:06, Mark Rutland wrote:
> > Contemporary W^X means that a given virtual alias cannot be writeable
> > and executeable simultaneously, permitting (a) and (b). If you read the
> > references on the Wikipedia page for W^X you'll see the OpenBSD 3.3
> > release notes and related presentation make this clear, and further they
> > expect (b) to occur with JITS flipping W/X with mprotect().
> 
> W^X (with "permanent" mprotect restrictions [1]) goes back to 2000 with
> PaX [2] (which predates partial OpenBSD implementation from 2003).
> 
> [1] https://pax.grsecurity.net/docs/mprotect.txt
> [2] https://undeadly.org/cgi?action=article;sid=20030417082752

Thanks for the pointers!

Mark.
