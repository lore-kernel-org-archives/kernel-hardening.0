Return-Path: <SRS0=zAxt=VD=lists.openwall.com=kernel-hardening-return-16366-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	GAPPY_SUBJECT,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E02C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 15:30:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 678CE20838
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 15:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FVfMkcgg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 678CE20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16366-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14029 invoked by uid 550); 6 Jul 2019 15:30:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13993 invoked from network); 6 Jul 2019 15:30:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R5T3JdF3uAoxSggzlvhNs2X88sgTBZ7bfNPEjr5/PdE=; b=FVfMkcggaArI6Rrc6O+/xTAlkz
	rdcq0dibJ5ZhFhfnlrZfRI4O7PCUETe4XxNS+sPGXlKZZhKmJrubnyzs3KpZV2acwXKXoaaPNL3NK
	YxOrfw10/Tu5j/fST3C0r9bS+RFzCcpbp2EvNY0NJMB7Hst0+6V/g+QcNi7NT9m3Dj/KoyWiF568i
	mP5sj1aDAYlF85pd9UNKMGjKJsKutGTc6MpknFrzOvLcMGpjeCxV++nNHz0sNB6yv+sNAI8YdLfRz
	oLAc0Jek9i95iKaZN+OoAFxWqlFDw0Ar4L2KzLdHRXTwh6j2NC3S5IxWPWUT7GG1JuS73FwiVgdbo
	f8WNQGUg==;
Subject: Re: [PATCH v5 02/12] S.A.R.A.: create framework
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Brad Spengler <spender@grsecurity.net>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christoph Hellwig <hch@infradead.org>,
 James Morris <james.l.morris@oracle.com>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
 "Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-3-git-send-email-s.mesoraca16@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4d85d8f3-b6be-04fe-ea5e-de47c9441f11@infradead.org>
Date: Sat, 6 Jul 2019 08:29:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562410493-8661-3-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi,

On 7/6/19 3:54 AM, Salvatore Mesoraca wrote:
> diff --git a/security/sara/Kconfig b/security/sara/Kconfig
> new file mode 100644
> index 0000000..0456220
> --- /dev/null
> +++ b/security/sara/Kconfig
> @@ -0,0 +1,40 @@
> +menuconfig SECURITY_SARA
> +	bool "S.A.R.A."
> +	depends on SECURITY
> +	select SECURITYFS
> +	default n

No need for "default n".  Drop it, please.

> +	help
> +	  This selects S.A.R.A. LSM which aims to collect heterogeneous
> +	  security measures providing a common interface to manage them.
> +	  This LSM will always be stacked with the selected primary LSM and
> +	  other stacked LSMs.
> +	  Further information can be found in
> +	  Documentation/admin-guide/LSM/SARA.rst.
> +
> +	  If unsure, answer N.
> +
> +config SECURITY_SARA_DEFAULT_DISABLED
> +	bool "S.A.R.A. will be disabled at boot."
> +	depends on SECURITY_SARA
> +	default n
> +	help
> +	  If you say Y here, S.A.R.A. will not be enabled at startup. You can
> +	  override this option at boot time via "sara.enabled=[1|0]" kernel
> +	  parameter or via user-space utilities.
> +	  This option is useful for distro kernels.
> +
> +	  If unsure, answer N.
> +
> +config SECURITY_SARA_NO_RUNTIME_ENABLE
> +	bool "S.A.R.A. can be turn on only at boot time."

	               can be turned on

> +	depends on SECURITY_SARA_DEFAULT_DISABLED
> +	default y
> +	help
> +	  By enabling this option it won't be possible to turn on S.A.R.A.
> +	  at runtime via user-space utilities. However it can still be
> +	  turned on at boot time via the "sara.enabled=1" kernel parameter.
> +	  This option is functionally equivalent to "sara.enabled=0" kernel
> +	  parameter. This option is useful for distro kernels.
> +
> +	  If unsure, answer Y.
> +


-- 
~Randy
