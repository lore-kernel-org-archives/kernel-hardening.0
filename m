Return-Path: <SRS0=Wuu0=LJ=lists.openwall.com=kernel-hardening-return-21306-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA20C48BDF
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 19:33:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D6ABD60E0C
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 19:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6ABD60E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21306-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5156 invoked by uid 550); 15 Jun 2021 19:33:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5120 invoked from network); 15 Jun 2021 19:33:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1623785582;
	bh=Mx6wAAXn/soRKwq/hg+UAA/IhWBECd+G+9shpZSj+rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s+556g9OCPnVI5+ewcio9gs7JtTbSK0kEbBTFHukMPNcwVXk/K9XkoxpQMEG9V6K2
	 xa7MYmQCNdKpw4GjteIkhU1bajY7WA4K0tSqER20sHf2BJpuximXtWZA7BFDUdwfLy
	 a5CIp1f9C6JpdMC6UvfG9TSdjdreYAsPIzLDQGYzG9j+S+L0yGoxfuVIsmkBgxZmPW
	 85cxV357Znr2898TTvgeZfNb/gKhd7CFqztKshOTQcdBnUTuOZcFjMUVol8KFq65e3
	 XxzEiKTfJkSj37kH19RlKg6u6y34o8SKF79C76tq/0GsVeRKw3WjjSmf3c1aI0cTSq
	 71lkPV5tl5n2w==
Date: Tue, 15 Jun 2021 12:33:00 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>
Cc: Kurt Manucredo <fuzzybritches0@gmail.com>,
	syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
	keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
	andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
	john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, songliubraving@fb.com,
	syzkaller-bugs@googlegroups.com, nathan@kernel.org,
	ndesaulniers@google.com, clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <YMkAbNQiIBbhD7+P@gmail.com>
References: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>

On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
> 
> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>  which is the *slow path* and indeed on many production systems is
>  compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
> Perhaps a better approach to the fix would be to change the interpreter
>  to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>  bitnesses), thus matching the behaviour of most chips' shift opcodes.
> This would shut up UBSAN, without affecting JIT code generation.
> 

Yes, I suggested that last week
(https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
get optimized out when compiling for most CPUs.

- Eric
