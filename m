Return-Path: <SRS0=771j=WC=lists.openwall.com=kernel-hardening-return-16727-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8EFC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 15:51:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6B23B20717
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 15:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="omsCdPaW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B23B20717
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16727-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28187 invoked by uid 550); 6 Aug 2019 15:51:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28156 invoked from network); 6 Aug 2019 15:51:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=SncjWrmoRC5b495lasgofj0Rqb2mQTyyh5dUq+5um6c=; b=omsCdPaWcnXHcWz6QUOPsZ1pH
	m4nhZmOCV5hlYYIM86PIwoYv97n1noOSx61nqdD5Rvo9OhGQQJ+ZPRQzx7OSmkV0g38j23wJVV0Wu
	OA6nibDOjqa3aQAvytDJ1hR4rA9LfBGjXdSQASh7g9TEaQ8ZQXZk5SLvA35tGtSk8QSRL8vagnuRA
	grsvsDLfqhl+NiT+Dqly9Tn8qDyLmrA6YcWPBssLEypNK8woJHz1tPHv/fxvUgbTsilr6PrnL7CMY
	86FQfGDuo3nB2UVQvSwY6mHsHIHy7t5NB7g5s7yo2yQLb4vLc/RxZQGZgFdwDXYBYoVrN3i/SKjrc
	dsPnU77wA==;
Date: Tue, 6 Aug 2019 17:50:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
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
	Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Enrico Weigelt <info@metux.net>,
	Allison Randal <allison@lohutok.net>,
	Alexios Zavras <alexios.zavras@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v9 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <20190806155034.GP2349@hirez.programming.kicks-ass.net>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190806154347.GD25897@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806154347.GD25897@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 06, 2019 at 05:43:47PM +0200, Borislav Petkov wrote:
> On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> > These patches make some of the changes necessary to build the kernel as
> > Position Independent Executable (PIE) on x86_64. Another patchset will
> > add the PIE option and larger architecture changes.
> 
> Yeah, about this: do we have a longer writeup about the actual benefits
> of all this and why we should take this all? After all, after looking
> at the first couple of asm patches, it is posing restrictions to how
> we deal with virtual addresses in asm (only RIP-relative addressing in
> 64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
> willing to bet money that some future unrelated change will break PIE
> sooner or later.

Possibly objtool can help here; it should be possible to teach it about
these rules, and then it will yell when violated. That should avoid
regressions.

