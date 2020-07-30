Return-Path: <SRS0=Va6M=BJ=lists.openwall.com=kernel-hardening-return-19497-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F572C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:02:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91ACD206F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 16:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="go0s7dqN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91ACD206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19497-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17752 invoked by uid 550); 30 Jul 2020 16:02:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17732 invoked from network); 30 Jul 2020 16:02:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596124921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=/t9guy78vRPTT6BL7IT2WeMD9e6hnDcbjU3OamD57wI=;
	b=go0s7dqN6dfQI6SK8IgM7j69z9njFAfRgLbh3LJKWOcTm306UEPquqb4DQuw0z5S7qonjl
	e+6GKlrzrF1ZXfD5DtDZw4VRGlD9jFMaLXfu1l9olOQ+5/TMHssaIXb2UQCc9FVXxOs1fF
	t0y5JT/0bdBARxotRG9ih7nULK9KoXY=
X-MC-Unique: cFYi_ne7Mv2A9VPzGtO_8g-1
From: Florian Weimer <fweimer@redhat.com>
To: oss-security@lists.openwall.com, x86-64-abi@googlegroups.com, kernel-hardening@lists.openwall.com
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Alternative CET ABI
Date: Thu, 30 Jul 2020 18:01:55 +0200
Message-ID: <87k0ylgff0.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

CET (and Arm BTI) restrict targets for indirect jumps and calls to
landing pads which start with specially-formatted NOP instruction
dedicated to this purpose (endrb64 in the x86-64 case).

The traditional way of implementing ELF on top of this is to have every
global function start with that NOP, and also use these NOPs in PLT
stubs in the main program (which may provide the canonical address of
functions, i.e. there address may be taken).

The downside of this approach is that all functions in the process
become available for execution, whether they are used in the original
program or not.  (In principle, control flow integrity provides
reasonably efficient ways to counteract that, by keeping track of symbol
resolution and verifying flags at the start of critical functions, but
we do not have automated support for that today, and there are some open
issues about complex call graphs.)

CET has a NOTRACK prefix for indirect jumps/and calls.  It asserts that
the jump target address is trusted and disables the control flow
integrity check.  It is expected to be used with jump tables and the
like, in conjunction with RELRO (so that the address has been loaded
from read-only memory).

I think this also provides support for a completely different ABI, where
global functions are not automatically addressable.  It depends on
BIND_NOW and RELRO, for a read-only GOT.

First of all, it needs new relocation types that tell the static link
editor which symbol references are address-significant.  Generally,
function addresses which end up in RELRO data only are not
address-significant if they are used immediately in call instructions
(without indirection of any form through writable memory).  This means
that direct calls do not have address significance.  For vtables, it
depends on how they are used; their function addresses probably need to
be treated conservatively as address-significant (because the vtable
pointer is in writable memory; at least for C++ vtables, the address of
a virtual member function is not significant).

Functions no longer start with the ENDBR64 prefix.  Instead, the link
editor produces a PLT entry with an ENDBR64 prefix if it detects any
address-significant relocation for it.  The PLT entry performs a NOTRACK
jump to the target address.  This assumes that the target address is
subject to RELRO, of course, so that redirection is not possible.
Without address-significant relocations, the link editor produces a PLT
entry without the ENDBR64 prefix (but still with the NOTRACK jump), or
perhaps no PLT entry at all.

The net effect is that only functions which have their address taken in
the original program can be called through indirect function calls.  For
example, this means that the system function in libc is usually dormant,
and cannot be reached, even if an attacker can cause the process to call
arbitrary functions with an arbitrary string argument.  The reason is
that the system function lacks the ENDBR64 prefix, and all PLT entries
calling it also lack it.

dlopen'ing a shared object which has a address-significant relocation
against a function is not a problem under this model.  Either there
already was an address-significant relocation before, then the function
already has a canonical address, and that can be used.  Or there was
not, then the just-loaded PLT entry (which as an ENDBR64 prefix)
provides the canonical address function.

To support dlsym, each global function definition would have a separate
ENDBR64-enabled PLT/GOT slot for that, with the GOT slot only filled in
at the time of the dlsym call (with mprotect calls around that, with
some hand-waving required these can never fail).  This is probably the
most awkward part about all this.  Alternatively, these stubs could also
be generated at run time, from a pre-computed code page.

Obviously, it is too late for that now for x86-64, but maybe someone
else gets a chance to try this.

Thanks,
Florian

