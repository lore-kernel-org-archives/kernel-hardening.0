Return-Path: <SRS0=DxIq=EK=lists.openwall.com=kernel-hardening-return-20357-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B12C4741F
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 14:46:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E49792074B
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 14:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FuehmNZc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E49792074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20357-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3460 invoked by uid 550); 4 Nov 2020 14:46:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3436 invoked from network); 4 Nov 2020 14:46:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604501156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2/qDMVtos7dYdtcZu5rNmBGlotvjjozf9G0PRDDGQXs=;
	b=FuehmNZcdrcy7rGZnQ6XxJIDWzKhga0wN8DWf9q9lAn5+h7YMqS/iRfTkVcDYtLce2bqEv
	rpV8BHUYd8xNdGdP48JbZTM5DM6puvHJbrMDqYBiiEC5BY4k19KWWdwDQlVcWqmpb8BpPz
	Cs/+yMIC2jWRjTSFP4fauRvai2JRQJE=
X-MC-Unique: jgwp6zJgNeGan1kW1fiemg-1
From: Florian Weimer <fweimer@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>,  Jeremy Linton
 <jeremy.linton@arm.com>,  Mark Brown <broonie@kernel.org>,
  libc-alpha@sourceware.org,  Mark Rutland <mark.rutland@arm.com>,  Will
 Deacon <will@kernel.org>,  Kees Cook <keescook@chromium.org>,  Salvatore
 Mesoraca <s.mesoraca16@gmail.com>,  Lennart Poettering
 <mzxreary@0pointer.de>,  Topi Miettinen <toiwoton@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kernel-hardening@lists.openwall.com,  linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
	<20201103173438.GD5545@sirena.org.uk>
	<8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
	<20201104085704.GB24704@arm.com> <20201104144120.GD28902@gaia>
Date: Wed, 04 Nov 2020 15:45:44 +0100
In-Reply-To: <20201104144120.GD28902@gaia> (Catalin Marinas's message of "Wed,
	4 Nov 2020 14:41:21 +0000")
Message-ID: <87ft5p2naf.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

* Catalin Marinas:

> Can the dynamic loader mmap() the main exe again while munmap'ing the
> original one? (sorry if it was already discussed)

No, we don't have a descriptor for that.  /proc may not be mounted, and
using the path stored there has a race condition anyway.

Thanks,
Florian
-- 
Red Hat GmbH, https://de.redhat.com/ , Registered seat: Grasbrunn,
Commercial register: Amtsgericht Muenchen, HRB 153243,
Managing Directors: Charles Cachera, Brian Klemm, Laurie Krebs, Michael O'Neill

