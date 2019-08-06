Return-Path: <SRS0=cn4V=WC=lists.openwall.com=kernel-hardening-return-16726-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3D6C31E40
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 15:44:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A904C20C01
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 15:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="dt2cjv9c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A904C20C01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16726-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19818 invoked by uid 550); 6 Aug 2019 15:44:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19793 invoked from network); 6 Aug 2019 15:43:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565106228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=TDFDazt6//hwNfwRMzmVKFiu4ldxLz+yMwXDE8Lj5Eo=;
	b=dt2cjv9ck6Riog7ad+ewdarAX2dM8UrmZhk8qdfxpW8EfZWGjwleuVrU4g1cmXqrcn8Kh+
	TWcpA8A1qy+/qbzkXNRCP6wNTc/+TBGiGV3muxnmmGbdGi77lel3IPkl79O3Iqqfn0x3XN
	2iqBRrkAzDyyrAqpiKzGnDMqxESTm0c=
Date: Tue, 6 Aug 2019 17:43:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Enrico Weigelt <info@metux.net>,
	Allison Randal <allison@lohutok.net>,
	Alexios Zavras <alexios.zavras@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v9 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <20190806154347.GD25897@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> These patches make some of the changes necessary to build the kernel as
> Position Independent Executable (PIE) on x86_64. Another patchset will
> add the PIE option and larger architecture changes.

Yeah, about this: do we have a longer writeup about the actual benefits
of all this and why we should take this all? After all, after looking
at the first couple of asm patches, it is posing restrictions to how
we deal with virtual addresses in asm (only RIP-relative addressing in
64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
willing to bet money that some future unrelated change will break PIE
sooner or later. And I'd like to have a better justification why we
should enforce those new "rules" unconditionally.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
