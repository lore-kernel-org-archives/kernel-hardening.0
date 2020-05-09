Return-Path: <SRS0=3eLw=6X=lists.openwall.com=kernel-hardening-return-18741-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FE3C28CBC
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 May 2020 12:31:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2179721775
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 May 2020 12:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="iJC2Fspu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2179721775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18741-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25667 invoked by uid 550); 9 May 2020 12:31:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19702 invoked from network); 9 May 2020 12:20:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1589026822;
	bh=AXKMDUgU0rViMFmaqnzUY3q+9rU8Dm53+ejO5t/OOHM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
	b=iJC2Fspu3AOfP82nfw+zLTn9bDlDyceQGxkP/iskDImEZ8IKPsUtXrBeDIj5N9l3V
	 hV6Ih2JfJJvxO80rh+uhwmQxjeU//plGJFYBNUxPZdRMVtEzHl4ezjByaWCdE3IkoM
	 h/uKfZvlhCpm8cWSOz3RXkVvSH8JuB6vseHyC/T4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 9 May 2020 14:20:08 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	kernel-hardening@lists.openwall.com
Subject: Get involved in the KSPP
Message-ID: <20200509122007.GA5356@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:Cg3WOMZuo67gC9Y2dGTRxItSviGStc6or6i2UczJAbRGjjelMZa
 6M7Uyl0RFyIQnk79Ijq0PMAi3DO9s144SRuthr5Aq9nb0T+ISC1P8klyPrT+YnEeMGnLjU2
 /dcNZB7TZiJP8gg8qfRpz3twxmTO9JmcC5YTh1d9957a8N5ZjkYHPmyOy5gznePzeTnFLuk
 eHWrtzkqhzneKHQ1f6lDA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Td24nPfo6IM=:LkxjV7pvXj93KchTRK6P9Y
 g7YxlVVgMTy/L1bBiR3jaufwiJtj7UccylNKuy7i4zJCQiq7PiueTs7M42m+QvPNsI9hakiKi
 wKwVsbHRzPOFsDgFzb8AWPH6XfYZ4Xk3g8sQYjFNwg57XPfjm1MIWtDaVLNRDNz5dLGiCSSvZ
 F4Rx0V2PCQI8pWUwdBs8WKeFJClsSXsr3Gxwg+p6pSbXf3ZHY8X+nl9xpHy+qQOZaP0Y41xA0
 q9UotEcszQWKmcliqUR2LxMzMlasORvGFoGdgK8XnuGSXPpOP60DjMikcJKWtMoAW+9RvVDY3
 vgtE0eVf/A6+c77eK4kvP6U15Ta4CXKJmPJrztBjO0qzF7diMnlJmpWgrugph7p2Pwd1U7Vz1
 do414MrQK/TSZJwK3qQUxGDrtLSAe4p9fjdIkp7UAqttY0yQBi2PrT7OqdCHki8WBFcDO7S+6
 Df0CeQO2g/+blj5Sz1e/zM8+VkaiqsuL33USY+bgj3QU40t1JA4RhzpVJPaePMigNH9xGHsRy
 TeZW2yO9fqyEVX4/9syzAIuGi9BCbIBq9bXc6xb+kApCw2AkilP3jJZHhWF7jjPC3xxwIYGKZ
 p7S8XHf6Tys74be035WImokniQuwgWeD3lEAjjs4zp1JnsdscWzn/AcmE/9UQwonuVTsuTGCg
 ynuCi2/pIOvSeiBnVyNLNTcsNxcbqS49HkbSaQA2oJa8dRdWUQRTlaCGVn+waIC8OxFp3m9N9
 ZzbWLdSY8Ju8rBQMmXAbJdTgyJX6Hylds7VPZSvkzQLXretDAwHhTf/643Nb7hAzsm5josgIC
 MmLl4dKYHFssn0D79vYrs46m3LFjgwyLriOkEWQNJPkjf/2IKvkhoEl1tIgIH2XlEyiiKaUT8
 7+xS4AaTRw+IaSBjXkFK3HR6gqbK29vyQXioUrmHvIpfzyKrZnisyPsa1hqgQbp7SxNZF+xWc
 iyUpPw2atoWhQ8XR3gmjzSW8i+9JT3exLJ2oOZOf+XcxSjf+WsVMr+5Zmlz8W7+UFm1RCoRRi
 A2Xsxhk0nZsP9DEdca72yb9AxEfo3MQLkop+JIzJWOCYg26u9GRsm23u4ID8PmYA9usU1v3Ny
 uMr+kPINbYIm5as2e73jyuLOZZ54kt3fC53S0qrLrT224jDYnVOIYDoZZUc0syhCqEck2a6TJ
 JMBNSnRFI2djcIGiEK2WlbKNJ0T0g6nxtsbIlF0k4drO/6m9gQ/6j69KU0g0SgXm2Ee9TFH+F
 YnAXig3C8yth/s18H

Hi, my name is Oscar. I would like to get involved in the kernel self protection
project because I love the software security and I think this is one of the most
challenging fields.

I have experience in microcrontrollers and working with low level software, but
my experience with the linux kernel development is a few commits in the staging
area.

For now, and due to my low experience with the linux kernel code and software
security, I do not care about the area and task to be done. What I pretend is to
help this great community and improve my knowledge and skills in this
challenging field.

So, I would like to know if I can be assigned to some task that suits me. I've
taken a look at https://github.com/KSPP/linux/issues but I don't know which task
to choose and if someone else is working on it.

Thanks,

Oscar Carter
