Return-Path: <SRS0=w6x3=AF=lists.openwall.com=kernel-hardening-return-19098-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D76C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 13:55:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A7B3120781
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 13:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTWXXWzz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7B3120781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19098-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20080 invoked by uid 550); 24 Jun 2020 13:55:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20051 invoked from network); 24 Jun 2020 13:55:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593006905;
	bh=/1svtZ7NFc/8pJ2Kp6i4gm4ajra1i4VBRLm1WItsEMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTWXXWzzkiccoVFz/2cLbK9y/b4meGyKs970QbtqAoJKFfrYOE8wJQNan/2zkjIbG
	 M9gInwgc0i5vdEgc9IJfSprW2ZMaMPfd25JecqOiJlhvlLKNXm9xCTx1tcU3dr6wx2
	 XnwsVCEoVoSbiftJU5wdTX+rn7DxiauXaityvSg4=
From: Will Deacon <will@kernel.org>
To: Iurii Zaikin <yzaikin@google.com>,
	PaX Team <pageexec@freemail.hu>,
	Mathias Krause <minipli@googlemail.com>,
	x86@kernel.org,
	Sven Schnelle <svens@stackframe.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Florian Weimer <fweimer@redhat.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	linux-kernel@vger.kernel.org,
	Michal Marek <michal.lkml@markovi.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Emese Revfy <re.emese@gmail.com>,
	kernel-hardening@lists.openwall.com,
	Laura Abbott <labbott@redhat.com>,
	Brad Spengler <spender@grsecurity.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jessica Yu <jeyu@kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	linux-kbuild@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Alexander Popov <alex.popov@linux.com>,
	gcc@gcc.gnu.org,
	Jann Horn <jannh@google.com>,
	linux-arm-kernel@lists.infradead.org
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	notify@kernel.org
Subject: Re: [PATCH v2 0/5] Improvements of the stackleak gcc plugin
Date: Wed, 24 Jun 2020 14:54:49 +0100
Message-Id: <159300400829.52405.11593787740425104484.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624123330.83226-1-alex.popov@linux.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 24 Jun 2020 15:33:25 +0300, Alexander Popov wrote:
> This is the v2 of the patch series with various improvements of the
> stackleak gcc plugin.
> 
> The first three patches disable unneeded gcc plugin instrumentation for
> some files.
> 
> The fourth patch is the main improvement. It eliminates an unwanted
> side-effect of kernel code instrumentation performed by stackleak gcc
> plugin. This patch is a deep reengineering of the idea described on
> grsecurity blog:
>   https://grsecurity.net/resolving_an_unfortunate_stackleak_interaction
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: vdso: Don't use gcc plugins for building vgettimeofday.c
      https://git.kernel.org/arm64/c/e56404e8e475

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
