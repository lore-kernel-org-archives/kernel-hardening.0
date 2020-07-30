Return-Path: <SRS0=/drV=BJ=lists.openwall.com=kernel-hardening-return-19499-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCFBC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:56:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E5D120829
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="goW9xjOH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E5D120829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19499-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1999 invoked by uid 550); 30 Jul 2020 16:55:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1975 invoked from network); 30 Jul 2020 16:55:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596128098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mUJJz00/qMUPPiVVgu2HBKBrMX99JElEmzWclI1Ii/I=;
	b=goW9xjOH0957Nxn7GUDkR2r2vfZBvvCxCufQPpZzia6Z3nMeklk/71eWpm2gPIv5xwQi58
	TozpVSopKbWUxF2qGkDB7+/ZoUtIhPb26cmj95eVXxQlJWXSOO84dF4aJVjqCCfjLcaSZB
	LwdDgz0TwfUvWh+wyYYtfz3MIP2B2Xc=
X-MC-Unique: xLgGYBWVORe5mNHR8sHpHQ-1
From: Florian Weimer <fweimer@redhat.com>
To: Jann Horn <jannh@google.com>
Cc: oss-security@lists.openwall.com,  x86-64-abi@googlegroups.com,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: Alternative CET ABI
References: <87k0ylgff0.fsf@oldenburg2.str.redhat.com>
	<CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
Date: Thu, 30 Jul 2020 18:54:50 +0200
In-Reply-To: <CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
	(Jann Horn's message of "Thu, 30 Jul 2020 18:41:40 +0200")
Message-ID: <87h7tpeyed.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

* Jann Horn:

> On Thu, Jul 30, 2020 at 6:02 PM Florian Weimer <fweimer@redhat.com> wrote:
>> Functions no longer start with the ENDBR64 prefix.  Instead, the link
>> editor produces a PLT entry with an ENDBR64 prefix if it detects any
>> address-significant relocation for it.  The PLT entry performs a NOTRACK
>> jump to the target address.  This assumes that the target address is
>> subject to RELRO, of course, so that redirection is not possible.
>> Without address-significant relocations, the link editor produces a PLT
>> entry without the ENDBR64 prefix (but still with the NOTRACK jump), or
>> perhaps no PLT entry at all.
>
> How would this interact with function pointer comparisons? As in, if
> library A exports a function func1 without referencing it, and
> libraries B and C both take references to func1, would they end up
> with different function pointers (pointing to their respective PLT
> entries)?

Same as today.  ELF already deals with this by picking one canonical
function address per process.

Some targets already need PLTs for inter-DSO calls, so the problem is
not new.  It happens even on x86 because the main program can refer to
its PLT stubs without run-time relocations, so those determine the
canonical address of those functions, and not the actual implementation
in a shared object.

> Would this mean that the behavior of a program that compares
> function pointers obtained through different shared libraries might
> change?

Hopefully not, because that would break things quite horribly (as it's
sometimes possible to observe if the RTLD_DEEPBIND flag is used).

Both the canonicalization and the fact in order to observe the function
pointer, you need to take its address should take care of this.

> I guess you could maybe canonicalize function pointers somehow, but
> that'd probably at least break dlclose(), right?

Ahh, dlclose.  I think in this case, my idea to generate a PLT stub
locally in the address-generating DSO will not work because the
canonical address must survive dlclose if it refers to another DSO.
There are two ways to deal with this: do not unload the PLT stub until
the target DSO is also unloaded (but make sure that the DSO can be
reloaded at a different address; probably not worth the complexity),
or use the dlsym hack I sketched for regular symbol binding as well.
Even more room for experiments, I guess.

Thanks,
Florian

