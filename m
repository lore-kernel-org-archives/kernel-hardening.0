Return-Path: <SRS0=IwAA=EJ=lists.openwall.com=kernel-hardening-return-20327-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D601C8262C
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:34:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F52A21D40
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 10:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MXLKW2eq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F52A21D40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20327-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22289 invoked by uid 550); 3 Nov 2020 10:34:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22269 invoked from network); 3 Nov 2020 10:34:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604399674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NeyfLxLqbPXnSVbIXerlFIoWQVVpshnlirjJvDi476c=;
	b=MXLKW2eqIxXz/kMc4QgmxEJjHXl1yOpHlfTmO0N7cZfXWo3CkvaC8t1xhtF+GKGKJSTDCZ
	0CsQvIdCI0S3/0X+ONuE+W44rb3pAXz0wovT5m5joLoxRZ7cHWSDqQ3bXvL43Zbl3yxaNJ
	SV8VQus5Ynhb5e1gWRtoImaDVkSx6kk=
X-MC-Unique: 9pmT0jXYPpibXCdCo9ZU8g-1
From: Florian Weimer <fweimer@redhat.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: libc-alpha@sourceware.org,  Jeremy Linton <jeremy.linton@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Will Deacon <will.deacon@arm.com>,  Mark Brown
 <broonie@kernel.org>,  Kees Cook <keescook@chromium.org>,  Salvatore
 Mesoraca <s.mesoraca16@gmail.com>,  Lennart Poettering
 <mzxreary@0pointer.de>,  Topi Miettinen <toiwoton@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kernel-hardening@lists.openwall.com,  linux-hardening@vger.kernel.org
Subject: Re: [PATCH 3/4] aarch64: Use mmap to add PROT_BTI instead of
 mprotect [BZ #26831]
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
	<f5eaa74cb7538382b2fd2439755386ac68f7c8db.1604393169.git.szabolcs.nagy@arm.com>
Date: Tue, 03 Nov 2020 11:34:22 +0100
In-Reply-To: <f5eaa74cb7538382b2fd2439755386ac68f7c8db.1604393169.git.szabolcs.nagy@arm.com>
	(Szabolcs Nagy's message of "Tue, 3 Nov 2020 10:26:29 +0000")
Message-ID: <87v9embufl.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

* Szabolcs Nagy:

> Re-mmap executable segments if possible instead of using mprotect
> to add PROT_BTI. This allows using BTI protection with security
> policies that prevent mprotect with PROT_EXEC.
>
> If the fd of the ELF module is not available because it was kernel
> mapped then mprotect is used and failures are ignored.  It is
> expected that linux kernel will add PROT_BTI when mapping a module
> (current linux as of version 5.9 does not do this).
>
> Computing the mapping parameters follows the logic of
> _dl_map_object_from_fd more closely now.

What's the performance of this on execve-heavy workloads, such as kernel
or glibc builds?  Hopefully it's cheap because these mappings have not
been faulted in yet.

Thanks,
Florian
-- 
Red Hat GmbH, https://de.redhat.com/ , Registered seat: Grasbrunn,
Commercial register: Amtsgericht Muenchen, HRB 153243,
Managing Directors: Charles Cachera, Brian Klemm, Laurie Krebs, Michael O'Neill

